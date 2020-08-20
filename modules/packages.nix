{ pkgs, config, lib, inputs, ... }:
let
  filterGit =
    builtins.filterSource (type: name: name != ".git" || type != "directory");
  system = "x86_64-linux";
  old = import inputs.nixpkgs-old ({
    config = config.nixpkgs.config;
    localSystem = { inherit system; };
  });
in {
  nixpkgs.config = {
    allowUnfree = true;
  };
  environment.etc.nixpkgs.source = inputs.nixpkgs;
  nix = rec {
    nixPath = lib.mkForce [
      "nixpkgs=/etc/nixpkgs"
    ];

    binaryCaches = [ "https://cache.nixos.org" ];

    registry.self.flake = inputs.self;

    trustedUsers = [ "root" "sencho" "@wheel" ];

    nrBuildUsers = 16;

    optimise.automatic = true;

    package = inputs.nix.packages.x86_64-linux.nix;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    requireSignedBinaryCaches = false;
  };
}
