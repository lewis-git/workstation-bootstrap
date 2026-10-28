#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

if [[ "$(uname -s)" != Darwin ]]; then
  echo "This first version supports macOS only." >&2
  exit 1
fi

MACOS_MAJOR="$(sw_vers -productVersion | cut -d. -f1)"
if (( MACOS_MAJOR < 12 )); then
  echo "Requires macOS 12 or newer." >&2
  exit 1
fi

if [[ ! -x /opt/local/bin/port ]]; then
  cat >&2 <<'MSG'
MacPorts is required and not installed.
Download the installer matching your macOS version from:
  https://www.macports.org/install.php
Install it, open a fresh terminal, then rerun ./bootstrap.sh.
MSG
  exit 1
fi

if ! xcode-select -p >/dev/null 2>&1; then
  echo "Apple Command Line Tools are required. Run: xcode-select --install" >&2
  exit 1
fi

echo "Installing the Python 3.12 runtime needed by Ansible..."
sudo /opt/local/bin/port install python312 py312-pip

PYTHON="/opt/local/bin/python3.12"
VENV="$ROOT/.venv"
if [[ ! -x "$VENV/bin/python" ]]; then
  "$PYTHON" -m venv "$VENV"
fi

"$VENV/bin/python" -m pip install --disable-pip-version-check 'ansible-core>=2.21,<2.22'
"$VENV/bin/ansible-galaxy" collection install -r "$ROOT/ansible/requirements.yml"

export ANSIBLE_CONFIG="$ROOT/ansible/ansible.cfg"
"$VENV/bin/ansible-playbook" -i 'localhost,' "$ROOT/ansible/playbook.yml" --ask-become-pass "$@"
