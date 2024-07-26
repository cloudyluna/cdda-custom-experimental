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
        writeLauncherScript = ''
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

        makeInstallPhase = (extraContentsInstaller: ''
          runHook preInstall

          mkdir $out

          ${(extraContentsInstaller)}

          cp -R data gfx doc $out

          install -m755 -D cataclysm-tiles $out/bin/cataclysm-tiles

          ${writeLauncherScript}

          runHook postInstall
        '');
      in rec {
        packages = rec {
          # With extra mods and all the goodies I like.
          extras = pkgs.lib.overrideDerivation default (_:
            let

              /* * Add, edit or remove mods/audiopacks here.
                 # Every mods and audiopacks list attribute must have this
                 # keys for consistency and documentation.
                 # This is subject to change, however.

                 {
                   name = "Name of mod";

                   # Leave as an empty list if you want to copy
                   # the whole parent directory.
                   subdirs = [
                     "sub directory 1"
                     "sub directory 2"
                   ];

                   # The mod package source.
                   # You could use `pkgs.fetchGit` or `builtins.fetchurl` to
                   download (and unpack) tarballs remotely.
                   # See the real usage below.
                   src = ...;
                 }
              */
              cddaExtraContents = {
                mods = [
                  {
                    name = "tankmod-revived";
                    subdirs = [ "Tankmod_Revived" ];
                    src = builtins.fetchGit {
                      url =
                        "https://github.com/chaosvolt/cdda-tankmod-revived-mod";
                      rev = "70278e9576a875c801ff6848e059312ae97a411c";
                      shallow = true;
                    };
                  }

                  {
                    name = "minimods";
                    subdirs = [ "No_rust" ];
                    src = builtins.fetchGit {
                      url = "https://github.com/John-Candlebury/CDDA-Minimods";
                      rev = "67a3f14a096f5780294ec32d3de48c4bb37b05e3";
                      shallow = true;
                    };
                  }

                ];
                soundPacks = [

                  # I would like to include this in my extras package,
                  # but its tarball is 500Mb in size. Nevermind then.
                  /* {
                       name = "Otopack";
                       subdirs = [ "Otopack+ModsUpdates" ];
                       src = pkgs.fetchzip {
                         url = "https://github.com/Kenan2000/Otopack-Mods-Updates/"
                           + "archive/refs/tags/"
                           + "Otopack+ModsUpdates_09.03.2024.tar.gz";
                         hash =
                           "sha256-CzqDyPsFWKb6gJYserVd2X8nfJY2cugQNfC/0opLdvo=";
                       };
                     }
                  */

                ];
              };

              installSubdirs = (content: target:
                pkgs.lib.foldl' (acc: subdir:
                  acc + ''
                    cp -R ${content.src}/${subdir} data/${target}
                  '') "" content.subdirs);

              installContents = (contents: target:
                pkgs.lib.foldl' (acc: content:
                  if content.subdirs == [ ] then
                    acc + ''
                      cp -R ${content.src} data/${target}
                    ''
                  else
                    acc + "${(installSubdirs content target)}") "" contents);

              installExtraContents = ''
                ${installContents cddaExtraContents.mods "mods"}
                ${installContents cddaExtraContents.soundPacks "sound"}
              '';

            in {
              installPhase = (makeInstallPhase installExtraContents);

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
