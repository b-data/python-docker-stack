ARG BASE_IMAGE=debian:bullseye
ARG BLAS=libopenblas-dev
ARG PYTHON_VERSION=3.10.5
ARG PYTHON_SUBTAG=slim-bullseye

FROM python:${PYTHON_VERSION}-${PYTHON_SUBTAG} as psi

FROM ${BASE_IMAGE}

LABEL org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://gitlab.b-data.ch/python/docker-stack" \
      org.opencontainers.image.vendor="b-data GmbH" \
      org.opencontainers.image.authors="Olivier Benz <olivier.benz@b-data.ch>"

ARG DEBIAN_FRONTEND=noninteractive

ARG BASE_IMAGE
ARG BLAS
ARG PYTHON_VERSION

ENV BASE_IMAGE=${BASE_IMAGE} \
    PYTHON_VERSION=${PYTHON_VERSION} \
    LANG=en_US.UTF-8 \
    TERM=xterm \
    TZ=Etc/UTC

## Install Python
COPY --from=psi /usr/local /usr/local

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    libexpat1-dev \
    libjs-sphinxdoc \
    liblapack-dev \
    ${BLAS} \
    locales \
    netbase \
    tzdata \
    unzip \
    zip \
    zlib1g-dev \
  ## Update locale
  && sed -i "s/# $LANG/$LANG/g" /etc/locale.gen \
  && locale-gen \
  && update-locale LANG=$LANG \
  ## Switch BLAS/LAPACK (manual mode)
  && if [ ${BLAS} = "libopenblas-dev" ]; then \
    update-alternatives --set libblas.so.3-$(uname -m)-linux-gnu \
      /usr/lib/$(uname -m)-linux-gnu/openblas-pthread/libblas.so.3; \
    update-alternatives --set liblapack.so.3-$(uname -m)-linux-gnu \
      /usr/lib/$(uname -m)-linux-gnu/openblas-pthread/liblapack.so.3; \
  fi \
  ## Clean up
  && rm -rf /var/lib/apt/lists/*

CMD ["python3"]
