{ pkgs, config, ... }: {
  environment.pathsToLink = [ "/share/zsh" ];
  environment.sessionVariables.SHELL = "zsh";

  home-manager.users.sencho.programs.zsh = let
    scripts = import ./scripts pkgs config;
  in {
    enable = true;

    initExtraBeforeCompInit = ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      source ${./lean-oneline.zsh}
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
        src = pkgs.fetchFromGitHub {
          owner = "b4b4r07";
          repo = "enhancd";
          rev = "v2.2.4";
          #sha256 = "e30b7729b10806adbe41f0b7de5d9c51232986d0463fef92986dfb62f17f9892";
          #sha256 = "sha256-4wt3KbEIBq2+QfC33l2cUSMphtBGP++SmG37YvF/mJI=";
          sha256 = "sha256-9/JGJgfAjXLIioCo3gtzCXJdcmECy6s59Oj0uVOfuuo=";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        file = "zsh-syntax-highlighting.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.7.0";
          #sha256 = "f5044266ee198468b1bcec881a56e6399e209657d6ed9fa6d21175bc76afdefa";
          sha256 = "sha256-eRTk0o35QbPB9kOIV0iDwd0j5P/yewFFISVS/iEfP2g=";
        };
      }
    ];

    initExtra = 
      ''
      r-nix(){nix run nixpkgs.$1 -c $@ }

      alias -g Ls="| less"
      alias -g FZF='$(fzf)'
      alias -g HSE='$(${scripts.hse-dir})'

      alias -s txt=nvim
      alias -s {avi,mkv,mp4}=vlc
      alias -s html='firefox'
      alias -s pdf='zathura'
      alias -s docx='libreoffice'

      hash -d hw=~/code/gitlab/SenchoPens/hse-hw
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
    enable = true;
    enableNixDirenvIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = false;
  };
}
