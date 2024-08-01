{ pkgs, ... }:
with pkgs;
mkShell {
  buildInputs = [
    nix-prefetch
    nix-prefetch-git
    nixfmt-rfc-style
    gnumake
    jq
  ];
}
