{ pkgs, lib, ... }: {
  imports = [
    ./users.nix
    ./themes.nix
    ./devices.nix
    ./services.nix
    ./hardware.nix
    ./packages.nix
    ./applications.nix

    ./applications/nvim
    ./applications/zathura.nix
    ./applications/firefox.nix
    ./applications/packages.nix
    ./applications/alacritty.nix
    ./applications/qutebrowser.nix

    ./workspace/zsh
    ./workspace/sway
    ./workspace/gtk.nix
    ./workspace/i3blocks
    ./workspace/misc.nix
    ./workspace/mako.nix
    ./workspace/fonts.nix
    ./workspace/interception
    ./workspace/xresources.nix
  ];
}
