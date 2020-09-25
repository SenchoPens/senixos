{ config, pkgs, home-manager, inputs, ... }:
let
  thm = config.themes.dark.originalTheme;
in {
  home-manager.users.sencho.programs.qutebrowser = {
    enable = true;

    searchEngines = {
      n = "search.nixos.org/packages?query={}";
      gen = "https://www.google.com/search?hl=en&q={}";
      gru = "https://www.google.com/search?hl=ru&q={}";
      ddg = "https://duckduckgo.com/?q={}";
      sx1 = "https://searx.gnu.style/?q={}";
      sx2 = "https://searx.ninja/?q={}";
      sx3 = "https://searx.monicz.pl/?q={}";
      sx4 = "https://searx.fmac.xyz/?q={}";
    };

    config = {
      
    };

    extraConfig = with pkgs.lib; let
      thm' = thm // {base00 = thm.base01; };
    in
      builtins.replaceStrings
        (mapAttrsToList (x: _: "{{${x}-hex}}") thm) 
        (mapAttrsToList (_: x: x) thm')
        (builtins.readFile "${inputs.base16-qutebrowser}/templates/default.mustache");
  };
}
