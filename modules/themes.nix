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
    , base08, base09, base0A, base0B, base0C, base0D, base0E, base0F, ... }:
    rec {
      colorList = [ base00 base01 base02 base03 base04 base05 base06 base07 base08 base09 base0A base0B base0C base0D base0E base0F ];
      colors = builtins.mapAttrs (_: v: "#" + v) {
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
      colorsDec = builtins.mapAttrs (name: color: colorHex2Dec color) colors;
    };

  fromYAML = yaml:
    builtins.fromJSON (builtins.readFile (pkgs.stdenv.mkDerivation {
      name = "fromYAML";
      phases = [ "buildPhase" ];
      buildPhase = "echo '${yaml}' | ${pkgs.yaml2json}/bin/yaml2json > $out";
    }));

  splitHex = hexStr:
    map (x: builtins.elemAt x 0) (builtins.filter (a: a != "" && a != [ ])
      (builtins.split "(.{2})" (builtins.substring 1 6 hexStr)));

  hex2decDigits = rec {
    "0" = 0; "1" = 1; "2" = 2; "3" = 3; "4" = 4; "5" = 5; "6" = 6; "7" = 7; "8" = 8; "9" = 9;
    "a" = 10; A = a;
    "b" = 11; B = b;
    "c" = 12; C = c;
    "d" = 13; D = d;
    "e" = 14; E = e;
    "f" = 15; F = f;
  };

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

        colorList = mkOption {
          description =
            "List of base16 colors in order 00, 01, ..., 0F";
          type = types.listOf colorType;
        };

        colors = mkOption {
          description =
            "Set of colors from which the themes for various applications will be generated";
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

        colorsDec = mkOption {
          description =
            "Set of colors in decimal format (basically for KDE)";
          
          type = colors.type;
        };
      };
    });
  };
  config = {
    themes = {
      light = 
        fromBase16 (
          fromYAML (
            builtins.readFile "${inputs.base16-summerfruit-scheme}/summerfruit-light.yaml"
          )
        );
      
      dark = 
        fromBase16 (
          fromYAML (
            builtins.readFile "${inputs.base16-summerfruit-scheme}/summerfruit-dark.yaml"
          )
        );
    };
  };
}
