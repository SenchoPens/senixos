{ pkgs, config, inputs, ... }: {
  environment.pathsToLink = [ "/share/zsh" ];
  environment.sessionVariables.SHELL = "zsh";

  home-manager.users.sencho.programs.zsh = let
    hs-scripts = import ./haskell-scripts pkgs config;
  in {
    enable = true;

    initExtraBeforeCompInit = ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      source ${./lean-oneline-base16.zsh}
      source "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme"
    '';

    enableAutosuggestions = true;
    enableCompletion = true;

    autocd = true;

    defaultKeymap = "viins";

    shellAliases = {
      "snrs" = "sudo nixos-rebuild switch";
      "b-nix" = ''nix-build "<nixpkgs>" --no-out-link -A'';

      "ls" = "exa --group-directories-first -F";

      "mount"  = "sudo mount";
      "umount" = "sudo umount";

      "ga" = "git add";
      "gcm" = "git commit -m";
      "gcam" = "git commit -am";
      "gaacam" = "git add -A && git commit -m";
    };

    plugins = [
      {
        name = "enhancd";
        file = "init.sh";
        src = inputs.enhancd;
      }
      {
        name = "zsh-syntax-highlighting";
        file = "zsh-syntax-highlighting.zsh";
        src = inputs.zsh-syntax-highlighting;
      }
    ];

    localVariables = {
      ENHANCD_FILTER = "${pkgs.fzf}/bin/fzf";
      ENHANCD_DISABLE_DOT = 1;
    };

    initExtra = 
      ''
      r-nix(){nix run nixpkgs.$1 -c $@ }

      alias -g Ls="| less"
      alias -g FZF='$(fzf)'
      alias -g HSE='$(${hs-scripts.hse-dir})'

      alias -s txt=nvim
      alias -s {avi,mkv,mp4}=vlc
      alias -s html='firefox'
      alias -s pdf='zathura'
      alias -s docx='libreoffice'

      hash -d hw=~/code/gitlab.com/SenchoPens/hse-hw
      hw() {
        cd ~hw
        HSE
      }
      hash -d mat=~/Documents/hse-materials
      hash -d hse-tex=~/code/github/SenchoPens/my-hse-tex

      function list_all() {
        emulate -L zsh
        exa --group-directories-first -F
      }
      chpwd_functions=(''${chpwd_functions[@]} "list_all")
      ''
      +
      builtins.readFile ./functions.zsh
   ;
  };

  home-manager.users.sencho.programs.direnv = {
    nix-direnv.enable = true;
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = false;
  };
}
