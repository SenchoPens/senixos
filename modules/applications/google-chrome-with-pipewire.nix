{ config, pkgs, ... }:
{
  # services.xserver.enable = true; #??
  # services.xserver.displayManager.sddm = {
  #   enable = true;
  #   autoLogin = {
  #     enable = true;
  #     user = "sencho";
  #   };
  # };
  # services.xserver.displayManager.defaultSession = "sway";

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr ];
    gtkUsePortal = true;
  };

  services.pipewire.enable = true;
}
