{ ... }:
{
  femboy.modules.wine =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        wineWow64Packages.stagingFull
        winetricks
      ];
    };
}
