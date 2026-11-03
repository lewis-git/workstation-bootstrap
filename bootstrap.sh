#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV="$ROOT/.venv"
PYTHON=/opt/local/bin/python3.12

# MacPorts lives in /opt/local, which a fresh shell won't have on PATH
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

die() { echo "Error: $*" >&2; exit 1; }

[[ "$(uname -s)" == Darwin ]] || die "Only macOS is supported for now."

MACOS_MAJOR="$(sw_vers -productVersion | cut -d. -f1)"
(( MACOS_MAJOR >= 12 )) || die "Requires macOS 12 or newer."

# MacPorts depends on the Command Line Tools, so check those first
xcode-select -p >/dev/null 2>&1 || die "Run: xcode-select --install"
[[ -x /opt/local/bin/port ]] || die "Install MacPorts: https://www.macports.org/install.php"

if [[ ! -x "$PYTHON" ]]; then
  echo "Installing Python 3.12..."
  sudo port install python312
fi

# Keep Ansible in a local venv so it never touches system Python
[[ -x "$VENV/bin/python" ]] || "$PYTHON" -m venv "$VENV"

echo "Installing Ansible..."
"$VENV/bin/pip" install --quiet --disable-pip-version-check 'ansible-core>=2.21,<2.22'

"$VENV/bin/ansible-playbook" \
  -i localhost, \
  "$ROOT/ansible/playbook.yml" \
  --ask-become-pass \
  "$@"

echo "Bootstrap complete."