{ self, nixpkgs, ... }:
let
  inherit (nixpkgs.lib)
    genAttrs
    isFunction
    mapAttrs
    setAttrByPath
    ;

  supportedSystems = [ "x86_64-linux" ];

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
    mkPkgx = system: self.packages.${system};
    mkPkgx' = pkgs: self.lib.mkPkgx pkgs.stdenv.hostPlatform.system;
    pkgsFor = genAttrs supportedSystems (system: nixpkgs.legacyPackages.${system});
    eachSystem =
      fn:
      mapAttrs (
        system: pkgs:
        let
          zpkgs = self.lib.mkPkgx system;
        in
        fn { inherit system pkgs zpkgs; }
      ) self.lib.pkgsFor;

    mkDotsModule =
      username: dots: mkSourceMap [ "hjem" "users" username "xdg" "config" "files" ] self.paths.dots dots;

    mkHomeFilesModule =
      username: files: mkSourceMap [ "hjem" "users" username "files" ] self.paths.dots files;
  };
}
