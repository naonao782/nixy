{ ... }:
{
  femboy.modules.noctalia =
    {
      inputs,
      lib,
      pkgs,
      ...
    }:
    let
      iconTheme = "WhiteSur";
      package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
      wrappedPackage = pkgs.writeShellScriptBin "noctalia-shell" ''
        export XDG_DATA_HOME="''${XDG_DATA_HOME:-$HOME/.local/share}"
        export XDG_DATA_DIRS="''${XDG_DATA_HOME}:$HOME/.nix-profile/share:/run/current-system/sw/share''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
        export QT_ICON_THEME="''${QT_ICON_THEME:-${iconTheme}}"
        export QT_QPA_PLATFORMTHEME="''${QT_QPA_PLATFORMTHEME:-qt6ct}"
        unset QT_QUICK_CONTROLS_STYLE

        exec ${lib.getExe package} "$@"
      '';
    in
    {
      environment.systemPackages = [
        wrappedPackage
      ];
    };
}
