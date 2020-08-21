{ pkgs, config, ...}:
{
  home-manager.users.sencho.programs.mako = {
    enable = true;
    layer = "overlay";
    font = builtins.elemAt config.fonts.fontconfig.defaultFonts.serif 0;
    width = 500;
    height = 80;
    defaultTimeout = 10000;
    maxVisible = 10;
    backgroundColor = config.themes.light.colors.bg;
    textColor = config.themes.light.colors.fg;
    borderColor = config.themes.light.colors.blue;
    progressColor = "over ${config.themes.light.colors.green}";
  };
}
