{ ... }:
{
  femboy.modules.boot =
    { pkgs, ... }:
    {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      boot.kernelPackages = pkgs.linuxKernel.packagesFor pkgs.cachyosKernels.linux-cachyos-latest;

      powerManagement.enable = true;
      programs.dconf.enable = true;

      boot.kernelParams = [
        "amd_pstate=active"
        "pcie_aspm.policy=powersave"
      ];
    };
}
