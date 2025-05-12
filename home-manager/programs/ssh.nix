{ config, lib, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    matchBlocks.brocade = {
      hostname = "2607:fa48:6ed8:8a5d::2";
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

