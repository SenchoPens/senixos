{ pkgs, config, lib, inputs, ... }: {
  home-manager.users.sencho.home.packages = with pkgs;
    [
      wget
      curl
      unrar
      acpi
      light
      htop

      gcc
      cmake
      gnumake
      python3
      nur.repos.balsoft.pkgs.nix-patch

      fzf
      ripgrep  # rust grep, fast, use: rg
      zsh-powerlevel10k
      exa

      cm_unicode  # for latex
      (texlive.combine {
        inherit (pkgs.texlive) scheme-small collection-langcyrillic preprint invoice 
        collection-fontsrecommended collection-latexrecommended latexmk;
      })

      wl-clipboard
      grim
      ydotool
      slurp
      lambda-launcher
      xdg_utils
      libsForQt5.qtstyleplugins

      tdesktop
      transmission-gtk
      vlc
      keepassxc
      libreoffice
      gthumb
      jetbrains.clion
      jetbrains.pycharm-community
      zoom-us
      torbrowser
    ];
}
