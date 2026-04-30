{ ... }:
{
  femboy.modules.services = {
    hardware.bluetooth.enable = true;

    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;
    services.thermald.enable = true;
    services.printing.enable = true;
  };
}
