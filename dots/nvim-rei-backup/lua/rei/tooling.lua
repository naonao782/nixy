local function map(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

require("conform").setup({
  formatters_by_ft = {
    go = { "goimports", "gofmt" },
    lua = { "stylua" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    python = { "isort", "black" },
    php = { "pint" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    rust = { "rustfmt" },
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

map({ "n", "v" }, "<leader>cf", function()
  require("conform").format({ async = true }, function(err, did_edit)
    if not err and did_edit then
      vim.notify("Formatted", vim.log.levels.INFO)
    end
  end)
end, "Format")

local lint = require("lint")

if lint.linters.golangcilint then
  lint.linters.golangcilint.ignore_exitcode = true
end

if lint.linters.luacheck then
  lint.linters.luacheck.args = {
    "--formatter",
    "plain",
    "--codes",
    "--ranges",
    "--filename",
    function()
      return vim.api.nvim_buf_get_name(0)
    end,
    "-",
  }
  lint.linters.luacheck.stdin = true
end

if lint.linters.eslint_d then
  lint.linters.eslint_d.args = {
    "--format",
    "json",
    "--stdin",
    "--stdin-filename",
    function()
      return vim.api.nvim_buf_get_name(0)
    end,
  }
end

lint.linters.pint = {
  name = "pint",
  cmd = "pint",
  stdin = false,
  args = { "--test", "--json" },
  stream = "stdout",
  ignore_exitcode = true,
  parser = function(output)
    local diagnostics = {}
    if not output or output == "" then
      return diagnostics
    end

    local ok, decoded = pcall(vim.json.decode, output)
    if ok and decoded and decoded.files then
      for _, issues in pairs(decoded.files) do
        if type(issues) == "table" and #issues > 0 then
          for _, issue in ipairs(issues) do
            table.insert(diagnostics, {
              lnum = issue.line and (issue.line - 1) or 0,
              col = issue.column or 0,
              message = issue.message or "Style issue",
              severity = vim.diagnostic.severity.WARN,
              source = "pint",
            })
          end
        end
      end
    elseif string.find(output, "FAIL") or string.find(output, "differs") then
      table.insert(diagnostics, {
        lnum = 0,
        col = 0,
        message = "Code style issues found - run formatter to fix",
        severity = vim.diagnostic.severity.WARN,
        source = "pint",
      })
    end

    return diagnostics
  end,
}

lint.linters_by_ft = {
  go = { "golangcilint" },
  javascript = { "eslint_d" },
  typescript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  vue = { "eslint_d" },
  svelte = { "eslint_d" },
  html = { "htmlhint" },
  css = { "stylelint" },
  scss = { "stylelint" },
  less = { "stylelint" },
  lua = { "luacheck" },
  python = { "ruff", "mypy" },
  sh = { "shellcheck" },
  bash = { "shellcheck" },
  zsh = { "shellcheck" },
  fish = { "fish" },
  php = { "phpstan", "pint" },
  blade = { "phpstan", "pint" },
  ruby = { "rubocop" },
  eruby = { "erb_lint" },
  rust = { "clippy" },
  yaml = { "yamllint" },
  json = { "jsonlint" },
  jsonc = { "jsonlint" },
  markdown = { "markdownlint" },
  dockerfile = { "hadolint" },
  terraform = { "tflint", "tfsec" },
  tf = { "tflint", "tfsec" },
  sql = { "sqlfluff" },
  proto = { "buf_lint" },
  make = { "checkmake" },
  c = { "cppcheck", "cpplint" },
  cpp = { "cppcheck", "cpplint" },
}

local debounce_timer

local function debounce_lint(ms)
  if debounce_timer then
    vim.fn.timer_stop(debounce_timer)
  end

  debounce_timer = vim.fn.timer_start(ms or 250, function()
    vim.schedule(function()
      lint.try_lint()
    end)
  end)
end

local function is_file_too_large()
  local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(0))
  return ok and stats and stats.size > (1024 * 1024)
end

local function should_lint(bufnr)
  bufnr = bufnr or 0

  if vim.b[bufnr].lint_enabled == false then
    return false
  end

  local buftype = vim.bo[bufnr].buftype
  if buftype ~= "" and buftype ~= "acwrite" then
    return false
  end

  if is_file_too_large() then
    return false
  end

  local ft = vim.bo[bufnr].filetype
  local linters = lint.linters_by_ft[ft]
  return linters and #linters > 0
end

local lint_group = vim.api.nvim_create_augroup("nvim_lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
  group = lint_group,
  callback = function(args)
    if should_lint(args.buf) then
      if args.event == "BufWritePost" then
        lint.try_lint()
      else
        debounce_lint(100)
      end
    end
  end,
})

vim.api.nvim_create_autocmd("TextChanged", {
  group = lint_group,
  callback = function(args)
    if should_lint(args.buf) and vim.bo[args.buf].filetype ~= "TelescopePrompt" then
      debounce_lint(1000)
    end
  end,
})

vim.api.nvim_create_user_command("LintInfo", function()
  local ft = vim.bo.filetype
  local linters = lint.linters_by_ft[ft] or {}
  local installed, missing = {}, {}

  print(string.format("Filetype: %s", ft))
  print(string.format("Configured linters: %s", #linters > 0 and table.concat(linters, ", ") or "none"))
  print(string.format("Status: %s", should_lint() and "enabled" or "disabled"))

  for _, linter in ipairs(linters) do
    local cmd = lint.linters[linter] and lint.linters[linter].cmd
    if cmd then
      if vim.fn.executable(cmd) == 1 then
        table.insert(installed, linter)
      else
        table.insert(missing, linter)
      end
    end
  end

  if #installed > 0 then
    print(string.format("Installed: %s", table.concat(installed, ", ")))
  end

  if #missing > 0 then
    print(string.format("Missing: %s", table.concat(missing, ", ")))
  end
end, { desc = "Show linting information" })

vim.api.nvim_create_user_command("LintToggle", function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.b[bufnr].lint_enabled = not (vim.b[bufnr].lint_enabled ~= false)
  vim.notify(
    string.format("Linting %s", vim.b[bufnr].lint_enabled and "enabled" or "disabled"),
    vim.log.levels.INFO
  )
end, { desc = "Toggle linting" })

map("n", "<leader>ll", function()
  if should_lint() then
    lint.try_lint()
    vim.notify("Linting...", vim.log.levels.INFO)
  else
    vim.notify("No linters configured", vim.log.levels.WARN)
  end
end, "Lint")

map("n", "<leader>lI", "<cmd>LintInfo<cr>", "Lint Info")
map("n", "<leader>lL", "<cmd>LintToggle<cr>", "Toggle Lint")
map("n", "<leader>lC", function()
  local namespace = require("lint").get_namespace(vim.bo.filetype)
  vim.diagnostic.reset(namespace)
  vim.notify("Lint cleared", vim.log.levels.INFO)
end, "Clear Lint")
