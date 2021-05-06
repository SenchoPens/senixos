{ config, pkgs, lib, ... }:
let thm = config.themes.default.colors;
in {
  home-manager.users.sencho.programs.alacritty = {
    enable = true;
    settings = {
      draw_bold_text_with_bright_colors = true;

      font = with builtins; let
        splitted = split "([0-9]+)" (elemAt config.fonts.fontconfig.defaultFonts.monospace 0);
      in {
        font = elemAt splitted 0;
        size = lib.strings.toInt (elemAt (elemAt splitted 1) 0);
        bold = { style = "Bold"; };
      };

      window.padding = {
        x = 2;
        y = 2;
      };
      
      shell.program = "${pkgs.zsh}/bin/zsh";

      # cursor.style = "Beam";

      colors = {
        primary = {
          background = thm.dark;
          foreground = thm.fg;
        };
        cursor = {
          text = thm.alt;
          cursor = thm.fg;
        };
        normal = {
          black = thm.bg;
          inherit (thm) red green yellow blue cyan;
          magenta = thm.purple;
          white = thm.fg;
        };
        bright = {
          black = thm.bg;
          inherit (thm) red green yellow blue cyan;
          magenta = thm.purple;
          white = thm.fg;
        };
        dim = {
          black = thm.bg;
          inherit (thm) red green yellow blue cyan;
          magenta = thm.purple;
          white = thm.fg;
        };
      };
    };
  };
}
