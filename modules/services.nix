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

  #systemd.services.dhcpcd.scriptArgs = "-b -q %I";
  networking.dhcpcd.enable = false;  # not needed when using NetworkManager

  systemd.services.NetworkManager-wait-online.enable = false;  # slows boot by 6-9s

  virtualisation.docker.enable = config.deviceSpecific.isHost;
  virtualisation.docker.enableOnBoot = false;  # slows boot by 2s
}
