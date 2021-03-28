## Installing it on your machine
```
sudo nixos-rebuild test --flake .
sudo ln -s /etc/nixos/ /path/to/this/flake
```

## Creating your own secret.nix for better experience
You can check out the structure of `./secret.nix` in `./modules/secrets.nix`

## What's in?
* WM - sway
* DM - getty (console login)
* Terminal - Alacritty + zsh + powershell10k
* Editor - neovim
* Launcher - λauncher 

## Updating all packages
```
nix flake update
sudo nixos-rebuild switch
```

## Credits
This configuration would not have been possible without the original balsoft's
configuration and the russian Nixos community (`https://t.me/ru_nixos`).
