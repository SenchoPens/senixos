{ config, pkgs, lib, ... }:
with import ../../support.nix { inherit lib config; };
let thm = config.themes.light.colors;
in {
  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
    MOZ_DBUS_REMOTE = "1";
  };
  home-manager.users.sencho = {
    programs.firefox = {
      enable = false;  # keep until this is fixed: https://github.com/nix-community/home-manager/issues/1641
      package = pkgs.firefox-wayland;
    };
  };
}
