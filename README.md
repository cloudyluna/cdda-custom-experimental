# CDDA Custom Experimental
This is my personal nix flake to run the automatically (experimental) built CDDA game from CDDA's github repo. The executable artifact is fetched from their Github's Action CI system.

My biggest primary motives for this flake is to:

1. Play the experimental game version without first building it from source which could take a lot of resources and time on my NixOS running PC.

2. Reproduce any possible configurations from system level dependencies (SDL2 and other required runtimes) along with CDDA's specific dependencies that didn't come by default including extra mods, sound packs or customized game configurations.

3. Make this flake available for my private CDDA modding project which uses nix. See [development](#development).

4. Learn `nix`, `nix flake` and `NixOS` by developing this flake. What's better to learn a new technology than to use it for something immediately useful for my own personal use?

For completion, please see [what this project is not](#what-this-project-is-not).

> NOTE: This is only tested on NixOS. You may need [nixGL](https://github.com/nix-community/nixGL) if
you are running `nix` on other Linux distribution.

## Table of Contents
- [Description](#cdda-custom-experimental)
- [Installation](#installation)
  - [Remotely](#remotely)
  - [Locally](#locally)
  - [Run remotely](#run-remotely)
- [Flake configuration version](#flake-configuration-version)
- [Flake outputs](#flake-outputs)
  - [default](#default)
    - [Current game type used](#current-game-type-used)
      - [Exposed executables](#exposed-executables)
    - [I want to play the very latest version!](#i-want-to-play-the-very-latest-version)
  - [extras](#extras)
    - [Included mods](#included-mods)
    - [I want more cool mods or sound packs!](#i-want-more-cool-mods-or-sound-packs)
  - [development](#development)
    - [Included tools](#included-tools)
    - [devShells usage example](#devshells-usage-example)
- [Default user directory](#default-user-directory)
- [What this project is not](#what-this-project-is-not)
- [See more](#see-more)

## Installation

### Remotely

- `nix profile install --refresh github:cloudyluna/cdda-custom-experimental`

### Locally
- `nix profile install --refresh .`

### Run remotely

- `nix run --refresh github:cloudyluna/cdda-custom-experimental`

## Flake configuration version
0.3.0

## Flake Outputs

These are the available outputs provided by this project. In general, all the executables and scripts exposed by this flake should *work without major crashes*. 

Due to the experimental nature of the used edition of the game (bugs are to be expected), this flake provided game will seldom be updated for a while (weeks or even months). Although, I will personally test the game and the included extra stuff for stability purposes.

To use run or build these outputs, append `#OUTPUT_NAME` to the `nix build` or `nix run` remote URL or local path.

Example: 
  - Remotely: `nix run --refresh github:cloudyluna/cdda-custom-experimental#extras`
  - Locally: `nix run --refresh .#extras`


### default

The base and the primary CDDA game version used throughout in other outputs (except for **development**). You can see the list of pre-built executables from [here](https://github.com/CleverRaven/Cataclysm-DDA/releases).

#### Current game type used
- Edition: Native GUI (tiles) bundled with CC-Sounds sound pack.
  > Note: CC-Sounds need to be enabled manually in your game settings! (Options > General > Soundpack)
- Version: 2024-07-24-0510
- Release page URL: https://github.com/CleverRaven/Cataclysm-DDA/releases/tag/cdda-experimental-2024-07-24-0510
- Supported architectures: x86_64-linux
- Full changelog: https://github.com/CleverRaven/Cataclysm-DDA/compare/cdda-experimental-2024-07-24-0150...cdda-experimental-2024-07-24-0510
- Executable tarball direct download: https://github.com/CleverRaven/Cataclysm-DDA/releases/download/cdda-experimental-2024-07-24-0510/cdda-linux-tiles-sounds-x64-2024-07-24-0510.tar.gz

#### Exposed executables:
  - `cdda-tiles-launcher` - A shell script to launch cataclysm-tiles with the user directory located in custom location. See [Default user directory](#default-user-directory) for further information.
  - `catacylsm-tiles` - The invoked game binary. Call this manually (with `--help` for info) if you want more control.


#### I want to play the very latest version!

You can manually update the game type (versions, editions, etc) by changing the values within [modules/cdda-game-settings.nix](/modules/cdda-game-settings.nix) file to your liking, locally. There are some comments left in there to explain what the keys and values mean.

> Note: Remember to run `nix build .#` once you finished changing the values.


### extras
This output is CDDA + with some mods bundled which I consider to be "must have", that I personally prefer to have while playing the game.

> NOTE: Remember to enable them in your world creation menu by pressing 'm' button and select your mod of choice in the world creation screen.

#### Included mods
- [Tankmod_Revived](https://github.com/chaosvolt/cdda-tankmod-revived-mod/tree/70278e9576a875c801ff6848e059312ae97a411c)
  - M1 Abrams, electric powered mini tank, etc. I love battle tanks in this game! Cozy and comfy.
- [Minimods](https://github.com/John-Candlebury/CDDA-Minimods/tree/67a3f14a096f5780294ec32d3de48c4bb37b05e3)
  - Included submods:
    - ***No_rust*** because I don't want want character skills to decay at all.
    Enable this in your mod balance's sub-tab menu.


#### I want more cool mods or sound packs!
You can add more mods or sound packs within [/modules/cdda-extras.nix](/modules/cdda-extras.nix) file.
There are comments and real usage examples in it to guide you on how to do this.

> Note: Remember to run `nix build .#extras` once you finished changing the values.

It is also possible to copy your preferred sound pack directory into the `sound`
directory within `$HOME/.cdda-custom-experimental` or into wherever else your user directory location. By default, this will be in `$HOME/.cdda-custom-experimental/sound`. 

You don't need to run `nix build` for this but be warned this is not
reproducible with nix if you switch your computer in the future unlike updating
the `cdda-extras.nix` above.

### development

Why this exists? I also use this flake as a development input for my private
CDDA modding projects which I integrate with nix flake for 
reproducibility purposes (used in devshells).

> Note: This output is a special exception where it doesn't bundle CDDA game
and data contents.

#### Included tools
- `json_formatter.cgi` - Format mods JSON file according to CDDA's maintainer preferred style.

#### devShells usage example
*flake.nix*
```nix{
  description = ''
    My flake for developing a cute CDDA mod!
    '';

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url  = "github:numtide/flake-utils";
    cdda-development.url    = "github:cloudyluna/cdda-custom-experimental";
  };
  
  outputs = { self, nixpkgs, flake-utils, cdda-development, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
        {
          devShells.default = with pkgs; mkShell {
            buildInputs = [
              gnumake
              dhall
              dhall-json
              dhall-lsp-server

              # Exposes json_formatter.cgi to the env.
              cdda-development.packages.${system}.development
            ];
          };
          
        }
    );
}
```

## Default user directory

`cdda-tiles-launcher` will use `$HOME/.cdda-custom-experimental` directory by
***default***.
To override this to any directory you like, append the path of the
location by the end of command call.

Example: `cdda-tiles-launcher ~/cdda_cat_development`.


## What this project is not

As this project and flake is mostly for my own use, this project aren't intended for and is not:

- A CDDA game launcher/manager for `nix` systems. That is a large scope on its own and I don't have the energy to develop this into something like that.

- A very robust and flexible nix configuration for many different use cases. This project purposes are only for as the ones described in [description](#cdda-custom-experimental) section.

- To be a derivation of the [cdda-experimental-git](https://search.nixos.org/packages?channel=24.05&show=cataclysm-dda-git&from=0&size=50&sort=relevance&type=packages&query=cataclysm) from official nixpkgs repo, which means that I would need to build this from source if the one in the repo aren't up to date as I want to.


Also, I wish to keep this flake pure (not depending on dynamic, runtime values), so new updates will reflect this decision. Though this might change if this nix flake feature [will get implemented](https://github.com/NixOS/nix/issues/5663) or if there are better ways to do this without significantly sacrificing reproducibility aspect of this flake.

## See More
- [The Nix Book](https://nix.dev/)
- [nix language tour, the one that started my nix lang learning journey](https://nixcloud.io/tour/?id=introduction/nix)
- https://nixos-and-flakes.thiscute.world/
- https://noogle.dev/