{
  description = "cdda-experimental-git";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let supportedSystems = [ "x86_64-linux" ];
    in flake-utils.lib.eachSystem supportedSystems (system:
      let pkgs = import nixpkgs { inherit system; };
      in rec {
        packages = rec {
          # With extra mods and all the goodies I like.
          extras =
            pkgs.lib.overrideDerivation default (oldAttrs:
              let
                mods = {
                  tank = builtins.fetchGit {
                    url =
                      "https://github.com/chaosvolt/cdda-tankmod-revived-mod";
                    rev = "70278e9576a875c801ff6848e059312ae97a411c";
                  };
                };
              in {
                installPhase = ''
                  runHook preInstall

                  mkdir $out
                  cp -R ${mods.tank}/Tankmod_Revived data/mods/
                  cp -R data gfx doc $out

                  install -m755 -D cataclysm-tiles $out/bin/cataclysm-tiles

                  cat << EOF > launcher
                  #!${pkgs.runtimeShell}
                  $out/bin/cataclysm-tiles --basepath $out --userdir \$HOME/.cdda-experimental-git
                  EOF
                  install -m755 -D launcher $out/bin/${oldAttrs.name}

                  runHook postInstall
                '';
              });

          default = pkgs.stdenvNoCC.mkDerivation rec {
            name = "cdda-tiles-launcher";
            version = "2024-06-26-1623";
            src = pkgs.fetchurl {
              url =
                "https://github.com/CleverRaven/Cataclysm-DDA/releases/download/cdda-experimental-${version}/cdda-linux-tiles-sounds-x64-${version}.tar.gz";
              hash = "sha256-wQFRuJQcfBjRh1WY0/uUUAgIMMMsB/rq3H1UlDixhag=";
            };

            nativeBuildInputs = with pkgs; [ autoPatchelfHook ];

            buildInputs = with pkgs; [ SDL2 SDL2_image SDL2_mixer SDL2_ttf ];

            dontStrip = true;

            installPhase = ''
              runHook preInstall

              mkdir $out
              cp -R data gfx doc $out

              install -m755 -D cataclysm-tiles $out/bin/cataclysm-tiles

              cat << EOF > launcher
              #!${pkgs.runtimeShell}
              $out/bin/cataclysm-tiles --basepath $out --userdir \$HOME/.cdda-experimental-git
              EOF
              install -m755 -D launcher $out/bin/${name}

              runHook postInstall
            '';
          };
        };
      });
}
