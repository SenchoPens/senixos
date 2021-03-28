{ config, pkgs, lib, inputs, ... }:
let 
  thm = config.themes.default;
in {
  home-manager.users.sencho.home.packages = with pkgs; [
    python38Packages.python-language-server
    nodePackages.bash-language-server
    nodePackages.vim-language-server
    gopls
    ccls
    texlab
  ];
  home-manager.users.sencho.home.sessionVariables = {
    EDITOR = "nvim";
    GIT_EDITOR = "nvim";
    VISUAL = "nvim";
    DIFFPROG = "nvim -d";
    MANPAGER = "nvim +Man!";
    MANWIDTH = 999;
  };
  home-manager.users.sencho.programs.neovim = {
    enable = true;
    # package = pkgs.neovim-unwrapped.overrideAttrs (old: {
    #   version = "nightly";
    #   src = inputs.neovim-unwrapped-nightly;
    # });
    package = pkgs.neovim-nightly;

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
      vim-smoothie

      vim-polyglot  # syntax highlighting

      vim-commentary  # gc to comment visual selection, gcc to comment line

      vimtex

      nvim-lspconfig
      completion-nvim
      # https://github.com/Infinisil/all-hies  # haskell for nix

      vim-vsnip
      vim-vsnip-integ

      floobits-neovim
    ];

    extraPython3Packages = (ps: with ps; [
      python-language-server  # pyls looks up the system interpreter :(
    ]);

    extraConfig = 
      (builtins.readFile ./init.vim)
      +
      ''
        let g:vsnip_snippet_dir = "${./vsnip}"
      ''
      +
      ''
        lua <<EOF
        vim.cmd('packadd nvim-lspconfig')
        vim.cmd('packadd completion-nvim')

        local lspconfig = require'lspconfig'

        lspconfig.pyls.setup{
          settings = {
            pycodestyle = {
              enabled = false;
            }
          }
        }
        lspconfig.bashls.setup{}
        lspconfig.vimls.setup{}
        lspconfig.ccls.setup{}
        lspconfig.texlab.setup{}
        EOF
      ''
    ;
  };
}

