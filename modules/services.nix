{ config, lib, pkgs, ... }: {

  services.acpid.enable = true;

  services.earlyoom = {
    enable = config.devices.${config.device}.ram < 16;
    freeMemThreshold = 5;
    freeSwapThreshold = 90;
  };

  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint ];
  };
  programs.dconf.enable = true;

  services.fwupd.enable = true;

  services.avahi.enable = true;

  systemd.services.systemd-udev-settle.enable = false;

  # provides power management to some applications and automatically shuts down if battery <2%
  services.upower.enable = true;

  virtualisation.docker.enable = config.deviceSpecific.isHost;
}
