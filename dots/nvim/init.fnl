;; disable builtin vim plugins and providers, small speedup

(local default-plugins [:2html_plugin
                        :getscript
                        :getscriptPlugin
                        :gzip
                        :logipat
                        :netrw
                        :netrwPlugin
                        :netrwSettings
                        :netrwFileHandlers
                        :matchit
                        :tar
                        :tarPlugin
                        :rrhelper
                        :spellfile_plugin
                        :vimball
                        :vimballPlugin
                        :zip
                        :zipPlugin
                        :tutor
                        :rplugin
                        :syntax
                        :synmenu
                        :optwin
                        :compiler
                        :bugreport
                        :ftplugin])

(local default-providers [:node :perl :ruby])

(each [_ plugin (pairs default-plugins)] (tset vim.g (.. :loaded_ plugin) 1))
(each [_ provider (ipairs default-providers)]
  (tset vim.g (.. :loaded_ provider :_provider) 0))

(let [data-path (vim.fn.stdpath :data)
      hotpot-path (or (let [path (.. data-path :/site/pack/packer/start/hotpot.nvim)]
                        (when (vim.loop.fs_stat path) path))
                      (let [path (.. data-path :/site/pack/packer/opt/hotpot.nvim)]
                        (when (vim.loop.fs_stat path) path)))]
  (when hotpot-path
    ((. vim.opt.rtp :prepend) hotpot-path)))

;; check if hotpot exists
(if (pcall require :hotpot) 
  (do
    (let [fennel ((. (require :fennel) :install) {:allowedGlobals false
                                                  :compilerEnv _G})
          config-path (vim.fn.stdpath :config)]
      (set fennel.path (table.concat [(.. config-path :/fnl/?.fnl)
                                      (.. config-path :/fnl/?/init.fnl)
                                      (.. config-path :/?.fnl)
                                      (.. config-path :/?/init.fnl)
                                      fennel.path]
                                     ";"))
      (tset fennel :macro-path
            (table.concat [(.. config-path :/fnl/?.fnlm)
                           (.. config-path :/fnl/?/init.fnlm)
                           (.. config-path :/fnl/?.fnl)
                           (.. config-path :/fnl/?/init-macros.fnl)
                           (.. config-path :/fnl/?/init.fnl)
                           (.. config-path :/?.fnlm)
                           (.. config-path :/?/init.fnlm)
                           (.. config-path :/?.fnl)
                           (.. config-path :/?/init-macros.fnl)
                           (.. config-path :/?/init.fnl)
                           (. fennel :macro-path)]
                          ";")))
    ;; if NYOOM_PROFILE is set, load profiling code
    (when (os.getenv :NYOOM_PROFILE)
      ((. (require :core.lib.profile) :toggle)))
    ;; load nyoom standard library
    (local stdlib (require :core.lib))
    (each [k v (pairs stdlib)] (rawset _G k v))
    ;; load nyoom
    (require :core))
  ;; else print error
  (print "Unable to require hotpot. Run `~/.config/nvim/bin/nyoom install` and then `~/.config/nvim/bin/nyoom sync`.")))
