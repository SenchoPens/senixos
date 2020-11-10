{ config, pkgs, lib, inputs, ... }:
{
  home-manager.users.sencho.programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      auto-pairs
    ];
    extraConfig = ''
      let g:AutoPairsFlyMode = 0
      " autocmd FileType tex let b:AutoPairs = AutoPairsDefine({'\\[' : '\\]', '\\(': '\\)'})  " does not work :(
      " This 3-line magic is needed for integration with completion-nvim
      let g:completion_confirm_key = ""
      imap <expr> <cr>  pumvisible() ? complete_info()["selected"] != "-1" ?
                       \ "\<Plug>(completion_confirm_completion)"  : "\<c-e>\<CR>" :  "\<CR>"
      let g:AutoPairsShortcutToggle = ""  " Default is Ctrl-P, inconvinient
    '';
  };
}
