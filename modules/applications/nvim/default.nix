{ config, pkgs, lib, inputs, ... }:
let 
  thm = config.themes.default;
in {
  home-manager.users.sencho.home.packages = with pkgs; [
    # python38Packages.python-language-server
    pkgs.unstable.python39Packages.python-lsp-server
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
    package = pkgs.unstable.neovim-unwrapped;  # Udpate when neovim in 21.05 reaches 0.5

    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    plugins = with pkgs.unstable.vimPlugins; [
      vim-gitgutter

      vim-airline
      vim-airline-themes

      # github.com/kyazdani42/nvim-tree.lua
      nvim-tree-lua

      limelight-vim

      vim-smoothie  # replace when github.com/karb94/neoscroll.nvim is in nixpkgs

      vim-polyglot  # syntax highlighting

      # github.com/tpope/vim-commentary
      # gc to comment visual selection, gcc to comment line
      vim-commentary

      # github.com/tpope/vim-abolish
      # crs (coerce to snake_case). MixedCase (crm), camelCase (crc), snake_case (crs), UPPER_CASE (cru)
      # dash-case (cr-), dot.case (cr.), space case (cr<space>), and Title Case (crt)
      # Also provides powerful substitution commands
      vim-abolish

      vimtex

      nvim-lspconfig
      completion-nvim
      # https://github.com/Infinisil/all-hies  # haskell for nix

      vim-vsnip
      vim-vsnip-integ

      base16-vim
    ];

    # not working ? check
    # Maybe it is only for usage in python plugins as libraries, not for LSP
    # extraPython3Packages = (ps: with ps; [
    #   python-lsp-server  # pylsp looks up the system interpreter :(  - recheck
    # ]);

    extraConfig = 
      (builtins.readFile ./init.vim)
      +
      ''
        let g:vsnip_snippet_dir = "${./vsnip}"
      ''
      +
      # Commented does not work:
      # lua require('init')
      # Replace when home-manager supports lua neovim config
      ''
        lua << EOF
        ${builtins.readFile ./lua/init.lua}
        EOF
      ''
    ;
  };
}
