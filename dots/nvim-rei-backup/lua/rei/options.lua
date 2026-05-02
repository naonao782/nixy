vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.updatetime = 100
vim.opt.timeoutlen = 1000
vim.opt.confirm = true
vim.opt.autoread = true

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.signcolumn = "yes:1"
vim.opt.cursorline = false
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.showmode = false
vim.opt.showcmd = false
vim.opt.ruler = true
vim.opt.showtabline = 0
vim.opt.cmdheight = 1
vim.opt.pumheight = 10
vim.opt.fillchars = { eob = " " }
vim.o.winborder = "rounded"

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.fileencoding = "utf-8"
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.conceallevel = 0

vim.opt.title = true
vim.opt.guifont = "monospace:h17"

vim.filetype.add({
  extension = {
    gotmpl = "gotmpl",
    tmpl = "gotmpl",
  },
  filename = {
    [".envrc"] = "sh",
  },
  pattern = {
    ["[jt]sconfig.*.json"] = "jsonc",
  },
})
