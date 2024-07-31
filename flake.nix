{
  description = ''
    cdda-custom-experimental: A nix flake to install pre-built experimental CDDA
    executables directly from CDDA's Github repository releases.
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    let
      supportedSystems = [ "x86_64-linux" ];
    in
    flake-utils.lib.eachSystem supportedSystems (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        lib = pkgs.lib;
        modules = import ./modules/default.nix { inherit pkgs lib; };
      in
      rec {
        packages = rec {

          extras-expanded = extras.overrideAttrs (
            let
              extraContents = modules.cddaExtraExpandedContents;
            in
            {
              prePatch = (modules.contentsInstaller.installExtraContents extraContents ".");
            }
          );

          # With extra mods and all the goodies I like.
          extras = default.overrideAttrs (
            let

              extraContents = modules.cddaExtraContents;
            in
            {
              prePatch = (modules.contentsInstaller.installExtraContents extraContents ".");
              patchFlags = [
                "-p1"
                "-d"
                "data/mods"
              ];
              patches = [ ./patches/minimods/minimods.patch ];
            }
          );

          development = default.overrideAttrs (previousAttrs: rec {
            name = "json_formatter.cgi";
            nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [ pkgs.stdenv.cc.cc ];
            buildInputs = [ ];
            installPhase = ''
              runHook preInstall

              mkdir $out

              install -m755 -D ${name} $out/bin/${name}

              runHook postInstall
            '';
          });

          default =
            let
              gameSettings = modules.cddaGameSettings;
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

              makeInstallPhase = ''
                runHook preInstall

                mkdir -p $out
                cp -R data gfx doc $out

                install -m755 -D cataclysm-tiles $out/bin/cataclysm-tiles

                ${writeLauncherScript}

                runHook postInstall
              '';
            in
            pkgs.stdenvNoCC.mkDerivation {
              name = "cdda-tiles-launcher";
              version = gameSettings.cdda.version;
              src = pkgs.fetchurl {
                url = gameSettings.cdda.archiveUrl;
                hash = gameSettings.cdda.hash;
              };

              nativeBuildInputs = with pkgs; [ autoPatchelfHook ];

              buildInputs = with pkgs; [
                SDL2
                SDL2_image
                SDL2_mixer
                SDL2_ttf
              ];

              dontConfigure = true;
              dontBuild = true;
              dontStrip = true;

              installPhase = makeInstallPhase;
            };
        };

        devShells.default = modules.devshell;
      }
    );
}
