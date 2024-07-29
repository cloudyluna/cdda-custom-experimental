{ pkgs, lib }:
let
  innnermostDir = (
    dir:
    let
      dstr = builtins.split "\/" dir;
      isANestedDir = builtins.length dstr > 1;
    in
    if isANestedDir then pkgs.lib.last dstr else ""
  );

  f = (
    subdir:
    let
      x = innnermostDir subdir;
    in
    if x == "" then subdir else x

  );

  installSubdirs = (
    content: target:
    lib.foldl' (
      acc: subdir:

      let
        sanitizedDir = (f subdir);
      in

      acc
      + ''

        # Note:
        # Without copying like this, we'll ended up with read-only
        # permission, subdir content. The patch phase won't be able
        # to overwrite the content, sadly.
        # Not sure why, though.
        install -d 0644 "${target}/${sanitizedDir}"

        cp -R "${content.src}/${subdir}/"* "${target}/${sanitizedDir}"
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
