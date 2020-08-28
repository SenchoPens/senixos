{ pkgs, config, lib, ... }:
with import ../support.nix { inherit lib config; }; {
  options.defaultApplications = lib.mkOption {
    type = lib.types.attrs;
    description = "Preferred applications";
  };
  config = rec {
    defaultApplications = {
      term = {
        cmd = "${pkgs.alacritty}/bin/alacritty";
        desktop = "alacritty";
      };
      editor = {
        cmd = "${pkgs.neovim}/bin/nvim";
        desktop = "nvim";
      };
      browser = {
        cmd = "${pkgs.firefox-wayland}/bin/firefox";
        desktop = "firefox";
      };
      pdfViewer = {
        cmd = "${pkgs.kdeApplications.okular}/bin/okular";
        desktop = "org.kde.okular";
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
            "x-scheme-handler/http" = browser;
            "x-scheme-handler/https" = browser;
            "x-scheme-handler/about" = browser;
            "x-scheme-handler/unknown" = browser;
            "image/*" = { desktop = "org.kde.gwenview"; };
            "application/pdf" = pdfViewer;
          };
    };
  };
}
