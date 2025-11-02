# Basic dev environment template

## Prerequisites
* Have [nix](https://nixos.org/) installed
* Have [flakes](https://nixos.wiki/wiki/Flakes) enabled
* use [direnv](https://direnv.net/) and [nix-direnv](https://github.com/nix-community/nix-direnv)

## How to use
Clone this repo using
```
nix flake init --template github:jensereal/dev-flake-template <desired output path>
```
Afterwards run
```
direnv allow
```