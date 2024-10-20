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
      name = "Tankmod-Revived";
      subdirs = [ "Tankmod_Revived" ];
      src = fetchGit {
        url = "https://github.com/chaosvolt/cdda-tankmod-revived-mod";
        rev = "70278e9576a875c801ff6848e059312ae97a411c";
        shallow = true;
      };
    }

    {
      name = "Minimods";
      subdirs = [
        "No_rust"
        "No_portal_storms - Steam 0.G"
      ];
      src = fetchGit {
        url = "https://github.com/John-Candlebury/CDDA-Minimods";
        rev = "b039afd3007b083d191f4bf63d35f9b28896d8e4";
        shallow = true;
      };
    }

    {
      name = "Jackledead-Armory";
      subdirs = [
        "mods/jackledead_armory"

        # Note, the current pinned CDDA game + and this mod version
        # will cause an error in the world loading screen.
        # Hence, why this mod is not included by default.
        # Remove '#' below to include the world core content expansion.
        # "mods/jackledead_armory_expansion"
      ];
      src = fetchGit {
        url = "https://github.com/jackledead/jackledead_armory";
        rev = "ddb48de223839f7b61390d4e58fa506878624a30";
        shallow = true;
      };
    }

    {
      name = "Arcana";
      subdirs = [ "Arcana" ];
      src = fetchGit {
        url = "https://github.com/chaosvolt/cdda-arcana-mod";
        rev = "76b2dc9257441734baffb0c0e17d50d7a0e58073";
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
          + "releases/download/8%2F16%2F24/Vanilla.zip";
        hash = "sha256-QOXepCWNj4sNWDRPxiWpzdwDEHITkk6WW0vfWvoDOFM=";
      };
    }
  ];
}
