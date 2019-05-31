# docker-gophish 🐳🎣 #

[![Build Status](https://travis-ci.com/cisagov/docker-gophish.svg?branch=develop)](https://travis-ci.com/cisagov/docker-gophish)

Creates a Docker container with an installation of the
[gophish](https://getgophish.com) phishing framework.

## Usage ##

A sample [docker composition](docker-compose.yml) is included in this repository.
To build and start the container use the command: `docker-compose up`

### Ports ###

This container exposes the following ports:

- 3333: `admin server`
- 8080: `phish server`

The sample [docker composition](docker-compose.yml) publishes the
exposed ports at 3333, and 3380 respectively.

### Environment Variables ###

None.

### Secrets ###

- `config.json`: gophish configuration file
- `admin_fullchain.pem`: public key for admin port
- `admin_privkey.pem`: private key for admin port
- `phish_fullchain.pem`: public key for phishing port
- `phish_privkey.pem`: private key for phishing port

### Volumes ###

None.

## Contributing ##

We welcome contributions!  Please see [here](CONTRIBUTING.md) for
details.

## License ##

This project is in the worldwide [public domain](LICENSE.md).

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain
dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.
