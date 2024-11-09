{
  cdda = rec {
    version = "2024-11-08-2048";
    archiveUrl =
      "https://github.com/CleverRaven/Cataclysm-DDA/releases/download"
      + "/cdda-experimental-${version}"
      + "/cdda-linux-tiles-sounds-x64-${version}.tar.gz";
    hash = "sha256-UOa6/aAJJ5BDmFs9buMXUWGw21hLMzZnA3oc/PgoioY=";
    description = "CDDA GUI version (tiles) bundled with CC-Sounds soundpack";
  };
}
