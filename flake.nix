{
  description = ''
    cdda-custom-experimental: A nix flake to install pre-built experimental CDDA
    executables directly from CDDA's Github repository releases.
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let supportedSystems = [ "x86_64-linux" ];
    in flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
        writeLauncher = ''
          cat << EOF > launcher

          #!${pkgs.runtimeShell}

          if [[ -z "\$1" ]]; then
              userdir="\$HOME/.cdda-custom-experimental"
          else
              userdir="\$1"
          fi

          $out/bin/cataclysm-tiles --basepath $out --userdir "\$userdir"

          EOF

          install -m755 -D launcher $out/bin/cdda-tiles-launcher
        '';

        makeInstallPhase = modsCopier: ''
          runHook preInstall

          mkdir $out

          ${(modsCopier)}

          cp -R data gfx doc $out

          install -m755 -D cataclysm-tiles $out/bin/cataclysm-tiles

          ${writeLauncher}

          runHook postInstall
        '';
      in rec {
        packages = rec {
          # With extra mods and all the goodies I like.
          extras = pkgs.lib.overrideDerivation default (_:
            let
              mods = {
                tank = builtins.fetchGit {
                  url = "https://github.com/chaosvolt/cdda-tankmod-revived-mod";
                  rev = "70278e9576a875c801ff6848e059312ae97a411c";
                };

                minimods = builtins.fetchGit {
                  url = "https://github.com/John-Candlebury/CDDA-Minimods";
                  rev = "67a3f14a096f5780294ec32d3de48c4bb37b05e3";
                };
              };

              copyMods = pkgs.lib.foldl' (acc: mod:
                acc + ''
                  cp -R ${mod} data/mods/ 
                '') "";
            in {
              installPhase = (makeInstallPhase (copyMods [
                "${mods.tank}/Tankmod_Revived"
                "${mods.minimods}/No_rust"
              ]));

            });

          json-formatter = pkgs.lib.overrideDerivation default (origin: rec {
            name = "cdda-json-formatter";
            nativeBuildInputs = origin.nativeBuildInputs
              ++ [ pkgs.stdenv.cc.cc ];
            buildInputs = [ ];
            installPhase = ''
              runHook preInstall

              mkdir $out

              install -m755 -D json_formatter.cgi $out/bin/${name}

              runHook postInstall
            '';
          });

          default = pkgs.stdenvNoCC.mkDerivation rec {
            name = "cdda-tiles-launcher";
            version = "2024-07-24-0510";
            src = pkgs.fetchurl {
              url =
                "https://github.com/CleverRaven/Cataclysm-DDA/releases/download"
                + "/cdda-experimental-${version}"
                + "/cdda-linux-tiles-sounds-x64-${version}.tar.gz";
              hash = "sha256-r+tuGdljPKIHZ0mJ1Pb0OQmEZN696XyGdmzpeUGJNRY=";
            };

            nativeBuildInputs = with pkgs; [ autoPatchelfHook ];

            buildInputs = with pkgs; [ SDL2 SDL2_image SDL2_mixer SDL2_ttf ];

            dontStrip = true;

            installPhase = (makeInstallPhase "");
          };
        };
      });
}
