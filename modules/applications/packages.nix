{ pkgs, config, lib, inputs, ... }: {
  home-manager.users.sencho.home.packages = with pkgs;
    [
      wget
      curl
      unrar
      acpi
      neovim
      light
      yadm

      gcc
      cmake
      gnumake
      python3

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
    ];
}
