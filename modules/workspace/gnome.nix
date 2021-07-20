{ config, pkgs, lib, ... }: {
  services.gnome = {
    gnome-settings-daemon.enable = true;
  };
}
