# select build image
FROM rustlang/rust:nightly as build

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-add-repository "deb http://apt.llvm.org/jessie/ llvm-toolchain-jessie-6.0 main"



RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends liblz4-dev;
#RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
#RUN apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-6.0 main"
#    libclang-dev \
#RUN apt-get install -y libjsoncpp0
#RUN apt-get install -y libstdc++-4.9-dev
#RUN apt-get install -y libgcc-4.9-dev
#RUN apt-get install -y libobjc-4.9-dev
#RUN apt-get install -y llvm-6.0-dev
#RUN apt-get install -y python
#RUN apt-get install -y libomp-dev
#RUN apt-get install -y clang-6.0
#RUN apt-get install -y libclang-6.0-dev



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