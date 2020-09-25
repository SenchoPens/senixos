{ pkgs, config, inputs, ... }:
let
  interception-k2k = pkgs.stdenv.mkDerivation {
    pname = "interception-k2k";
    version = "sencho";
    src = inputs.interception-k2k;
    buildPhase = ''
      mkdir sencho-interception-config
      cp -r ${./sencho-pipe} sencho-interception-config/sencho-pipe
      make CONFIG_DIR=sencho-interception-config
    '';
    installPhase = ''
      make install CONFIG_DIR=sencho-interception-config INSTALL_DIR=$out/bin
    '';
  };

in {
  services.interception-tools = {
    enable = true;
    plugins = [ interception-k2k ];
    udevmonConfig = ''
      - JOB: "intercept -g $DEVNODE | sencho-pipe | uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC, KEY_LEFTALT, KEY_RIGHTALT]
    '';
  };
}
