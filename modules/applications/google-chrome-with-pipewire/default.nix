{ config, pkgs, ... }:
{
  services.xserver.enable = true; #??
  services.xserver.displayManager.sddm = {
    enable = true;
    autoLogin = {
      enable = true;
      user = "sencho";
    };
  };
  services.xserver.displayManager.defaultSession = "sway";
  nixpkgs.overlays = [(final: prev: {
    google-chrome-beta-with-pipewire =
      prev.callPackage ./google-chrome-with-pipewire.nix {
        google-chrome = final.google-chrome-beta;
        pipewire = final.pipewire_0_2;
      };
  })];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr ];
    gtkUsePortal = true;
  };

  services.pipewire.enable = true;
}
