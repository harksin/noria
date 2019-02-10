
#todo: try bazel / distroless
#todo: build in docker when https://github.com/fintelia/rahashmap/pull/5 was merged
# select build image
#FROM rustlang/rust:nightly as build
#
#RUN set -eux; \
#    apt-get update; \
#    apt-get install -y --no-install-recommends liblz4-dev;
#
#
##create a new empty shell project
#RUN USER=root cargo new --bin noria
#WORKDIR /noria
#
#COPY ./Cargo.lock ./Cargo.lock
#COPY ./docker.toml ./Cargo.toml
#COPY ./noria-server  ./noria-server
#COPY ./noria  ./noria
#
#
## build for release
#RUN cargo build --release --bin noria-server

# our final base
FROM rustlang/rust:nightly-slim

# copy the build artifact from the build stage
COPY ./target/release/noria-server .
#COPY --from=build /noria/target/release/noria-server .

# set the startup command to run your binary
CMD ["./noria-server"]