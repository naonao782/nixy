local function map(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

require("flash").setup({})

require("mini.ai").setup({ n_lines = 500 })
require("mini.surround").setup()
require("mini.pairs").setup()
require("mini.icons").setup()
require("persistence").setup({})

local trouble_snacks = require("trouble.sources.snacks")

require("snacks").setup({
  bigfile = { enabled = true },
  dashboard = {
    enabled = true,
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
    },
  },
  explorer = { enabled = true },
  image = {
    enabled = true,
    doc = {
      enabled = true,
      inline = true,
      float = true,
      max_width = 80,
      max_height = 40,
    },
  },
  indent = { enabled = false },
  input = { enabled = true },
  notifier = { enabled = true, timeout = 3000 },
  picker = {
    enabled = true,
    actions = trouble_snacks.actions,
    sources = {
      files = { hidden = true },
      gh_issue = {},
      gh_pr = {},
    },
    win = {
      input = {
        keys = {
          ["<c-t>"] = { "trouble_open", mode = { "n", "i" } },
        },
      },
    },
  },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = false },
  statuscolumn = { enabled = true },
  words = { enabled = true },
  styles = { notification = {} },
  gh = {},
})

local Snacks = require("snacks")

_G.dd = function(...)
  Snacks.debug.inspect(...)
end

_G.bt = function()
  Snacks.debug.backtrace()
end

vim.print = _G.dd

Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>ur")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle.diagnostics():map("<leader>uD")
Snacks.toggle.option(
  "conceallevel",
  { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }
):map("<leader>uc")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
Snacks.toggle.inlay_hints():map("<leader>uh")
Snacks.toggle.indent():map("<leader>ui")
Snacks.toggle.dim():map("<leader>ud")

map("n", "<leader><space>", function()
  Snacks.picker.files()
end, "Find Files")
map("n", "<leader>/", function()
  Snacks.picker.grep()
end, "Grep")
map("n", "<leader>.", function()
  Snacks.scratch()
end, "Scratch Buffer")
map("n", "<leader>e", function()
  Snacks.explorer()
end, "Explorer")
map("n", "<leader>,", function()
  Snacks.picker.buffers()
end, "Buffers")

map("n", "<C-/>", function()
  Snacks.terminal()
end, "Terminal")
map("n", "<C-_>", function()
  Snacks.terminal()
end, "which_key_ignore")

map({ "n", "t" }, "]]", function()
  Snacks.words.jump(vim.v.count1)
end, "Next Reference")
map({ "n", "t" }, "[[", function()
  Snacks.words.jump(-vim.v.count1)
end, "Prev Reference")

map("n", "<leader>bb", function()
  Snacks.picker.buffers({
    win = {
      input = { keys = { ["dd"] = "bufdelete", ["<C-d>"] = { "bufdelete", mode = { "n", "i" } } } },
      list = { keys = { ["dd"] = "bufdelete" } },
    },
  })
end, "Switch Buffer")
map("n", "<leader>bd", function()
  Snacks.bufdelete()
end, "Delete Buffer")
map("n", "<leader>bo", function()
  Snacks.bufdelete.other()
end, "Delete Other Buffers")
map("n", "Q", function()
  Snacks.bufdelete()
end, "Delete Buffer")

map("n", "<leader>dd", function()
  Snacks.picker.diagnostics()
end, "Workspace Diagnostics")
map("n", "<leader>db", function()
  Snacks.picker.diagnostics_buffer()
end, "Buffer Diagnostics")
map("n", "<leader>dq", function()
  Snacks.picker.qflist()
end, "Quickfix List")
map("n", "<leader>dl", function()
  Snacks.picker.loclist()
end, "Location List")

map("n", "<leader>ff", function()
  Snacks.picker.files()
end, "Find Files")
map("n", "<leader>fr", function()
  Snacks.picker.recent()
end, "Recent Files")
map("n", "<leader>fc", function()
  Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, "Config Files")
map("n", "<leader>fg", function()
  Snacks.picker.git_files()
end, "Git Files")
map("n", "<leader>fp", function()
  Snacks.picker.projects()
end, "Projects")
map("n", "<leader>fR", function()
  Snacks.rename.rename_file()
end, "Rename File")

map("n", "<leader>gg", function()
  Snacks.lazygit()
end, "Lazygit")
map("n", "<leader>gl", function()
  Snacks.picker.git_log()
end, "Log")
map("n", "<leader>gL", function()
  Snacks.picker.git_log_line()
end, "Log (line)")
map("n", "<leader>gf", function()
  Snacks.picker.git_log_file()
end, "Log (file)")
map("n", "<leader>gs", function()
  Snacks.picker.git_status()
end, "Status")
map("n", "<leader>gS", function()
  Snacks.picker.git_stash()
end, "Stash")
map("n", "<leader>gd", function()
  Snacks.picker.git_diff()
end, "Diff (picker)")
map("n", "<leader>gc", function()
  Snacks.picker.git_branches()
end, "Checkout Branch")
map({ "n", "v" }, "<leader>go", function()
  Snacks.gitbrowse()
end, "Open in Browser")
map("n", "<leader>gi", function()
  Snacks.picker.gh_issue()
end, "Issues")
map("n", "<leader>gI", function()
  Snacks.picker.gh_issue({ state = "all" })
end, "Issues (all)")
map("n", "<leader>gp", function()
  Snacks.picker.gh_pr()
end, "Pull Requests")
map("n", "<leader>gP", function()
  Snacks.picker.gh_pr({ state = "all" })
end, "Pull Requests (all)")

map("n", "<leader>ls", function()
  Snacks.picker.lsp_symbols()
end, "Document Symbols")
map("n", "<leader>lS", function()
  Snacks.picker.lsp_workspace_symbols()
end, "Workspace Symbols")

map("n", "<leader>nn", function()
  Snacks.notifier.show_history()
end, "Notification History")
map("n", "<leader>nd", function()
  Snacks.notifier.hide()
end, "Dismiss All")

map("n", "<leader>sg", function()
  Snacks.picker.grep()
end, "Grep")
map({ "n", "x" }, "<leader>sw", function()
  Snacks.picker.grep_word()
end, "Word")
map("n", "<leader>sb", function()
  Snacks.picker.lines()
end, "Buffer Lines")
map("n", "<leader>sB", function()
  Snacks.picker.grep_buffers()
end, "Grep Buffers")
map("n", "<leader>sh", function()
  Snacks.picker.help()
end, "Help")
map("n", "<leader>sm", function()
  Snacks.picker.marks()
end, "Marks")
map("n", "<leader>sj", function()
  Snacks.picker.jumps()
end, "Jumps")
map("n", "<leader>sk", function()
  Snacks.picker.keymaps()
end, "Keymaps")
map("n", "<leader>sc", function()
  Snacks.picker.commands()
end, "Commands")
map("n", "<leader>s:", function()
  Snacks.picker.command_history()
end, "Command History")
map("n", "<leader>s/", function()
  Snacks.picker.search_history()
end, "Search History")
map("n", "<leader>sr", function()
  Snacks.picker.registers()
end, "Registers")
map("n", "<leader>sR", function()
  Snacks.picker.resume()
end, "Resume Last")
map("n", "<leader>su", function()
  Snacks.picker.undo()
end, "Undo History")
map("n", "<leader>sM", function()
  Snacks.picker.man()
end, "Man Pages")
map("n", "<leader>si", function()
  Snacks.picker.icons()
end, "Icons")

map("n", "<leader>uC", function()
  Snacks.picker.colorschemes()
end, "Colorschemes")
map("n", "<leader>uz", function()
  Snacks.zen()
end, "Zen Mode")
map("n", "<leader>uZ", function()
  Snacks.zen.zoom()
end, "Zoom")
map("n", "<leader>uN", function()
  Snacks.win({
    file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
    width = 0.6,
    height = 0.6,
    wo = {
      spell = false,
      wrap = false,
      signcolumn = "yes",
      statuscolumn = " ",
      conceallevel = 3,
    },
  })
end, "Neovim News")

map("n", "<leader>wd", "<C-w>c", "Close Window")
map("n", "<leader>ws", "<C-w>s", "Split Horizontal")
map("n", "<leader>wv", "<C-w>v", "Split Vertical")
map("n", "<leader>ww", "<C-w>w", "Other Window")
map("n", "<leader>w=", "<C-w>=", "Equal Size")
map("n", "<leader>wm", function()
  Snacks.zen.zoom()
end, "Maximize")

map("n", "gd", function()
  Snacks.picker.lsp_definitions()
end, "Definition")
map("n", "gD", function()
  Snacks.picker.lsp_declarations()
end, "Declaration")
map("n", "gr", function()
  Snacks.picker.lsp_references()
end, "References", { nowait = true })
map("n", "gi", function()
  Snacks.picker.lsp_implementations()
end, "Implementation")
map("n", "gy", function()
  Snacks.picker.lsp_type_definitions()
end, "Type Definition")

require("which-key").setup({
  preset = "helix",
  delay = 250,
  sort = { "alphanum", "local", "order", "group", "mod" },
  icons = {
    mappings = false,
    rules = false,
    breadcrumb = "»",
    separator = "→",
    group = "+",
  },
  plugins = {
    marks = true,
    registers = true,
    spelling = { enabled = false },
  },
  win = {
    border = "rounded",
    padding = { 1, 2 },
  },
  spec = {
    { "<leader><space>", desc = "Find Files" },
    { "<leader>/", desc = "Grep" },
    { "<leader>,", desc = "Buffers" },
    { "<leader>.", desc = "Scratch" },
    { "<leader>e", desc = "Explorer" },
    { "<leader>q", desc = "Quit" },
    { "<leader>Q", desc = "Quit All" },
    { "<leader>b", group = "Buffers" },
    { "<leader>c", group = "Code" },
    { "<leader>d", group = "Diagnostics" },
    { "<leader>f", group = "Files" },
    { "<leader>g", group = "Git" },
    { "<leader>gh", group = "Hunks" },
    { "<leader>l", group = "LSP" },
    { "<leader>m", group = "Markdown" },
    { "<leader>n", group = "Notifications" },
    { "<leader>s", group = "Search" },
    { "<leader>u", group = "UI/Toggle" },
    { "<leader>w", group = "Windows" },
    { "[", group = "Prev" },
    { "]", group = "Next" },
    { "g", group = "Goto" },
    { "gs", group = "Surround" },
  },
})

map("n", "<leader>?", function()
  require("which-key").show({ global = false })
end, "Buffer Keymaps")
map("n", "<leader>K", function()
  require("which-key").show({ global = true })
end, "All Keymaps")

require("blink.cmp").setup({
  snippets = { preset = "default" },
  signature = { enabled = true },
  appearance = {
    use_nvim_cmp_as_default = false,
    nerd_font_variant = "normal",
  },
  sources = {
    default = { "lazydev", "lsp", "path", "buffer", "snippets" },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
      cmdline = {
        min_keyword_length = 2,
      },
    },
  },
  keymap = {
    ["<C-f>"] = {},
  },
  cmdline = {
    enabled = false,
    completion = { menu = { auto_show = true } },
    keymap = {
      ["<CR>"] = { "accept_and_enter", "fallback" },
    },
  },
  completion = {
    menu = {
      border = "rounded",
      scrolloff = 1,
      scrollbar = false,
      draw = {
        padding = 1,
        gap = 1,
        columns = {
          { "kind_icon" },
          { "label", "label_description", gap = 1 },
          { "kind" },
          { "source_name" },
        },
      },
    },
    documentation = {
      window = {
        border = "rounded",
        scrollbar = false,
        winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
      },
      auto_show = true,
      auto_show_delay_ms = 500,
    },
  },
})

require("lazydev").setup({
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})

require("nvim-ts-autotag").setup({})

local comment_pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
require("Comment").setup({
  pre_hook = comment_pre_hook,
})

require("gitsigns").setup({
  signs = {
    add = { text = "┃" },
    change = { text = "┃" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signs_staged = {
    add = { text = "┃" },
    change = { text = "┃" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  watch_gitdir = { interval = 1000, follow_files = true },
  attach_to_untracked = true,
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
  sign_priority = 6,
  status_formatter = nil,
  update_debounce = 200,
  max_file_length = 40000,
  preview_config = {
    border = "rounded",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local function buffer_map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    buffer_map("n", "]h", gs.next_hunk, "Next Hunk")
    buffer_map("n", "[h", gs.prev_hunk, "Prev Hunk")
  end,
})

map("n", "<leader>ghp", function()
  require("gitsigns").preview_hunk()
end, "Preview Hunk")
map("n", "<leader>ghP", function()
  require("gitsigns").preview_hunk_inline()
end, "Preview Hunk Inline")
map("n", "<leader>ghs", function()
  require("gitsigns").stage_hunk()
end, "Stage Hunk")
map("n", "<leader>ghu", function()
  require("gitsigns").undo_stage_hunk()
end, "Undo Stage Hunk")
map("n", "<leader>ghr", function()
  require("gitsigns").reset_hunk()
end, "Reset Hunk")
map("n", "<leader>gR", function()
  require("gitsigns").reset_buffer()
end, "Reset Buffer")
map("n", "<leader>gS", function()
  require("gitsigns").stage_buffer()
end, "Stage Buffer")
map("n", "<leader>gb", function()
  require("gitsigns").blame_line()
end, "Blame Line")
map("n", "<leader>gB", function()
  require("gitsigns").blame()
end, "Blame Buffer")
map("n", "<leader>gD", function()
  vim.cmd("Gitsigns diffthis HEAD")
end, "Diff HEAD")

require("diffview").setup({})

require("tiny-inline-diagnostic").setup({
  preset = "classic",
  transparent_bg = false,
  transparent_cursorline = false,
  hi = {
    error = "DiagnosticError",
    warn = "DiagnosticWarn",
    info = "DiagnosticInfo",
    hint = "DiagnosticHint",
    arrow = "NonText",
    background = "CursorLine",
    mixing_color = "None",
  },
  options = {
    show_source = { enabled = false, if_many = false },
    use_icons_from_diagnostic = false,
    set_arrow_to_diag_color = false,
    add_messages = true,
    throttle = 20,
    softwrap = 30,
    multilines = { enabled = false, always_show = false },
    show_all_diags_on_cursorline = false,
    enable_on_insert = false,
    enable_on_select = false,
    overflow = { mode = "wrap", padding = 0 },
    break_line = { enabled = false, after = 30 },
    format = nil,
    virt_texts = { priority = 2048 },
    severity = {
      vim.diagnostic.severity.ERROR,
      vim.diagnostic.severity.WARN,
      vim.diagnostic.severity.INFO,
      vim.diagnostic.severity.HINT,
    },
    overwrite_events = nil,
  },
  disabled_ft = {},
})

vim.diagnostic.config({ virtual_text = false })

vim.g.mkdp_filetypes = { "markdown" }
vim.g.mkdp_auto_close = 1
vim.g.mkdp_theme = "dark"
vim.g.mkdp_preview_options = {
  mermaid = { theme = "dark" },
  katex = {},
  disable_sync_scroll = 0,
  sync_scroll_type = "middle",
  hide_yaml_meta = 1,
  sequence_diagrams = {},
  flowchart_diagrams = {},
}

map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", "Markdown Preview")

require("render-markdown").setup({
  heading = {
    enabled = true,
    sign = false,
    icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
  },
  code = {
    enabled = true,
    sign = false,
    style = "full",
    left_pad = 1,
    right_pad = 1,
    border = "thin",
    language_pad = 1,
  },
  bullet = {
    enabled = true,
    icons = { "●", "○", "◆", "◇" },
  },
  checkbox = {
    enabled = true,
    unchecked = { icon = "☐ " },
    checked = { icon = "☑ " },
  },
  quote = { enabled = true, icon = "▎" },
  pipe_table = { enabled = true, style = "full" },
  callout = {
    note = { raw = "[!NOTE]", rendered = " Note", highlight = "RenderMarkdownInfo" },
    tip = { raw = "[!TIP]", rendered = " Tip", highlight = "RenderMarkdownSuccess" },
    important = { raw = "[!IMPORTANT]", rendered = " Important", highlight = "RenderMarkdownHint" },
    warning = { raw = "[!WARNING]", rendered = " Warning", highlight = "RenderMarkdownWarn" },
    caution = { raw = "[!CAUTION]", rendered = " Caution", highlight = "RenderMarkdownError" },
  },
})

map("n", "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", "Render Markdown Toggle")

require("trouble").setup({
  win = {
    type = "split",
    position = "bottom",
    size = 15,
  },
})

map("n", "<leader>dt", "<cmd>Trouble diagnostics toggle<cr>", "Trouble (workspace)")
map("n", "<leader>dT", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Trouble (buffer)")
map("n", "<leader>dL", "<cmd>Trouble loclist toggle<cr>", "Location List")
map("n", "<leader>dQ", "<cmd>Trouble qflist toggle<cr>", "Quickfix List")
map("n", "<leader>lt", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", "LSP References (Trouble)")
map("n", "<leader>lT", "<cmd>Trouble symbols toggle focus=false<cr>", "Symbols (Trouble)")
