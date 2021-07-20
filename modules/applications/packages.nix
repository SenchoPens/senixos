{ pkgs, config, lib, inputs, ... }: {
  home-manager.users.sencho = {
    home.packages = with pkgs;
      [
        # ToDo: move wayland-specific progs to programs.sway.extraPackages

        # Basic programs
        wget
        curl
        unrar
        acpi
        light
        htop
        zip
        unzip
        psmisc  # killall, pstree, ...
        # (lowPrio binutils-unwrapped)  # string, ... [collision with clang]
        inputs.nix-autobahn.defaultPackage.x86_64-linux

        # Programming-related utilities and compilers
        go
        clang
        cmake
        gnumake
        (python3.withPackages (ps:
          [ps.numpy ps.sympy ps.ptpython]
        ))
        nur.repos.balsoft.pkgs.nix-patch
        docker-compose
        # python38Packages.jupyterlab  # does not work. Better use nixos option.

        # Hipster shell
        fzf
        ripgrep  # rust grep, fast, use: rg
        zsh-powerlevel10k
        exa

        # Latex
        cm_unicode  # for latex
        (texlive.combine {
          inherit (pkgs.texlive) scheme-small collection-langcyrillic preprint invoice 
          collection-fontsrecommended collection-latexrecommended fontawesome latexmk yfonts
          gauss xypic bbm type1cm;  # type1cm, dvipng are for matplotlib
          # gauss xypic bbm type1cm dvipng physics;  # type1cm, dvipng are for matplotlib
        })

        # Wayland
        wl-clipboard
        pamixer
        grim
        ydotool
        slurp
        lambda-launcher
        xdg_utils
        # libsForQt5.qtstyleplugins  # did not build :(

        # Desktop apps
        tdesktop
        foliate
        transmission-gtk
        vlc
        keepassxc
        libreoffice
        imv
        firefox-wayland
        wf-recorder
        cachix
        wine
        # Conference apps
        zoom-us
        skypeforlinux
        teams

        # google-chrome-beta-with-pipewire  # screensharing still does not work
      ];

    # Does not build, does not work, maybe delete, maybe try later
    programs.obs-studio = {
      enable = false;
      plugins = [ inputs.nixpkgs-wayland.packages.x86_64-linux.obs-wlrobs ];
    };
  };
}
