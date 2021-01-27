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
      enable = false;
      package = pkgs.firefox;
    };
  };
}
