# gophish-docker 🎣🐳 #

[![Build Status](https://travis-ci.com/cisagov/gophish-docker.svg?branch=develop)](https://travis-ci.com/cisagov/gophish-docker)

## Docker Image ##

![MicroBadger Layers](https://img.shields.io/microbadger/layers/dhsncats/gophish.svg)
![MicroBadger Size](https://img.shields.io/microbadger/image-size/dhsncats/gophish.svg)

Creates a Docker container with an installation of the
[gophish](https://getgophish.com) phishing framework.

## Usage ##

### Install ###

Pull `dhsncats/gophish` from the Docker repository:

    docker pull dhsncats/gophish

Or build `dhsncats/gophish` from source:

    git clone https://github.com/cisagov/gophish-docker.git
    cd gophish-docker
    docker-compose build --build-arg VERSION=0.0.1

### Run ###

    docker-compose run --rm example

## Ports ##

This container exposes the following ports:

- 3333: `admin server`
- 8080: `phish server`

## Secrets ##

- `config.json`: gophish configuration file
- `admin_fullchain.pem`: public key for admin port
- `admin_privkey.pem`: private key for admin port
- `phish_fullchain.pem`: public key for phishing port
- `phish_privkey.pem`: private key for phishing port

## Contributing ##

We welcome contributions!  Please see [here](CONTRIBUTING.md) for
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
