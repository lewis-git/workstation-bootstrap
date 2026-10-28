#!/usr/bin/env bash
set -euo pipefail

# Resolve repository directory
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

# Check operating system
if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This bootstrap currently supports macOS only." >&2
  exit 1
fi

MACOS_MAJOR="$(sw_vers -productVersion | cut -d. -f1)"

if (( MACOS_MAJOR < 12 )); then
  echo "Requires macOS 12 or newer." >&2
  exit 1
fi

# Check MacPorts
if [[ ! -x /opt/local/bin/port ]]; then
  echo "MacPorts is required."
  echo "Install it from https://www.macports.org/install.php"
  exit 1
fi

# Check Apple Command Line Tools
if ! xcode-select -p >/dev/null 2>&1; then
  echo "Apple Command Line Tools are required."
  echo "Run: xcode-select --install"
  exit 1
fi

# Install Python
echo "Installing Python 3.12..."
sudo /opt/local/bin/port install python312 py312-pip

PYTHON="/opt/local/bin/python3.12"
VENV="$ROOT/.venv"

# Create isolated Python environment
if [[ ! -x "$VENV/bin/python" ]]; then
  echo "Creating Python virtual environment..."
  "$PYTHON" -m venv "$VENV"
fi

# Install Ansible and trusted CA certificates
echo "Installing Ansible and certifi..."
"$VENV/bin/python" -m pip install \
  --disable-pip-version-check \
  'ansible-core>=2.21,<2.22' \
  certifi

# Configure SSL certificate verification
export SSL_CERT_FILE="$("$VENV/bin/python" -m certifi)"

# Install Ansible collections
echo "Installing Ansible collections..."
"$VENV/bin/ansible-galaxy" collection install \
  -r "$ROOT/ansible/requirements.yml"

# Run local workstation configuration
echo "Running Ansible playbook..."
export ANSIBLE_CONFIG="$ROOT/ansible/ansible.cfg"

"$VENV/bin/ansible-playbook" \
  -i 'localhost,' \
  "$ROOT/ansible/playbook.yml" \
  --ask-become-pass \
  "$@"

echo "Bootstrap completed successfully."