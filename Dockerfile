FROM debian:stable-slim as build

RUN apt-get update
RUN apt-get install -y curl git libpq-dev m4 npm unzip
RUN curl -fsSL https://bun.sh/install | bash

WORKDIR /build

RUN bun install esy

# Install dependencies.
ADD esy.* .
RUN [ -f esy.lock ] || node_modules/.bin/esy solve
RUN node_modules/.bin/esy fetch
RUN node_modules/.bin/esy build-dependencies

# Build project.
ADD . .
RUN node_modules/.bin/esy install
RUN node_modules/.bin/esy build

FROM debian:stable-slim as run

RUN apt-get update
RUN apt-get install -y libev4 libpq5 wget
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1-1ubuntu2.1~18.04.23_amd64.deb
RUN dpkg -i libssl1.1_1.1.1-1ubuntu2.1~18.04.23_amd64.deb

COPY --from=build build/_esy/default/build/default/app.exe /bin/app

ENTRYPOINT /bin/app