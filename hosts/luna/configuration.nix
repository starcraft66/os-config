{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "luna"; # Define your hostname.

  services.tor.enable = true;

  profiles.pipewire.enable = true;

  nix.settings.trusted-users = [ "root" "@wheel" ];

  networking.interfaces.enp5s0.useDHCP = true;
  networking.wireguard.enable = true;
  services.lldpd.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # (((steam))) and (((nvidia)))
  programs.steam.extraCompatPackages = with pkgs; [ proton-ge-bin ];
  hardware.graphics.enable = true;

  # Sops config
  sops.defaultSopsFile = ../../secrets/luna.yaml;

  # Backup config
  sops.secrets.borg-repo-passphrase = {};
  sops.secrets.borg-ssh-private-key = {};
  services.borgbackup.jobs.luna = {
    paths = "/";
    exclude = [
      "/dev"
      "/proc"
      "/media"
      "/sys"
      "/mnt"
      "/sys"
      "/home/*/.local/share/Steam"
      "/run"
      "/var/lib/docker"
      "/nix"
    ];
    repo = "ssh://backup@borgbackup.235.tdude.co/mnt/borgbackup/luna";
    encryption = {
      mode = "repokey";
      passCommand = "cat ${config.sops.secrets.borg-repo-passphrase.path}";
    };
    environment = { BORG_RSH = "ssh -i ${ config.sops.secrets.borg-ssh-private-key.path }"; };
    doInit = false;
    compression = "auto,zstd";
    startAt = "daily";
    prune.keep = {
      daily = 7;
      weekly = 4;
      monthly = 6;
    };
  };

  # systemd.user.services.scream = {
  #   enable = true;
  #   description = "Scream Audio Receiver";
  #   serviceConfig = {
  #     ExecStart = "${pkgs.scream}/bin/scream-alsa -i virbr0";
  #     Restart = "always";
  #     RestartSec = "5";
  #   };

  #   wantedBy = [ "default.target" ];
  #   requires = [ "pulseaudio.service" ];
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  programs._1password = {
    enable = true;
  };

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "tristan" ];
  };

  # Virtualization
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.runAsRoot = false;
  virtualisation.libvirtd.onBoot = "ignore";

  # podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # nfs shared folders
  services.nfs.server.enable = true;

  # apcupsd battery shit
  services.apcupsd.enable = true;

  # onedrive syncing
  services.onedrive.enable = true;
  systemd.user.services."onedrive@".unitConfig.ConditionEnvironment = "XDG_SESSION_CLASS=user";

  # mullvad vpn
  services.mullvad-vpn.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.browserpass.enable = true;
  programs.yubikey-touch-detector.enable = true;

  # List services that you want to enable:
  services.geoclue2.enable = true;

  environment.etc = {
    "geolocation".text = ''
      # Example static location file for a machine inside Statue of Liberty torch
      ${toString config.location.latitude}   # latitude
      ${toString config.location.longitude}  # longitude
      96           # altitude
      1.83         # accuracy radius (the diameter of the torch is 12 feet)
    '';
    "geoclue/conf.d/00-config.conf".text = ''
      [static-source]
      enable=true
    '';
  };

  services.avahi = {
    nssmdns4 = true;
    nssmdns6 = true;
    ipv4 = true;
    ipv6 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };
  # services.tftpd.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  services.xserver.deviceSection = ''
    Option "UseEdidDpi" "False"
    Option "DPI" "144 x 144"
  '';

  services.xserver.screenSection = ''
    Option         "metamodes" "HDMI-0: 3840x2160_240 +3840+0 {ForceCompositionPipeline=Off}, DP-0: 3840x2160_144 +0+0 {ForceCompositionPipeline=Off, AllowGSYNCCompatible=On}"
  '';

  networking.useNetworkd = true;
  # https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1473408913
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

  # Open Port in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 2049 111 6881 ];
  networking.firewall.allowedUDPPorts = [ 2049 111 ];
  # For scream audio in my windows VM
  networking.firewall.interfaces.virbr0.allowedUDPPorts = [ 4010 ];
  networking.firewall.logRefusedConnections = true;
  networking.firewall.logRefusedUnicastsOnly = true;
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # No comment...
  sops.secrets.nocom-wireguard-private-key = {};
  networking.wireguard.interfaces = {
    nocom = {
      privateKeyFile = config.sops.secrets.nocom-wireguard-private-key.path;
      ips = [
        "192.168.69.72/24"
      ];
      peers = [
        {
          allowedIPs = [
            "192.168.69.0/24"
          ];
          publicKey = "r+4gwEuOKEXMJEQvM1YX5jc5WHIpjjZGAKW8SkRVyVQ=";
          endpoint = "fiki.dev:14030";
        }
      ];
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.xkb.options = "compose:ralt";

  # Enable touchpad support.
  # services.libinput.enable = true;

  services.displayManager.sddm.enable = false;
  services.displayManager.cosmic-greeter.enable = true;
  services.gnome.gnome-keyring.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  services.xserver.desktopManager.wallpaper.mode = "tile";
  services.desktopManager.cosmic.enable = true;

  programs.hyprland = { # or wayland.windowManager.hyprland
    enable = true;
    xwayland = {
      enable = true;
    };
  };

  users.users.tristan = {
    extraGroups = [ "libvirtd" "cdrom" "dialout" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/J+vzZtv/1CQzmHfgLGsLWowvSJRKr23N+NnBNg1l0dT/cPFTeDtr9kggPaHkdc587kziHFcUtkbewR8r4PgH4xMn272OPwd5r+HT1fffcE1SZO05GaxMvbXwrN6duK9EihtTpp/roitiJ/SmUX5S4YW0lzULUZG6sHDtJ7P5gPACdt/eLN50qwRVxq1yrfD2JfsI9hTFwud75HjPUDtPqL7yhfnuJ1xrbtP7Fzqs70eFQCtm7VcHa5b4azUytHBeHlf3OwBVopkiV7PUzH0UKZ+FMX3T19JyVAKPRvkuL4i2foxQthD4m/Wlr4szK2Z2yzXjAthxD2rwqlY+UiRCwWTIus12fSWS4lZWdkpqhRBXCL/fovkBWg9k4jO3Gkdt+CgbA47mcyBt5wRT013n4SPdAoIDxWRwW14T3urUoBUqjMgHlRy3s2i9cyb+dYzmeu8XIJ0YqvIUmXibTST8DOFKF16I5FqzC2SkVIrqwemqpL6Hk4BltWiZuhMu9ObBqjEKLDQ/JKvbHJH+vM2kS2JXWFfD8TUpS7nen7rTVnl2nwbBl2Ca7uchqIdQ+gOF+Mox1ncfUJ6bDAQ/QEyBCxa2u346hfvZ6Pcg1Dp8muXvkD27vLN7qUdYGnOG518gSTH4dAOYe9gaKYwDWMyH1FGNrW3052pNTN4TphEQpw== cardno:16 738 578"
    ];
  };

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0666 tristan qemu-libvirtd -"
  ];

  home-manager = {
    users.tristan = { ... }: {
      config.my.terminalFontSize = 12;
      config.my.ckb = true;
      config.my.dpi = 144;
      config.my.cursorDpi = 48;
      config.my.wayland = true;
      config.my.vsync = true;
      config.my.picomBackend = "glx";
      config.my.trayOutput = "HDMI-0";
      config.my.leftMonitor = "DP-0";
      config.my.rightMonitor = "HDMI-0";
      config.my.wiredInterface = "enp5s0";
    };
  };

  # For dark-mode light-mode switching via gsettings
  # xdg.portal = {
  #   enable = true;
  #   wlr.enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # };

  systemd.packages = [
    (pkgs.runCommand "delegate.conf" {
      preferLocalBuild = true;
      allowSubstitutes = false;
    } ''
      mkdir -p $out/etc/systemd/system/user@.service.d/
      echo -e "[Service]\nDelegate=yes" > $out/etc/systemd/system/user@.service.d/delegate.conf
    '')
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.05"; # Did you read the comment?
}
