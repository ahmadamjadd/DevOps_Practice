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

