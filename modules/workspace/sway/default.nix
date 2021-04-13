{ pkgs, lib, config, ... }:
let
  thm = config.themes.default.colors;
  thm' = config.themes.default.colorsRaw;

  apps = config.defaultApplications;

  fzf-menu  = pkgs.writeShellScript "fzf-menu"  (builtins.readFile ./fzf-menu.sh);
  # lock      = pkgs.writeShellScript "lock"      "swaymsg 'output * dpms off'; sudo /run/current-system/sw/bin/lock; swaymsg 'output * dpms on'";
  swaylock-config = pkgs.writeText "swaylock-config" ''
    ignore-empty-password

    clock
    timestr=%R
    datestr=%a, %e of %B

    screenshots

    effect-pixelate=10

    indicator
    indicator-radius=130
    indicator-thickness=15

    key-hl-color=${thm'.green}

    separator-color=00000000

    inside-color=${thm'.bg}
    inside-clear-color=${thm'.bg}
    inside-ver-color=${thm'.blue}
    inside-wrong-color=${thm'.red}

    ring-color=${thm'.dark}
    ring-clear-color=${thm'.dark}
    ring-ver-color=${thm'.blue}
    ring-wrong-color=${thm'.red}

    line-color=00000000
    line-clear-color=00000000
    line-ver-color=00000000
    line-wrong-color=00000000

    text-clear-color=${thm'.orange}
    text-caps-lock-color=${thm'.orange}
    text-ver-color=${thm'.orange}
    text-wrong-color=${thm'.orange}

    bs-hl-color=${thm'.red}
  '';

  workspaces = map (x: x + "") [ "10:  " "1:  " "2:  " "3:  " "4:  " "5:  " "6: {}" "7:  " "8:  " "9:  " ];

  get_ws = n: builtins.elemAt workspaces n;
  get_ws_n = with lib; with builtins;
    ws: trivial.mod (toInt (elemAt (split ":" ws) 0)) 10;
  
  defaultFonts = config.fonts.fontconfig.defaultFonts;

  alacritty = "${pkgs.alacritty}/bin/alacritty";

in {
  programs.sway.extraPackages = lib.mkForce (with pkgs; [ swayidle xwayland swaylock-effects ]);

  home-manager.users.sencho.wayland.windowManager.sway = {
    enable = true;

    config = let
      modifier' = "Mod4";  # "Win" key
    in rec {
      modifier = "Mod1";  # "Alt" key

      focus.followMouse = false;
      focus.forceWrapping = true;

      fonts = defaultFonts.monospace;

      terminal = alacritty;

      input = {
        "*" = { 
          xkb_layout = "us,ru"; 
          xkb_options = "grp:rshift_toggle,grp_led:caps,caps:ctrl_modifier";
        };
      };

      assigns = let 
        wsAssigns = [
          [  ]
          [ { app_id = "firefox"; } ]
          [  ]
          [  ]
          [  ]
          [  ]
          [  ]
          [ { app_id = "transmission-gtk"; } ]
          [ { app_id = "telegramdesktop"; } ]
          [  ]
        ]; 
      in lib.genAttrs workspaces (ws: builtins.elemAt wsAssigns (get_ws_n ws));

      colors = rec {
        background = thm.dark;

        unfocused = {
          text = thm.light_fg;
          border = thm.dark;
          background = thm.dark;
          childBorder = thm.dark;
          indicator = thm.fg;
        };
        focusedInactive = unfocused;

        urgent = unfocused // {
          text = thm.fg;
          border = thm.orange;
          childBorder = thm.orange;
        };

        focused = unfocused // {
          childBorder = thm.gray;
          border = thm.gray;
          background = thm.gray;
          text = thm.fg;
        };
      };

      gaps = {
        inner = 20;
        smartGaps = true;
        smartBorders = "on";
      };

      window = {
        border = 1;
        titlebar = true;

        commands = [
          {
            command = "border pixel 2px";
            criteria = { window_role = "popup"; };
          }
          {
            command = "sticky enable";
            criteria = { floating = ""; };
          }
          {
            command = "floating enable";
            criteria = { app_id = "TerminalFloating"; };
          }
        ];
      };

      bars = [
        {
          id = "bottom";

          colors = let
            default = {
              background = thm.dark;
              border = thm.dark;
            };
          in {
            background = thm.dark;
            statusline = thm.fg;
            separator = thm.light_fg;
            focusedWorkspace = default // { text = thm.fg; };
            activeWorkspace = default // { text = thm.fg; };
            inactiveWorkspace = default // { text = thm.dark_fg; };
            urgentWorkspace = default // { text = thm.orange; };
            bindingMode = default // { text = thm.yellow; };
          };


          # see ../i3blocks for i3block configuration
          statusCommand = "${pkgs.i3blocks}/bin/i3blocks";

          fonts = defaultFonts.monospace;
          mode = "dock";
          position = "bottom";

          workspaceNumbers = true;

          extraConfig = ''
            separator_symbol "  "
          '';
            #workspace_min_width = 100;
            #separator_symbol "  "
            #separator_symbol " "
        }
      ];

      startup = [
        { command = "${pkgs.xorg.xrdb}/bin/xrdb -merge ~/.Xresources"; }
        { command = "sudo ${pkgs.ydotool}/bin/ydotoold"; }
      ];

      keybindings = let
        script = name: content: "exec ${pkgs.writeScript name content}";

        wsKeys = (builtins.genList (x: [ (toString x) (get_ws x) ]) 10);

        # xdotool_click_n = n: ''exec "sh -c 'eval `${pkgs.xdotool}/bin/xdotool getactivewindow click --clearmodifiers ${builtins.toString(n)}`'"'';
        # ydotool = "sudo ${pkgs.ydotool}/bin/ydotool";
        # ydotool_do_alt = action: "${ydotool} key --up Alt && ${ydotool} ${action} && ${ydotool} key --down Alt";
        sway-click = btn: "seat - cursor press button${toString btn}; seat - cursor release button${toString btn}";
        sway-move = x: y: "seat - cursor move ${toString x} ${toString y}";

      in lib.mapAttrs'
      (name: value: {
        name = "--to-code " + name;
        inherit value;
      })  # makes bindings keyboard layout-agnostic
      ({
        "${modifier}+Shift+q" = "kill";
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+Shift+Return" = "exec ${terminal} --class 'TerminalFloating'";
        "${modifier}+o" = "layout toggle all";

        #"${modifier'}+s" = "echo 'clicked' > /tmp/lol && ${ydotool} click 1";  # left
        "${modifier'}+s" = sway-click 1;
        "${modifier'}+d" = sway-click 2;
        "${modifier'}+f" = sway-click 3;

        "${modifier'}+h" = sway-move (-100) 0;
        "${modifier'}+j" = sway-move 0 100;
        "${modifier'}+k" = sway-move 0 (-100);
        "${modifier'}+l" = sway-move 100 0;
        "${modifier'}+Ctrl+h" = sway-move (-50) 0;
        "${modifier'}+Ctrl+j" = sway-move 0 50;
        "${modifier'}+Ctrl+k" = sway-move 0 (-50);
        "${modifier'}+Ctrl+l" = sway-move 50 0;
        "${modifier'}+Shift+Ctrl+h" = sway-move (-25) 0;
        "${modifier'}+Shift+Ctrl+j" = sway-move 0 25;
        "${modifier'}+Shift+Ctrl+k" = sway-move 0 (-25);
        "${modifier'}+Shift+Ctrl+l" = sway-move 25 0;

        "${modifier}+Shift+h" = "focus child; focus left";
        "${modifier}+Shift+l" = "focus child; focus right";
        "${modifier}+Shift+k" = "focus child; focus up";
        "${modifier}+Shift+j" = "focus child; focus down";

        "${modifier}+Left" = "focus child; focus left";
        "${modifier}+Right" = "focus child; focus right";
        "${modifier}+Up" = "focus child; focus up"; "${modifier}+Down" = "focus child; focus down";

        "${modifier}+Shift+Ctrl+h" = "move left";
        "${modifier}+Shift+Ctrl+l" = "move right";
        "${modifier}+Shift+Ctrl+k" = "move up";
        "${modifier}+Shift+Ctrl+j" = "move down";

        "${modifier}+f" = "fullscreen toggle; floating toggle";
        "${modifier}+r" = "mode resize";
        "${modifier}+Shift+f" = "floating toggle";

        "${modifier}+d" = "exec ${terminal} --class 'TerminalFloating' -e ${fzf-menu}";

        "${modifier}+Print" = script "screenshot"
          "${pkgs.grim}/bin/grim Pictures/Screenshots/$(date +'%Y-%m-%d+%H:%M:%S').png";
        "${modifier}+Control+Print" = script "screenshot-copy"
          "${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy";
        "${modifier}+Shift+Print" = script "screenshot-area" ''
          ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" Pictures/Screenshots/$(date +'%Y-%m-%d+%H:%M:%S').png
        '';
        "${modifier}+Control+Shift+Print" =
          script "screenshot-area-copy" ''
            ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy'';

        "${modifier}+x" = "reload";
        "${modifier}+Shift+x" = "exit";

        "${modifier}+F1" = "move to scratchpad";
        "${modifier}+F2" = "scratchpad show";
        "${modifier}+F3" = "exec sudo ${pkgs.light}/bin/light -U 5";
        "${modifier}+F4" = "exec sudo ${pkgs.light}/bin/light -A 5";
        "${modifier}+F5" = "${pkgs.pamixer}/bin/pamixer --allow-boost -t";
        "${modifier}+F6" = "${pkgs.pamixer}/bin/pamixer --allow-boost -d 5";
        "${modifier}+F7" = "${pkgs.pamixer}/bin/pamixer --allow-boost -i 5";
        "${modifier}+F11" = "exec ${terminal} --class 'TerminalFloating' -e nmtui";  # -e work with alacritty
        "${modifier}+F12" = "output * dpms on";

        "${modifier}+End" = "exec ${pkgs.swaylock-effects}/bin/swaylock -C ${swaylock-config}";

        "${modifier}+p" = "sticky toggle";
        "${modifier}+b" = "focus mode_toggle";
      } 
      // builtins.listToAttrs (builtins.map (x: {
        name = "${modifier}+${builtins.elemAt x 0}";
        value = "workspace ${builtins.elemAt x 1}";
      }) wsKeys) 
      // builtins.listToAttrs (builtins.map (x: {
        name = "${modifier}+Shift+${builtins.elemAt x 0}";
        value = "move container to workspace ${builtins.elemAt x 1}";
      }) wsKeys));

      workspaceLayout = "tabbed";
      workspaceAutoBackAndForth = true;

      output = {
        "*".bg = "${thm.bg} solid_color";
      };
    };

    wrapperFeatures = {
      gtk = true;
      base = true;
    };

    # https://discourse.ubuntu.com/t/environment-variables-for-wayland-hackers/12750
    extraSessionCommands = ''
      export _JAVA_AWT_WM_NONREPARENTING="1";
      export XDG_CURRENT_DESKTOP="sway";
      export XDG_SESSION_TYPE="wayland";
      export GDK_BACKEND="wayland,x11";
      export QT_QPA_PLATFROM="wayland-egl";
    '';

    extraConfig = ''
      default_border pixel 1
      hide_edge_borders --i3 smart
      exec pkill swaynag
      exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK DBUS_SESSION_BUS_ADDRESS
      exec systemctl --user import-environment
    '';
      # exec systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK DBUS_SESSION_BUS_ADDRESS
  };
}

