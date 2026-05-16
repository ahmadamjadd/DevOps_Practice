# DOMjudge Deployment — Assignment 3

This repository demonstrates two approaches for deploying DOMjudge in containers:

- `task1/` — a Bash script that drives `docker` commands directly.
- `task2/` — a Docker Compose based deployment with a small helper script.

This README explains what was done, why the first approach proved inefficient, and why the `task2` Compose-based approach was implemented.

**What I did**

- Implemented a working deployment in `task1/` using `domjudge-deployment.sh` which:
  - Creates a prefixed network and named DB volume.
  - Starts MariaDB, DOMserver, then N judgehost containers.
  - Resets credentials using `docker exec`.
- Implemented an improved deployment in `task2/` using `docker-compose.yml` and `deploy_task2.sh` which:
  - Sets `COMPOSE_PROJECT_NAME` to derive prefixed resource names.
  - Declares services, volumes and networks in Compose.
  - Uses a server healthcheck and `docker compose up -d --scale judgehost=<N>` for scaling.

**Why Task 1 was inefficient**

1. Procedural, not declarative: the Bash script runs many individual `docker` commands in sequence. This makes the flow fragile to partial failures and timing issues (e.g. a judgehost started before the server is ready).
2. No proper health checks: the script relied on ordering and optional waits rather than an automated service-level healthcheck, which required manual timing workarounds.
3. Manual scaling and orchestration: adding or removing judgehosts required explicit looped container creation rather than a single `compose` scale flag.
4. Harder to read and maintain: long shell logic, ad-hoc parsing and string manipulation increases cognitive load and the chance of bugs.
5. Less friendly developer ergonomics: `docker`-level commands require more manual bookkeeping; tooling like `docker compose ps` and `docker compose logs` are nicer for day-to-day operations.

**What Task 2 improves**

- Declarative service definition: `docker-compose.yml` describes services, networks, and volumes in one place, making the deployment easier to understand and change.
- Built-in scaling: `docker compose up -d --scale judgehost=<N>` provides a single-step scaling mechanism.
- Healthchecks and ordering: Compose can wait for service readiness (explicitly via healthchecks or via simple scripting around `compose` outputs), reducing race conditions.
- Improved observability: `docker compose ps`, `docker compose logs`, and Compose-compatible tooling simplify debugging.
- Cleaner helper script: `deploy_task2.sh` only sets `COMPOSE_PROJECT_NAME` and forwards commands, keeping logic out of the script and in the Compose file.

**Usage notes and system requirements**

- Both approaches require Docker installed and running. `task2` also requires a Compose-capable Docker (Docker Compose v2 is recommended).
- On Linux, DOMjudge judgehosts require cgroup memory/swap accounting. Add the following to GRUB and reboot:

```bash
sudo nano /etc/default/grub
# set: GRUB_CMDLINE_LINUX_DEFAULT="quiet cgroup_enable=memory swapaccount=1"
sudo update-grub
sudo reboot
```

- Default credentials set by the deployments (reset after first deploy):
  - Admin: `admin / admin123`
  - Judgehost API user: `judgehost / password`

**Files of interest**

- [task1/README.md](task1/README.md) — original Bash-based deployment instructions and usage.
- [task2/README.md](task2/README.md) — Compose-based deployment instructions and usage.

If you want, I can:

- Run a quick smoke test (bring up the compose deployment and check health).
- Add release-style scripts or a Makefile to unify commands across the two approaches.
