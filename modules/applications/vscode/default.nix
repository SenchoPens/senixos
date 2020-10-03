{ config, pkgs, home-manager, inputs, ... }:
{
  imports = [
    "${inputs.vsliveshare}"
  ];
  home-manager.users.sencho.programs.vscode = {
    enable = true;
  };
  # home-manager.users.users.sencho.services.vsliveshare = {
  services.gnome3.gnome-keyring.enable = true;
  services.vsliveshare = {
    enable = true;
    extensionsDir = "$HOME/.vscode-oss/extensions";
    # nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/61cc1f0dc07c2f786e0acfd07444548486f4153b";
  };
}
