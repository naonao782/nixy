{ ... }:
{
  femboy.modules.plasma =
    { lib, ... }:
    {
      services.xserver.enable = true;
      services.desktopManager.plasma6.enable = true;

      security.pam.services = {
        login.kwallet.enable = lib.mkForce false;
        kde.kwallet.enable = lib.mkForce false;
      };
    };
}
