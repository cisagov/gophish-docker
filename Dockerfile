
FROM debian:bullseye-slim

# The version of Gophish to install
ARG GOPHISH_VERSION="0.11.0-cisa.1"

# The directory where the get-api-key script will be installed
ENV SCRIPT_DIR="/usr/local/bin"

###
# For a list of pre-defined annotation keys and value types see:
# https://github.com/opencontainers/image-spec/blob/master/annotations.md
#
# Note: Additional labels are added by the build workflow.
###
LABEL org.opencontainers.image.authors="vm-fusion-dev-group@trio.dhs.gov"
LABEL org.opencontainers.image.vendor="Cybersecurity and Infrastructure Security Agency"

###
# Unprivileged user setup variables
###
ARG CISA_UID=421
ARG CISA_GID=${CISA_UID}
ARG CISA_USER="cisa"
ENV CISA_GROUP=${CISA_USER}
ENV CISA_HOME="/home/${CISA_USER}"

###
# Upgrade the system
###
RUN apt-get update --quiet --quiet \
    && apt-get upgrade --quiet --quiet

###
# Create unprivileged user
###
RUN groupadd --system --gid ${CISA_GID} ${CISA_GROUP} \
    && useradd --system --uid ${CISA_UID} --gid ${CISA_GROUP} --comment "${CISA_USER} user" ${CISA_USER}

###
# Install everything we need
#
# Install dependencies are only needed for software installation and
# will be removed at the end of the build process.
###
ENV DEPS \
    ca-certificates \
    libsqlite3-dev \
    sqlite3
ENV INSTALL_DEPS \
    unzip \
    wget
RUN apt-get install --quiet --quiet --yes \
    --no-install-recommends --no-install-suggests \
    $DEPS $INSTALL_DEPS

COPY bin/get-api-key ${SCRIPT_DIR}

# TODO: Revert from cisagov/gophish back to gophish/gophish after all of our
# pull requests have been merged; including, but potentially not limited to:
# - https://github.com/gophish/gophish/pull/1484
# - https://github.com/gophish/gophish/pull/1486
# See https://github.com/cisagov/gophish-docker/issues/25 for details.
RUN wget --no-verbose https://github.com/cisagov/gophish/releases/download/v${GOPHISH_VERSION}/gophish-v${GOPHISH_VERSION}-linux-64bit.zip \
    && unzip -d ${CISA_HOME} gophish-v${GOPHISH_VERSION}-linux-64bit.zip \
    && rm --force gophish-v${GOPHISH_VERSION}-linux-64bit.zip
RUN chmod +x ${CISA_HOME}/gophish \
    && ln --symbolic --no-dereference --force /run/secrets/config.json ${CISA_HOME}/config.json \
    && mkdir --parents ${CISA_HOME}/data \
    && ln --symbolic --no-dereference --force ${CISA_HOME}/data/gophish.db ${CISA_HOME}/gophish.db

###
# Remove install dependencies
###
RUN apt-get remove --quiet --quiet $INSTALL_DEPS

###
# Clean up aptitude cruft
###
RUN apt-get --quiet --quiet clean \
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
EXPOSE 3333/TCP 8080/TCP
ENTRYPOINT ["./gophish"]
