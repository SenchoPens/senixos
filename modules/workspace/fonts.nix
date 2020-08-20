{ pkgs, config, lib, ... }:
{
  fonts = {
    fonts = with pkgs; [
      hasklig
      nerdfonts
      material-design-icons
      material-icons
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "DejaVuSansMono Nerd Font 13" ];
        sansSerif = [ "DejaVuSans Nerd Font 13" ];
        serif = [ "DejaVuSerif Nerd Font 13" ];
      };
    };
    enableDefaultFonts = true;
  };
}
