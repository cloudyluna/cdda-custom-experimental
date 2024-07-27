{ pkgs }: {
  extraContents = import ./cdda-extras.nix { inherit pkgs; };
  cddaGameSettings = import ./cdda-game-settings.nix;
}
