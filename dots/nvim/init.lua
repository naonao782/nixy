local default_plugins = {"2html_plugin", "getscript", "getscriptPlugin", "gzip", "logipat", "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers", "matchit", "tar", "tarPlugin", "rrhelper", "spellfile_plugin", "vimball", "vimballPlugin", "zip", "zipPlugin", "tutor", "rplugin", "syntax", "synmenu", "optwin", "compiler", "bugreport", "ftplugin"}
local default_providers = {"node", "perl", "ruby"}
for _, plugin in pairs(default_plugins) do
  vim.g[("loaded_" .. plugin)] = 1
end
for _, provider in ipairs(default_providers) do
  vim.g[("loaded_" .. provider .. "_provider")] = 0
end
local data_path = vim.fn.stdpath("data")
for _, hotpot_path in ipairs({
  data_path .. "/site/pack/packer/start/hotpot.nvim",
  data_path .. "/site/pack/packer/opt/hotpot.nvim",
}) do
  if vim.loop.fs_stat(hotpot_path) then
    vim.opt.rtp:prepend(hotpot_path)
    break
  end
end
if pcall(require, "hotpot") then
  local fennel = (require("fennel")).install({allowedGlobals = false, compilerEnv = _G})
  local config_path = vim.fn.stdpath("config")
  fennel.path = table.concat({
    config_path .. "/fnl/?.fnl",
    config_path .. "/fnl/?/init.fnl",
    config_path .. "/?.fnl",
    config_path .. "/?/init.fnl",
    fennel.path,
  }, ";")
  fennel["macro-path"] = table.concat({
    config_path .. "/fnl/?.fnlm",
    config_path .. "/fnl/?/init.fnlm",
    config_path .. "/fnl/?.fnl",
    config_path .. "/fnl/?/init-macros.fnl",
    config_path .. "/fnl/?/init.fnl",
    config_path .. "/?.fnlm",
    config_path .. "/?/init.fnlm",
    config_path .. "/?.fnl",
    config_path .. "/?/init-macros.fnl",
    config_path .. "/?/init.fnl",
    fennel["macro-path"],
  }, ";")
  if os.getenv("NYOOM_PROFILE") then
    do end (require("core.lib.profile")).toggle()
  else
  end
  local stdlib = require("core.lib")
  for k, v in pairs(stdlib) do
    rawset(_G, k, v)
  end
  return require("core")
else
  return print("Unable to require hotpot. Run `~/.config/nvim/bin/nyoom install` and then `~/.config/nvim/bin/nyoom sync`.")
end 
