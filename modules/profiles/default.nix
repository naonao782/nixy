{ self, ... }:
{
  femboy.profiles.default = {
    imports = [
      self.femboy.modules.hjem
      self.femboy.modules.boot
      self.femboy.modules.nix
      self.femboy.modules.fish
      self.femboy.modules.starship
    ];
  };
}
