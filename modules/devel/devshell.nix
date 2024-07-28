{ pkgs }:
with pkgs;
mkShell {
  buildInputs = [
    nix-prefetch
    nix-prefetch-git
    nix-prefetch-github
    nixfmt-rfc-style
    gnumake
  ];

}
