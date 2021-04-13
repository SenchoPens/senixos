{ config, pkgs, ... }:
{
  # services.xserver = {
  #   enable = true;
  #   displayManager = {
  #     defaultSession = "sway";
  #     autoLogin = {
  #       enable = true;
  #       user = "sencho";
  #     };
  #   };
  # };
  # nixpkgs.overlays = [(final: prev: {
  #   google-chrome-beta-with-pipewire =
  #     prev.callPackage ./google-chrome-with-pipewire.nix {
  #       google-chrome = final.google-chrome-beta;
  #       pipewire = final.pipewire_0_2;
  #     };
  # })];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs;
      [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };
  systemd.user.services.xdg-desktop-portal.environment = {
    XDG_DESKTOP_PORTAL_DIR = config.environment.variables.XDG_DESKTOP_PORTAL_DIR;
  };

  services.pipewire.enable = true;
}
