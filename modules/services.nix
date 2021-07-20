{ config, lib, pkgs, ... }: {

  services.acpid.enable = true;

  # kill the most RAM-eating app if RAM is 95% full and swap 10% full
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

  services.tlp.enable = true;  # must increase battery life

  # provides power management to some applications and automatically shuts down if battery <2%
  services.upower.enable = true;

  networking.dhcpcd.enable = false;  # not needed when using NetworkManager

  systemd.services.NetworkManager-wait-online.enable = false;  # slows boot by 6-9s

  virtualisation.docker = {
    enable = config.deviceSpecific.isHost;
    enableOnBoot = false;  # slows boot by 2s
    # 'docker' group is root equivalent, so maybe better not to add myself to it,
    # but on the other hand I AM root :/
    # https://github.com/moby/moby/issues/9976
  };
}
