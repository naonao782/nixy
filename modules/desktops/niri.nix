{ ... }:
{
  femboy.modules.niri =
    { pkgs, ... }:
    {
      programs.niri.enable = true;
      programs.xwayland.enable = true;

      environment.systemPackages = with pkgs; [
        xwayland-satellite
      ];

      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };
}
