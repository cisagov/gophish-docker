ARG VERSION=unspecified

FROM debian:buster-slim

ARG VERSION

# For a list of pre-defined annotation keys and value types see:
# https://github.com/opencontainers/image-spec/blob/master/annotations.md
# Note: Additional labels are added by the build workflow.
LABEL org.opencontainers.image.authors="mark.feldhousen@cisa.dhs.gov"
LABEL org.opencontainers.image.vendor="Cyber and Infrastructure Security Agency"

ARG GOPHISH_VERSION="0.7.1"
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
RUN wget -nv https://github.com/gophish/gophish/releases/download/${GOPHISH_VERSION}/gophish-v${GOPHISH_VERSION}-linux-64bit.zip && \
unzip gophish-v${GOPHISH_VERSION}-linux-64bit.zip && \
rm -f gophish-v${GOPHISH_VERSION}-linux-64bit.zip

RUN chmod +x gophish && ln -snf /run/secrets/config.json config.json && \
mkdir -p data && ln -snf data/gophish.db gophish.db

EXPOSE 3333/TCP 8080/TCP
ENTRYPOINT ["./gophish"]
