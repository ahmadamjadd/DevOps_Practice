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
