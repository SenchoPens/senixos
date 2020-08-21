{ pkgs, lib, config, ... }:
with lib;
with types; {

  options = {
    device = mkOption { type = strMatching "[A-z|0-9]*-(Laptop|Workstation|VM)"; };
    devices = mkOption { type = attrs; };
    deviceSpecific = mkOption { type = attrs; };
  };

  config = {
    deviceSpecific = let
      device = config.device;
      devInfo = config.devices.${config.device};
    in rec {
      isLaptop = (!isNull (builtins.match ".*Laptop" device));

      cpu = devInfo.cpu.vendor;
      inherit devInfo;

      isHost = isLaptop;
    };

    devices = {
      diane-Laptop = {
        uefi = true;

        cpu = {
          vendor = "intel";
          clock = 1600;
          cores = 4;
        };

        drive = {
          type = "ssd";
          speed = 2000;
          size = 110;
        };

        ram = 12;
      };

      bob-Laptop = {
        uefi = false;

        cpu = {
          vendor = "intel";
          clock = 2500;
          cores = 8;
        };

        drive = {
          type = "ssd";
          speed = 1000;
          size = 120;
        };

        ram = 8;
      };

      mike-Laptop = {
        uefi = false;

        cpu = {
          vendor = "intel";
          clock = 2500;
          cores = 2;
        };

        drive = {
          type = "ssd";
          speed = 250;
          size = 120;
        };
        ram = 2;
      };
    };
  };
}
