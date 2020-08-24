{ pkgs, lib, config, ... }:
let
  thm = config.themes.dark.colors;

  apps = config.defaultApplications;

  lock_fork = pkgs.writeShellScript "lock_fork" "sudo /run/current-system/sw/bin/lock &";
  lock = pkgs.writeShellScript "lock" "swaymsg 'output * dpms off'; sudo /run/current-system/sw/bin/lock; swaymsg 'output * dpms on'";

  workspaces = map (x: x + "") [ "10:  " "1:  " "2:  " "3:  " "4:  " "5:  " "6: {}" "7:  " "8:  " "9:  " ];

  get_ws = n: builtins.elemAt workspaces n;
  get_ws_n = with lib; with builtins;
    ws: trivial.mod (toInt (elemAt (split ":" ws) 0)) 10;
  
  defaultFonts = config.fonts.fontconfig.defaultFonts;

in {
  environment.sessionVariables._JAVA_AWT_WM_NONREPARENTING = "1";

  programs.sway.wrapperFeatures.gtk = true;

  programs.sway.extraPackages = lib.mkForce (with pkgs; [ swayidle xwayland ]);

  home-manager.users.sencho.wayland.windowManager.sway = {
    enable = true;

    config = rec {
      modifier = "Mod1";

      focus.followMouse = false;
      focus.forceWrapping = true;

      fonts = defaultFonts.monospace;

      terminal="${pkgs.alacritty}/bin/alacritty";

      input = {
        "*" = { 
          xkb_layout = "us,ru"; 
          xkb_options = "grp:rshift_toggle,grp_led:caps,caps:ctrl_modifier";
        };
      };

      assigns = let 
        wsAssigns = [
          [  ]
          [ { app_id = "firefox"; } { class = "qutebrowser"; } { class = "Tor Browser"; } ]
          [  ]
          [  ]
          [ { class = "jetbrains-pycharm-ce"; } ]
          [  ]
          [  ]
          [ { class = "ktorrent"; } { class = "Transmission-gtk"; } ]
          [ { class = "TelegramDesktop"; } { class = "Keybase"; } { class = "Trello"; } ]
          [ { class = "smplayer"; } ]
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
            focusedWorkspace = default // { text = thm.green; };
            activeWorkspace = default // { text = thm.fg; };
            inactiveWorkspace = default // { text = thm.fg; };
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

        xdotool_click_n = n: ''exec "sh -c 'eval `${pkgs.xdotool}/bin/xdotool getactivewindow click --clearmodifiers ${builtins.toString(n)}`'"'';
        ydotool = "sudo ${pkgs.ydotool}/bin/ydotool";
        ydotool_do_alt = action: "${ydotool} key --up Alt && ${ydotool} ${action} && ${ydotool} key --down Alt";

      in ({
        "${modifier}+Shift+q" = "kill";
        "${modifier}+Return" = "exec ${apps.term.cmd}";
        "${modifier}+o" = "layout toggle all";

        "${modifier}+q" = ydotool_do_alt "click 1";  # left
        "${modifier}+e" = ydotool_do_alt "click 2";  # rigth
        "${modifier}+w" = ydotool_do_alt "click 3";  # middle

        "${modifier}+h" = ydotool_do_alt "key left";
        "${modifier}+l" = ydotool_do_alt "key right";
        "${modifier}+k" = ydotool_do_alt "key up";
        "${modifier}+j" = ydotool_do_alt "key down";

        "${modifier}+Shift+h" = "focus child; focus left";
        "${modifier}+Shift+l" = "focus child; focus right";
        "${modifier}+Shift+k" = "focus child; focus up";
        "${modifier}+Shift+j" = "focus child; focus down";

        "${modifier}+Left" = "focus child; focus left";
        "${modifier}+Right" = "focus child; focus right";
        "${modifier}+Up" = "focus child; focus up";
        "${modifier}+Down" = "focus child; focus down";

        "${modifier}+Shift+Ctrl+h" = "move left";
        "${modifier}+Shift+Ctrl+l" = "move right";
        "${modifier}+Shift+Ctrl+k" = "move up";
        "${modifier}+Shift+Ctrl+j" = "move down";

        "${modifier}+f" = "fullscreen toggle; floating toggle";
        "${modifier}+r" = "mode resize";
        "${modifier}+Shift+f" = "floating toggle";

        "${modifier}+d" = "exec ${pkgs.lambda-launcher}/bin/lambda-launcher";

        "${modifier}+Print" = script "screenshot"
          "${pkgs.grim}/bin/grim Pictures/Screenshots/$(date +'%Y-%m-%d+%H:%M:%S').png";

        "${modifier}+Control+Print" = script "screenshot-copy"
          "${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy";

        "--release ${modifier}+Shift+Print" = script "screenshot-area" ''
          ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" Pictures/Screenshots/$(date +'%Y-%m-%d+%H:%M:%S').png
        '';

        "--release ${modifier}+Control+Shift+Print" =
          script "screenshot-area-copy" ''
            ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy'';

        "${modifier}+x" = "move workspace to output right";
        "${modifier}+F5" = "reload";
        "${modifier}+Shift+F5" = "exit";
        "${modifier}+Shift+x" = "layout splith";
        "${modifier}+Shift+v" = "layout splitv";
        "${modifier}+z" = "split h";
        "${modifier}+v" = "split v";
        "${modifier}+F1" = "move to scratchpad";
        "${modifier}+F2" = "scratchpad show";
        "${modifier}+F3" = "exec sudo ${pkgs.light}/bin/light -U 5";
        "${modifier}+F4" = "exec sudo ${pkgs.light}/bin/light -A 5";
        "${modifier}+F11" = "output * dpms off";
        "${modifier}+F12" = "output * dpms on";
        "${modifier}+End" = "exec ${lock}";
        "${modifier}+p" = "sticky toggle";

        "${modifier}+b" = "focus mode_toggle";

        "button2" = "kill";
        "--whole-window ${modifier}+button2" = "kill";
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
    };

    extraConfig = ''
      default_border pixel 1
      hide_edge_borders --i3 smart
      exec pkill swaynag
    '';
  };
}

