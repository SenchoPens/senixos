{ pkgs, config, lib, ... }:

with rec { inherit (config) device devices deviceSpecific; };
with deviceSpecific; {

  hardware.cpu.${devices.${device}.cpu.vendor}.updateMicrocode = true; # Update microcode

  hardware.enableRedistributableFirmware = true; # For some unfree drivers

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  # hardware.opengl.driSupport32Bit = true; # For steam
  hardware.opengl.package = pkgs.mesa_drivers;

  hardware.bluetooth.enable = true;

  # boot.kernelModules = [ "ec_sys" ]; # module for thinkpad's leds, view balsoft config for details

  boot = {
    loader = {
      timeout = 1;
    } // (if !deviceSpecific.devInfo.uefi then {
      grub.enable = true;
      grub.version = 2;
      grub.device = "/dev/sda";
    } else { # UEFI config
      systemd-boot.enable = true;
    });
    kernelPackages = pkgs.linuxPackages_latest;
    consoleLogLevel = 3;  # default 4
    kernel.sysctl."vm.swappiness" = 15;  # activate swap when RAM is >85% full
    kernel.sysctl."kernel/sysrq" = 1;
    kernelParams = [
      # wiki.archlinux.org/index.php/Silent_boot
      "quiet"
      "rd.systemd.show_status=auto"
      "rd.udev.log_priority=3"

      # enable multi-queue IO
      "scsi_mod.use_blk_mq=1"

      # graphics
      "modeset"

      # faster boot (see https://security.stackexchange.com/questions/42164/rdrand-from-dev-random)
      "random.trust_cpu=on"

      # Turn off meltdown and spectre mitigations for performance reasons
      # yeah, if you wanna hack my computer, you know what to use
      "pti=off"
      "spectre_v2=off"
    ];
  };

  environment.etc."mkinitcpio.conf" = {
      enable = true;
      text = ''
        COMPRESSION=”lz4″
      '';
  };

  services.logind.lidSwitch = "suspend";
  services.logind.lidSwitchExternalPower = "ignore";
  services.logind.extraConfig = "HandlePowerKey=poweroff";
}
