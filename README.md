# zmdockerfiles

Dockerfile for development ZoneMinder (includes gdb, vim etc).

Components: nginx, mysql, php-fpm.

# Build and start:

1. ./build.sh   # Build container
2. ./run.sh     # Start container (open 127.0.0.1:80 for configurating or usage ZoneMinger)
3. ./attache.sh # Open bash from container

4. delete.sh    # Delete all images and conteiners with ZoneMinger
5. stop.sh      # Stopo ZoneMinger
6. copy.sh      # example with copy file to the cointeider

# Notes

* I don't like apache2, and I switch to nginx.
* For ONVIF discovery need broadcast, I use '--net=host' for network on the Docker, becouse other
optins blocked broadcast. (Fix it if you can)


