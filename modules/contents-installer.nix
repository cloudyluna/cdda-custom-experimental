{ pkgs, lib }:
let
  getDeepestDirFrom = (
    dir:
    let
      splittedDirPaths = builtins.split "\/" dir;
      isANestedDir = builtins.length splittedDirPaths > 1;
    in
    if isANestedDir then pkgs.lib.last splittedDirPaths else ""
  );

  makeSanitizedDirPath = (
    subdir:
    let
      deepestDir = getDeepestDirFrom subdir;
    in
    if deepestDir == "" then subdir else deepestDir

  );

  installSubdirs = (
    content: target:
    lib.foldl' (
      acc: subdir:

      let
        sanitizedDir = (makeSanitizedDirPath subdir);
      in

      acc
      + ''

        # Note:
        # Without copying like this, we'll ended up with read-only
        # permission, subdir content. The patch phase won't be able
        # to overwrite the content, sadly.
        # Not sure why, though.
        install -d 0644 "${target}/${sanitizedDir}"

        echo "${content.name}: Installing into "${target}/${sanitizedDir}" ...."
        cp -R "${content.src}/${subdir}/"* "${target}/${sanitizedDir}"
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
