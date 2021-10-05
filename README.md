# CentOS 6.9 build Docker environment

You can use this Docker container to build portable Linux binaries. This C/C++
build environment solves problem of incompatible GLIBC version on old Linux
distributions. You can build your tool on CentOS 6.9 and distribute built
binaries. You can run a portable Linux tool on Ubuntu 10.04-20.04. It is highly
recommended to build with `-static-libgcc -static-libstdc++`.

## Run

    $ sudo docker run --rm -it sweetvishnya/centos6.9-build /bin/bash

## What this Docker contains

 - make
 - cmake 3.21.3
 - binutils 2.34
 - gcc 9.3.0
 - ninja 1.10.2
 - python 2.7.18
 - python 3.9.0
 - clang 10.0.0
 - openssl 1.1.1i
 - Rust

## Note

`wget` doesn't work inside docker due to CA certificates issue. Use `curl`
instead.
