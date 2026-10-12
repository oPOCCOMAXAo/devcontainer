# Dev container

Ubuntu 26.04 image with [OpenCode](https://opencode.ai) v2 and [OpenChamber](https://openchamber.dev).

## Contents

- Ubuntu 26.04 with all updates
- Node.js 24 from NodeSource
- OpenCode v2 (`@opencode/cli`) and OpenChamber (`@openchamber/web`)
- User `ubuntu` (UID 1000), no password, sudo with no password
- OpenChamber serves on port 3000, OpenCode listens on port 4096

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
