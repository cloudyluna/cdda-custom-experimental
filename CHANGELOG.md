# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- A development environment shell (aka devshell) and a Makefile to make development of this flake less tedious and reproducible as well.

### Fixed
- Content source directory with spaces in its name now can be copied properly.
- CHANGELOG.md now adheres to the keepachangelog format as much as possible.

### Changed
- Factor out functionalities out of flake.nix into their own modules.
- Rename some of the outputs for consistency.
    - `#json-formatter` output to `#development`.
    - `#extras.name` to `extras`.
    - `#default.name` to `default`.
- Leave the original `json_formatter.cgi` executable name as it is for 
`#development`.


## [0.2.0] - 27-07-2024

### Added
- Enable a functionality to add audio packs.
- Also refactor the mods installer function so user can add or remove 
mods/audio packs within a variable attribute set instead of going around all over
the place in the flake.nix file.
- Document about overriding user directory path at runtime via 
`cdda-tiles-launcher` in README.md

- Maybe add tilesets support later if I'd need it?

## [0.1.0.0] - 24-07-2024

Initial release.
