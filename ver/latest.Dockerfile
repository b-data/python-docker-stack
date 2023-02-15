ARG BASE_IMAGE=debian
ARG BASE_IMAGE_TAG=11
ARG CUDA_IMAGE
ARG CUDA_IMAGE_SUBTAG
ARG BLAS=libopenblas-dev
ARG CUDA_VERSION
ARG PYTHON_VERSION

FROM registry.gitlab.b-data.ch/python/psi/${PYTHON_VERSION}/${BASE_IMAGE}:${BASE_IMAGE_TAG} as psi

FROM ${CUDA_IMAGE:-$BASE_IMAGE}:${CUDA_IMAGE:+$CUDA_VERSION}${CUDA_IMAGE:+-}${CUDA_IMAGE_SUBTAG:-$BASE_IMAGE_TAG}

LABEL org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://gitlab.b-data.ch/python/docker-stack" \
      org.opencontainers.image.vendor="b-data GmbH" \
      org.opencontainers.image.authors="Olivier Benz <olivier.benz@b-data.ch>"

ARG DEBIAN_FRONTEND=noninteractive

ARG BASE_IMAGE
ARG BASE_IMAGE_TAG
ARG CUDA_IMAGE
ARG CUDA_IMAGE_SUBTAG
ARG BLAS
ARG CUDA_VERSION
ARG PYTHON_VERSION
ARG BUILD_START

ENV BASE_IMAGE=${BASE_IMAGE}:${BASE_IMAGE_TAG} \
    CUDA_IMAGE=${CUDA_IMAGE}${CUDA_IMAGE:+:}${CUDA_IMAGE:+$CUDA_VERSION}${CUDA_IMAGE:+-}${CUDA_IMAGE_SUBTAG} \
    PARENT_IMAGE=${CUDA_IMAGE:-$BASE_IMAGE}:${CUDA_IMAGE:+$CUDA_VERSION}${CUDA_IMAGE:+-}${CUDA_IMAGE_SUBTAG:-$BASE_IMAGE_TAG} \
    PYTHON_VERSION=${PYTHON_VERSION} \
    BUILD_DATE=${BUILD_START}

ENV LANG=en_US.UTF-8 \
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
    pkg-config \
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
