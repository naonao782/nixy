{ ... }:
{
  femboy.modules.theme = {
    environment.sessionVariables = {
      QT_ICON_THEME = "WhiteSur";
      QT_QPA_PLATFORMTHEME = "qt6ct";
      XCURSOR_THEME = "WhiteSur-cursors";
      XCURSOR_SIZE = "28";
    };

    programs.dconf.profiles.user.databases = [
      {
        settings."org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          cursor-theme = "WhiteSur-cursors";
          font-name = "Inter 10";
          gtk-theme = "WhiteSur-Dark";
          icon-theme = "WhiteSur";
        };
      }
    ];
  };
}
