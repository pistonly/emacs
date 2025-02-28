xhost +local:docker
docker run -it --rm \
       --name ubuntu_emacs \
       --env DISPLAY=host.docker.internal:0 \
       --env XAUTHORITY=$XAUTHORITY \
       --volume /tmp/.X11-unix:/tmp/.X11-unix \
       -v /Users/kakaluote/:/Users/kakaluote \
       ubuntu-emacs:24.04

