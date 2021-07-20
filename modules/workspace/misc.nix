{ pkgs, lib, config, inputs, ... }: {
  users.users.sencho.extraGroups = [ "sway" ];

  systemd.coredump.enable = true;

  home-manager.users.sencho = {
    xdg.enable = true;

    programs.git = {
      enable = true;
      userEmail = "senya@chekanov.net";
      userName = "Arseniy Chekanov";
    };
  };
}
