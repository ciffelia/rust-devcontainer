FROM rust:1.82.0-bookworm

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y --no-install-recommends clang

ARG mold_version=2.34.1

# Install mold
RUN curl -fsSL "https://github.com/rui314/mold/releases/download/v$mold_version/mold-$mold_version-x86_64-linux.tar.gz" | tar xzC /usr/local --strip-components 1

# Set up Rust to use mold
RUN mkdir /.cargo && \
    echo '[target.x86_64-unknown-linux-gnu]' >> /.cargo/config.toml && \
    echo 'linker = "clang"' >> /.cargo/config.toml && \
    echo 'rustflags = ["-C", "link-arg=-fuse-ld=/usr/local/bin/mold"]' >> /.cargo/config.toml
