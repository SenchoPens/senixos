{ config, lib, pkgs, inputs, ... }:
with lib;
let
  colorType = types.str;
  color = (name:
    (mkOption {
      description = "${name} color of palette";
      type = colorType;
    }));
  # http://chriskempson.com/projects/base16/
  # https://github.com/cscorley/base16-summerfruit-scheme/blob/master/preview-light.png
  fromBase16 = { base00, base01, base02, base03, base04, base05, base06, base07
    , base08, base09, base0A, base0B, base0C, base0D, base0E, base0F, ... }:
    {
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
        dark_orange = base0F
    };

  fromYAML = yaml:
    builtins.fromJSON (builtins.readFile (pkgs.stdenv.mkDerivation {
      name = "fromYAML";
      phases = [ "buildPhase" ];
      buildPhase = "echo '${yaml}' | ${pkgs.yaml2json}/bin/yaml2json > $out";
    }));
in {
  options = {
    themes = {
      colorList = mkOption {
        description =
          "List of base16 colors in order 00, 01, ..., 0F";
        type = types.listOf colorType;
      }
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
    };
  };
  config = {
    themes = 
      fromBase16 (
        fromYAML (
          builtins.readFile "${inputs.base16-summerfruit-scheme}/summerfruit-light.yaml"
        )
      )
  };
}
