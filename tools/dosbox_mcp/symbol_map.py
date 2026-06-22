"""Parse pkmn.map (GNU ld format) and gb_memmap.inc to resolve names to addresses."""

import re
import os
from typing import Optional

_MAP_LINE = re.compile(r'^\s+(0x[0-9a-fA-F]+)\s+(\w+)\s*$')
# Matches both $XXXX and 0xXXXX hex literals (gb_memmap.inc uses 0x prefix)
_HEX_VAL  = r'(?:0x|0X|\$)([0-9a-fA-F]+)'
_INC_EQU  = re.compile(r'^\s*(\w+)\s+EQU\s+' + _HEX_VAL, re.IGNORECASE)
_INC_DEF  = re.compile(r'^\s*%define\s+(\w+)\s+' + _HEX_VAL, re.IGNORECASE)


class SymbolMap:
    def __init__(self, map_file: str, memmap_inc: Optional[str] = None):
        self._syms: dict[str, int] = {}
        self._gb: dict[str, int] = {}
        if os.path.exists(map_file):
            self._load_map(map_file)
        if memmap_inc and os.path.exists(memmap_inc):
            self._load_memmap(memmap_inc)

    def _load_map(self, path: str) -> None:
        with open(path) as f:
            for line in f:
                m = _MAP_LINE.match(line)
                if m:
                    addr = int(m.group(1), 16)
                    name = m.group(2)
                    self._syms[name] = addr

    def _load_memmap(self, path: str) -> None:
        with open(path) as f:
            for line in f:
                for pat in (_INC_EQU, _INC_DEF):
                    m = pat.match(line)
                    if m:
                        self._gb[m.group(1)] = int(m.group(2), 16)
                        break

    def resolve(self, name_or_addr: str) -> Optional[int]:
        """Return linear (ELF VMA) address for a symbol name, or parse hex literal."""
        if name_or_addr.startswith('0x') or name_or_addr.startswith('0X'):
            return int(name_or_addr, 16)
        if name_or_addr in self._syms:
            return self._syms[name_or_addr]
        # Try pure hex (no 0x prefix)
        try:
            return int(name_or_addr, 16)
        except ValueError:
            return None

    def gb_offset(self, name: str) -> Optional[int]:
        """Return GB memory offset for a wRAM/HRAM constant name."""
        return self._gb.get(name)

    def all_symbols(self) -> dict[str, int]:
        return dict(self._syms)

    def search(self, pattern: str) -> list[tuple[str, int]]:
        pat = re.compile(pattern, re.IGNORECASE)
        return [(n, a) for n, a in self._syms.items() if pat.search(n)]
