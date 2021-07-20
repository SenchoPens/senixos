{ config, pkgs, home-manager, inputs, ... }:
{
  imports = [
    "${inputs.vsliveshare}"
  ];
  home-manager.users.sencho.programs.vscode = {
    enable = false;
  };
  # home-manager.users.users.sencho.services.vsliveshare = {
  services.gnome.gnome-keyring.enable = false;  # might need set to true if vscode is enabled
  services.vsliveshare = {
    enable = false;
    extensionsDir = "$HOME/.vscode-oss/extensions";
    # nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/61cc1f0dc07c2f786e0acfd07444548486f4153b";
  };
}
