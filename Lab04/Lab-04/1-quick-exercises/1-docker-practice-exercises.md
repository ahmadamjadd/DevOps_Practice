# Docker Containers Lab – Complete CLI Practice

## 🛠 Prerequisites

- Docker installed
- Terminal access

Verify Docker:

```bash
docker --version
docker run hello-world
```

## PART 1 – Basic Container Lifecycle

### Run Ubuntu

```bash
docker run ubuntu
```
Check containers status:

```bash
# list running & stopped containers
docker ps
docker ps -a
```

Why did it exit immediately?

---

### Run Ubuntu with Sleep

```bash
docker run ubuntu sleep 5
```

Check containers:

```bash
docker ps
docker ps -a
```

---

## PART 2 – Interactive Mode (-i and -t)

Run interactive container:

```bash
docker run -it ubuntu bash
```

Inside container:

```bash
echo "Hello Docker"
ls
```

Exit:

```bash
exit
```

Check status:

```bash
docker ps -a
```

---

## PART 3 – Stop and Remove Containers

Run container:

```bash
docker run -it ubuntu bash
```

Open new terminal and check:

```bash
docker ps
```

Stop container:

```bash
docker stop <container_id>
```

Remove container:

```bash
docker rm <container_id>
```

---

## PART 4 – Images and Remove Images

List images:

```bash
docker images
```

Remove image:

```bash
docker rmi ubuntu
```

If error appears, remove containers first.

---

## PART 5 – Run with Name

```bash
docker run --name myubuntu ubuntu sleep 30
```

Check:

```bash
docker ps
```

Stop by name:

```bash
docker stop myubuntu
```

---

## PART 6 – Run with Tag

```bash
docker run ubuntu:22.04
docker images
```

What is the difference between `ubuntu` and `ubuntu:22.04`?

---

## PART 7 – Detached Mode

```bash
docker run -dit --name test ubuntu bash
```

Check:

```bash
docker ps
```

---

## PART 8 – Attach

```bash
docker attach test
```

Detach without stopping container:

Press:

```
CTRL + P + Q
```

---

## PART 9 – Exec

```bash
docker exec -it test bash
```

What is the difference between `attach` and `exec`?

---

## PART 10 – Logs

Run:

```bash
docker run --name logger ubuntu echo "Logging example"
```

Check logs:

```bash
docker logs logger
```

---

## PART 11 – Inspect

```bash
docker inspect test
```

Optional formatted output:

```bash
docker inspect --format='{{.State.Status}}' test
```

---

## PART 12 – Multiple Containers (Apache Example)

Pull image:

```bash
docker pull ubuntu/apache2
```

Run Web1:

```bash
docker run -d --name web1 -p 8081:80 ubuntu/apache2
```

Run Web2:

```bash
docker run -d --name web2 -p 8082:80 ubuntu/apache2
```

Open browser:

```
http://localhost:8081
http://localhost:8082
```

Check:

```bash
docker ps
```

View logs:

```bash
docker logs web1
```

---

## PART 13 – Simple Shell Script (stdin Example)

Create file `input.sh`

```bash
#!/bin/bash
echo "Enter your name:"
read name
echo "Hello $name"
```

Make executable:

```bash
chmod +x input.sh
```

Run container with volume:

```bash
docker run -it -v $(pwd):/scripts ubuntu bash
```

Inside container:

```bash
cd /scripts
./input.sh
```

Explain why `-i` is needed?

---

## PART 14 – Run Multiple Containers

```bash
docker run -d ubuntu sleep 300
docker run -d ubuntu sleep 300
docker run -d ubuntu sleep 300
```

Check:

```bash
docker ps
```

How many containers can you run?


## Final Cleanup

Stop all containers:

```bash
docker stop $(docker ps -q)
```

Remove all containers:

```bash
docker rm $(docker ps -aq)
```

Remove image:

```bash
docker rmi ubuntu
```