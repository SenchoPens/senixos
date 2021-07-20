{ pkgs, config, lib, ... }:
with import ../support.nix { inherit lib config; }; {
  options.defaultApplications = lib.mkOption {
    type = lib.types.attrs;
    description = "Preferred applications";
  };
  config = rec {
    defaultApplications =
      let
        openInTerminal = bin: pkgs.writeShellScriptBin "${bin}-in-terminal"
          ''
          ${pkgs.alacritty}/bin/alacritty -e "${bin} $1"
          '';
      in {
        term = {
          cmd = "${pkgs.alacritty}/bin/alacritty";
          desktop = "alacritty";
        };
        editor = {
          cmd = openInTerminal "${pkgs.neovim}/bin/nvim";
          desktop = "nvim-terminal";  # TODO: Create desktop entry
        };
        browser = {
          cmd = "${pkgs.firefox-wayland}/bin/firefox";
          desktop = "firefox";
        };
        pdfViewer = {
          cmd = "${pkgs.zathura}/bin/zathura";
          desktop = "org.pwmt.zathura";
        };
      };
    home-manager.users.sencho.xdg.configFile."mimeapps.list".force = true;
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
            "image/*" = { desktop = "gthumb"; };
            "image/vnd.djvu" = pdfViewer;
            "application/pdf" = pdfViewer;
            "application/vnd.comicbook+zip" = pdfViewer;
            "application/vnd.comicbook-rar" = pdfViewer;
          };
    };
  };
}
