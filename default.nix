# This is Sencho Pens's configuration file.
#
# https://github.com/SenchoPens/nixos-config
#
# This is main nixos configuration
# To use this configuration:
#   1. Add your own secret.nix and hardware-configuration/`hostname`.nix to this folder
#   2. Set the hostname to the desired one
#   3. `sudo nixos-rebuild switch --flake .`
#   4. Log in to application and services where neccesary

{ config, nix, pkgs, lib, inputs, name, ... }:
rec {
  imports = [
    (./hardware-configuration + "/${name}.nix")

    inputs.home-manager.nixosModules.home-manager

    (import ./modules)
  ];

  device = name + "-Laptop";  # ToDo: do this adequately
 
  system.stateVersion = "20.03";

  networking.hostName = name; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  environment.sessionVariables = {
    XKB_DEFAULT_LAYOUT = "us,ru";
    XKB_DEFAULT_OPTIONS = "grp:rshift_toggle,grp_led:caps,caps:ctrl_modifier";
    LANG = lib.mkForce "en_GB.UTF-8";
  };

  #services.xserver = {
    #extraLayouts = {
      #sencho = {
        #description = "my xkb layout";
        #languages = [ "rus" "eng" ];
        #symbolsFile = ./sencho_xkb;
      #};
    #};

    #layout = "sencho";
    #xkbOptions = "grp:rshift_toggle,grp_led:caps,caps:ctrl_modifier";
  #};
  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  home-manager.users.sencho.home.language = let
    en = "en_GB.UTF-8";
    ru = "ru_RU.UTF-8";
  in {
    address = ru;
    monetary = ru;
    paper = ru;
    time = en;
    base = en;
  };
}
