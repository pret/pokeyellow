"""Low-level Unix socket client for the DOSBox-X MCP debug interface."""

import socket
import os
import threading
from typing import Optional


class DebugSocketClient:
    """
    Connects to the DOSBox-X MCP debug socket and provides synchronous
    command/response communication.

    Protocol: client sends "COMMAND\n", server replies with output lines
    terminated by a bare "END\n" line.
    """

    END_MARKER = b'\nEND\n'

    def __init__(self, sock_path: str, timeout: float = 60.0):
        self._path = sock_path
        self._timeout = timeout
        self._sock: Optional[socket.socket] = None
        self._lock = threading.Lock()

    def connect(self) -> None:
        if self._sock is not None:
            return
        s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        s.settimeout(self._timeout)
        s.connect(self._path)
        self._sock = s

    def disconnect(self) -> None:
        if self._sock:
            try:
                self._sock.close()
            except OSError:
                pass
            self._sock = None

    def is_connected(self) -> bool:
        return self._sock is not None

    def command(self, cmd: str, timeout: Optional[float] = None) -> str:
        """Send a command and return the response text (END marker stripped)."""
        with self._lock:
            if self._sock is None:
                self.connect()
            sock = self._sock
            old_timeout = sock.gettimeout()
            if timeout is not None:
                sock.settimeout(timeout)
            try:
                sock.sendall((cmd.strip() + '\n').encode())
                return self._recv_response(sock)
            except Exception:
                self.disconnect()
                raise
            finally:
                if timeout is not None and self._sock:
                    self._sock.settimeout(old_timeout)

    def _recv_response(self, sock: socket.socket) -> str:
        buf = b''
        while True:
            chunk = sock.recv(4096)
            if not chunk:
                raise ConnectionError("DOSBox-X closed the connection")
            buf += chunk
            if buf.endswith(self.END_MARKER) or b'\nEND\n' in buf:
                break
            # Also accept END\n at the very start (empty output)
            if buf == b'END\n':
                break
        # Strip the END marker and decode
        text = buf.decode(errors='replace')
        if text.endswith('\nEND\n'):
            text = text[:-len('\nEND\n')]
        return text.strip()
