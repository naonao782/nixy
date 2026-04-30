{ self, nixpkgs, ... }:
let
  inherit (nixpkgs.lib) isFunction mapAttrs setAttrByPath;

  mkSourceMap =
    attrPath: basePath: files:
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      args = {
        inherit
          config
          pkgs
          lib
          self
          ;
        dotsDir = self.paths.dots;
      };

      normalize = entry: {
        source = if isFunction entry then entry args else basePath + entry;
      };
    in
    setAttrByPath attrPath (mapAttrs (_: normalize) files);
in
{
  lib = {
    mkDotsModule =
      username: dots: mkSourceMap [ "hjem" "users" username "xdg" "config" "files" ] self.paths.dots dots;

    mkHomeFilesModule =
      username: files: mkSourceMap [ "hjem" "users" username "files" ] self.paths.dots files;
  };
}
