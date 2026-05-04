{
  self,
  textfox,
  ...
}:
let
  inherit (self.lib) mkDotsModule mkHomeFilesModule;
  username = "shigure";
  vscodeSettings = self.paths.dots + "/vscode/settings.json";
in
{
  femboy.users.shigure =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        (lib.mkAliasOptionModule [ "hj" ] [ "hjem" "users" username ])
      ];

      users.users.${username} = {
        isNormalUser = true;
        description = username;
        home = "/home/${username}";
        createHome = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "audio"
        ];
        shell = pkgs.fish;
      };

      hjem.users.${username} = {
        enable = true;
        user = username;
        directory = config.users.users.${username}.home;
        clobberFiles = true;
      };

      systemd.services."vscode-settings-bootstrap-${username}" = {
        description = "Materialize a writable VSCode settings.json for ${username}";
        wantedBy = [ "hjem.target" ];
        after = [ "hjem-copy@${username}.service" ];
        serviceConfig.Type = "oneshot";
        script =
          let
            homeDir = config.users.users.${username}.home;
            target = "${homeDir}/.config/Code/User/settings.json";
            group = config.users.users.${username}.group;
          in
          ''
            target=${lib.escapeShellArg target}
            baseline=${lib.escapeShellArg vscodeSettings}

            mkdir -p "$(dirname "$target")"

            if [ ! -e "$target" ]; then
              cp "$baseline" "$target"
              chown ${username}:${group} "$target"
              chmod 0644 "$target"
              exit 0
            fi

            if [ -L "$target" ]; then
              resolved="$(readlink -f "$target")"
              if [[ "$resolved" == /nix/store/* ]]; then
                tmp="$(mktemp "$(dirname "$target")/settings.json.XXXXXX")"
                cp "$target" "$tmp"
                mv -f "$tmp" "$target"
                chown ${username}:${group} "$target"
                chmod 0644 "$target"
              fi
            fi
          '';
      };
    };

  femboy.dots.shigure-cli = mkDotsModule username {
    "atuin/config.toml" = "/atuin/config.toml";
    "fish/aliases.fish" = "/fish/aliases.fish";
    "fish/conf.d/repo-init.fish" = "/fish/conf.d/repo-init.fish";
    "kitty/kitty.conf" = "/kitty/kitty.conf";
    "kitty/themes/oxocarbon.conf" = "/kitty/themes/oxocarbon.conf";
    "krabby/config.toml" = "/krabby/config.toml";
    "yazi/theme.toml" = "/yazi/theme.toml";
  };

  femboy.dots.shigure-gui = mkDotsModule username {
    "fontconfig/fonts.conf" = "/fontconfig/fonts.conf";
    "fuzzel/fuzzel.ini" = "/fuzzel/fuzzel.ini";
    "gtk-3.0/settings.ini" = "/gtk-3.0/settings.ini";
    "gtk-4.0/settings.ini" = "/gtk-4.0/settings.ini";
    "kwalletrc" = "/kwalletrc";
    "qt5ct/qt5ct.conf" = "/qt5ct/qt5ct.conf";
    "qt6ct/qt6ct.conf" = "/qt6ct/qt6ct.conf";
    "xsettingsd/xsettingsd.conf" = "/xsettingsd/xsettingsd.conf";
  };

  femboy.dots.shigure-niri = mkDotsModule username {
    "niri/config.kdl" = "/niri/config.kdl";
  };

  femboy.dots.shigure-browser = mkHomeFilesModule username {
    ".mozilla/firefox/7ve3qmtx.rawr/chrome" = _: textfox.outPath + "/chrome";
    ".mozilla/firefox/7ve3qmtx.rawr/user.js" = _: textfox.outPath + "/user.js";
  };
}
