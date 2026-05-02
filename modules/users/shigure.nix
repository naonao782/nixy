{
  self,
  textfox,
  ...
}:
let
  inherit (self.lib) mkDotsModule mkHomeFilesModule;
  username = "shigure";
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
