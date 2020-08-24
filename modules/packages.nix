{ pkgs, config, lib, inputs, ... }:
let
  filterGit =
    builtins.filterSource (type: name: name != ".git" || type != "directory");
  system = "x86_64-linux";

in {
  nixpkgs.overlays = [
    inputs.nix.overlay
    (self: super: {
      inherit (inputs.lambda-launcher.packages.x86_64-linux) lambda-launcher;
    })
  ] ++ [
    (import ../overlays/overlay_1.nix)
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  environment.etc.nixpkgs.source = inputs.nixpkgs;

  nix = rec {
    nixPath = [
      "nixpkgs=/etc/nixpkgs"
      "nixpkgs-overlays=/etc/nixos/overlays"
      #"nixpkgs-overlays=/etc/nixos/modules/overlays-compat"  # does not work, most likely because of flakes.
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
