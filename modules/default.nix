{ pkgs, lib }:
{
  cddaExtraContents = import ./cdda-extras.nix { inherit pkgs lib; };
  cddaExtraExpandedContents = import ./cdda-extras-expanded.nix { inherit pkgs lib; };
  cddaGameSettings = import ./cdda-game-settings.nix;
  devshell = import ./devel/devshell.nix { inherit pkgs lib; };
  contentsInstaller = import ./contents-installer.nix { inherit pkgs lib; };
}
