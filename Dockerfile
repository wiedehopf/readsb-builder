FROM debian:bookworm-slim
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    git \
    wget \
    pkg-config \
    autoconf \
    gcc \
    make \
    libusb-1.0-0-dev \
    librtlsdr-dev \
    libncurses-dev \
    zlib1g-dev \
    libzstd-dev \
    ca-certificates

# install jemalloc
RUN JEMALLOC_BDIR=$(mktemp -d) && \
    git clone --depth 1 https://github.com/jemalloc/jemalloc $JEMALLOC_BDIR && \
    cd $JEMALLOC_BDIR && \
    ./autogen.sh && \
    arch=$(dpkg --print-architecture) && \
    if [[ $arch == amd64 ]]; then ./configure; \
    elif [[ $arch == aarch64 ]]; then ./configure --with-lg-page=14; \
    else ./configure; \
    fi && \
    make -j$(nproc) && \
    make install && \
    rm -rf $JEMALLOC_BDIR
