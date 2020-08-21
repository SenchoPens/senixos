{ config, pkgs, ... }:
{
  home-manager.users.sencho.programs.alacritty = {
    enable = true;
    settings = {
      draw_bold_text_with_bright_colors = true;

      font = {
        size = 9;
        bold = { style = "Bold"; };
      };

      window.padding = {
        x = 2;
        y = 2;
      };

      colors = {
        primary = {
          background = "0xfafafa";
          foreground = "0x383a42";
        };
        cursor = {
          text = "0xfafafa";
          cursor = "0x383a42";
        };
        normal = {
          black = "0xfafafa";
          red = "0xca1243";
          green = "0x50a14f";
          yellow = "0xc18401";
          blue = "0x4078f2";
          magenta = "0xa626a4";
          cyan = "0x0184bc";
          white = "0x383a42";
        };
        bright = {
          black = "0xa0a1a7";
          red = "0xca1243";
          green = "0x50a14f";
          yellow = "0xc18401";
          blue = "0x4078f2";
          magenta = "0xa626a4";
          cyan = "0x0184bc";
          white = "0x090a0b";
        };
      };
    };
  };
}
