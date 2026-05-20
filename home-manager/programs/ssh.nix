{ config, lib, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings.brocade = {
      HostName = "2a0c:9a46:636:25::2";
      Port = 22;
      KexAlgorithms = "+diffie-hellman-group1-sha1";
      HostKeyAlgorithms = "+ssh-rsa";
      PubkeyAcceptedKeyTypes = "+ssh-rsa";
    };
    settings."172.16.2.*" = {
      KexAlgorithms = "+diffie-hellman-group1-sha1";
      HostKeyAlgorithms = "+ssh-rsa";
      PubkeyAcceptedKeyTypes = "+ssh-rsa";
      Ciphers = "+aes256-cbc";
    };
    settings.bunker = {
      HostName = "bunker.tdude.co";
      Port = 7331;
    };
    settings."*.tzone.org *.ga-safety.net *.wi-flight.net *.tdude.co" = {
      ForwardAgent = true;
    };
  };
}

