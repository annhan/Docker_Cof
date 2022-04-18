# Install

```
$ sudo apt-get update
$ sudo apt-get install \
   apt-transport-https \
   ca-certificates \
   curl \
   software-properties-common
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$ sudo apt-key fingerprint 0EBFCD88
$ sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable"
```

Cài đặt docker CE:

```
$ sudo apt-get update
$ sudo apt-get install docker-ce
$ sudo docker run hello-world
```

# Realtime OS Run

```
$ xhost +
$ docker run --rm -it --oom-kill-disable --cpu-rt-runtime=950000 --ulimit rtprio=99 --cap-add=sys_nice \
  -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0 -e DISPLAY=:0 jeffersonjhunt/linuxcnc start
```
