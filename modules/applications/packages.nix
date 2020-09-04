{ pkgs, config, lib, inputs, ... }: {
  home-manager.users.sencho.home.packages = with pkgs;
    [
      wget
      curl
      unrar
      acpi
      light
      htop

      gcc
      cmake
      gnumake
      python3
      nur.repos.balsoft.pkgs.nix-patch

      fzf
      zsh-powerlevel10k

      wl-clipboard
      grim
      ydotool
      slurp
      lambda-launcher
      xdg_utils
      libsForQt5.qtstyleplugins

      tdesktop
      transmission-gtk
      vlc
      keepassxc
      libreoffice
      evince
      gthumb
      jetbrains.clion
      jetbrains.pycharm-community
      zoom-us
    ];
}
