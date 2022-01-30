{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.pipewire;
in
{
  options.profiles.pipewire.enable = mkEnableOption "Enable the PipeWire audio/video daemon instead of PulseAudio";
  options.profiles.pipewire.lowlatency.enable = mkEnableOption "Enable low-latency audio configuration for PipeWire";

  config = mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        # needed for pactl utility some apps might rely on
        pulseaudio
        # patchbay
        helvum
        # sound effects
        easyeffects
      ];
      # https://nixos.wiki/wiki/PipeWire
      sound.enable = false;
      hardware.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;

        # Default session manager
        media-session.enable = true;


        config.pipewire = {
          "context.properties" = {
            #"link.max-buffers" = 64;
            "link.max-buffers" = 16; # version < 3 clients can't handle more than this
            "log.level" = 2; # https://docs.pipewire.org/page_daemon.html
            #"default.clock.rate" = 48000;
            #"default.clock.quantum" = 1024;
            #"default.clock.min-quantum" = 32;
            #"default.clock.max-quantum" = 8192;
            #
          };
          "context.objects" = [
            {
              # A default dummy driver. This handles nodes marked with the "node.always-driver"
              # properyty when no other driver is currently active. JACK clients need this.
              factory = "spa-node-factory";
              args = {
                "factory.name"     = "support.node.driver";
                "node.name"        = "Dummy-Driver";
                "priority.driver"  = 8000;
              };
            }
            {
              factory = "adapter";
              args = {
                "factory.name"     = "support.null-audio-sink";
                "node.name"        = "Microphone-Proxy";
                "node.description" = "Microphone";
                "media.class"      = "Audio/Source/Virtual";
                "audio.position"   = "MONO";
              };
            }
            {
              factory = "adapter";
              args = {
                "factory.name"     = "support.null-audio-sink";
                "node.name"        = "Main-Output-Proxy";
                "node.description" = "Main Output";
                "media.class"      = "Audio/Sink";
                "audio.position"   = "FL,FR";
              };
            }
          ];
        };
      };
    })
    (mkIf cfg.lowlatency.enable {
      services.pipewire = {
        config.pipewire = {
          "context.properties" = {
            "link.max-buffers" = 16;
            "log.level" = 2;
            "default.clock.rate" = 48000;
            "default.clock.quantum" = 32;
            "default.clock.min-quantum" = 32;
            "default.clock.max-quantum" = 32;
            "core.daemon" = true;
            "core.name" = "pipewire-0";
          };
          "context.modules" = [
            {
              name = "libpipewire-module-rtkit";
              args = {
                "nice.level" = -15;
                "rt.prio" = 88;
                "rt.time.soft" = 200000;
                "rt.time.hard" = 200000;
              };
              flags = [ "ifexists" "nofail" ];
            }
            { name = "libpipewire-module-protocol-native"; }
            { name = "libpipewire-module-profiler"; }
            { name = "libpipewire-module-metadata"; }
            { name = "libpipewire-module-spa-device-factory"; }
            { name = "libpipewire-module-spa-node-factory"; }
            { name = "libpipewire-module-client-node"; }
            { name = "libpipewire-module-client-device"; }
            {
              name = "libpipewire-module-portal";
              flags = [ "ifexists" "nofail" ];
            }
            {
              name = "libpipewire-module-access";
              args = {};
            }
            { name = "libpipewire-module-adapter"; }
            { name = "libpipewire-module-link-factory"; }
            { name = "libpipewire-module-session-manager"; }
          ];
        };
        config.pipewire-pulse = {
          "context.properties" = {
            "log.level" = 2;
          };
          "context.modules" = [
            {
              name = "libpipewire-module-rtkit";
              args = {
                "nice.level" = -15;
                "rt.prio" = 88;
                "rt.time.soft" = 200000;
                "rt.time.hard" = 200000;
              };
              flags = [ "ifexists" "nofail" ];
            }
            { name = "libpipewire-module-protocol-native"; }
            { name = "libpipewire-module-client-node"; }
            { name = "libpipewire-module-adapter"; }
            { name = "libpipewire-module-metadata"; }
            {
              name = "libpipewire-module-protocol-pulse";
              args = {
                "pulse.min.req" = "32/48000";
                "pulse.default.req" = "32/48000";
                "pulse.max.req" = "32/48000";
                "pulse.min.quantum" = "32/48000";
                "pulse.max.quantum" = "32/48000";
                "server.address" = [ "unix:native" ];
              };
            }
          ];
          "stream.properties" = {
            "node.latency" = "32/48000";
            "resample.quality" = 1;
          };
        };
      };
    })
    (mkIf (!cfg.enable) {
      sound.enable = true;
      hardware.pulseaudio = {
        enable = true;
        package = pkgs.pulseaudioFull;
        support32Bit = true;
      };
    })
  ];
}
