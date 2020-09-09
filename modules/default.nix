{ pkgs, lib, ... }: {
  imports = [
    ./users.nix
    ./themes.nix
    ./devices.nix
    ./services.nix
    ./hardware.nix
    ./packages.nix
    ./applications.nix

    ./applications/firefox.nix
    ./applications/packages.nix
    ./applications/alacritty.nix
    ./applications/nvim
    ./applications/zathura.nix

    ./workspace/sway
    ./workspace/zsh
    ./workspace/gtk.nix
    ./workspace/i3blocks
    ./workspace/misc.nix
    ./workspace/mako.nix
    ./workspace/fonts.nix
    ./workspace/xresources.nix
  ];
}
