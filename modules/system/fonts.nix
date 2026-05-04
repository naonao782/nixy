{ ... }:
{
  femboy.modules.fonts =
    { lib, pkgs, ... }:
    {
      fonts = {
        fontDir.enable = true;
        fontconfig = {
          enable = true;
          antialias = true;
          hinting = {
            enable = false;
            style = "slight";
          };
          subpixel = {
            rgba = "none";
            lcdfilter = "none";
          };

          defaultFonts = {
            serif = [
              "Source Serif 4"
              "Noto Serif"
            ];
            sansSerif = [
              "Inter"
              "Noto Sans"
            ];
            monospace = [
              "JetBrainsMono Nerd Font"
              "Iosevka Nerd Font"
            ];
            emoji = [
              "Noto Color Emoji"
            ];
          };
        };

        packages = lib.attrValues {
          inherit (pkgs.nerd-fonts)
            jetbrains-mono
            caskaydia-cove
            iosevka
            fira-mono
            roboto-mono
            monaspace
            commit-mono
            martian-mono
            geist-mono
            hack
            inconsolata
            sauce-code-pro
            meslo-lg
            blex-mono
            ubuntu-mono
            symbols-only
            ;

          inherit (pkgs.maple-mono)
            NF
            ;

          inherit (pkgs)
            inter
            source-sans
            source-serif
            ibm-plex
            atkinson-hyperlegible
            libertinus
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-cjk-serif
            noto-fonts-color-emoji
            twitter-color-emoji
            material-design-icons
            font-awesome
            carlito
            dejavu_fonts
            sarasa-gothic
            ;
        };
      };
    };

  environment.variables = {
    FREETYPE_PROPERTIES = ''
      truetype:interpreter-version=40
      autofitter:no-stem-darkening=1
      cff:no-stem-darkening=1
    '';
  };
}
