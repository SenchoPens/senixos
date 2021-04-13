{ pkgs, config, lib, inputs, ... }:
let
  thm = config.themes.default.colors;
  thm' = builtins.mapAttrs (name: value: builtins.substring 1 7 value) thm;
  materia_colors = pkgs.writeTextFile {
    name = "gtk-generated-colors";
    text = ''
      BG=${thm'.bg}
      FG=${thm'.fg}
      BTN_BG=${thm'.bg}
      BTN_FG=${thm'.fg}
      MENU_BG=${thm'.bg}
      MENU_FG=${thm'.fg}
      ACCENT_BG=${thm'.alt}
      SEL_BG=${thm'.blue}
      SEL_FG=${thm'.bg}
      TXT_BG=${thm'.bg}
      TXT_FG=${thm'.fg}
      HDR_BTN_BG=${thm'.bg}
      HDR_BTN_FG=${thm'.fg}
      WM_BORDER_FOCUS=${thm'.alt}
      WM_BORDER_UNFOCUS=${thm'.dark}
      MATERIA_STYLE_COMPACT=True
      MATERIA_COLOR_VARIANT=dark
      UNITY_DEFAULT_LAUNCHER_STYLE=False
      NAME=generated
    '';
  };
in {
  nixpkgs.overlays = [(self: super: {
    generated-gtk-theme-2 = with pkgs; stdenv.mkDerivation rec {
      name = "generated-gtk-theme-2";
      src = fetchFromGitHub {
        owner = "themix-project";
        repo = "oomox";
        rev = "1.13.3";
        sha256 = "0krhvd73gm8znfr088l9d5195y6c7bsabdpf7fjdivjcrjv1a9qz";
        fetchSubmodules = true;
      };
      dontBuild = true;
      nativeBuildInputs = [ glib libxml2 bc ];
      buildInputs = [ gnome3.gnome-themes-extra gdk-pixbuf librsvg pkgs.sassc pkgs.inkscape pkgs.optipng ];
      propagatedUserEnvPkgs = [ gtk-engine-murrine ];
      installPhase = ''
        # icon theme
        mkdir -p $out/share/icons/Starlight
        pushd plugins/icons_suruplus_aspromauros
        patchShebangs .
        ./change_color.sh -o Starlight -d $out/share/icons/Starlight -c ${thm'.fg}
        popd
        # gtk theme
        mkdir -p $out/share/themes/Starlight
        pushd plugins/theme_oomox
        patchShebangs .
        echo "
        BG=${thm'.bg}
        FG=${thm'.fg}
        BTN_BG=${thm'.bg}
        BTN_FG=${thm'.fg}
        MENU_BG=${thm'.bg}
        MENU_FG=${thm'.fg}
        ACCENT_BG=${thm'.alt}
        SEL_BG=${thm'.blue}
        SEL_FG=${thm'.bg}
        TXT_BG=${thm'.bg}
        TXT_FG=${thm'.fg}
        HDR_BTN_BG=${thm'.bg}
        HDR_BTN_FG=${thm'.fg}
        WM_BORDER_FOCUS=${thm'.alt}
        WM_BORDER_UNFOCUS=${thm'.dark}
        MATERIA_STYLE_COMPACT=True
        MATERIA_COLOR_VARIANT=dark
        UNITY_DEFAULT_LAUNCHER_STYLE=False
        NAME=generatedd
        " > $out/starlight.colors
        HOME=$out ./change_color.sh -o Starlight -m all -t $out/share/themes $out/starlight.colors
        popd
      '';
    };
    generated-gtk-theme = self.stdenv.mkDerivation rec {
      name = "generated-gtk-theme";
      src = inputs.materia-theme;
      buildInputs = with self; [ sassc bc which inkscape optipng ];
      installPhase = ''
        HOME=/build
        chmod 777 -R .
        patchShebangs .
        mkdir -p $out/share/themes

        echo "$(pwd)"
        # echo "$(ls)"
        # cd $src
        echo "$(pwd)"
        echo "DIR:"
        # echo "$(ls)"
        echo "/DIR"

        substituteInPlace change_color.sh --replace "\$HOME/.themes" "$out/share/themes"
        echo "Changing colours:"
        ./change_color.sh -o Generated ${materia_colors}

        # cd -
        chmod 555 -R .
      '';
    };
  })];
  services.dbus.packages = with pkgs; [ gnome3.dconf ];
  home-manager.users.sencho = {
    gtk = {
      enable = true;
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      theme = {
        name = "Generated";
        package = pkgs.generated-gtk-theme-2;
      };
      font = {
        name = builtins.elemAt config.fonts.fontconfig.defaultFonts.serif 0;
      };
      gtk3.extraConfig.gtk-cursor-theme-name = "breeze";
    };
    home.sessionVariables.GTK_THEME = "Generated";
  };
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "gtk2";
  };
}
