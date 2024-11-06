{
  cdda = rec {
    version = "2024-11-03-0625";
    archiveUrl =
      "https://github.com/CleverRaven/Cataclysm-DDA/releases/download"
      + "/cdda-experimental-${version}"
      + "/cdda-linux-tiles-sounds-x64-${version}.tar.gz";
    hash = "sha256-dorsAaqBcOtN5UO43zkqf3Uo2Di2KISAG1DJdsV6aag=";
    description = "CDDA GUI version (tiles) bundled with CC-Sounds soundpack";
  };
}
