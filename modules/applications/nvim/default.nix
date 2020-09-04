{ config, pkgs, lib, ... }:
let 
  thm = config.themes.dark;
in {
  home-manager.users.sencho.programs.neovim = {
    enable = true;

    vimdiffAlias = true;
    withNodeJs = true;
    withPython = true;
    withPython3 = true;
    withRuby = true;

    plugins = with pkgs.vimPlugins; [
      vim-gitgutter

      vim-airline
      (vim-airline-themes.overrideAttrs (old:
        let
          intToHex = "0123456789ABCDEF";
          airline-theme-filename = "base16_nixos_airline_theme.vim";
          airline-theme = with builtins; with lib.strings; pkgs.writeText airline-theme-filename (concatStringsSep "\n" [
            (concatImapStringsSep "\n" (i: color: ''let s:gui0${substring (i - 1) 1 intToHex} = "#${color}"'') thm.colorList)
            (concatImapStringsSep "\n" (i: color: ''let s:cterm0${substring (i - 1) 1 intToHex} = ${color}'') thm.colorTermList)
            (readFile ./base16-theme-end.vim)
          ]);
        in {
          postUnpack = builtins.trace "${airline-theme}" ''
            cp ${airline-theme} source/autoload/airline/themes/${airline-theme-filename}
          '';
        }
      ))

      vim-nix

      coc-nvim  # checks and provides completion
      coc-json
      coc-css
      coc-go
      coc-python
      coc-html
      # coc-rls  # https://github.com/neoclide/coc-rls for installation
      # coc-tabnine  # can be resourceful, AI-completion. Works shitty
    ];

    extraPython3Packages = (ps: with ps; [
      pylint
      jedi
    ]);

    extraConfig = 
      builtins.readFile ./init.vim
      + builtins.readFile ./coc.vim
    ;
  };

  # home-manager.users.sencho.xdg.configFile."nvim/coc-settings.json".source = "${./coc-settings.json}";
  home-manager.users.sencho.xdg.configFile."nvim/coc-settings.json".text = builtins.toJSON {
    "python.pythonPath" = "${config.home-manager.users.sencho.programs.neovim.finalPackage}/bin/nvim-python3";
    # "rust-client.disableRustup" = true;  # coc-rls
  };
}
