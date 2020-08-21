{ config, pkgs, lib, ... }: {
  users.mutableUsers = true;

  users.users.sencho = {
    isNormalUser = true;
    extraGroups = [
      "sudo"
      "wheel"
      "networkmanager"
      "disk"
      "dbus"
      "audio"
      "docker"
      "sound"
      "pulse"
      "adbusers"
      "input"
      "libvirtd"
      "vboxusers"
      "wireshark"
    ];
    description = "Arseniy Chekanov";
  };

  systemd.services."user@" = { serviceConfig = { Restart = "always"; }; };

  # This will allow consoles to automatically log in as sencho
  # services.mingetty.autologinUser = "sencho";
  services.mingetty.helpLine = builtins.readFile ./welcome.ascii_art;
  
  environment.loginShellInit = ''
    [[ "$(tty)" == /dev/tty1 ]] && sway
  '';
  console.colors = config.themes.colorList;
  console.font = "Lat2-Terminus18";
  # console.font = "cyr-sun16";
  # console.keyMap = "ruwin_cplk-UTF-8";

  security.sudo = {
    # Enable "sudo" command
    enable = true;

    # Enable running following commands as root without entering the password for user sencho
    extraRules = let
      nopasswd_command = command: { inherit command; options = [ "NOPASSWD" ]; };
    in
    [ 
      { 
        users = [ "sencho" ]; runAs = "root";
        commands = map nopasswd_command [
          "/run/current-system/sw/bin/lock"
          "/run/current-system/sw/bin/lock this"
          "${pkgs.light}/bin/light -A 5"
          "${pkgs.light}/bin/light -U 5"

          "${pkgs.ydotool}/bin/ydotoold"
          "${pkgs.ydotool}/bin/ydotool click 1"
          "${pkgs.ydotool}/bin/ydotool click 2"
          "${pkgs.ydotool}/bin/ydotool click 3"
        ];
      } 
    ];
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
}
