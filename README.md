# CDDA Custom Experimental

🐈🐈🐈

This is my personal nix flake to run the automatically (experimental) built 
CDDA game from CDDA's github repo. The executable artifact is fetched from 
their Github's Action CI system.

My biggest primary motives for this flake are to:

1. Play the somewhat, recently released, experimental game version, without 
first building it from source which could take a lot of resources and time on
my NixOS computer.

2. Reproduce any possible configurations from system level dependencies (SDL2 
and other required runtimes) along with CDDA's specific dependencies that 
didn't come by default including extra mods, sound packs or customized game 
configurations.

3. Make this flake available for my private CDDA modding project which uses nix. 
See [development](#development).

4. Learn `nix`, `nix flake` and `NixOS` by developing this flake. What's better 
way to learn a new technology than to use it for something immediately useful 
for my own personal use?

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
    - [Included tilesets](#included-tilesets)
    - [I want more cool mods or sound packs!](#i-want-more-cool-mods-or-sound-packs)
  - [extras-expanded](#extras-expanded)
    - [Included sound packs](#included-sound-packs)
  - [development](#development)
    - [Included tools](#included-tools)
    - [devShells usage example](#devshells-usage-example)
- [Default user directory](#default-user-directory)
- [Developing this flake](#developing-this-flake)
- [What this project is not](#what-this-project-is-not)
- [See more](#see-more)

## Installation

### Remotely

- `nix profile install --refresh github:cloudyluna/cdda-custom-experimental#extras`

### Locally
- `nix profile install --refresh .#extras`

Once it is installed, run `cdda-tiles-launcher` and enjoy the game!

### Run remotely

- `nix run --refresh github:cloudyluna/cdda-custom-experimental#extras`

## Flake configuration version
0.7.0

## Flake Outputs

These are the available outputs provided by this project. In general, all the 
executables and scripts exposed by this flake should *work without major crashes*. 

Due to the experimental nature of the used edition of the game (bugs are to be 
expected), this flake provided game will seldom be updated for a while 
(weeks or even months). I will personally test the game and the included extra 
stuff for stability purposes.

To use run or build these outputs, append `#OUTPUT_NAME` to the `nix build` 
or `nix run` remote URL or local path.

Example: 
  - Remotely: `nix run --refresh github:cloudyluna/cdda-custom-experimental#extras`
  - Locally: `nix run --refresh .#extras`


### default

The base and the primary CDDA game version used throughout in other outputs 
(except for [***development***](#development)). You can see the list of 
pre-built executables from [here](https://github.com/CleverRaven/Cataclysm-DDA/releases).

#### Current game type used
- Edition: Native GUI (tiles) bundled with CC-Sounds sound pack.
  > Note: If CC-Sounds is not enabled by default, you can enable it manually in your game settings! (Options > General > Soundpack)
- **Version**: 2024-11-06-0003
- **Supported architecture**: x86_64-linux
- [Release page](https://github.com/CleverRaven/Cataclysm-DDA/releases/tag/cdda-experimental-2024-11-06-0003)
- [Full changelog since 2024-09-06-2220](https://github.com/CleverRaven/Cataclysm-DDA/compare/cdda-experimental-2024-09-06-2220...cdda-experimental-2024-11-06-0003)

#### Exposed executables:
  - `cdda-tiles-launcher` - ***Most user should use this.*** A shell script to 
  launch cataclysm-tiles with the user directory located in custom location. 
  See [Default user directory](#default-user-directory) for further information.

  - `catacylsm-tiles` - The invoked game binary. Call this manually 
  (with `--help` for info) if you want more control.


#### I want to play the very latest version!

You can manually update the game type (versions, editions, etc) by changing 
the values within [modules/cdda-game-settings.nix](/modules/cdda-game-settings.nix) 
file to your liking, locally. There are some comments left in there to explain 
what the keys and values mean.

> Note: Remember to run `nix build .#` once you finished changing the values.


### extras
This one is a combination of [default output](#default) + with some mods 
bundled which I consider to be "must have", that I personally prefer to have 
while playing the game.

> NOTE: Remember to enable them in your world creation menu by pressing 'm' button and select your mod of choice in the world creation screen.

#### Included mods
- [Tankmod Revived](https://github.com/chaosvolt/cdda-tankmod-revived-mod/tree/70278e9576a875c801ff6848e059312ae97a411c)
   - M1 Abrams, electric powered mini tank, etc. 
   I love battle tanks in this game! Cozy and comfy.

- [Minimods](https://github.com/John-Candlebury/CDDA-Minimods/tree/b039afd3007b083d191f4bf63d35f9b28896d8e4)
  - Included submods:
    - ***No Rust*** because I don't want character skills to decay at all.
    Enable this in your mod balance's sub-tab menu.
    - ***No Portal Storms*** in case if I reallly, reaaaaallly don't want portal
    storms to appear at all 🫠.

- [Jackledead Armory](https://github.com/jackledead/jackledead_armory/tree/ddb48de223839f7b61390d4e58fa506878624a30)
  - More cool weapons!!!
  - Only additional items mod are added which doesn't include the world
  content expansion submod. See [modules/cdda-extras.nix](/modules/cdda-extras.nix) if you want to add.

#### Included tilesets
- [UndeadPeopleTileset](https://github.com/Theawesomeboophis/UndeadPeopleTileset/tree/65a9f538897643c084c93133861eb13e26d47db8)
  - Really good looking tileset/gfx and I personally favor it for most of 
  my runs.
  - Somewhat sizable in download size (20Mb ish) and still small enough. 
  Worth it 🐈! 
  


#### I want more cool mods or sound packs!
You can add more mods or sound packs within 
[/modules/cdda-extras.nix](/modules/cdda-extras.nix) file.
There are comments and real usage examples in it to guide you on how to do this.

> Note: Remember to run `nix build .#extras` once you finished changing the values.

It is also possible to copy your preferred sound pack directory into the `sound`
directory within `$HOME/.cdda-custom-experimental` or into wherever else your
user directory location is. By default, this will be in 
`$HOME/.cdda-custom-experimental/sound`. 

You don't need to run `nix build` for this but be warned this is not
reproducible with nix if you switch your computer in the future unlike updating
the `cdda-extras.nix` above.


### extras-expanded

As the title says, this output is expanded on top of [extras](#extras) and it 
inherits every mods, sound packs and tilesets from it. 

> Note: It is expected for this output installation to take longer time and probably will consume more system resources to complete.


To add more contents
specific for this output, see 
[modules/cdda-extras-expanded.nix](/modules/cdda-extras-expanded.nix).

#### Included sound packs

- [Otopack's](https://github.com/Kenan2000/Otopack-Mods-Updates/tree/419e3dbacb3f84ae121e12b0d148985a415b19f0)
  - *The soundpack* that I prefer by default, which sounds fantastic. 
  I excluded this from [extras](#extras) due to the large, archive download 
  size (500MB+).

### development

Why this exists? I also use this flake as a development input for my private
CDDA modding projects which I integrate with nix flake for 
reproducibility purposes (used in devshells).

> Note: This output is a special exception where it doesn't bundle CDDA game
and data contents.

#### Included tools
- `json_formatter.cgi` - Format mods JSON file according to CDDA's 
maintainer preferred style.

#### devShells usage example
*flake.nix*
```nix{
  description = ''
    My flake for developing a cute CDDA mod!
    '';

  inputs = {
    nixpkgs.url                  = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url              = "github:numtide/flake-utils";
    cdda-custom-experimental.url = "github:cloudyluna/cdda-custom-experimental";
  };
  
  outputs = { self, nixpkgs, flake-utils, cdda-custom-experimental, ... }:
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

              # Exposes cdda-tiles-launcher & cataclysm-tiles to the env.
              cdda-custom-experimental.packages.${system}.extras

              # Exposes json_formatter.cgi to the env.
              cdda-custom-experimental.packages.${system}.development
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


## Developing this flake

For convenience, I've included a simple `devShell` to be used with `nix develop`
or `direnv` to get the tools you need to make updating this flake slightly 
easier.

First, from within this repository, run `nix develop` or `direnv allow` 
(if you have nix-direnv enabled) and let it load the environment for you.

Then, you can use `make` to do most common things. You can change the target
by appending `TARGET=PATH#OUTPUT_NAME`.

- `make build` - Build the flake output.
- `make` - alias to `make build`.
- `make check` - Check if the flake files are syntactically correct.
- `make format` - Format (in-place) all the .nix files in the repository.

Example: `make build TARGET=.#extras`

## What this project is not

As this project and flake is mostly for my own use, this project aren't intended
for and is not:

- A CDDA game launcher/manager for `nix` systems. That is a large scope on its 
own and I don't have the energy to develop this into something like that.

- A very robust and flexible nix configuration for many different use cases. 
This project purposes are only for as the ones described in 
[description](#cdda-custom-experimental) section.

- To be a derivation of the [cdda-experimental-git](https://search.nixos.org/packages?channel=24.05&show=cataclysm-dda-git&from=0&size=50&sort=relevance&type=packages&query=cataclysm) 
from official nixpkgs repo, which means that I would need to build this from 
source if the one in the repo aren't up to date as I want to.


Also, I wish to keep this flake pure (not depending on dynamic, runtime values),
so new updates will reflect this decision. Though this might change if this nix 
flake feature [will get implemented](https://github.com/NixOS/nix/issues/5663) 
or if there are better ways to do this without significantly sacrificing 
reproducibility aspect of this flake.

## See More
- [The Nix Book](https://nix.dev/)
- [nix language tour, the one that started my nix lang learning journey](https://nixcloud.io/tour/?id=introduction/nix)
- https://nixos-and-flakes.thiscute.world/
- https://noogle.dev/
