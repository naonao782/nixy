{ ... }:
{
  femboy.modules.fonts =
    { lib, pkgs, ... }:
    {
      fonts = {
        fontDir.enable = true;
        fontconfig.defaultFonts = {
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
}
