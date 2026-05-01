{ ... }:
{
  femboy.modules.audio = {
    users.groups.audio = { };

    services.pulseaudio.enable = false;

    security.rtkit.enable = true;
    security.pam.loginLimits = [
      {
        domain = "@audio";
        item = "memlock";
        type = "-";
        value = "unlimited";
      }
      {
        domain = "@audio";
        item = "nice";
        type = "-";
        value = "-19";
      }
      {
        domain = "@audio";
        item = "rtprio";
        type = "-";
        value = "95";
      }
    ];

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;

      extraConfig.pipewire."92-low-latency"."context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.allowed-rates" = [
          44100
          48000
          88200
          96000
        ];
        "default.clock.quantum" = 128;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 2048;
      };

      extraConfig."pipewire-pulse"."92-low-latency"."stream.properties" = {
        "pulse.default.req" = "128/48000";
        "pulse.max.req" = "1024/48000";
        "pulse.min.frag" = "32/48000";
        "pulse.min.req" = "32/48000";
      };

      wireplumber.extraConfig."51-disable-device-suspend"."monitor.alsa.rules" = [
        {
          actions.update-props = {
            "session.suspend-timeout-seconds" = 0;
          };
          matches = [
            {
              "node.name" = "~alsa_input.*";
            }
            {
              "node.name" = "~alsa_output.*";
            }
          ];
        }
      ];
    };
  };
}
