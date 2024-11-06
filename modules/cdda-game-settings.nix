{
  cdda = rec {
    version = "2024-11-06-0003";
    archiveUrl =
      "https://github.com/CleverRaven/Cataclysm-DDA/releases/download"
      + "/cdda-experimental-${version}"
      + "/cdda-linux-tiles-sounds-x64-${version}.tar.gz";
    hash = "sha256-Vs6d5Q67hM+4YfWi7HZqk63go2y31w+WHCvOFYKvRTk=";
    description = "CDDA GUI version (tiles) bundled with CC-Sounds soundpack";
  };
}
