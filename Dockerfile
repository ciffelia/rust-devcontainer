FROM rust:1.77.0-bookworm

ARG mold_version=2.30.0

# Install mold
RUN curl -L https://github.com/rui314/mold/archive/refs/tags/v$mold_version.tar.gz | tar xz && \
    cd mold-$mold_version && \
    ./install-build-deps.sh && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=c++ -B build && \
    cmake --build build -j "$(nproc)" && \
    cmake --build build --target install && \
    rm -rf .

# Set up Rust to use mold
RUN mkdir /.cargo && \
    echo '[target.x86_64-unknown-linux-gnu]' >> /.cargo/config.toml && \
    echo 'linker = "clang"' >> /.cargo/config.toml && \
    echo 'rustflags = ["-C", "link-arg=-fuse-ld=/usr/local/bin/mold"]' >> /.cargo/config.toml
