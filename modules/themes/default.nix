{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./themes.nix
  ];

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
            # builtins.readFile "${inputs.base16-atelier-schemes}/atelier-seaside.yaml"
            builtins.readFile "${inputs.base16-black-metal-schemes}/black-metal-burzum.yaml"
          )
        );

      default = dark;
    };
  };
}
