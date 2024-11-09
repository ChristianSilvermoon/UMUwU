#!/bin/bash

# Initialize XDG Vars
: ${XDG_DATA_DIR:=$HOME/.local/share}
: ${XDG_CONFIG_HOME:=$HOME/.config}
: ${XDG_CACHE_HOME:=$HOME/.cache}
: ${XDG_STATE_HOME:=$HOME/.local/state}

UMUWU_DATA="${XDG_DATA_DIR}/UMUwU"


# -----------
# UMU Example
# -----------
#   export WINEPREFIX=$HOME/Games/epic-games-store
#   export GAMEID=umu-dauntless
#   export STORE=egs 
#   export PROTONPATH="$HOME/.steam/steam/compatibilitytools.d/GE-Proton8-28" 
#   exec umu-run "$HOME/Games/epic-games-store/drive_c/Program Files (x86)/Epic Games/Launcher/Portal/Binaries/Win32/EpicGamesLauncher.exe" -opengl -SkipBuildPatchPrereq
# -----------

: ${WINEPREFIX:=$UMUWU_DATA/prefix/default}
: ${GAMEID:=umuwu-launcher}
: ${STORE:=}

err() { echo "$@" 1>&2; }

help_msg() {
	local e="${0##*/}"
	echo -e "\e[1;32m${e}\e[39m - \e[36mx3 umu is cool~<3, UwU\e[0m"
	echo -e "\n  Easily manage and run software with Proton prefixes using umu-run\n"

	echo -e "\e[1mUSAGE\e[0m"
	echo -e "  $e [OPTIONS] [EXE]\n"

	echo -e "\e[1mOPTIONS\e[0m"
	printf "  %-28s %s\n" \
		"--appdata, -a"     "Open AppData folder for current Prefix" \
		"--prefix=<PATH>"   "Use specific prefix directory"          \
		""                  "  if PATH contains no \"/\", then"      \
		""                  "  under $UMUWU_DATA/prefix/<NAME>"      \
		"--script, -S"      "Print BASH script for launching."       \
		"--simulate, -s"    "Don't actually launch anything"         \
		"--prefix-here, -P" "Set \$WINEPREIFX to \$PWD/umuwu-prefix" \
		"--help, -?"        "Display this message"
}

proton_scan() {
	mapfile -t PROTON_VERSIONS < <( printf "%s\n" "$HOME/.steam/steam/compatibilitytools.d/GE-Proton"* | sort -Vr )
	PROTONPATH="${PROTON_VERSIONS[0]}"
}

arg_proc() {
	local ai a narg ARGS

	for a in "$@"; do
		[ "$narg" ] && EXE+=( "$a" ) && continue

		case "$a" in
			"--help"|"-?") help_msg; exit ;;
			"--appdata"|"-a") exec xdg-open "$WINEPREFIX/drive_c/users/steamuser/AppData" ;;
			"--proton="*)
					PROTONPATH="${a#*=}"
					[ -d "$PROTONPATH" ] && continue
					err -e "ERROR, Proton Path does not exist.\n  $PROTONPATH"
					exit 1
				;;
			"--prefix-here"|"-P") WINEPREFIX="$PWD/umuwu-prefix" ;;
			"--prefix="*)
				WINEPREFIX="${a#*=}"
				[[ ! $WINEPREFIX =~ / ]] && WINEPREFIX="${UMUWU_DATA}/prefix/${WINEPREFIX}"
				;;
			"--script"|"-S")   UMUWU_MODE=script     ;;
			"--simulate"|"-s") UMUWU_MODE=simulate   ;;
			"--")              narg=1; continue ;;
			"-"*)              err "Unknown Arg: $a" 1>&2; exit 1 ;;
			*) EXE+=( "$a" ) ;;
		esac
	done
}

script_gen() {
	local LINES
	LINES=(
		"#!/bin/bash"
		"export WINEPREFIX=$WINEPREFIX"
		"export PROTONPATH=$PROTONPATH"
		"export STORE=$STORE"
		"export GAMEID=$GAMEID"
		"exec umu-run -- $(printf -- "\"%s\" " "${EXE[@]}")"
	)

	printf -- "%s\n" "${LINES[@]}"
}

umuwu_config_print() {
	echo "UMU Config:"
	printf " %-28s : %s\n" \
		'$PROTONPATH'  "$PROTONPATH" \
		'$WINEPREFIX'  "$WINEPREFIX" \
		'$STORE'       "${STORE:-$'\e'[2mN/a$'\e'[0m}" \
		'$GAMEID'      "$GAMEID"
	printf " %-28s : " "EXECUTE"
	printf -- "\"%s\" " "umu-run" "--" "${EXE[@]}"
	echo ""
}

arg_proc "$@"
[ "$PROTONPATH" ] || proton_scan

case "$UMUWU_MODE" in
	"script")
		script_gen
		exit
		;;
	"simulate")
		umuwu_config_print
		echo -e "-----\nSimuated Only. Exiting.\n-----\n"
		exit
		;;
	*)
		# Launch
		umuwu_config_print
		export PROTONPATH WINEPREFIX STORE GAMEID
		exec umu-run -- "${EXE[@]}"
		;;
esac

