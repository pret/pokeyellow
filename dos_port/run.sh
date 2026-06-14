#!/usr/bin/env bash
# Launch pokeyellow_dos.exe in DOSBox-X.
# dos_port/ is used as the default working directory (DOSBox-X's C: drive).
set -e
DOSPORT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec dosbox-x -defaultdir "$DOSPORT" -c "PKMN.EXE"
