{ ... }:
{
  femboy.modules.fish =
    { pkgs, ... }:
    {
      programs.fish.enable = true;
      users.defaultUserShell = pkgs.fish;
    };
}
