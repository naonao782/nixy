{
  paths,
  pkgs,
}:
let
  inherit (pkgs.lib) filesystem removeAttrs;

  packageSet = filesystem.packagesFromDirectoryRecursive {
    inherit (pkgs) newScope;
    callPackage = pkgs.callPackage;
    directory = paths.pkgs;
  };
in
removeAttrs packageSet [
  "callPackage"
  "newScope"
  "overrideScope"
  "packages"
  "recurseForDerivations"
]
