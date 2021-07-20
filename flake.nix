{
  description = "Nixos config by Sencho Pens, stolen from balsoft/nixos-config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-21.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    lambda-launcher.url = github:SenchoPens/lambda-launcher;
    NUR.url = github:nix-community/NUR;
    home-manager.url = github:nix-community/home-manager?ref=release-21.05;
    nixpkgs-wayland.url = github:colemickens/nixpkgs-wayland;
    # neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    base16.url = "github:SenchoPens/base16.nix";

    # Tool to patch /bin/bash etc.
    envfs.url = "github:Mic92/envfs";
    envfs.inputs.nixpkgs.follows = "nixpkgs";

    # Tool to run unpatched binaries (see also nix-ld and steam-run)
    nix-autobahn.url = "github:SenchoPens/nix-autobahn";

    base16-summerfruit-scheme = {
      url = github:cscorley/base16-summerfruit-scheme;
      flake = false;
    };

    base16-atelier-schemes = {
      url = github:atelierbram/base16-atelier-schemes;
      flake = false;
    };

    base16-black-metal-schemes = {
      url = github:metalelf0/base16-black-metal-scheme;
      flake = false;
    };

    base16-eva-scheme = {
      url = github:kjakapat/base16-eva-scheme;
      flake = false;
    };

    interception-k2k = {
      url = github:zsugabubus/interception-k2k;
      flake = false;
    };

    materia-theme = {
      # next time updating try to remove rev
      url = "github:nana-4/materia-theme?rev=6f7e51a97fc7ff3ddbb7908cff505a8c1919b6a2";
      flake = false;
    };

    base16-qutebrowser = {
      url = github:theova/base16-qutebrowser;
      flake = false;
    };

    vsliveshare = {
      url = github:msteen/nixos-vsliveshare;
      flake = false;
    };

    enhancd = {
      url = github:b4b4r07/enhancd;
      flake = false;
    };

    zsh-syntax-highlighting = {
      url = github:zsh-users/zsh-syntax-highlighting;
      flake = false;
    };
  };
  
  outputs = { nixpkgs, nur, self, home-manager, base16, envfs, ... } @ inputs: {
    nixosConfigurations = with nixpkgs.lib;
      let
        hosts = map 
          (fname: builtins.head (builtins.match "(.*)\\.nix" fname))
          (builtins.attrNames (builtins.readDir ./hardware-configuration));
        mkHost = name:
         nixosSystem {
            system = "x86_64-linux";
            modules =
              let
                overlay-unstable = final: prev: {
                  unstable = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
                };
              in
                [
                  (import ./default.nix)
                  {
                    nixpkgs.overlays = [
                      nur.overlay
                      overlay-unstable
                      # inputs.neovim-nightly-overlay.overlay
                    ];
                  }
                  home-manager.nixosModules.home-manager
                  base16.nixosModule
                  envfs.nixosModules.envfs
                ];
            specialArgs = {
              inherit inputs name;
            };
          };
      in genAttrs hosts mkHost;

    legacyPackages.x86_64-linux = 
      (builtins.head (builtins.attrValues self.nixosConfigurations)).pkgs;
  };
} 
