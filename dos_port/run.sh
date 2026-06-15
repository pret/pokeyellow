#!/usr/bin/env bash
# Launch PKMN.EXE in DOSBox-X.
# dos_port/ is mounted as C: drive.
set -e
DOSPORT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec dosbox-x -defaultdir "$DOSPORT" -c "mount c \"$DOSPORT\"" -c "c:" -c "PKMN.EXE"
