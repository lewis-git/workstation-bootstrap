# DevOps Workstation Bootstrap

A simple Bash and Ansible setup for installing common DevOps and Platform Engineering tools on macOS.

Uses MacPorts for package management and Ansible to install and configure the tooling. Currently supports macOS 12+ (Intel and Apple Silicon).

## Prerequisites

- Apple Command Line Tools (`xcode-select --install`)
- [MacPorts](https://www.macports.org/install.php)

## Usage

Clone the repo and run:

```bash
./bootstrap.sh
```

The script sets up Python and Ansible in a local virtual environment, installs the required Ansible collections, and runs the playbook.

## Tools

- Git
- Terraform
- kubectl
- Helm
- jq
- wget

## Notes

- Safe to rerun; Ansible handles already-installed packages.
- Tool installation and verification are managed under `ansible/`.
- Currently macOS only, with support for other operating systems planned.