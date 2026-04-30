{ ... }:
{
  femboy.modules.hjem =
    { inputs, ... }:
    {
      imports = [
        inputs.hjem.nixosModules.default
      ];
    };
}
