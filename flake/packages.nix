{
  self,
  ...
}:
{
  packages = builtins.mapAttrs (
    _system: pkgs:
    import ../packageSet.nix {
      inherit pkgs;
      paths = self.paths;
    }
  ) self.lib.pkgsFor;
}
