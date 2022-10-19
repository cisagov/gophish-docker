ARG VERSION=unspecified

FROM debian:bullseye-slim

ARG VERSION

# For a list of pre-defined annotation keys and value types see:
# https://github.com/opencontainers/image-spec/blob/master/annotations.md
# Note: Additional labels are added by the build workflow.
LABEL org.opencontainers.image.authors="mark.feldhousen@cisa.dhs.gov"
LABEL org.opencontainers.image.vendor="Cybersecurity and Infrastructure Security Agency"

ARG GOPHISH_VERSION="0.11.0-cisa.1"
ARG CISA_UID=421
ENV CISA_HOME="/home/cisa" \
    SCRIPT_DIR="/usr/local/bin"

RUN addgroup --system --gid ${CISA_UID} cisa \
  && adduser --system --uid ${CISA_UID} --ingroup cisa cisa

RUN apt-get update && \
apt-get install --no-install-recommends -y \
unzip \
ca-certificates \
wget && \
apt-get install -y sqlite3 libsqlite3-dev && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY bin/get-api-key ${SCRIPT_DIR}

USER cisa
WORKDIR ${CISA_HOME}
# TODO: Revert from cisagov/gophish back to gophish/gophish after all of our
# pull requests have been merged; including, but potentially not limited to:
# - https://github.com/gophish/gophish/pull/1484
# - https://github.com/gophish/gophish/pull/1486
# See https://github.com/cisagov/gophish-docker/issues/25 for details.
RUN wget -nv https://github.com/cisagov/gophish/releases/download/v${GOPHISH_VERSION}/gophish-v${GOPHISH_VERSION}-linux-64bit.zip && \
unzip gophish-v${GOPHISH_VERSION}-linux-64bit.zip && \
rm -f gophish-v${GOPHISH_VERSION}-linux-64bit.zip

RUN chmod +x gophish && ln -snf /run/secrets/config.json config.json && \
mkdir -p data && ln -snf data/gophish.db gophish.db

EXPOSE 3333/TCP 8080/TCP
ENTRYPOINT ["./gophish"]
