# cdda-custom-experimental

This is my personal nix flake to run the automatically (experimental) built CDDA game from CDDA github repo. 
Beware that I'm using this flake for learning nix flakes and NixOS.

> NOTE: This is only tested on NixOS. You may need [nixGL](https://github.com/nix-community/nixGL) if
you are running `nix` on other Linux distribution.

# To give a quick try

- Remotely: `nix run github:cloudyluna/cdda-custom-experimental`.

- Locally: `nix run` or `nix run .#default` from within the repo directory.

# Install

- Remotely: `nix profile install github:cloudyluna/cdda-custom-experimental`
- Locally:  `nix profile install .` from within the directory.

# Extras

## Mods
I also bundle some mods that I like as a separate package.

> NOTE: Remember to enable them in your world creation menu by pressing 'm' button and select your mod of choice
in the world creation screen.

## Current included mods for `extras` package are:
- [Tankmod Revived](https://github.com/chaosvolt/cdda-tankmod-revived-mod) (commit hash: 70278e9576a875c801ff6848e059312ae97a411c)
  - M1 Abrams, electric powered mini tank, etc. I love battle tanks in this game! Cozy and comfy.
- [CDDA-Minimods](https://github.com/John-Candlebury/CDDA-Minimods/) (commit hash: 67a3f14a096f5780294ec32d3de48c4bb37b05e3)
  - Included submods:
    - ***No_rust*** because I don't want want character skills to decay overtime of when rarely used. Remember
    this mod can be found in the balance tab in the mod menu.

To make this work, just append `#extras` to the flake path name.

For example:

To install remotely: `nix profile install github:cloudyluna/cdda-custom-experimental#extras`


## Development tools

### json_formatter.cgi

Install: `nix profile install github:cloudyluna/cdda-custom-experimental#json-formatter`


- Exposed as: `cdda-json-formatter`

# Troubleshooting

If you're hitting the issue where `nix profile install` or `nix run` not downloading the latest update from this repo, append
your commands with `--refresh`.

For example: `nix run --refresh github:cloudyluna/cdda-custom-experimental`

# This flake config version

0.1.0.0

# Game version

- 2024-07-24-0510

# Exposed binaries

- `cdda-tiles-launcher` - A shell script to launch `cataclysm-tiles` with my preferred settings of choice.
- `cataclysm-tiles` - The invoked game binary. Call this manually (with `--help` for info) if you want more control.

# User directory

I don't want to to mess with my existing CDDA game user directories, so I set a custom one in `$HOME/.cdda-custom-experimental`.

# Supported archs

- x86_64_linux

I don't see any point of supporting more but feel free to extend the flake.

# Not supported
- TUI/ncurses edition.
