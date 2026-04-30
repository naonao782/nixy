{ nixpkgs, ... }:

let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
in
{
  formatter.${system} = pkgs.writeShellApplication {
    name = "nix-fmt";
    runtimeInputs = with pkgs; [
      findutils
      nixfmt
    ];
    text = ''
      find . -name '*.nix' -print0 | xargs -0 nixfmt
    '';
  };
}
