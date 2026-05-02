local capabilities = vim.lsp.protocol.make_client_capabilities()

local ok_blink, blink = pcall(require, "blink.cmp")
if ok_blink and blink.get_lsp_capabilities then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

vim.lsp.config("*", {
  root_markers = { ".git" },
  capabilities = capabilities,
})

local function setup_keymaps(bufnr)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
  end

  map("n", "K", function()
    vim.lsp.buf.hover({ border = "rounded", max_height = 25, max_width = 120 })
  end, "Hover")
  map({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, "Signature Help")

  map("n", "[d", function()
    vim.diagnostic.jump({ count = -1 })
  end, "Prev Diagnostic")
  map("n", "]d", function()
    vim.diagnostic.jump({ count = 1 })
  end, "Next Diagnostic")

  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
  map("n", "<leader>cr", vim.lsp.buf.rename, "Rename Symbol")
  map("n", "<leader>cd", vim.diagnostic.open_float, "Line Diagnostic")
  map("n", "<leader>cv", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Definition in Vsplit")

  map("n", "<leader>li", "<cmd>checkhealth vim.lsp<cr>", "LSP Info")
  map("n", "<leader>lr", "<cmd>lsp restart<cr>", "LSP Restart")
  map("n", "<leader>lh", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
  end, "Toggle Inlay Hints")
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    setup_keymaps(bufnr)

    if client.server_capabilities.documentHighlightProvider then
      local group = vim.api.nvim_create_augroup("LspDocumentHighlight_" .. bufnr, { clear = true })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = bufnr,
        group = group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = bufnr,
        group = group,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = true, header = "", prefix = "" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      [vim.diagnostic.severity.WARN] = "WarningMsg",
    },
  },
})

local server_bins = {
  nixd = "nixd",
  lua_ls = "lua-language-server",
  clangd = "clangd",
  gopls = "gopls",
  zls = "zls",
  ts_ls = "typescript-language-server",
  rust_analyzer = "rust-analyzer",
  intelephense = "intelephense",
  bashls = "bash-language-server",
  pyright = "pyright-langserver",
  cssls = "vscode-css-language-server",
  html = "vscode-html-language-server",
  jsonls = "vscode-json-language-server",
  yamlls = "yaml-language-server",
  sourcekit = "sourcekit-lsp",
}

local enabled_servers = {}
for name, bin in pairs(server_bins) do
  if vim.fn.executable(bin) == 1 then
    table.insert(enabled_servers, name)
  end
end

table.sort(enabled_servers)
vim.lsp.enable(enabled_servers)
