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
        modules = import ./modules/default.nix { inherit pkgs; };

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
              cddaExtraContents = modules.extraContents;

              installSubdirs = (content: target:
                pkgs.lib.foldl' (acc: subdir:
                  acc + ''
                    cp -R '${content.src}/${subdir}' data/${target}
                  '') "" content.subdirs);

              installContents = (contents: target:
                pkgs.lib.foldl' (acc: content:
                  if content.subdirs == [ ] then
                    acc + ''
                      cp -R '${content.src}' data/${target}
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

          default = let gameSettings = modules.cddaGameSettings;
          in pkgs.stdenvNoCC.mkDerivation {
            name = "cdda-tiles-launcher";
            version = gameSettings.cdda.version;
            src = pkgs.fetchurl {
              url = gameSettings.cdda.archiveUrl;
              hash = gameSettings.cdda.hash;
            };

            nativeBuildInputs = with pkgs; [ autoPatchelfHook ];

            buildInputs = with pkgs; [ SDL2 SDL2_image SDL2_mixer SDL2_ttf ];

            dontStrip = true;

            installPhase = (makeInstallPhase "");
          };
        };
      });
}
