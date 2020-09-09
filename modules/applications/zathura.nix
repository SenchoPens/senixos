{ config, pkgs, home-manager, ... }:
let
  thm = config.themes.dark.colors;
in {
  home-manager.users.sencho.programs.zathura = {
    enable = true;
    options = { 
      default-bg = thm.dark;
      statusbar-bg = thm.dark;
      inputbar-bg = thm.dark;
      default-fg = thm.fg; 
      statusbar-fg = thm.fg;
      inputbar-fg = thm.fg;

      font = config.fonts.defaultFont.serif.font;
    };
  };
}
