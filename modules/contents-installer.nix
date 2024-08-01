{ pkgs, lib }:
let
  makeSanitizedDirPath = (
    originalDir:
    let
      splittedDirPaths = builtins.split "\/" originalDir;
      isANestedDir = builtins.length splittedDirPaths > 1;
      deepestDir = lib.last splittedDirPaths;
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

        echo "${content.name}:[${sanitizedSubdir}]: Installing to "${target}/${sanitizedSubdir}" ...."

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
            echo "Copying whole parent directory"
            echo "${content.name}: Installing to ${target}/${content.name}"

            install -d 0644 "${target}/${content.name}"
            cp -R "${content.src}/"* "${target}/${content.name}"

            echo "${content.name}: Done."
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
