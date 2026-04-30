inputs@{
  self,
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
            nix-cachyos-kernel.overlays.default
          ];
        }
      ];
    };
in
{
  nixosConfigurations = genAttrs (attrNames self.femboy.hosts) mkHost;
}
