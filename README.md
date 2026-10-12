# Dev container

Prebuilt Ubuntu 26.04 image for agentic development. Ships [OpenCode](https://opencode.ai) v2 and [OpenChamber](https://openchamber.dev) on a full toolchain, so agents can build and test out of the box.

## Contents

- Ubuntu 26.04 with all updates
- Node.js 24 from NodeSource
- Python 3 (full, with pip and venv)
- OpenCode v2 (`@opencode/cli`) and OpenChamber (`@openchamber/web`)
- User `ubuntu` (UID 1000), no password, sudo with no password
- Locale `C.UTF-8`
- OpenChamber serves on port 3000, OpenCode listens on port 4096

## Development tools

- Build: `build-essential` (gcc, g++, make), `patch`
- VCS: `git`, OpenSSH client
- Search: `ripgrep`, `fd-find`
- Data: `jq`, MariaDB client
- Files: `unzip`, `zip`, `xz-utils`, `less`, `tmux`
- System: `procps`, `bash-completion`, `man-db`

## Build and push

```
make release        # build latest, push latest, push latest git tag
make build-latest
make push-tag       # HEAD must sit exactly on a git tag
```

## Run

```
docker compose up -d --build
```

Then open `http://localhost:3000`.

## Volumes

Named volumes keep data after you remove the container.

| Volume | Path in container |
| --- | --- |
| `workspace` | `/workspace` |
| `opencode-config` | `/home/ubuntu/.config/opencode` |

## Security

The UI has no password. `--lan` and `OPENCHAMBER_ALLOW_UNAUTHENTICATED_LAN=true` open the port on all host interfaces. Keep the port private, or start with `--ui-password`.
