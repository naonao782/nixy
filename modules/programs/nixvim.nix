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
        };

        clipboard = {
          providers.wl-copy.enable = true;
          register = "unnamedplus";
        };

        plugins = {
          lualine.enable = true;
          telescope.enable = true;
          treesitter.enable = true;
          web-devicons.enable = true;
          cmp.enable = true;
          lsp = {
            enable = true;
            servers = {
              nixd.enable = true;
              lua_ls.enable = true;
            };
          };
        };

        extraPackages = with pkgs; [
          ripgrep
          fd
          stylua
          nixd
          lua-language-server
          wl-clipboard
        ];
      };

      environment.systemPackages = [
        config.programs.nixvim.build.package
      ];
    };
}
