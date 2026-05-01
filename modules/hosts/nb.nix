{ self, ... }:
{
  femboy.hosts.nb = {
    imports = [
      ../../hosts/nb/hardware-configuration.nix
      self.femboy.users.shigure
      self.femboy.dots.shigure-cli
      self.femboy.dots.shigure-gui
      self.femboy.dots.shigure-niri
      self.femboy.dots.shigure-browser
      self.femboy.profiles.default
      self.femboy.profiles.workstation
      self.femboy.profiles.audio
      self.femboy.profiles.gaming
      self.femboy.profiles.niri
    ];

    networking.hostName = "nb";
    time.timeZone = "Asia/Jakarta";

    boot.kernelParams = [ "acpi_backlight=native" ];

    system.stateVersion = "25.11";
  };
}
