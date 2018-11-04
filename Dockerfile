# select build image
FROM rustlang/rust:nightly-slim as build


RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    libclang-dev \
    libclang-dev; \
    rm -rf /var/lib/apt/lists/*;


#create a new empty shell project
RUN USER=root cargo new --bin noria
WORKDIR /noria

COPY ./Cargo.lock ./Cargo.lock
COPY ./docker.toml ./Cargo.toml
COPY ./noria-server  ./noria-server
COPY ./noria  ./noria


# build for release
RUN cargo build --release --bin noria-server

# our final base
FROM rustlang/rust:nightly-slim

# copy the build artifact from the build stage
COPY --from=build /noria/target/release/noria-server .

# set the startup command to run your binary
CMD ["./noria-server"]