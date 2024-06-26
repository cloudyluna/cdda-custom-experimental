{
  description = "cdda-git";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url  = "github:numtide/flake-utils";
  };
  
  outputs = { self, nixpkgs, flake-utils, ... }:
    let supportedSystems = [ "x86_64-linux" ];
    in flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
        rec {
          packages = {
            cdda-experimental-git = pkgs.stdenv.mkDerivation rec {
              name = "cdda-tiles-launcher";
              src = let
                releaseVersion = "2024-06-26-0530";
              in
                pkgs.fetchurl {
                  # if want local tarball, use file://... url.
                  url = "https://github.com/CleverRaven/Cataclysm-DDA/releases/download/cdda-experimental-${releaseVersion}/cdda-linux-tiles-sounds-x64-${releaseVersion}.tar.gz";
                  hash = "sha256-Hf4LiPU7jjqWlP8Ic0Du9KUdKRqC7o51/65qSpL1wfI=";
                };
              
              nativeBuildInputs = with pkgs; [
                autoPatchelfHook
              ];
              
              buildInputs = with pkgs; [
                ncurses
                gettext
                SDL2
                SDL2_image
                SDL2_mixer
                SDL2_ttf
              ];

              patchDesktopFile = ''
              substituteInPlace $out/share/applications/org.cataclysmdda.CataclysmDDA.desktop \
                --replace "Exec=cdda-tiles-launcher" "Exec=$out/bin/cdda-tiles-launcher"
              '';
              
              dontStrip = true;

              installPhase = ''
                runHook preInstall

                mkdir $out
                cp -R data gfx doc $out
                
                install -m755 -D cataclysm-tiles $out/bin/cataclysm-tiles

                launcher=$app/Contents/MacOS/Cataclysm.sh
                cat << EOF > launcher
                #!${pkgs.runtimeShell}
                $out/bin/cataclysm-tiles --basepath $out
                EOF
                install -m755 -D launcher.sh $out/bin/${name}

                runHook postInstall
              '';
            };
          };
          packages.default = packages.cdda-experimental-git;
        });
}
