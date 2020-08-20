{ pkgs, config, lib, inputs, ... }: {
  home-manager.users.sencho.home.packages = with pkgs;
    [
      wget
      curl
      unrar
      acpi
      neovim
      light
      ydotool
      xdotool

      wl-clipboard
      termite
      tdesktop
      keepassxc
      yadm

      grim
      slurp
    ];
}
