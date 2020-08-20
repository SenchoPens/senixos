{ pkgs, config, lib, ... }:

with import ../../../support.nix { inherit pkgs config lib; };
with lib;
{
  home-manager.users.sencho.xdg.configFile."i3blocks/config".text = let
    scripts = import ./scripts pkgs config;

    scr = x: {
      name = x;
      command = scripts.${x};
    };

    scrint = x: interval: (scr x) // { inherit interval; };
  in ''
    interval=60
    markup=pango
  '' 
  # The order is left to right
  + genIniOrdered (
      [ ]
      ++ [
        (scrint "weather" 600) 
        (scr "calendar") 
        (scrint "music" 10)
        (scrint "sound" 5)
        (scrint "cpu" 5)
        (scrint "freq" 10)
        (scr "temperature")
        (scrint "free" 10) 
        (scrint "connections" 10) 
        (scr "df") 
        (scr "date")
        (scrint "time" 1)
      ] 
      #ToDo: ++ optionals config.deviceSpecific.isLaptop [
      ++ [
        (scr "battery")
        (scrint "brightness" 5)
      ]
      #++ optional (config.deviceSpecific.devInfo ? bigScreen) (scrint "network" 1)
    );
}
