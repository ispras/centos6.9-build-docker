FROM centos:6.9

MAINTAINER Alexey Vishnyakov

RUN sed -i 's/^#baseurl/baseurl/g' /etc/yum.repos.d/CentOS-Base.repo && \
    sed -i '/^mirrorlist=.*$/d' /etc/yum.repos.d/CentOS-Base.repo && \
    sed -i 's/mirror\./vault\./g' /etc/yum.repos.d/CentOS-Base.repo

RUN yum -y update && yum -y install epel-release && yum -y update && \
    yum -y install gcc gcc-c++ glibc-devel.i686 glibc-devel \
                   libstdc++-devel.i686 libstdc++-devel make zlib-devel \
                   python-devel git wget unzip xz bzip2 lzop re2c \
                   texi2html texinfo libffi-devel

RUN wget https://www.openssl.org/source/openssl-1.1.1i.tar.gz && \
    tar xf openssl-1.1.1i.tar.gz && rm openssl-1.1.1i.tar.gz && \
    cd openssl-1.1.1i && ./config --prefix=/usr && \
    sed -i '/^CFLAG/s/$/ -fPIC/' Makefile && \
    make -j200 && make install && cd .. && rm -rf openssl-1.1.1i

RUN wget https://github.com/Kitware/CMake/releases/download/v3.17.3/cmake-3.17.3-Linux-x86_64.sh && \
    sh cmake-3.17.3-Linux-x86_64.sh --prefix=/ --exclude-subdir --skip-license && \
    rm cmake-3.17.3-Linux-x86_64.sh

RUN wget https://ftp.gnu.org/gnu/binutils/binutils-2.34.tar.xz && \
    tar xf binutils-2.34.tar.xz && rm binutils-2.34.tar.xz && \
    cd binutils-2.34 && \
    ./configure --prefix=/usr && make -j200 && make install && \
    cd .. && rm -rf binutils-2.34

RUN wget https://ftp.gnu.org/gnu/gcc/gcc-9.3.0/gcc-9.3.0.tar.xz && \
    tar xf gcc-9.3.0.tar.xz && rm gcc-9.3.0.tar.xz && \
    cd gcc-9.3.0 && \
    contrib/download_prerequisites && \
    mkdir ../gcc-build && cd ../gcc-build && \
    ../gcc-9.3.0/configure --prefix=/usr --enable-languages=c,c++ --enable-multilib && \
    make -j200 && make install && \
    cd .. && rm -rf gcc-9.3.0 gcc-build

RUN wget https://github.com/ninja-build/ninja/archive/v1.10.0.tar.gz && \
    tar xf v1.10.0.tar.gz && rm v1.10.0.tar.gz && \
    cd ninja-1.10.0 && mkdir build && cd build && \
    cmake .. && cmake --build . -j200 && cp ninja /usr/bin && \
    cd ../.. && rm -rf ninja-1.10.0

RUN wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tar.xz && \
    tar xf Python-2.7.18.tar.xz && rm Python-2.7.18.tar.xz && \
    cd Python-2.7.18 && \
    sed -i 's/^#SSL/SSL/g' Modules/Setup.dist && \
    sed -i 's/^#_ssl/_ssl/g' Modules/Setup.dist && \
    sed -i 's/^#\t-DUSE_SSL/\t-DUSE_SSL/g' Modules/Setup.dist && \
    sed -i 's/^#\t-L\$(SSL)/\t-L\$(SSL)/g' Modules/Setup.dist && \
    ./configure --enable-optimizations && make -j200 install && \
    cd .. && rm -rf Python-2.7.18

RUN wget https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/llvm-project-10.0.0.tar.xz && \
    tar xf llvm-project-10.0.0.tar.xz && rm llvm-project-10.0.0.tar.xz && \
    cd llvm-project-10.0.0 && mkdir build && cd build && \
    cmake ../llvm -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release \
                  -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;compiler-rt" -GNinja && \
    cmake --build . -j200 && cmake --install . && \
    cd ../.. && rm -rf llvm-project-10.0.0

RUN wget https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/llvm-project-10.0.0.tar.xz && \
    tar xf llvm-project-10.0.0.tar.xz && rm llvm-project-10.0.0.tar.xz && \
    cd llvm-project-10.0.0 && mkdir build && cd build && \
    cmake ../llvm -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release \
                  -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
                  -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;compiler-rt" -GNinja && \
    cmake --build . -j200 && cmake --install . && \
    cd ../.. && rm -rf llvm-project-10.0.0

RUN wget https://www.python.org/ftp/python/3.9.0/Python-3.9.0.tar.xz && \
    tar xf Python-3.9.0.tar.xz && rm Python-3.9.0.tar.xz && \
    cd Python-3.9.0 && \
    sed -i 's/^#SSL/SSL/g' Modules/Setup && \
    sed -i 's/^#_ssl/_ssl/g' Modules/Setup && \
    sed -i 's/^#\t-DUSE_SSL/\t-DUSE_SSL/g' Modules/Setup && \
    sed -i 's/^#\t-L\$(SSL)/\t-L\$(SSL)/g' Modules/Setup && \
    ./configure --enable-optimizations && make -j200 install && \
    cd .. && rm -rf Python-3.9.0

RUN wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py && \
    rm get-pip.py

RUN python3 -m pip install concurrencytest psutil
