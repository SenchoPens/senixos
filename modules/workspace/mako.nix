{ pkgs, config, ...}:
{
  home-manager.users.sencho.programs.mako = let
    thm = config.base16.schemes.default.namedHashtag;
  in {
    enable = true;
    layer = "overlay";
    font = builtins.elemAt config.fonts.fontconfig.defaultFonts.serif 0;
    width = 500;
    height = 80;
    defaultTimeout = 10000;
    maxVisible = 10;
    backgroundColor = thm.bg;
    textColor = thm.fg;
    borderColor = thm.blue;
    progressColor = "over ${thm.green}";
  };
}
