{ ... }:
{
  femboy.modules.nix = {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    documentation.man.enable = false;
    documentation.man.cache.enable = false;

    nixpkgs.config.allowUnfree = true;

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      open = false;
      nvidiaSettings = true;

      prime = {
        offload.enable = true;
        offload.enableOffloadCmd = true;

        amdgpuBusId = "PCI:6:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}
