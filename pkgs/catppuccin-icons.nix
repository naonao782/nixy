{ fetchFromGitHub, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "catppuccin-icons";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "kagurazakei";
    repo = "Catppuccin-SE";
    rev = "4552dcc48544da2f08bf37e7b64f1c3a3322707c";
    hash = "sha256-8liUy6faUy9i/M1A/DGX/y82gO2l+Bx76Z3UXEMauM4=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/icons
    cp -r Catppuccin-SE $out/share/icons/
  '';
}
