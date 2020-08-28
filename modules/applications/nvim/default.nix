{ config, pkgs, lib, ... }:
{
  home-manager.users.sencho.programs.neovim = {
    vimdiffAlias = true;
    withNodeJs = true;
    withPython = true;
    withPython3 = true;
    withRuby = true;

    plugins = with pkgs.vimPlugins; [
      vim-gitgutter

      nvim-yarp
      ncm2
    ];

    extraConfig = 
      builtins.readFile "${./init.vim}";
  };
}
