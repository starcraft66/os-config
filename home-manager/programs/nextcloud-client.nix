{ config, lib, pkgs, ... }:

{
  services.nextcloud-client = {
    enable = true;
  };
}
