{ ... }:
{
  femboy.modules.nixvim =
    {
      config,
      inputs,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.nixvim.nixosModules.nixvim
      ];

      programs.nixvim = {
        enable = true;
        defaultEditor = true;
        colorschemes.catppuccin.enable = true;

        opts = {
          number = true;
          relativenumber = true;
          shiftwidth = 2;
          tabstop = 2;
          expandtab = true;
          showmode = false;
          cmdheight = 0;
          laststatus = 3;
          ruler = false;
        };

        clipboard = {
          providers.wl-copy.enable = true;
          register = "unnamedplus";
        };

        plugins = {
          lualine = {
            enable = true;
            callSetup = false;
          };
          telescope.enable = true;
          treesitter.enable = true;
          web-devicons.enable = true;
          gitsigns.enable = true;
          cmp.enable = true;
          lsp = {
            enable = true;
            servers = {
              nixd.enable = true;
              lua_ls.enable = true;
              clangd.enable = true;
            };
          };
        };

        extraPackages = with pkgs; [
          ripgrep
          fd
          stylua
          nixd
          lua-language-server
          clang-tools
          wl-clipboard
        ];

        extraConfigLuaPost = ''
          local nyoom_modes = {
            n = "RW",
            no = "RO",
            v = "**",
            V = "**",
            ["\22"] = "**",
            s = "S",
            S = "SL",
            ["\19"] = "SB",
            i = "**",
            ic = "**",
            R = "RA",
            Rv = "RV",
            c = "VIEX",
            cv = "VIEX",
            ce = "EX",
            r = "r",
            rm = "r",
            ["r?"] = "r",
            ["!"] = "!",
            t = "TERM",
          }

          local function nyoom_mode()
            local mode = vim.api.nvim_get_mode().mode
            return string.upper(string.format(" %s ", nyoom_modes[mode] or mode))
          end

          local function nyoom_filename()
            local name = vim.fn.expand("%:t")
            if name == "" then
              return " nyoom-nvim "
            end

            return string.format(" %s ", name)
          end

          local function nyoom_branch()
            local gitsigns = vim.b.gitsigns_status_dict
            if not gitsigns or not gitsigns.head or gitsigns.head == "" then
              return ""
            end

            return string.format(" (git:#%s) ", gitsigns.head)
          end

          local function nyoom_bufnr()
            return string.format(" #%d ", vim.api.nvim_get_current_buf())
          end

          local function diagnostic_count(severity)
            return #vim.diagnostic.get(0, { severity = severity })
          end

          local function nyoom_diagnostics()
            if not vim.diagnostic then
              return ""
            end

            local warnings = diagnostic_count(vim.diagnostic.severity.WARN)
            local errors = diagnostic_count(vim.diagnostic.severity.ERROR)
            if warnings == 0 and errors == 0 then
              return ""
            end

            return string.format(" W:%d E:%d ", warnings, errors)
          end

          local function nyoom_search_or_location()
            if vim.v.hlsearch == 0 then
              return string.format(" %d:%d ", vim.fn.line("."), vim.fn.col("."))
            end

            local ok, count = pcall(vim.fn.searchcount, { recompute = true })
            if not ok or not count or not count.current or count.total == 0 then
              return ""
            end

            if count.incomplete == 1 then
              return " ?/? "
            end

            local total = count.total
            if count.total > count.maxcount then
              total = ">" .. count.maxcount
            end

            return string.format(" %s matches ", total)
          end

          require("lualine").setup({
            options = {
              theme = "catppuccin",
              globalstatus = true,
              component_separators = { left = "", right = "" },
              section_separators = { left = "", right = "" },
            },
            sections = {
              lualine_a = { nyoom_mode },
              lualine_b = { nyoom_filename },
              lualine_c = { nyoom_branch, nyoom_bufnr },
              lualine_x = { nyoom_diagnostics, "filetype", nyoom_search_or_location },
              lualine_y = {},
              lualine_z = {},
            },
            inactive_sections = {
              lualine_a = {},
              lualine_b = { nyoom_filename },
              lualine_c = { nyoom_branch },
              lualine_x = { "filetype" },
              lualine_y = {},
              lualine_z = {},
            },
          })
        '';
      };

      environment.systemPackages = [
        config.programs.nixvim.build.package
      ];
    };
}
