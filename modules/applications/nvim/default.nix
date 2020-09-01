{ config, pkgs, lib, ... }:
{
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

      vim-nix

      coc-nvim  # checks and provides completion
      coc-json
      coc-css
      coc-go
      coc-python
      coc-html
      coc-rls
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
  };
}
