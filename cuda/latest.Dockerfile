ARG CUDNN_VERSION
ARG CUDNN_VERSION_AMD64=${CUDNN_VERSION}
ARG CUDNN_VERSION_ARM64=${CUDNN_VERSION}
ARG CUDNN_CUDA_VERSION_MAJ_MIN

ARG LIBNVINFER_VERSION
ARG LIBNVINFER_VERSION_AMD64=${LIBNVINFER_VERSION}
ARG LIBNVINFER_VERSION_ARM64=${LIBNVINFER_VERSION}
ARG LIBNVINFER_CUDA_VERSION_MAJ_MIN

ARG BUILD_ON_IMAGE
ARG CUDNN_VERSION_MAJ=${CUDNN_VERSION%%.*}
ARG CUDNN_VERSION_MAJ=${CUDNN_VERSION_MAJ:-${CUDNN_VERSION_AMD64%%.*}}
ARG CUDNN_VERSION_MAJ=${CUDNN_VERSION_MAJ:-${CUDNN_VERSION_ARM64%%.*}}
ARG CUDA_IMAGE_FLAVOR

FROM ${BUILD_ON_IMAGE} AS cudnn8-runtime-amd64

ARG CUDNN_VERSION_AMD64
ARG CUDNN_CUDA_VERSION_MAJ_MIN

LABEL com.nvidia.cudnn.version="${CUDNN_VERSION_AMD64}"

ENV CUDNN_VERSION=${CUDNN_VERSION_AMD64}
ENV NV_CUDNN_PACKAGE_VERSION=${CUDNN_VERSION_AMD64}
ENV NV_CUDNN_PACKAGE_NAME=libcudnn${NV_CUDNN_PACKAGE_VERSION%%.*}
ENV NV_CUDNN_PACKAGE="${NV_CUDNN_PACKAGE_NAME}=${NV_CUDNN_PACKAGE_VERSION}-1+cuda${CUDNN_CUDA_VERSION_MAJ_MIN}"

FROM ${BUILD_ON_IMAGE} AS cudnn8-runtime-arm64

ARG CUDNN_VERSION_ARM64
ARG CUDNN_CUDA_VERSION_MAJ_MIN

LABEL com.nvidia.cudnn.version="${CUDNN_VERSION_ARM64}"

ENV CUDNN_VERSION=${CUDNN_VERSION_ARM64}
ENV NV_CUDNN_PACKAGE_VERSION=${CUDNN_VERSION_ARM64}
ENV NV_CUDNN_PACKAGE_NAME=libcudnn${NV_CUDNN_PACKAGE_VERSION%%.*}
ENV NV_CUDNN_PACKAGE="${NV_CUDNN_PACKAGE_NAME}=${NV_CUDNN_PACKAGE_VERSION}-1+cuda${CUDNN_CUDA_VERSION_MAJ_MIN}"

FROM ${BUILD_ON_IMAGE} AS cudnn8-devel-amd64

ARG CUDNN_VERSION_AMD64
ARG CUDNN_CUDA_VERSION_MAJ_MIN

LABEL com.nvidia.cudnn.version="${CUDNN_VERSION_AMD64}"

ENV CUDNN_VERSION=${CUDNN_VERSION_AMD64}
ENV NV_CUDNN_PACKAGE_VERSION=${CUDNN_VERSION_AMD64}
ENV NV_CUDNN_DEV_PACKAGE_VERSION=${CUDNN_VERSION_AMD64}
ENV NV_CUDNN_PACKAGE_NAME=libcudnn${NV_CUDNN_PACKAGE_VERSION%%.*}
ENV NV_CUDNN_DEV_PACKAGE_NAME=libcudnn${NV_CUDNN_DEV_PACKAGE_VERSION%%.*}-dev
ENV NV_CUDNN_PACKAGE="${NV_CUDNN_PACKAGE_NAME}=${NV_CUDNN_PACKAGE_VERSION}-1+cuda${CUDNN_CUDA_VERSION_MAJ_MIN}"
ENV NV_CUDNN_DEV_PACKAGE="${NV_CUDNN_DEV_PACKAGE_NAME}=${NV_CUDNN_DEV_PACKAGE_VERSION}-1+cuda${CUDNN_CUDA_VERSION_MAJ_MIN}"

FROM ${BUILD_ON_IMAGE} AS cudnn8-devel-arm64

ARG CUDNN_VERSION_ARM64
ARG CUDNN_CUDA_VERSION_MAJ_MIN

LABEL com.nvidia.cudnn.version="${CUDNN_VERSION_ARM64}"

ENV CUDNN_VERSION=${CUDNN_VERSION_ARM64}
ENV NV_CUDNN_PACKAGE_VERSION=${CUDNN_VERSION_ARM64}
ENV NV_CUDNN_DEV_PACKAGE_VERSION=${CUDNN_VERSION_ARM64}
ENV NV_CUDNN_PACKAGE_NAME=libcudnn${NV_CUDNN_PACKAGE_VERSION%%.*}
ENV NV_CUDNN_DEV_PACKAGE_NAME=libcudnn${NV_CUDNN_DEV_PACKAGE_VERSION%%.*}-dev
ENV NV_CUDNN_PACKAGE="${NV_CUDNN_PACKAGE_NAME}=${NV_CUDNN_PACKAGE_VERSION}-1+cuda${CUDNN_CUDA_VERSION_MAJ_MIN}"
ENV NV_CUDNN_DEV_PACKAGE="${NV_CUDNN_DEV_PACKAGE_NAME}=${NV_CUDNN_DEV_PACKAGE_VERSION}-1+cuda${CUDNN_CUDA_VERSION_MAJ_MIN}"

FROM ${BUILD_ON_IMAGE} AS cudnn9-runtime-amd64

ARG CUDNN_VERSION_AMD64
ARG CUDNN_CUDA_VERSION_MAJ_MIN

LABEL com.nvidia.cudnn.version="${CUDNN_VERSION_AMD64}"

ENV CUDNN_VERSION=${CUDNN_VERSION_AMD64}
ENV NV_CUDNN_PACKAGE_VERSION=${CUDNN_VERSION_AMD64}
ENV NV_CUDNN_PACKAGE_NAME=libcudnn${NV_CUDNN_PACKAGE_VERSION%%.*}-cuda-${CUDNN_CUDA_VERSION_MAJ_MIN%%.*}
ENV NV_CUDNN_PACKAGE="${NV_CUDNN_PACKAGE_NAME}=${NV_CUDNN_PACKAGE_VERSION}-1"

FROM ${BUILD_ON_IMAGE} AS cudnn9-runtime-arm64

ARG CUDNN_VERSION_ARM64
ARG CUDNN_CUDA_VERSION_MAJ_MIN

LABEL com.nvidia.cudnn.version="${CUDNN_VERSION_ARM64}"

ENV CUDNN_VERSION=${CUDNN_VERSION_ARM64}
ENV NV_CUDNN_PACKAGE_VERSION=${CUDNN_VERSION_ARM64}
ENV NV_CUDNN_PACKAGE_NAME=libcudnn${NV_CUDNN_PACKAGE_VERSION%%.*}-cuda-${CUDNN_CUDA_VERSION_MAJ_MIN%%.*}
ENV NV_CUDNN_PACKAGE="${NV_CUDNN_PACKAGE_NAME}=${NV_CUDNN_PACKAGE_VERSION}-1"

FROM ${BUILD_ON_IMAGE} AS cudnn9-devel-amd64

ARG CUDNN_VERSION_AMD64
ARG CUDNN_CUDA_VERSION_MAJ_MIN

LABEL com.nvidia.cudnn.version="${CUDNN_VERSION_AMD64}"

ENV CUDNN_VERSION=${CUDNN_VERSION_AMD64}
ENV NV_CUDNN_PACKAGE_VERSION=${CUDNN_VERSION_AMD64}
ENV NV_CUDNN_DEV_PACKAGE_VERSION=${CUDNN_VERSION_AMD64}
ENV NV_CUDNN_PACKAGE_NAME=libcudnn${NV_CUDNN_PACKAGE_VERSION%%.*}-cuda-${CUDNN_CUDA_VERSION_MAJ_MIN%%.*}
ENV NV_CUDNN_DEV_PACKAGE_NAME=libcudnn${NV_CUDNN_DEV_PACKAGE_VERSION%%.*}-dev-cuda-${CUDNN_CUDA_VERSION_MAJ_MIN%%.*}
ENV NV_CUDNN_PACKAGE="${NV_CUDNN_PACKAGE_NAME}=${NV_CUDNN_PACKAGE_VERSION}-1"
ENV NV_CUDNN_DEV_PACKAGE="${NV_CUDNN_DEV_PACKAGE_NAME}=${NV_CUDNN_DEV_PACKAGE_VERSION}-1"

FROM ${BUILD_ON_IMAGE} AS cudnn9-devel-arm64

ARG CUDNN_VERSION_ARM64
ARG CUDNN_CUDA_VERSION_MAJ_MIN

LABEL com.nvidia.cudnn.version="${CUDNN_VERSION_ARM64}"

ENV CUDNN_VERSION=${CUDNN_VERSION_ARM64}
ENV NV_CUDNN_PACKAGE_VERSION=${CUDNN_VERSION_ARM64}
ENV NV_CUDNN_DEV_PACKAGE_VERSION=${CUDNN_VERSION_ARM64}
ENV NV_CUDNN_PACKAGE_NAME=libcudnn${NV_CUDNN_PACKAGE_VERSION%%.*}-cuda-${CUDNN_CUDA_VERSION_MAJ_MIN%%.*}
ENV NV_CUDNN_DEV_PACKAGE_NAME=libcudnn${NV_CUDNN_DEV_PACKAGE_VERSION%%.*}-dev-cuda-${CUDNN_CUDA_VERSION_MAJ_MIN%%.*}
ENV NV_CUDNN_PACKAGE="${NV_CUDNN_PACKAGE_NAME}=${NV_CUDNN_PACKAGE_VERSION}-1"
ENV NV_CUDNN_DEV_PACKAGE="${NV_CUDNN_DEV_PACKAGE_NAME}=${NV_CUDNN_DEV_PACKAGE_VERSION}-1"

FROM cudnn${CUDNN_VERSION_MAJ}-${CUDA_IMAGE_FLAVOR}-${TARGETARCH}

ARG DEBIAN_FRONTEND=noninteractive

ARG LIBNVINFER_VERSION_AMD64
ARG LIBNVINFER_VERSION_ARM64
ARG LIBNVINFER_CUDA_VERSION_MAJ_MIN

ARG CUDA_HOME=/usr/local/cuda
ARG NVBLAS_CONFIG_FILE=/etc/nvblas.conf

ARG CUDA_IMAGE_FLAVOR
ARG CUPTI_AVAILABLE
ARG BUILD_START

ENV CUDA_HOME=${CUDA_HOME} \
    NVBLAS_CONFIG_FILE=${NVBLAS_CONFIG_FILE} \
    LD_LIBRARY_PATH=${LD_LIBRARY_PATH}${LD_LIBRARY_PATH:+:}${CUDA_HOME}/lib:${CUDA_HOME}/lib64${CUPTI_AVAILABLE:+:${CUDA_HOME}/extras/CUPTI/lib64} \
    BUILD_DATE=${BUILD_START}

RUN cpuBlasLib="$(update-alternatives --query \
  libblas.so.3-$(uname -m)-linux-gnu | grep Value | cut -f2 -d' ')" \
  && dpkgArch="$(dpkg --print-architecture)" \
  && CUDA_VERSION_MAJ_MIN_DASH=$(echo ${CUDA_VERSION%.*} | tr '.' '-') \
  ## Install the CUDA Runtime native dev links, headers
  && apt-get update \
  && apt-get -y install --no-install-recommends \
    cuda-cudart-dev-${CUDA_VERSION_MAJ_MIN_DASH}=${NV_CUDA_CUDART_VERSION} \
  ## Keep apt from auto upgrading the CUDA Runtime packages
  && apt-mark hold \
    cuda-cudart-${CUDA_VERSION_MAJ_MIN_DASH} \
    cuda-cudart-dev-${CUDA_VERSION_MAJ_MIN_DASH} \
  ## Unminimise if the system has been minimised
  && if [ ${CUDA_IMAGE_FLAVOR} = "devel" -a $(command -v unminimize) ]; then \
    sed -i "s/apt-get upgrade/#apt-get upgrade/g" "$(which unminimize)"; \
    yes | unminimize; \
    sed -i "s/#apt-get upgrade/apt-get upgrade/g" "$(which unminimize)"; \
  fi \
  ## NVBLAS log configuration
  && touch /var/log/nvblas.log \
  && chown :users /var/log/nvblas.log \
  && chmod g+rw /var/log/nvblas.log \
  ## NVBLAS configuration using all compute-capable GPUs
  && echo "NVBLAS_LOGFILE /var/log/nvblas.log" > $NVBLAS_CONFIG_FILE \
  && echo "NVBLAS_CPU_BLAS_LIB $cpuBlasLib" >> $NVBLAS_CONFIG_FILE \
  && echo "NVBLAS_GPU_LIST ALL" >> $NVBLAS_CONFIG_FILE \
  ## Install cuDNN
  && apt-get -y install --no-install-recommends \
    ${NV_CUDNN_PACKAGE} \
    ${NV_CUDNN_DEV_PACKAGE} \
  ## Keep apt from auto upgrading the cuDNN packages
  && apt-mark hold \
    ${NV_CUDNN_PACKAGE_NAME} \
    ${NV_CUDNN_DEV_PACKAGE_NAME} \
  ## Install TensorRT
  && case "$dpkgArch" in \
    amd64) LIBNVINFER_VERSION=$LIBNVINFER_VERSION_AMD64 ;; \
    arm64) LIBNVINFER_VERSION=$LIBNVINFER_VERSION_ARM64 ;; \
    *) echo "error: Architecture $dpkgArch unsupported"; exit 1 ;; \
  esac \
  ## Install development libraries and headers
  ## if devel-flavor of CUDA image is used
  && if [ ${CUDA_IMAGE_FLAVOR} = "devel" ]; then \
    dev="-dev"; \
    if dpkg --compare-versions ${LIBNVINFER_VERSION} gt "8.6"; then \
      headers="-headers"; \
    fi; \
  fi \
  && LIBNVINFER_VERSION_MAJ=${LIBNVINFER_VERSION%%.*} \
  && CUDA_VERSION_MAJ_MIN=${LIBNVINFER_CUDA_VERSION_MAJ_MIN:-${CUDA_VERSION%.*}} \
  && apt-get -y install --no-install-recommends \
    libnvinfer${LIBNVINFER_VERSION_MAJ}=${LIBNVINFER_VERSION}-1+cuda${CUDA_VERSION_MAJ_MIN} \
    libnvinfer${dev:-${LIBNVINFER_VERSION_MAJ}}=${LIBNVINFER_VERSION}-1+cuda${CUDA_VERSION_MAJ_MIN} \
    libnvinfer${headers}${dev:-${LIBNVINFER_VERSION_MAJ}}=${LIBNVINFER_VERSION}-1+cuda${CUDA_VERSION_MAJ_MIN} \
    libnvinfer-plugin${LIBNVINFER_VERSION_MAJ}=${LIBNVINFER_VERSION}-1+cuda${CUDA_VERSION_MAJ_MIN} \
    libnvinfer-plugin${dev:-${LIBNVINFER_VERSION_MAJ}}=${LIBNVINFER_VERSION}-1+cuda${CUDA_VERSION_MAJ_MIN} \
    libnvinfer${headers}-plugin${dev:-${LIBNVINFER_VERSION_MAJ}}=${LIBNVINFER_VERSION}-1+cuda${CUDA_VERSION_MAJ_MIN} \
  ## Keep apt from auto upgrading the libnvinfer packages
  && apt-mark hold \
    libnvinfer${LIBNVINFER_VERSION_MAJ} \
    libnvinfer${dev:-${LIBNVINFER_VERSION_MAJ}} \
    libnvinfer${headers}${dev:-${LIBNVINFER_VERSION_MAJ}} \
    libnvinfer-plugin${LIBNVINFER_VERSION_MAJ} \
    libnvinfer-plugin${dev:-${LIBNVINFER_VERSION_MAJ}} \
    libnvinfer${headers}-plugin${dev:-${LIBNVINFER_VERSION_MAJ}} \
  ## Create symlink when only newer TensorRT libraries are available
  && trtRunLib=$(ls -d /usr/lib/$(uname -m)-linux-gnu/* | \
    grep 'libnvinfer.so.[0-9]\+$') \
  && trtPluLib=$(ls -d /usr/lib/$(uname -m)-linux-gnu/* | \
    grep 'libnvinfer_plugin.so.[0-9]\+$') \
  && if [ "$(echo $trtRunLib | sed -n 's/.*.so.\([0-9]\+\)/\1/p')" -gt "8" ]; then \
    ## TensorFlow versions < 2.18 expect TensorRT libraries version 8.6.1/8.6.2
    if [ "$dpkgArch" = "amd64" ]; then \
      ln -rs $trtRunLib /usr/lib/$(uname -m)-linux-gnu/libnvinfer.so.8.6.1; \
      ln -rs $trtPluLib /usr/lib/$(uname -m)-linux-gnu/libnvinfer_plugin.so.8.6.1; \
    fi; \
    if [ "$dpkgArch" = "arm64" ]; then \
      ln -rs $trtRunLib /usr/lib/$(uname -m)-linux-gnu/libnvinfer.so.8.6.2; \
      ln -rs $trtPluLib /usr/lib/$(uname -m)-linux-gnu/libnvinfer_plugin.so.8.6.2; \
    fi; \
    ## TensorFlow versions < 2.15 expect TensorRT libraries version 8
    ln -rs $trtRunLib /usr/lib/$(uname -m)-linux-gnu/libnvinfer.so.8; \
    ln -rs $trtPluLib /usr/lib/$(uname -m)-linux-gnu/libnvinfer_plugin.so.8; \
  fi \
  && if [ "$(echo $trtRunLib | sed -n 's/.*.so.\([0-9]\+\)/\1/p')" -gt "7" ]; then \
    ## TensorFlow versions < 2.12 expect TensorRT libraries version 7
    ln -rs $trtRunLib /usr/lib/$(uname -m)-linux-gnu/libnvinfer.so.7; \
    ln -rs $trtPluLib /usr/lib/$(uname -m)-linux-gnu/libnvinfer_plugin.so.7; \
  fi \
  ## Clean up
  && rm -rf /var/lib/apt/lists/*
