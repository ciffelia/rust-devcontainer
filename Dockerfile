FROM rust:1.76.0-bookworm

ARG mold_version=2.4.0

# Install mold
RUN curl -L https://github.com/rui314/mold/archive/refs/tags/v2.4.0.tar.gz | tar xz && \
    mkdir mold-2.4.0/build && \
    cd mold-2.4.0/build && \
    ../install-build-deps.sh && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=c++ .. && \
    cmake --build . -j "$(nproc)" && \
    cmake --build . --target install && \
    rm -rf /mold-2.4.0

# Set up Rust to use mold
RUN mkdir /.cargo && \
    echo '[target.x86_64-unknown-linux-gnu]' >> /.cargo/config.toml && \
    echo 'linker = "clang"' >> /.cargo/config.toml && \
    echo 'rustflags = ["-C", "link-arg=-fuse-ld=/usr/local/bin/mold"]' >> /.cargo/config.toml
