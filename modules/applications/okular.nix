{ pkgs, lib, config, inputs, ... }:
let
  thmDec = config.themes.default.colorsDec;
in with import ../../support.nix { inherit lib config; }; {
  home-manager.users.sencho.xdg.configFile."okularpartrc".text = genIni {
    "Dlg Accessibility" = {
      RecolorBackground = thmDec.bg;
      RecolorForeground = thmDec.fg;
    };
    "Document" = {
      ChangeColors = true;
      PaperColor = thmDec.bg;
      RenderMode = "Recolor";
    };
    "Main View" = { ShowLeftPanel = false; };
    PageView = {
      BackgroundColor = thmDec.bg;
      UseCustomBackgroundColor = true;
    };
  };
}
