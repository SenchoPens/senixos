{
  description = "Nixos config by Sencho Pens, stolen from balsoft/nixos-config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    lambda-launcher.url = github:SenchoPens/lambda-launcher;
    NUR.url = github:nix-community/NUR;
    home-manager.url = github:nix-community/home-manager?ref=release-20.09;
    nixpkgs-wayland.url = github:colemickens/nixpkgs-wayland;
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    base16-summerfruit-scheme = {
      url = github:cscorley/base16-summerfruit-scheme;
      flake = false;
    };

    base16-atelier-schemes = {
      url = github:atelierbram/base16-atelier-schemes;
      flake = false;
    };

    neovim-unwrapped-nightly = {
      url = github:neovim/neovim?rev=c6ccdda26ae0b8a9bf4d0779d398cb7c9864aedf;
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
  };
  
  outputs = { nixpkgs, nur, self, home-manager, ... } @ inputs: {
    nixosConfigurations = with nixpkgs.lib;
      let
        hosts = map 
          (fname: builtins.head (builtins.match "(.*)\\.nix" fname)) 
          (builtins.attrNames (builtins.readDir ./hardware-configuration));
        mkHost = name:
         nixosSystem {
            system = "x86_64-linux";
            modules = [ 
              (import ./default.nix) 
              {
                nixpkgs.overlays = [
                  nur.overlay
                  inputs.neovim-nightly-overlay.overlay
                ];
              }
              # home-manager.nixosModules.home-manager
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

