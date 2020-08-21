{ pkgs, lib, ... }: {
  imports = [
    ./users.nix
    ./themes.nix
    ./devices.nix
    ./services.nix
    ./hardware.nix
    ./packages.nix
    ./applications.nix

    #./applications/okular.nix
    ./applications/firefox.nix
    ./applications/packages.nix
    ./applications/alacritty.nix

    ./workspace/sway
    ./workspace/gtk.nix
    #./workspace/kde.nix
    ./workspace/i3blocks
    ./workspace/misc.nix
    ./workspace/mako.nix
    ./workspace/fonts.nix
    ./workspace/xresources.nix
  ];
}
