# UMUwU
Wrapper script to make standalone [umu-launcher](https://github.com/Open-Wine-Components/umu-launcher) more convenient to use.

Yes, the name is intended to be a meme.

Defaults
- This will attempt to use the highest version number of GE-Proton it finds under `~/.steam/steam/compatibilitytools.d/`
- This `$XDG_DATA_HOME/UMUwU/prefix/default` as a Proton Prefix

## Hopes & Dreams
Eventually, a goal is to make it so that setting a particular prefix for the hash of a specific path or executable file works.

MAYBE storing the intended info like prefix, proton version, GAMEID, etc in extended filesystem attributes would be reasonable?

Extended Filesystems Attributes are easily lost when moving files from one drive to another so that's worth noting.

MAYBE a history system and/or shortcut system to make re-launching previously done things easier?

This all revolves around finding the motivation to actually do it.

## Options

| OPTION                | What it does                                                                             |
| :-------------------- | ---------------------------------------------------------------------------------------: |
| `--appdata`, `-a`     | `xdg-open` the AppData folder for the current Prefix                                     |
| `--prefix=<PATH>`     | Use PATH as `$WINEPREIFX`, or `$XDG_DATA_HOME/UMUwu/prefix/NAME` if PATH contains no `/` |
| `--proton=<PATH>`     | Use PATH as `$PROTONPATH`                                                                |
| `--prefix-here`, `-P` | Use `./umuwu-prefix` as `$WINEPREFIX`                                                    |
| `--script`, `-S`      | Print BASH script for launching without `umuwu`                                          |
| `--simulate`, `-s`    | Display variables and exit. Don't actually launch anything.                              |
| `--`                  | Do not process anymore arguments for `umuwu`                                             |
| `--help`, `-?`        | Display help message                                                                     |
