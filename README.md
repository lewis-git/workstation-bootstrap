## Usage

```bash
cd workstation-bootstrap
./bootstrap.sh
```

Any extra arguments are passed to `ansible-playbook`, e.g. `./bootstrap.sh --check` for a dry run.

## How it works

Each tool is checked by running a command. Tools that already work are left
alone, however they were installed, and anything missing is installed with
MacPorts and verified.

## Adding a tool

Add an entry to `ansible/vars.yml`:

```yaml
  - name: git         # MacPorts port name
    check: [git, --version] # command that proves it works
```

## Why MacPorts?

This was built on macOS 12, which Homebrew no longer supports.