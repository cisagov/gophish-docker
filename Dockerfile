# Official Docker images are in the form library/<app> while non-official
# images are in the form <user>/<app>.
FROM docker.io/library/debian:trixie-slim AS compile-stage

###
# Unprivileged user variables
###
ARG CISA_USER="cisa"
ENV CISA_HOME="/home/${CISA_USER}"

# The version of Gophish to install
ARG GOPHISH_VERSION="0.11.0-cisa.1"

###
# Dependencies
#
# We need ca-certificates, unzip, and wget to pull down a copy of
# gophish.
###
RUN apt update
RUN apt install --quiet --quiet --yes \
    --no-install-recommends --no-install-suggests \
    ca-certificates \
    unzip \
    wget

# TODO: Revert from cisagov/gophish back to gophish/gophish after all of our
# pull requests have been merged; including, but potentially not limited to:
# - https://github.com/gophish/gophish/pull/1484
# - https://github.com/gophish/gophish/pull/1486
# See https://github.com/cisagov/gophish-docker/issues/25 for details.
RUN wget --no-verbose https://github.com/cisagov/gophish/releases/download/v${GOPHISH_VERSION}/gophish-v${GOPHISH_VERSION}-linux-64bit.zip \
    && mkdir --parents ${CISA_HOME}/gophish \
    && unzip -d ${CISA_HOME}/gophish gophish-v${GOPHISH_VERSION}-linux-64bit.zip

# Official Docker images are in the form library/<app> while non-official
# images are in the form <user>/<app>.
FROM docker.io/library/debian:trixie-slim AS build-stage

###
# For a list of pre-defined annotation keys and value types see:
# https://github.com/opencontainers/image-spec/blob/master/annotations.md
#
# Note: Additional labels are added by the build workflow.
###
LABEL org.opencontainers.image.authors="vm-dev@gwe.cisa.dhs.gov"
LABEL org.opencontainers.image.vendor="Cybersecurity and Infrastructure Security Agency"

# The directory where the get-api-key script will be installed
ENV SCRIPT_DIR="/usr/local/bin"

###
# Unprivileged user setup variables
###
ARG CISA_UID=421
ARG CISA_GID=${CISA_UID}
ARG CISA_USER="cisa"
ENV CISA_GROUP=${CISA_USER}
ENV CISA_HOME="/home/${CISA_USER}"

###
# Create unprivileged user
###
RUN groupadd --system --gid ${CISA_GID} ${CISA_GROUP} \
    && useradd --system --uid ${CISA_UID} --gid ${CISA_GROUP} --comment "${CISA_USER} user" $--create-home ${CISA_USER}

###
# Install everything we need
###
ENV DEPS="ca-certificates libsqlite3-dev sqlite3"
RUN apt update
RUN apt install --quiet --quiet --yes \
    --no-install-recommends --no-install-suggests \
    $DEPS

COPY bin/get-api-key ${SCRIPT_DIR}

# TODO: Revert from cisagov/gophish back to gophish/gophish after all of our
# pull requests have been merged; including, but potentially not limited to:
# - https://github.com/gophish/gophish/pull/1484
# - https://github.com/gophish/gophish/pull/1486
# See https://github.com/cisagov/gophish-docker/issues/25 for details.
COPY --from=compile-stage --chown=${CISA_USER}:${CISA_GROUP} ${CISA_HOME}/gophish/ ${CISA_HOME}/
RUN chmod +x ${CISA_HOME}/gophish \
    && ln --symbolic --no-dereference --force /run/secrets/config.json ${CISA_HOME}/config.json \
    && mkdir --parents ${CISA_HOME}/data \
    && ln --symbolic --no-dereference --force ${CISA_HOME}/data/gophish.db ${CISA_HOME}/gophish.db

###
# Clean up aptitude cruft
###
RUN apt clean --quiet --quiet \
    && rm --recursive --force /var/lib/apt/lists/*

###
# Setup working directory and entrypoint
###
RUN chown --recursive ${CISA_USER}:${CISA_GROUP} ${CISA_HOME}

###
# Prepare to run
###
USER ${CISA_USER}:${CISA_GROUP}
WORKDIR ${CISA_HOME}
EXPOSE 3333/tcp 8080/tcp
ENTRYPOINT ["./gophish"]
