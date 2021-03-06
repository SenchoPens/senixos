p: c:
with p;

builtins.mapAttrs 
  (name: value:
    stdenv.mkDerivation {
      inherit name;
      src = value;
      unpackPhase = "true";
      buildInputs = [ghc];
      buildPhase = "ghc -o $out $src";
      installPhase = "true";
    })

  {
    free = ./free.hs;
    temperature = ./temperature.hs;
    network = ./network.hs;
  } // builtins.mapAttrs (name: value:
    writeTextFile {
      inherit name;
      text = callPackage value {
        iconfont = "Material Design Icons";
        config = c;
      };
      executable = true;
      checkPhase =
      "${bash}/bin/bash -n $src || ${python3}/bin/python3 -m compileall $src";
    }) 
    {
      brightness = ./brightness.nix;
      weather = ./weather.nix;
      sound = ./sound.nix;
      music = ./music.nix;
      connections = ./connections.nix;

      cpu = {...}: ''top -b -n1 -p 1 | fgrep "Cpu(s)" | tail -1 | awk -F'id,' -v prefix="$prefix" '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); printf " %s%.1f%%\n", prefix, 100 - v }' '';
      freq = {...}: ''echo $(${pkgs.bc}/bin/bc -l <<< "scale=2; `cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq|sort|tail -1`/1000000") GHz'';
      df = {...}: ''echo '' `df / | tail -1 | grep -o '..%'`'';
      date = {...}: "${pkgs.coreutils}/bin/date +' %a %y-%m-%d'";
      time = {...}: "${pkgs.coreutils}/bin/date +' %T'";

      battery = {...}: "bash ${./battery.sh}";
      #connections = {...}: "bash ${./connections.sh}";
}
