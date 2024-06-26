{
  description = "cdda-git";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url  = "github:numtide/flake-utils";
  };
  
  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
        rec {
          packages = {
            cdda-experimental-git = pkgs.stdenv.mkDerivation rec {
              name = "cdda-tiles-launcher";
              src = pkgs.fetchurl {
                url = "https://github.com/CleverRaven/Cataclysm-DDA/releases/download/cdda-experimental-2024-06-26-0530/cdda-linux-tiles-sounds-x64-2024-06-26-0530.tar.gz";
                hash = "sha256-Hf4LiPU7jjqWlP8Ic0Du9KUdKRqC7o51/65qSpL1wfI=";
              };
              nativeBuildInputs = with pkgs; [
                autoPatchelfHook
              ];
              buildInputs = with pkgs; [
                SDL2
                SDL2_image
                SDL2_mixer
                SDL2_ttf
              ];

              sourceRoot = "cataclysmdda-0.I/";
              patchDesktopFile = ''
              substituteInPlace $out/share/applications/org.cataclysmdda.CataclysmDDA.desktop \
                --replace "Exec=cataclysm-tiles" "Exec=$out/bin/cataclysm-tiles"
              '';
              dontStrip = true;
              installPhase = ''
                runHook preInstall

                mkdir $out
                cp -R data gfx doc $out
                
                install -m755 -D cataclysm-tiles $out/bin/cataclysm-tiles
                cat << EOF > ${name}
                #!${pkgs.runtimeShell}
                $out/bin/cataclysm-tiles --basepath $out
                EOF
                install -m755 -D ${name} $out/bin/${name}
                runHook postInstall
              '';
            };
          };
          packages.default = packages.cdda-experimental-git;
        });
}
