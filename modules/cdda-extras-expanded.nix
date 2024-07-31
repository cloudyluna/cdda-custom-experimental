{ pkgs, lib }:
let
  extrasBase = import ./cdda-extras.nix { inherit pkgs lib; };
in
{
  mods = extrasBase.mods ++ [ ];

  soundPacks = extrasBase.soundPacks ++ [
    {
      name = "Otopack+ModsUpdates";
      subdirs = [ "Otopack+ModsUpdates" ];
      src = pkgs.fetchzip {
        url =
          "https://github.com/Kenan2000/Otopack-Mods-Updates/"
          + "archive/refs/tags/"
          + "Otopack+ModsUpdates_09.03.2024.tar.gz";
        hash = "sha256-CzqDyPsFWKb6gJYserVd2X8nfJY2cugQNfC/0opLdvo=";
      };
    }
  ];

  tileSets = extrasBase.tileSets ++ [ ];
}
