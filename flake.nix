{
  description = "Nixos config by Sencho Pens, stolen from balsoft/nixos-config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=master";
    lambda-launcher.url = github:SenchoPens/lambda-launcher;
    NUR.url = github:nix-community/NUR;
    home-manager.url = github:rycee/home-manager;
    nixpkgs-wayland.url = github:colemickens/nixpkgs-wayland;

    base16-summerfruit-scheme = {
      url = github:cscorley/base16-summerfruit-scheme;
      flake = false;
    };

    neovim-unwrapped-nightly = {
      url = github:neovim/neovim?ref=nightly;
      flake = false;
    };

    interception-k2k = {
      url = github:zsugabubus/interception-k2k;
      flake = false;
    };

    materia-theme = {
      url = github:nana-4/materia-theme;
      flake = false;
    };
  };
  
  outputs = { nixpkgs, nix, nur, self, ... } @ inputs: {
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
              { nixpkgs.overlays = [ nur.overlay ]; }
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

