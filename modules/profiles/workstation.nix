{ self, ... }:
{
  femboy.profiles.workstation = {
    imports = [
      self.femboy.modules.networking
      self.femboy.modules.audio
      self.femboy.modules.fonts
      self.femboy.modules.packages
      self.femboy.modules.services
      self.femboy.modules.flatpak
      self.femboy.modules.display
      self.femboy.modules.plasma
      self.femboy.modules.nixvim
      self.femboy.modules.theme
    ];
  };
}
