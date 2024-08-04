{
  cdda = rec {
    version = "2024-09-06-2220";
    archiveUrl =
      "https://github.com/CleverRaven/Cataclysm-DDA/releases/download"
      + "/cdda-experimental-${version}"
      + "/cdda-linux-tiles-sounds-x64-${version}.tar.gz";
    hash = "sha256-vJnitJlSP3+kL2GSA/5tl+rfUjn4D1Y1m4ofGu6mKZ4=";
    description = "CDDA GUI version (tiles) bundled with CC-Sounds soundpack";
  };
}
