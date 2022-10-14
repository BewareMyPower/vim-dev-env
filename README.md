# vim-dev-env

The development environment based on Vim editor.

## Install on Ubuntu 20.04

You only need to run `./install.sh`.

Since GitHub and apt source are blocked in some particular areas, if you have a proxy, you can configure the environment variable `PROXY` before running `install.sh`.

For example, my Ubuntu runs in [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install) and there is a proxy that listens on 10808 port. Here are how I configured the `PROXY` variable:

```bash
# Inside WSL2, run `ipconfig` on Windows to see the actual IP in your env
export PROXY=socks5://172.30.80.1:10808
```

```bash
# Inside a ubuntu:20.04 docker container
export PROXY=socks5://host.docker.internal:10808
```

## Docker image set up

You can also set up the development environment in a Docker image. Here are the instructions to build a Ubuntu-based image with Vim and the plugins installed.  

### Build the image

```bash
docker build -t ubuntu-18.04-vim-dev .
```

### Example

After building the image successfully, you can edit [the C++ example file](./example.cc) when starting the container.

```bash
docker run -it ubuntu-18.04-vim-dev /bin/bash -c "vim main.cc"
```

<img alt="Gif" src="https://s3.bmp.ovh/imgs/2022/04/10/692be8b625fe0eac.gif" width="60%" />
