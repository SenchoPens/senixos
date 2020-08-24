{
  description = "Nixos config by Sencho Pens, stolen from balsoft/nixos-config";

  inputs = {
    nixkgs.url = github:nixos/nixpkgs/16f18c37ed15df7414018f23fa48d398767aef74;

    lambda-launcher.url = github:SenchoPens/lambda-launcher;

    home-manager = {
      type = "github";
      owner = "rycee";
      repo = "home-manager";
      ref = "bqv-flakes";
    };

    base16-summerfruit-scheme = {
      url = github:cscorley/base16-summerfruit-scheme;
      flake = false;
    };

    nixpkgs-wayland = {
      type = "github";
      owner = "colemickens";
      repo = "nixpkgs-wayland";
      flake = false;
    };

    materia-theme = {
      url = github:nana-4/materia-theme;
      flake = false;
    };
  };
  
  outputs = { nixpkgs, nix, self, ... } @ inputs: {
    nixosConfigurations = with nixpkgs.lib;
      let
        hosts = map 
          (fname: builtins.head (builtins.match "(.*)\\.nix" fname)) 
          (builtins.attrNames (builtins.readDir ./hardware-configuration));
        mkHost = name:
         nixosSystem {
            system = "x86_64-linux";
            modules = [ (import ./default.nix) ];
            specialArgs = {
              inherit inputs name;
            };
          };
      in genAttrs hosts mkHost;
            
    legacyPackages.x86_64-linux = 
      (builtins.head (builtins.attrValues self.nixosConfigurations)).pkgs;
  };
} 

