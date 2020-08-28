{ pkgs, config, lib, ... }:
let
  genFont = fontName: fontSize: {
    inherit fontName fontSize;
    font = "${fontName} ${toString fontSize}";
  };
in {
  options = with lib; {
    fonts.defaultFont = with types; mkOption {
      type = attrsOf (submodule {
        options = {
	  fontName = mkOption { type = str; };
	  fontSize = mkOption { type = int; };
	  font = mkOption { type = str; };
	};
      });
    };
  };

  config = {  
    fonts = rec {
      fonts = with pkgs; [
        hasklig
        nerdfonts
        material-design-icons
        material-icons
      ];

      defaultFont = {
        monospace = genFont "DejaVuSansMono Nerd Font" 13;
        sansSerif = genFont "DejaVuSans Nerd Font" 13;
        serif = genFont "DejaVuSerif Nerd Font" 13;
      };

      fontconfig = {
        enable = true;
        defaultFonts = with defaultFont; {
          monospace = [ monospace.font ];
          sansSerif = [ sansSerif.font ];
          serif = [ serif.font ];
        };
      };

      enableDefaultFonts = true;
    };
  };
}
