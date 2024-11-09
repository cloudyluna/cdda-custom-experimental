# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.8.0] - 2024-11-09

### Added

- Add `cdda-tiles-launcher-development` to `#development` output.
    - Now, as a private CDDA mod author using this flake, I can replace mods
    and other contents from within `$HOME/.cdda-custom-experimental-development/content`
    directory without the need to update this flake anymore. This is far more
    convenient with this new script being available by default.
    

### Changed

- Bump `CDDA` game version to `2024-11-08-2048`.
- Bump `Tankmod_Revived` to `5b1ea6a16f9cbdde3ce8b5dd01d1704cf8625c61`.
- `#development` output now points to `cdda-tiles-launcher-dev` by default.
    - `json_formatter.cgi` is still available and exposed in `PATH` normally.

## [0.7.0] - 2024-11-07

### Removed

- `Arcana` mod from `#extras`. I personally don't really use it as much and thus I don't see the need for it to be included by default. One can always add this mod manually like any other, though.

### Changed

- Bump `CDDA` game version to `2024-11-03-0625`.
- Bump `No_rust` from Minimods to `b039afd3007b083d191f4bf63d35f9b28896d8e4`. Previously we were using the Steam 0.G edition with minimal compatibility patch.
- Bump `Tankmod_Revived` to `e542d43df005acb65468430821bc318886d85bf0`.

## [0.6.0] - 2024-09-07

### Changed

- Bump 'CDDA' game version to `2024-09-06-2220`.
- Bump `Arcana` mod revision to `76b2dc9257441734baffb0c0e17d50d7a0e58073`.
- Bump `UndeadPeople` tileset to `65a9f538897643c084c93133861eb13e26d47db8`, aka Tutti Frutti (August Release 2).

## [0.5.1] - 2024-08-04

### Changed

- Bump `Arcana` mod revision to `67aeeaea9581a3482e914134a980db84a2cf84d5`.


## [0.5.0] - 2024-08-02

### Added

- Arcana mod to `#extras`.

### Fixed

- Use the content name when when `subdirs` key is an empty list.

### Changed

- Bump CDDA experimental game version to `2024-08-01-0705`.


## [0.4.0] - 2024-07-31

### Added

- Support for tilesets (gfx).

- Add more content to `#extras`.
    - jackledead_armory mod 
        - I didn't include the world core addition submod due to
          it causing an error prompt in the world loading screen.
          I don't see anything major, but I don't want to risk it as a default
          inclusion.
          You can include this manually in your local nix file though.
          See [modules/cdda-extras.nix](/modules/cdda-extras.nix).
    - UndeadPeople tileset.

- `No portal storm` submod from Minimods. Though, their `modinfo.json` need to be
patched to fix some minor typo and remove Steam's related key-value.
    - Patch code can be found in 
    [patches/minimods/minimods.patch](/patches/minimods/minimods.patch)

- Add `#extras-expanded` output to include a wider selection of mods, soundpacks and tilesets
on top of `#extras`. Biggest downside with this output is that it's going to take a
while to complete building and may need more PC resources to complete (connection bandwidth, larger disk,
more RAM, etc).
    - This comes with the Otopack's sound pack by default.

### Changed

- Bumped Minimods commit to `2b8fbb3ffe1ecded1b0716d6d6601977752457d5`.


### Fixed

- Nested directories specified in `subdirs` key in `cdda-extras.nix` now will
be flattened to be consistent with other mods. 
For example: `mods/deadjackal_armory`
will live as `data/mods/deadjackal_armory` instead of `data/mods/mods/deadjackal_armory`.


## [0.3.0] - 2024-07-29

### Added
- A development environment shell (aka devshell) and a Makefile to make development of this flake less tedious and reproducible as well.

### Fixed
- Content source directory with spaces in its name now can be copied properly.
- CHANGELOG.md now adheres to the keepachangelog format as much as possible.
- README.md with more information.

### Changed
- Factor out functionalities out of flake.nix into their own modules.
- Rename `#json-formatter` to `#development`.
- Leave the original `json_formatter.cgi` executable name as it is for 
`#development`.


## [0.2.0] - 2024-07-27

### Added
- Enable a functionality to add audio packs.
- Also refactor the mods installer function so user can add or remove 
mods/audio packs within a variable attribute set instead of going around all over
the place in the flake.nix file.
- Document about overriding user directory path at runtime via 
`cdda-tiles-launcher` in README.md

- Maybe add tilesets support later if I'd need it?

## [0.1.0.0] - 2024-07-24

Initial release.
