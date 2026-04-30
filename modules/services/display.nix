{ ... }:
{
  femboy.modules.display =
    { pkgs, inputs, ... }:
    let
      sddm-theme = inputs.silentSDDM.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;

        theme = "silent";

        extraPackages = [
          sddm-theme
        ];
      };

      environment.systemPackages = [
        sddm-theme
      ];

      environment.etc."sddm.conf.d/silent-theme.conf".text = ''
        [Theme]
        Current=silent
        ConfigFile=${sddm-theme}/share/sddm/themes/silent/configs/catppuccin-macchiato.conf
      '';
    };
}
