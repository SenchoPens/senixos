{ pkgs, config, lib, inputs, ... }: {
  home-manager.users.sencho.home.packages = with pkgs;
    [
      wget
      curl
      unrar
      acpi
      neovim
      ydotool
      light

      wl-clipboard
      termite
      tdesktop
      keepassxc
      yadm
      networkmanagerapplet

      grim
      slurp
    ];
}
