{
  cdda = rec {
    version = "2024-10-05-0405";
    archiveUrl =
      "https://github.com/CleverRaven/Cataclysm-DDA/releases/download"
      + "/cdda-experimental-${version}"
      + "/cdda-linux-tiles-sounds-x64-${version}.tar.gz";
    hash = "sha256-fmZNk0WZX3Qy+6k6Fz2BS0WHWBY5pz4/ajbC9wkBTCA=";
    description = "CDDA GUI version (tiles) bundled with CC-Sounds soundpack";
  };
}
