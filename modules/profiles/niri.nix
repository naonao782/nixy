{ self, ... }:
{
  femboy.profiles.niri = {
    imports = [
      self.femboy.modules.niri
      self.femboy.modules.noctalia
    ];
  };
}
