# vim-dev-env

The development environment based on Vim editor.

## Build the image

```bash
docker build -t ubuntu-18.04-vim-dev .
```

## Example

After building the image successfully, you can edit [the C++ example file](./example.cc) when starting the container.

```bash
docker run -it ubuntu-18.04-vim-dev /bin/bash -c "vim main.cc"
```

<img alt="Gif" src="https://s3.bmp.ovh/imgs/2022/04/10/692be8b625fe0eac.gif" width="60%" />
