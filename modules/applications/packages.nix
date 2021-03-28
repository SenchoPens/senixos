{ pkgs, config, lib, inputs, ... }: {
  home-manager.users.sencho.home.packages = with pkgs;
    [
      # ToDo: move wayland-specific progs to programs.sway.extraPackages
      wget
      curl
      unrar
      acpi
      light
      htop
      zip
      unzip
      psmisc  # killall, pstree, ...

      clang
      cmake
      gnumake
      (python3.withPackages (ps:
        [ps.numpy ps.sympy ps.ptpython]
      ))
      nur.repos.balsoft.pkgs.nix-patch
      stack

      fzf
      ripgrep  # rust grep, fast, use: rg
      zsh-powerlevel10k
      exa

      cm_unicode  # for latex
      (texlive.combine {
        inherit (pkgs.texlive) scheme-small collection-langcyrillic preprint invoice 
        collection-fontsrecommended collection-latexrecommended fontawesome latexmk yfonts
        gauss xypic bbm;
      })

      wl-clipboard
      pamixer
      grim
      ydotool
      slurp
      lambda-launcher
      xdg_utils
      # python38Packages.jupyterlab  # does not work. Better use nixos option.
      # libsForQt5.qtstyleplugins  # did not build :(

      tdesktop
      transmission-gtk
      vlc
      keepassxc
      libreoffice
      gthumb
      zoom-us
      skypeforlinux
      teams
      firefox-wayland
      wf-recorder
      cachix
    ];
}
