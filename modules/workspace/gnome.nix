{ config, pkgs, lib, ... }: {
  services.gnome3 = {
    gnome-settings-daemon.enable = true;
  };
}
