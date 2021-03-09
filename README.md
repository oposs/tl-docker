# ThinLinc Demo Instance

This is a docker based instance of ThinLinc. Running under docker its default
behavior is to suffer from complete amnesia after each restart. As such
it requires some minimal configuration after startup to accept your logins.

## Build

For now we are just building a local docker to try things out ... run the `build.sh`
script to get this done. Later the build process will not be neccessary as the
docker image will be hosted on docker hub.

## Startup

First you have to install docker. If you are running ubuntu, docker will be
available as a package for installation. If you are on windows or macos you
can go to docker.com to download docker for your os. If you are on RedHat,
install `podman-docker` to get a docker compatible cli for podman.

Normally a docker image will run a single application.  Often only a single
process.  In order to demo thinlinc we get docker to run an entire linux
system for us.  For this to work, docker needs to run in `--privileged` mode.

The thinlinc client uses ssh to communicate with its server, 
with the `--publish` option you map the ssh port of the thinlinc demo server
to a port, accessible from the outside. 

You may also have to adjust your firewall appropriately. For now, keep the
docker attached to the terminal `-t` to see all the messages it outputs
to the console.

```console
$ docker run --privileged --name my-tl-demo --publish 9922:22 -t tl-ubuntu
```

Pro Tip: If you feel uneasy about giving the thinlinc docker image full
system access using the `--privileged` option you can also use the following
commandline to start.

```bash
$ docker run -v /sys/fs/cgroup/:/sys/fs/cgroup:ro --cap-add SYS_PTRACE --cap-add SYS_ADMIN \
  --tmpfs /run --tmpfs /run/tmpfs --name my-tl-demo --publish 9922:22 -t tl-ubuntu
```

## Configuration

Before you can login, the thinlinc server requires some minimal configuration

First add a user account

```console
$ docker exec my-tl-demo tlcfg add-user myuser mypassword
```

Second, let the thinlinc server know under what hostname it is reachable from the client.
This is a very important step, as thinlinc uses a load-balancing system where it will
tell your client to connect to the the thinlinc server with the lowest
load in your thinlinc cluster.

```console
$ docker exec my-tl-demo tlcfg set-hostname $(hostname -f)
```

Now all is ready for accessing the thinlinc server using the thinlinc client. Make sure to
configure the thinlinc client to use the right port number.

## Cleanup

When you are done testing, you can get rid of your thinlinc demo server very easily:

```console
$ docker kill my-tl-demo
$ docker rm my-tl-demo
```

Note that this will also get rid of anything you have done on the thinlinc demo server
while logged in with your demo user

## Debugging

If you want to have a peak inside the thinlinc server while it is running, try this

```console
$ docker exec -ti my-tl-demo bash
```

<!--EOF--> 
