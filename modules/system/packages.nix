{ ... }:
{
  femboy.modules.packages =
    { pkgs, ... }:
    let
      equicordDiscord = pkgs.discord.override {
        withEquicord = true;
      };

      cliPackages = with pkgs; [
        vim
        wget
        curl
        git
        git-lfs
        gh
        jq
        yq-go
        rsync
        unzip
        zip
        p7zip
        file
        tree
        bat
        fd
        ripgrep
        eza
        zoxide
        fzf
        lazygit
        fastfetch
        disfetch
        microfetch
        nitch
        nix-melt
      ];

      shellPackages = with pkgs; [
        fish
        atuin
        any-nix-shell
        nix-your-shell
        direnv
        nix-direnv
        z-lua
        starship
        carapace
        tmux
        zellij
        btop
        htop
        just
      ];

      desktopPackages = with pkgs; [
        ghostty
        kitty
        brave
        vivaldi
        firefox
        vscode
        google-chrome
        zed-editor
        spotify
        spotify-tray
        vesktop
        telegram-desktop
        obsidian
        thunar
        yazi
        zathura
        fuzzel
        mako
        wl-clipboard
        grim
        slurp
        xsettingsd
        xournalpp
        equicordDiscord
        heroic
      ];

      mediaPackages = with pkgs; [
        ffmpeg
        mpv
        imagemagick
        krabby
        reaper
        pipewire.jack
      ];

      devPackages = with pkgs; [
        gcc
        gnumake
        clang-tools
        nodejs
        bun
        go
        g-ls
        python315
        rust-analyzer
        cargo
        rustc
        rustfmt
        clippy
        emacs
        ghc
        stylua
        cabal-install
      ];

      systemPackages = with pkgs; [
        pciutils
        usbutils
        lm_sensors
        brightnessctl
        playerctl
        timeshift
        gsettings-desktop-schemas
        glib
        dconf
        awww
        xwayland-satellite
      ];

      themePackages = with pkgs; [
        hicolor-icon-theme
        adwaita-icon-theme
        kdePackages.breeze-icons
        whitesur-icon-theme
        whitesur-gtk-theme
        whitesur-cursors
        morewaita-icon-theme
        qt6Packages.qt6ct
        libsForQt5.qt5ct
        themechanger
        zpkgs.catppuccin-icons
      ];
    in
    {
      environment.systemPackages =
        cliPackages
        ++ shellPackages
        ++ desktopPackages
        ++ mediaPackages
        ++ devPackages
        ++ systemPackages
        ++ themePackages;
    };
}
