{ config, pkgs, home-manager, inputs, ... }:
let
  thm = config.themes.default.colors;
in {
  home-manager.users.sencho.programs.zathura = {
    enable = true;
    options = { 
      # default-bg = thm.dark;
      # statusbar-bg = thm.dark;
      # inputbar-bg = thm.dark;
      # default-fg = thm.fg; 
      # statusbar-fg = thm.fg;
      # inputbar-fg = thm.fg;

      font = config.fonts.defaultFont.serif.font;
    };
    extraConfig = builtins.readFile (pkgs.runCommand "zathura-theme" {} ''
      export HOME=$(pwd)/home; mkdir -p $HOME
      ${pkgs.base16-builder}/bin/base16-builder \
        --scheme ${inputs.base16-black-metal-schemes}/black-metal-burzum.yaml \
        --template zathura \
        --brightness dark \
        > $out
      '')
      +
      ''set recolor "false"''
    ;
  };
}
