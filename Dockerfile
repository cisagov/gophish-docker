FROM debian:buster-slim
MAINTAINER Mark Feldhousen <mark.feldhousen@trio.dhs.gov>

ARG GOPHISH_VERSION="0.7.1"
ARG CISA_UID=421
ENV CISA_HOME="/home/cisa" \
    SCRIPT_SRC="/user/src/scripts"

RUN addgroup --system --gid ${CISA_UID} cisa \
  && adduser --system --uid ${CISA_UID} --ingroup cisa cisa

RUN apt-get update && \
apt-get install --no-install-recommends -y \
unzip \
ca-certificates \
wget && \
apt-get install -y sqlite3 libsqlite3-dev && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY bin ${SCRIPT_SRC}/bin
RUN chmod +x ${SCRIPT_SRC}/bin/*
RUN ln -snf ${SCRIPT_SRC}/bin/* /usr/local/bin

USER cisa
WORKDIR ${CISA_HOME}
RUN wget -nv https://github.com/gophish/gophish/releases/download/${GOPHISH_VERSION}/gophish-v${GOPHISH_VERSION}-linux-64bit.zip && \
unzip gophish-v${GOPHISH_VERSION}-linux-64bit.zip && \
rm -f gophish-v${GOPHISH_VERSION}-linux-64bit.zip

RUN chmod +x gophish && ln -snf /run/secrets/config.json config.json

EXPOSE 3333/TCP 8080/TCP
ENTRYPOINT ["./gophish"]
