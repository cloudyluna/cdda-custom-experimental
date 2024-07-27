{ pkgs }: {
  /* * Add, edit or remove mods/audiopacks here.
               # Every mods and audiopacks list attribute must have this
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
                 # You could use  `fetchGit`` or `fetchurl` to
                 download (and unpack) tarballs remotely.
                 # See the real usage below.
                 src = ...;
               }
  */
  mods = [
    {
      name = "tankmod-revived";
      subdirs = [ "Tankmod_Revived" ];
      src = builtins.fetchGit {
        url = "https://github.com/chaosvolt/cdda-tankmod-revived-mod";
        rev = "70278e9576a875c801ff6848e059312ae97a411c";
        shallow = true;
      };
    }

    {
      name = "minimods";
      subdirs = [ "No_rust" ];
      src = builtins.fetchGit {
        url = "https://github.com/John-Candlebury/CDDA-Minimods";
        rev = "67a3f14a096f5780294ec32d3de48c4bb37b05e3";
        shallow = true;
      };
    }

  ];
  soundPacks = [

    # I would like to include this in my extras package,
    # but its tarball is 500Mb in size. Nevermind then.
    /* {
         name = "Otopack";
         subdirs = [ "Otopack+ModsUpdates" ];
         src = pkgs.fetchzip {
           url = "https://github.com/Kenan2000/Otopack-Mods-Updates/"
             + "archive/refs/tags/"
             + "Otopack+ModsUpdates_09.03.2024.tar.gz";
           hash =
             "sha256-CzqDyPsFWKb6gJYserVd2X8nfJY2cugQNfC/0opLdvo=";
         };
       }
    */

  ];
}
