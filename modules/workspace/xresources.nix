{ config, lib, pkgs, ... }:
{
  home-manager.users.sencho = {
    xresources.properties = with config.base16.schemes.default.namedHashtag; {
      "*background" = bg;
      "*foreground" = fg;
      "*color0" = dark;
      "*color1" = orange;
      "*color2" = green;
      "*color3" = yellow;
      "*color4" = blue;
      "*color5" = purple;
      "*color6" = cyan;
      "*color7" = fg;
      "*color8" = dark;
      "*color9" = orange;
      "*color10" = green;
      "*color11" = yellow;
      "*color12" = blue;
      "*color13" = purple;
      "*color14" = cyan;
      "*color15" = fg;
    };
  };
}
