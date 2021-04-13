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
    ./applications/vscode
    ./applications/zathura.nix
    ./applications/jupyter.nix
    ./applications/firefox.nix
    ./applications/packages.nix
    ./applications/alacritty.nix
    ./applications/qutebrowser.nix
    ./applications/google-chrome-with-pipewire

    ./workspace/sway
    ./workspace/shell
    ./workspace/gtk.nix
    ./workspace/i3blocks
    ./workspace/misc.nix
    ./workspace/mako.nix
    ./workspace/gnome.nix
    ./workspace/fonts.nix
    ./workspace/interception
    ./workspace/xresources.nix
  ];
}
