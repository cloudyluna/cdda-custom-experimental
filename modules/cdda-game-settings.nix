{
  cdda = rec {
    version = "2024-08-01-0705";
    archiveUrl =
      "https://github.com/CleverRaven/Cataclysm-DDA/releases/download"
      + "/cdda-experimental-${version}"
      + "/cdda-linux-tiles-sounds-x64-${version}.tar.gz";
    hash = "sha256-esc6+8Flcm+peTToJWFhQlDw9NBAySrzXlsvb9et0eU=";
    description = "CDDA GUI version (tiles) bundled with CC-Sounds soundpack";
  };
}
