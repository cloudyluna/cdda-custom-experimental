{
  cdda = rec {
    version = "2024-07-24-0510";
    archiveUrl =
      "https://github.com/CleverRaven/Cataclysm-DDA/releases/download"
      + "/cdda-experimental-${version}"
      + "/cdda-linux-tiles-sounds-x64-${version}.tar.gz";
    hash = "sha256-r+tuGdljPKIHZ0mJ1Pb0OQmEZN696XyGdmzpeUGJNRY=";
    description = "CDDA GUI version (tiles) bundled with CC-Sounds soundpack";
  };
}
