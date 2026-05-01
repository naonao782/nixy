{ self, ... }:
{
  femboy.profiles.audio = {
    imports = [
      self.femboy.modules.audioProduction
    ];
  };
}
