# ThinLinc Demo Instance

This is a docker based instance of ThinLinc. Running under docker its default
behavior is to suffer from complete amnesia after each restart. As such
it requires some minimal configuration after startup to accept your logins.

## Startup

First you have to install docker. If you are running ubuntu, docker will be
available as a package for installation. If you are on windows or macos you
can go to docker.com to download docker for your os. If you are on RedHat,
install `podman-docker` to get a docker compatible cli for podman.

Normally a docker image will run a single application.  Often only a single
process.  In order to demo ThinLinc we get docker to run an entire linux
system for us.  For this to work, docker needs to run in `--privileged` mode.

The ThinLinc client uses ssh to communicate with its server, with the
`--publish` option you map the ssh port of the ThinLinc demo server to a
port, accessible from the outside.  Keep the docker attached to the terminal
`-t` to see all the messages it outputs to the console.

```console
docker run --privileged --pull=always --name my-tl-demo --publish 9922:22 -t oposs/tl-ubuntu
```

**Pro Tip** If you feel uneasy about giving the ThinLinc docker image full
system access using the `--privileged` option you can also use the following
commandline to start.

```console
docker run -v /sys/fs/cgroup/:/sys/fs/cgroup:ro \
  --tmpfs /run --tmpfs /run/lock \
  --pull=always \
  --cap-add SYS_PTRACE --cap-add SYS_ADMIN \
  --name my-tl-demo --publish 9922:22 -t \
  oposs/tl-ubuntu
```

## Configuration

Before you can login, the ThinLinc server requires some minimal configuration

First add a user account. Either with a password

```console
docker exec my-tl-demo tlcfg add-user myuser mypassword
```

or using an ssh public key

```console
docker exec my-tl-demo tlcfg add-ssh-user myuser "public ssh key"
```
Second, let the ThinLinc server know under what hostname it is reachable
from the client.  This is a very important step, as ThinLinc uses a
load-balancing system where it will tell your client to connect to the the
ThinLinc server with the lowest load in your ThinLinc cluster.

In this example we tell the ThinLinc server that it can be reached from the
local machine.  But you can also set the public IP or the dns name of your
machine to make your demo instance available on your network.

```console
docker exec my-tl-demo tlcfg set-hostname 127.0.0.1
```

Now all is ready for accessing the ThinLinc server using the ThinLinc client. Make sure to
configure the ThinLinc client to use the right port number.

If you have not yet downloaded a ThinLinc client, you can download it
[here](https://www.cendio.com/thinlinc/download). 

## Cleanup

When you are done testing, you can get rid of your ThinLinc demo server very easily:

```console
docker kill my-tl-demo
docker rm my-tl-demo
```

Note that this will also get rid of anything you have done on the ThinLinc demo server
while logged in with your demo user

## Debugging

If you want to have a peak inside the ThinLinc server while it is running, try this

```console
docker exec -ti my-tl-demo bash
```

## Support

If you have questions in connection with ThinLinc in general or
thinlinc-demo-in-a-docker head over to the [ThinLinc Community](https://community.thinlinc.com/tag/docker).

## Build

If you want to tinker with thinlinc, and modify it ... fork this repo and
let me have a pull request. To get started, use the following command to
rebuild the docker image locally.

```console
docker build --tag tl-ubuntu:latest .
```

*EOF*
