{ self, ... }:
{
  femboy.profiles.gaming = {
    imports = [
      self.femboy.modules.gaming
      self.femboy.modules.wine
    ];
  };
}
