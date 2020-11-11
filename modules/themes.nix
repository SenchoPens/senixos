{ config, lib, pkgs, inputs, ... }:
with lib;
let

  # http://chriskempson.com/projects/base16/
  # https://github.com/cscorley/base16-summerfruit-scheme/blob/master/preview-light.png
  # https://github.com/cscorley/base16-summerfruit-scheme/blob/master/preview-dark.png

  colorType = types.str;

  color = (name:
    (mkOption {
      description = "${name} color of palette";
      type = colorType;
    }));
  fromBase16 = { base00, base01, base02, base03, base04, base05, base06, base07
    , base08, base09, base0A, base0B, base0C, base0D, base0E, base0F, ... }@originalTheme:
    rec {
      #ToDo: rename color*List -> colors*List?
      #ToDo: rename colorList -> colorRawList
      inherit originalTheme;
      colorList = [ base00 base01 base02 base03 base04 base05 base06 base07 base08 base09 base0A base0B base0C base0D base0E base0F ];
      colorTermList = map (color: toString (((hex2int color) * 256) / 16777216)) colorList;

      colorsRaw = {
        bg = base00;
        dark = base01;

        alt = base02;
        gray = base03;

        dark_fg = base04;
        default_fg = base05;
        light_fg = base06;

        fg = base07;

        red = base08;
        orange = base09;
        yellow = base0A;
        green = base0B;
        cyan = base0C;
        blue = base0D;
        purple = base0E;
        dark_orange = base0F;
      };
      colors = builtins.mapAttrs (_: v: "#" + v) colorsRaw;
      colorsDec = builtins.mapAttrs (name: color: colorHex2Dec color) colors;
    };

  fromYAML = yaml:
    builtins.fromJSON (builtins.readFile (pkgs.stdenv.mkDerivation {
      name = "fromYAML";
      phases = [ "buildPhase" ];
      buildPhase = "echo '${yaml}' | ${pkgs.yaml2json}/bin/yaml2json > $out";
    }));

  hex2int = s: with builtins; if s == "" then 0 else let l = stringLength s - 1; in 
    (hex2decDigits."${substring l 1 s}" + 16 * (hex2int (substring 0 l s)));

  hex2decDigits = rec {
    "0" = 0; "1" = 1; "2" = 2; "3" = 3; "4" = 4; "5" = 5; "6" = 6; "7" = 7; "8" = 8; "9" = 9;
    a = 10; b = 11; c = 12; d = 13; e = 14; f = 15; 
    A = a; B = b; C = c; D = d; E = e; F = f;
  };

  splitHex = hexStr:
    map (x: builtins.elemAt x 0) (builtins.filter (a: a != "" && a != [ ])
      (builtins.split "(.{2})" (builtins.substring 1 6 hexStr)));

  doubleDigitHexToDec = hex:
    16 * hex2decDigits."${builtins.substring 0 1 hex}"
    + hex2decDigits."${builtins.substring 1 2 hex}";

  colorHex2Dec = color:
    builtins.concatStringsSep ","
    (map (x: toString (doubleDigitHexToDec x)) (splitHex color));

in {

  options.themes = mkOption {
    description = "various themes";

    type = types.attrsOf (types.submodule {
      options = rec {
        originalTheme = mkOption {
          description =
            "Attrset { baseXX = '#yyyyyy'; }";
          type = types.attrs;
        };

        colorList = mkOption {
          description =
            "List of base16 colors in order 00, 01, ..., 0F";
          type = types.listOf colorType;
        };

        colorTermList = mkOption {
          description =
            "List of base16 colors in order 00, 01, ..., 0F, ranging from 0 to 255";
          type = colorList.type;
        };

        colorsRaw = mkOption {
          description = "Attr Set of base16 colors without '#' in the beginning";
          type = with types;
            submodule {
              options = {
                bg = color "background";
                dark = color "darker";

                alt = color "alternative";
                gray = color "gray";


                dark_fg = color "dark foreground";
                default_fg = color "default foregroud";
                light_fg = color "light foregroud";

                fg = color "foreground";

                blue = color "blue";
                green = color "green";
                red = color "red";
                orange = color "orange";
                yellow = color "yellow";
                cyan = color "cyan";
                purple = color "purple";
                dark_orange = color "dark_orange";
              };
            };
        };
        colors = mkOption { type = colorsRaw.type; };

        colorsDec = mkOption {
          description =
            "Set of colors in decimal format x (first two hex to decimal),y,z (basically for KDE)";
          
          type = colors.type;
        };
      };
    });
  };
  config = {
    themes = rec {
      light = 
        fromBase16 (
          fromYAML (
            # builtins.readFile "${inputs.base16-summerfruit-scheme}/summerfruit-light.yaml"
            builtins.readFile "${inputs.base16-atelier-schemes}/atelier-seaside-light.yaml"
          )
        );
      
      dark = 
        fromBase16 (
          fromYAML (
            # builtins.readFile "${inputs.base16-summerfruit-scheme}/summerfruit-dark.yaml"
            builtins.readFile "${inputs.base16-atelier-schemes}/atelier-seaside.yaml"
          )
        );

      default = dark;
    };
  };
}
