# select build image
FROM rust:1.30.0 as build

# create a new empty shell project
RUN USER=root cargo new --bin noria
WORKDIR /noria

#create a new empty shell project
RUN USER=root cargo new --bin noria
WORKDIR /noria/noria

# copy over your manifests
COPY ./noria/Cargo.toml ./Cargo.toml

# this build step will cache your dependencies
RUN cargo build --release
RUN rm src/*.rs

# copy your source tree
COPY ./noria/src ./src


# create a new empty shell project
RUN USER=root cargo new --bin noria-server
WORKDIR /noria/noria-server

# copy over your manifests
COPY ./noria-server/Cargo.toml ./Cargo.toml

# this build step will cache your dependencies
RUN cargo build --release
RUN rm src/*.rs

# copy your source tree
COPY ./noria-server/src ./src



WORKDIR /noria
# copy over your manifests
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml


# build for release
RUN rm ./target/release/deps/my_project*
RUN cargo build --release --bin noria-server

# our final base
FROM rust:1.30.0

# copy the build artifact from the build stage
COPY --from=build /noria/target/release/noria-server .

# set the startup command to run your binary
CMD ["./noria-server"]