{ ... }:
{
  femboy.modules.gaming =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        extest.enable = true;
        protontricks.enable = true;

        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };

      programs.gamescope = {
        enable = true;
        capSysNice = true;
      };

      programs.gamemode.enable = true;

      environment.systemPackages = with pkgs; [
        mangohud
        protonup-qt
      ];
    };
}
