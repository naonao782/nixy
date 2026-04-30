inputs:
assert inputs ? nixpkgs;
let
  lib = inputs.nixpkgs.lib;
  inherit (lib)
    flip
    flatten
    hasSuffix
    filter
    filesystem
    pipe
    recursiveUpdate
    foldAttrs
    ;

  recursiveImport = path: filter (hasSuffix ".nix") (filesystem.listFilesRecursive path);

  importModules = flip pipe [
    flatten
    (map (
      x:
      if builtins.isPath x then
        let
          file = toString x;
        in
        builtins.addErrorContext "while importing module file: ${file}" (import x)
      else
        x
    ))
    (map (
      x:
      if builtins.isFunction x then
        builtins.addErrorContext "while evaluating module function" (x inputs)
      else
        x
    ))
    (foldAttrs recursiveUpdate { })
  ];
in
{
  inherit recursiveImport importModules;
}
