# Docker_Cof

# Realtime OS Run

```
$ xhost +
$ docker run --rm -it --oom-kill-disable --cpu-rt-runtime=950000 --ulimit rtprio=99 --cap-add=sys_nice \
  -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0 -e DISPLAY=:0 jeffersonjhunt/linuxcnc start
```
