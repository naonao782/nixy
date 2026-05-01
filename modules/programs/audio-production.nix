{ ... }:
{
  femboy.modules.audioProduction =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        alsa-utils
        aubio
        carla
        cardinal
        calf
        bespokesynth
        crosspipe
        dragonfly-reverb
        easyeffects
        lsp-plugins
        pavucontrol
        qjackctl
        qpwgraph
        sonobus
        spek
        surge-xt
        tenacity
        x42-plugins
        yabridge
        yabridgectl
        zam-plugins
      ];
    };
}
