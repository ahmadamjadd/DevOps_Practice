# Task 2

This directory contains the Docker Compose based DOMjudge deployment and a helper script:

- `docker-compose.yml`
- `deploy_task2.sh`

The helper script sets `COMPOSE_PROJECT_NAME` to the current directory name so all generated Compose resources use a directory-based prefix.

## System Setup (Linux)

DOMjudge judgehosts rely on cgroup support. On Linux, add the following kernel parameters:

```bash
sudo nano /etc/default/grub
```

Set:

```bash
GRUB_CMDLINE_LINUX_DEFAULT="quiet cgroup_enable=memory swapaccount=1"
```

Apply changes and reboot:

```bash
sudo update-grub
sudo reboot
```

After reboot, verify:

```bash
cat /proc/cmdline
```

Also make sure Docker and Docker Compose are installed and running.

## Operate

Make script executable once:

```bash
cd Task_2
chmod +x deploy_task2.sh
```

## Usage

Run commands from inside `Task_2/`.

Deploy (default if no first argument is given):

```bash
./deploy_task2.sh
./deploy_task2.sh -i
./deploy_task2.sh -i --judgehosts=3
```

Stop currently running services:

```bash
./deploy_task2.sh -sp
```

Start previously stopped services:

```bash
./deploy_task2.sh -st
```

Delete deployment (containers and network):

```bash
./deploy_task2.sh -dt
```

## Change Passwords Manually

From inside `Task_2/`:

```bash
prefix=$(basename "$PWD")
docker exec -it "${prefix}_server" /opt/domjudge/domserver/webapp/bin/console domjudge:reset-user-password admin <new_admin_password>
docker exec -it "${prefix}_server" /opt/domjudge/domserver/webapp/bin/console domjudge:reset-user-password judgehost <new_judgehost_password>
```

## Behavior

- Uses `docker compose up -d --scale judgehost=<N>` for deployment.
- Resets credentials after deploy:
	- Admin: `admin / admin123`
	- Judgehost API user: `judgehost / password`
- Prints a deployment summary using `docker compose ps`.
- Uses a server healthcheck endpoint at `http://localhost/api/v4/config` before judgehost startup.

## Why Task 2

Task 2 was created because the Bash-driven Task 1 deployment was fragile and harder to maintain. The Compose-based approach here:

- Provides a declarative manifest for services and networking.
- Makes scaling judgehosts and inspecting service state trivial (`docker compose up -d --scale`, `docker compose ps`).
- Allows using healthchecks and Compose restart policies to reduce race conditions and improve resilience.

## Deep Dive — What the Compose deployment and `deploy_task2.sh` do

- `deploy_task2.sh` helper script
	- Exports `COMPOSE_PROJECT_NAME` from the current directory name so all Compose-created resources are prefixed consistently.
	- Parses `--judgehosts=N` from the second positional argument (defaults to `1`).
	- Implements the same lifecycle flags as Task 1 (`-i`, `-sp`, `-st`, `-dt`) but uses `docker compose` subcommands.
	- For deployment it runs: `docker compose up -d --scale judgehost=$num_judges`, then uses `docker exec` to reset admin and judgehost passwords on the server container.

- `docker-compose.yml` (service-level details)
	- `db` (MariaDB): uses envvars for credentials and a named volume `db_data` mounted at `/var/lib/mysql`. The image is started with `--max-allowed-packet=64M`.
	- `server` (DOMjudge webapp): uses `domjudge/domserver`, maps host port `80` to the container, and depends on `db`. A `healthcheck` is configured to query `http://localhost/api/v4/config` until the server reports ready. The service is aliased as `domserver` on the `domjudge_net` network.
	- `judgehost`: uses `domjudge/judgehost`, runs `privileged` with `/sys/fs/cgroup` mounted and aims to use the host cgroup namespace. It sets `DOMSERVER_BASEURL` and `JUDGEDAEMON_PASSWORD` to connect back to the server and specifies `depends_on: server: condition: service_healthy` so Compose will wait for the server healthcheck to succeed before starting judgehosts.
	- `networks` and `volumes`: the file declares a bridged `domjudge_net` network and a `db_data` volume for persistent DB storage.

- Why this is better in practice
	- Healthchecks: the server's healthcheck lets Compose know when the webapp is actually ready, avoiding ad-hoc `sleep` timers.
	- Scaling: `docker compose up --scale judgehost=N` is a single atomic command that creates multiple judgehost instances; Compose handles naming and lifecycle.
	- Developer ergonomics: `docker compose ps`, `docker compose logs`, and `docker compose down` are higher-level primitives that simplify operations during development and grading.

- Notes and potential pitfalls
	- The helper script still parses `--judgehosts` from the second argument, so the same usage constraint applies as in Task 1.
	- Scaled judgehosts are created without per-instance `DAEMON_ID` differentiation in the Compose file. If DOMjudge requires unique daemon IDs per judgehost, you may need an entrypoint that derives an ID from the container name or uses an orchestration mechanism to assign IDs.
	- The Compose `depends_on: condition: service_healthy` behavior depends on the Compose implementation/version being used; in modern Compose V2 the `condition` form may be unsupported. The effective behavior in this repository is to rely on the `healthcheck` and Compose's readiness ordering when supported by the local install.

- Operational tip: sanity checks for readiness
	- After `docker compose up -d --scale judgehost=N` run:

```bash
docker compose ps
docker compose logs --follow server
```

	- If the server never reaches the healthy state, inspect `docker compose logs server` and `docker logs <server-container>` for failures.


