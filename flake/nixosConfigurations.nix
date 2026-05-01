inputs@{
  self,
  audio,
  nixpkgs,
  nix-cachyos-kernel,
  ...
}:
let
  inherit (nixpkgs.lib) attrNames genAttrs nixosSystem;

  mkHost =
    hostName:
    nixosSystem {
      system = self.femboy.hosts.${hostName}.system or "x86_64-linux";

      specialArgs = {
        inherit inputs self;
      };

      modules = [
        self.femboy.hosts.${hostName}
        {
          nixpkgs.overlays = [
            audio.overlays.default
            (_final: prev: {
              zpkgs = import ../packageSet.nix {
                pkgs = prev;
                paths = self.paths;
              };
            })
            nix-cachyos-kernel.overlays.default
          ];
        }
      ];
    };
in
{
  nixosConfigurations = genAttrs (attrNames self.femboy.hosts) mkHost;
}
