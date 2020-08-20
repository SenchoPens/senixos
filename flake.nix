{
  description = "Nixos config by Sencho Pens, stolen from balsoft/nixos-config";

  inputs = {
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

