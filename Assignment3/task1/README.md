# Task 1

This directory contains the Bash-based DOMjudge deployment script:

- `domjudge-deployment.sh`

The script prefixes all generated Docker resources with the current directory name.

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

Also make sure Docker is installed and running.

## Operate

Make script executable once:

```bash
cd Task_1
chmod +x domjudge-deployment.sh
```

## Usage

Run commands from inside `Task_1/`.

Deploy (default if no first argument is given):

```bash
./domjudge-deployment.sh
./domjudge-deployment.sh -i
./domjudge-deployment.sh -i --judgehosts=3
```

Stop running services:

```bash
./domjudge-deployment.sh -sp
```

Start previously stopped services:

```bash
./domjudge-deployment.sh -st
```

Delete containers and network while preserving the database volume:

```bash
./domjudge-deployment.sh -dt
```

## Change Passwords Manually

From inside `Task_1/`:

```bash
prefix=$(basename "$PWD")
docker exec "${prefix}_server" /opt/domjudge/domserver/webapp/bin/console domjudge:reset-user-password admin <new_admin_password>
docker exec "${prefix}_server" /opt/domjudge/domserver/webapp/bin/console domjudge:reset-user-password judgehost <new_judgehost_password>
```

## Behavior

- Uses current folder name as prefix for containers, network, and volume.
- Supports optional `--judgehosts=<N>` (default: `1`).
- Deploy flow:
	- creates prefixed network and DB volume,
	- starts MariaDB,
	- starts DOMserver,
	- resets credentials,
	- starts `N` judgehost containers.
- Credentials set during deployment:
	- Admin: `admin / admin123`
	- Judgehost API user: `judgehost / password`
- Prints a deployment summary with:
	- `docker ps` filtered by prefix,
	- matching network list,
	- matching volume list,
	- manual login step.

## Deep Dive — What the `domjudge-deployment.sh` script actually does

This section explains the script flow, important implementation choices, and failure modes.

- Prefixing and variable parsing
	- `curr_dir` is derived from `pwd` and used as a namespace prefix for container names, network, and volume (e.g. `<curr_dir>_server`).
	- `--judgehosts=N` is parsed by examining the script's second argument and extracting the number after `=`; if missing or invalid, it defaults to `1`.

- Command modes
	- `-sp` (stop): calls `docker stop` on the prefixed DB and server containers, then stops any containers whose name matches the judgehost prefix. Errors are redirected to `/dev/null` so the script is tolerant to missing containers.
	- `-st` (start): starts the DB and server containers, then sleeps for 20s before starting judgehost containers found by name. The fixed `sleep` is a simple way to avoid races but is brittle.
	- `-dt` (delete): forcibly removes DB, server and judgehost containers and deletes the prefixed network; named volumes are preserved so the database data remains.
	- `-i` (install / deploy — default): performs a fresh deployment flow described next.

- Deploy flow (what happens during `-i`)
	1. Cleans up any existing containers with the same prefixed names (`docker rm -f ...`).
	2. Creates a bridge network `${curr_dir}_domjudge_net` and a named volume `${curr_dir}_db_data`.
	3. Starts a MariaDB container using `docker run -dit` with env vars for user, password and database, and mounts the named volume at `/var/lib/mysql`.
	4. Waits a fixed 20 seconds to allow MariaDB to initialize. (A more robust approach would poll `mysqladmin ping`.)
	5. Starts the DOMjudge server container (publishes port 80) and passes the DB connection env vars. The server is named `${curr_dir}_server` and given the network alias `domserver`.
	6. Waits a fixed 90 seconds for the server to initialize. This long sleep is intended to let the webapp bootstrap and run DB migrations; it is a coarse solution and can cause unnecessarily long deployments or races if the service takes longer.
	7. Uses `docker exec` to reset passwords inside the server container using DOMjudge's console helper.
	8. Starts `N` judgehost containers in a loop. Each judgehost:
		 - Is run privileged, mounts `/sys/fs/cgroup` and uses `--cgroupns=host` so that DOMjudge judgehosts can use containerized build/execute features that require cgroup access.
		 - Receives `DOMSERVER_BASEURL` and `JUDGEDAEMON_PASSWORD` via env vars to connect back to the DOMserver.
	9. Prints a short deployment summary using `docker ps`, `docker network ls`, and `docker volume ls` filtered by the prefix.

- Key implementation notes and failure modes
	- Relying on static `sleep` calls makes the script fragile: if DB or server initialization times vary, judgehosts may start too early or the script may waste time waiting.
	- Parsing `--judgehosts` from `$2` assumes the argument ordering and format; passing args in other positions or using different flags will break it.
	- `docker run` uses explicit container names and `-p 80:80`; running multiple deployments on the same host with the same port will conflict.
	- Error output is suppressed in several places which hides the real root cause when something fails.

- Suggestions for improvement (why Task 2 exists)
	- Replace the procedural flow with a declarative Compose file to leverage healthchecks, service dependencies, and built-in scaling.
	- Replace fixed sleeps with polling for readiness (e.g., `mysqladmin ping`, HTTP health endpoints) to make startup deterministic and faster.
	- Make argument parsing more flexible (use `getopts` or a small CLI parser) and validate inputs explicitly.


