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

      fzf
      zsh-powerlevel10k

      wl-clipboard
      grim
      ydotool
      slurp
      lambda-launcher
      xdg_utils

      tdesktop
      keepassxc
      libreoffice
      evince
      gthumb
    ];
}
