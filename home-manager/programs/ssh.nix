{ config, lib, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks.brocade = {
      hostname = "2a0c:9a46:636:25::2";
      port = 22;
      extraOptions = {
        KexAlgorithms = "+diffie-hellman-group1-sha1";
        HostKeyAlgorithms = "+ssh-rsa";
        PubkeyAcceptedKeyTypes = "+ssh-rsa";
      };
    };
    matchBlocks."172.16.2.*" = {
      extraOptions = {
        KexAlgorithms = "+diffie-hellman-group1-sha1";
        HostKeyAlgorithms = "+ssh-rsa";
        PubkeyAcceptedKeyTypes = "+ssh-rsa";
        Ciphers = "+aes256-cbc";
      };
    };
    matchBlocks.bunker = {
      hostname = "bunker.tdude.co";
      port = 7331;
    };
    matchBlocks."*.tzone.org *.ga-safety.net *.wi-flight.net *.tdude.co" = {
      forwardAgent = true;
    };
  };
}

