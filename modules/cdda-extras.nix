{ pkgs, lib }:
{
  /*
     # Add, edit or remove mods/sound packs here.
     # Every mods and sound packs list attribute must have this
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
       # You could use `builtins.fetchGit` or `lib.fetchurl` to
       download (and unpack) tarballs remotely.
       # See the real usage below.
       src = ...;
     }
  */
  mods = [
    {
      name = "tankmod-revived";
      subdirs = [ "Tankmod_Revived" ];
      src = fetchGit {
        url = "https://github.com/chaosvolt/cdda-tankmod-revived-mod";
        rev = "70278e9576a875c801ff6848e059312ae97a411c";
        shallow = true;
      };
    }

    {
      name = "minimods";
      subdirs = [
        "No_rust - Steam 0.G"
        "No_portal_storms - Steam 0.G"
      ];
      src = fetchGit {
        url = "https://github.com/John-Candlebury/CDDA-Minimods";
        rev = "2b8fbb3ffe1ecded1b0716d6d6601977752457d5";
      };
    }

    {
      name = "jackledead_armory";
      subdirs = [
        "mods/jackledead_armory"
        "mods/jackledead_armory_expansion"
      ];
      src = fetchGit {
        url = "https://github.com/jackledead/jackledead_armory";
        rev = "ddb48de223839f7b61390d4e58fa506878624a30";
        shallow = true;
      };
    }
  ];

  soundPacks = [ ];

  # also known as gfx(s)
  tileSets = [
    {
      name = "UndeadPeople";
      subdirs = [
        "MshockXotto+REAL"
        "MSX++UnDeadPeopleEdition"
      ];
      src = pkgs.fetchzip {
        url =
          "https://github.com/Theawesomeboophis/UndeadPeopleTileset/"
          + "releases/download/7%2F2%2F24/Vanilla.zip";
        hash = "sha256-e8FIcqF2JE5fxXSL7FNZLFretm0vN5AE6cFuQBFAn44=";
      };
    }
  ];
}
