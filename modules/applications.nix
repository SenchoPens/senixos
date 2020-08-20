{ pkgs, config, lib, ... }:
with import ../support.nix { inherit lib config; }; {
  options.defaultApplications = lib.mkOption {
    type = lib.types.attrs;
    description = "Preferred applications";
  };
  config = rec {
    defaultApplications = {
      term = {
        cmd = "${pkgs.termite}/bin/termite";
        desktop = "termite";
      };
      editor = {
        cmd = "${pkgs.neovim}/bin/nvim";
        desktop = "nvim";
      };
      browser = {
        cmd = "${pkgs.firefox-wayland}/bin/firefox";
        desktop = "firefox";
      };
    };
    home-manager.users.sencho.xdg.mimeApps = {
      enable = true;
      defaultApplications =

        with config.defaultApplications;
        builtins.mapAttrs (name: value:
          if value ? desktop then [ "${value.desktop}.desktop" ] else value) {
            "text/html" = browser;
            "text/plain" = editor;
          };
    };
  };
}
