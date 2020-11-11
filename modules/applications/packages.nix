{ pkgs, config, lib, inputs, ... }: {
  home-manager.users.sencho.home.packages = with pkgs;
    [
      wget
      curl
      unrar
      acpi
      light
      htop
      psmisc  # killall, pstree, ...

      clang
      cmake
      gnumake
      (python3.withPackages (ps:
        [ps.numpy ps.ptpython ps.sympy]
      ))
      nur.repos.balsoft.pkgs.nix-patch
      stack

      fzf
      ripgrep  # rust grep, fast, use: rg
      zsh-powerlevel10k
      exa
      gopass  # password manager

      cm_unicode  # for latex
      (texlive.combine {
        inherit (pkgs.texlive) scheme-small collection-langcyrillic preprint invoice 
        collection-fontsrecommended collection-latexrecommended fontawesome latexmk yfonts
        gauss;
      })

      wl-clipboard
      pamixer
      grim
      ydotool
      slurp
      lambda-launcher
      xdg_utils
      # neovim-unwrapped
      # libsForQt5.qtstyleplugins  # did not build :(

      tdesktop
      transmission-gtk
      vlc
      keepassxc
      libreoffice
      gthumb
      jetbrains.clion
      jetbrains.pycharm-community
      zoom-us
      skypeforlinux
      torbrowser
      discord
      # google-chrome-beta-with-pipewire
      teams
    ];
}
