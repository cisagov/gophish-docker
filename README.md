# gophish-docker 🎣🐳 #

[![GitHub Build Status](https://github.com/cisagov/gophish-docker/workflows/build/badge.svg)](https://github.com/cisagov/gophish-docker/actions)
[![CodeQL](https://github.com/cisagov/gophish-docker/workflows/CodeQL/badge.svg)](https://github.com/cisagov/gophish-docker/actions/workflows/codeql-analysis.yml)
[![Known Vulnerabilities](https://snyk.io/test/github/cisagov/gophish-docker/badge.svg)](https://snyk.io/test/github/cisagov/gophish-docker)

## Docker Image ##

[![Docker Pulls](https://img.shields.io/docker/pulls/cisagov/gophish)](https://hub.docker.com/r/cisagov/gophish)
[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/cisagov/gophish)](https://hub.docker.com/r/cisagov/gophish)
[![Platforms](https://img.shields.io/badge/platforms-amd64%20%7C%20arm%2Fv6%20%7C%20arm%2Fv7%20%7C%20arm64%20%7C%20ppc64le%20%7C%20s390x-blue)](https://hub.docker.com/r/cisagov/gophish/tags)

Creates a Docker container with an installation of the
[gophish](https://getgophish.com) phishing framework.

## Running ##

### Running with Docker ###

To run the `cisagov/gophish` image via Docker:

```console
docker run cisagov/gophish:0.0.1
```

### Running with Docker Compose ###

1. Create a `docker-compose.yml` file similar to the one below to use [Docker Compose](https://docs.docker.com/compose/).

    ```yaml
    ---
    version: "3.7"

    services:
      gophish:
        image: cisagov/gophish:0.0.1
        ports:
          - target: 3333
            published: 3333
            protocol: tcp
            mode: host
          - target: 8080
            published: 3380
            protocol: tcp
            mode: host
    ```

1. Start the container and detach:

    ```console
    docker-compose up --detach
    ```

## Using secrets with your container ##

This container also supports passing sensitive values via [Docker
secrets](https://docs.docker.com/engine/swarm/secrets/).  Passing sensitive
values like your credentials can be more secure using secrets than using
environment variables.  See the
[secrets](#secrets) section below for a table of all supported secret files.

1. To use secrets, create a file or files containing the values you
   want set.
1. Then add the secret or secrets to your `docker-compose.yml` file:

    ```yaml
    ---
    version: "3.7"

    secrets:
      config_json:
        file: ./src/secrets/config.json
      admin_fullchain_pem:
        file: ./src/secrets/admin_fullchain.pem
      admin_privkey_pem:
        file: ./src/secrets/admin_privkey.pem
      phish_fullchain_pem:
        file: ./src/secrets/phish_fullchain.pem
      phish_privkey_pem:
        file: ./src/secrets/phish_privkey.pem

    services:
      gophish:
        image: cisagov/gophish:0.0.1
        ports:
          - target: 3333
            published: 3333
            protocol: tcp
            mode: host
          - target: 8080
            published: 3380
            protocol: tcp
            mode: host
        secrets:
          - source: config_json
            target: config.json
          - source: admin_fullchain_pem
            target: admin_fullchain.pem
          - source: admin_privkey_pem
            target: admin_privkey.pem
          - source: phish_fullchain_pem
            target: phish_fullchain.pem
          - source: phish_privkey_pem
            target: phish_privkey.pem
    ```

## Updating your container ##

### Docker Compose ###

1. Pull the new image from Docker Hub:

    ```console
    docker-compose pull
    ```

1. Recreate the running container by following the [previous instructions](#running-with-docker-compose):

    ```console
    docker-compose up --detach
    ```

### Docker ###

1. Stop the running container:

    ```console
    docker stop <container_id>
    ```

1. Pull the new image:

    ```console
    docker pull cisagov/gophish:0.0.1
    ```

1. Recreate and run the container by following the [previous instructions](#running-with-docker).

## Image tags ##

The images of this container are tagged with [semantic
versions](https://semver.org) of the underlying gophish project that they
containerize.  It is recommended that most users use a version tag (e.g.
`:0.0.1`).

| Image:tag | Description |
|-----------|-------------|
|`cisagov/gophish:1.2.3`| An exact release version. |
|`cisagov/gophish:1.2`| The most recent release matching the major and minor version numbers. |
|`cisagov/gophish:1`| The most recent release matching the major version number. |
|`cisagov/gophish:edge` | The most recent image built from a merge into the `develop` branch of this repository. |
|`cisagov/gophish:nightly` | A nightly build of the `develop` branch of this repository. |
|`cisagov/gophish:latest`| The most recent release image pushed to a container registry.  Pulling an image using the `:latest` tag [should be avoided.](https://vsupalov.com/docker-latest-tag/) |

See the [tags tab](https://hub.docker.com/r/cisagov/gophish/tags) on Docker
Hub for a list of all the supported tags.

## Volumes ##

There are no volumes.

<!-- | Mount point | Purpose        | -->
<!-- |-------------|----------------| -->
<!-- | `/var/log`  |  Log storage   | -->

## Ports ##

The following ports are exposed by this container:

| Port | Purpose        |
|------|----------------|
| 8080 | Example only; nothing is actually listening on the port |

The sample [Docker composition](docker-compose.yml) publishes the
exposed port at 8080.

## Environment variables ##

### Required ###

There are no required environment variables.

<!--
| Name  | Purpose | Default |
|-------|---------|---------|
| `REQUIRED_VARIABLE` | Describe its purpose. | `null` |
-->

### Optional ###

There are no optional environment variables.

<!-- | Name  | Purpose | Default | -->
<!-- |-------|---------|---------| -->
<!-- | `ECHO_MESSAGE` | Sets the message echoed by this container.  | `Hello World from Dockerfile` | -->

## Secrets ##

| Filename     | Purpose |
|--------------|---------|
| `config.json` | gophish configuration file |
| `admin_fullchain.pem` | public key for admin port |
| `admin_privkey.pem` | private key for admin port |
| `phish_fullchain.pem` | public key for phishing port |
| `phish_privkey.pem` | private key for phishing port |

## Building from source ##

Build the image locally using this git repository as the [build context](https://docs.docker.com/engine/reference/commandline/build/#git-repositories):

```console
docker build \
  --build-arg VERSION=0.0.1 \
  --tag cisagov/gophish:0.0.1 \
  https://github.com/cisagov/gophish-docker.git#develop
```

## Cross-platform builds ##

To create images that are compatible with other platforms, you can use the
[`buildx`](https://docs.docker.com/buildx/working-with-buildx/) feature of
Docker:

1. Copy the project to your machine using the `Code` button above
   or the command line:

    ```console
    git clone https://github.com/cisagov/gophish-docker.git
    cd gophish-docker
    ```

1. Create the `Dockerfile-x` file with `buildx` platform support:

    ```console
    ./buildx-dockerfile.sh
    ```

1. Build the image using `buildx`:

    ```console
    docker buildx build \
      --file Dockerfile-x \
      --platform linux/amd64 \
      --build-arg VERSION=0.0.1 \
      --output type=docker \
      --tag cisagov/gophish:0.0.1 .
    ```

## Contributing ##

We welcome contributions!  Please see [`CONTRIBUTING.md`](CONTRIBUTING.md) for
details.

## License ##

This project is in the worldwide [public domain](LICENSE).

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain
dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.
