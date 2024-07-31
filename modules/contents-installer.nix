{ pkgs, lib }:
let
  makeSanitizedDirPath = (
    originalDir:
    let
      splittedDirPaths = builtins.split "\/" originalDir;
      isANestedDir = builtins.length splittedDirPaths > 1;
      deepestDir = pkgs.lib.last splittedDirPaths;
      
    in
    if isANestedDir then deepestDir else originalDir
  );

  installSubdirs = (
    content: target:
    lib.foldl' (
      acc: subdir:

      let
        sanitizedSubdir = (makeSanitizedDirPath subdir);
      in

      acc
      + ''

        # Note:
        # Without copying like this, we'll ended up with read-only
        # permission, subdir content. The patch phase won't be able
        # to overwrite the content, sadly.
        # Not sure why, though.
        install -d 0644 "${target}/${sanitizedSubdir}"

        echo "${content.name}: Installing into "${target}/${sanitizedSubdir}" ...."

        cp -R "${content.src}/${subdir}/"* "${target}/${sanitizedSubdir}"
        
        echo "${content.name}: Done."
      ''
    ) "" content.subdirs
  );

  installContents = (
    contents: target:
    lib.foldl' (
      acc: content:
      acc
      + (
        if content.subdirs == [ ] then
          ''
            cp -R "${content.src}" ${target}
          ''
        else
          "${(installSubdirs content target)}"
      )
    ) "" contents
  );

  installExtraContents = (
    contents: root: ''

      ${installContents contents.mods "${root}/data/mods"}
      ${installContents contents.soundPacks "${root}/data/sound"}
      ${installContents contents.tileSets "${root}/gfx"}
    ''
  );
in
{
  installExtraContents = installExtraContents;
}
