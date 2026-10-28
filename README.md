# DevOps workstation bootstrap

A small, human-readable **macOS 12+** workstation bootstrap, including Intel and Apple Silicon.
MacPorts installs packages; Ansible describes the desired state. Future Linux support can be added without changing the basic design.

## Before running

1. Install Apple Command Line Tools if needed: `xcode-select --install`.
2. Install **MacPorts for your macOS release** from https://www.macports.org/install.php.
3. Open a new Terminal. Confirm `port version` works.

Apple Command Line Tools normally include Git. Check with `git --version` before setting up GitHub access.

## Run

From this repository:

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

The bootstrap:
- Confirms macOS 12+ and MacPorts are present.
- Installs Python 3.12 and pip using MacPorts.
- Creates a project-local Python environment (`.venv`).
- Installs Ansible Core 2.21 and the required MacPorts Ansible collection.
- Runs the playbook to install and verify the CLI tools.

## Tools

- Git, jq, wget
- Terraform 1.14, kubectl 1.34, Helm 3.22

Versions refer to MacPorts version tracks rather than frozen patch releases. The playbook uses `port select` to enable each versioned command.

## Repeat runs

Run `./bootstrap.sh` again; installed MacPorts packages are not reinstalled, and Ansible checks whether a version is already selected. The script may check/update packages in its local virtual environment.

## Not included yet

Docker/container runtime, kind, AWS CLI, AWS authentication, cluster creation, Windows/Linux provisioning. These are deliberately left for follow-up increments.

## Notes

- MacPorts installation is deliberately a one-time manual prerequisite.
- This has been syntax-checked but **not executed on a macOS host**; Monterey compatibility and dependency availability need real-world testing.
- MacPorts may build packages from source, especially on older macOS versions.
- Some tools may require Apple Command Line Tools or additional build dependencies; MacPorts handles package dependencies.
