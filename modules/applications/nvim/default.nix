{ config, pkgs, lib, inputs, ... }:
let 
  thm = config.themes.dark;
in {
  home-manager.users.sencho.home.sessionVariables = {
    EDITOR = "nvim";
  };
  home-manager.users.sencho.programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped.overrideAttrs (old: {
      version = "nightly";
      src = inputs.neovim-unwrapped-nightly;
    });

    vimdiffAlias = true;
    withNodeJs = true;
    withPython = true;
    withPython3 = true;
    withRuby = true;

    plugins = with pkgs.vimPlugins; [
      vim-gitgutter

      vim-airline
      vim-airline-themes
      limelight-vim

      vim-polyglot  # syntax highlighting

      auto-pairs
      vim-commentary  # gc to comment visual selection, gcc to comment line

      vimtex

      coc-nvim  # checks and provides completion
      coc-json
      coc-css
      coc-go
      coc-python
      coc-html
      coc-vimtex
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
