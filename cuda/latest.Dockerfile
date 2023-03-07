ARG BUILD_ON_IMAGE

ARG CUDA_HOME=/usr/local/cuda
ARG NVBLAS_CONFIG_FILE=/etc/nvblas.conf

FROM ${BUILD_ON_IMAGE}

ARG CUDA_IMAGE_FLAVOR
ARG CUPTI_AVAILABLE
ARG BUILD_START

ARG CUDA_HOME
ARG NVBLAS_CONFIG_FILE

ENV CUDA_HOME=${CUDA_HOME} \
    NVBLAS_CONFIG_FILE=${NVBLAS_CONFIG_FILE} \
    LD_LIBRARY_PATH=${LD_LIBRARY_PATH}${LD_LIBRARY_PATH:+:}${CUDA_HOME}/lib:${CUDA_HOME}/lib64${CUPTI_AVAILABLE:+:${CUDA_HOME}/extras/CUPTI/lib64} \
    BUILD_DATE=${BUILD_START}

RUN cpuBlasLib="$(update-alternatives --query \
  libblas.so.3-$(uname -m)-linux-gnu | grep Value | cut -f2 -d' ')" \
  && dpkgArch="$(dpkg --print-architecture)" \
  ## NVBLAS log configuration
  && touch /var/log/nvblas.log \
  && chown :users /var/log/nvblas.log \
  && chmod g+rw /var/log/nvblas.log \
  ## NVBLAS configuration using all compute-capable GPUs
  && echo "NVBLAS_LOGFILE /var/log/nvblas.log" > $NVBLAS_CONFIG_FILE \
  && echo "NVBLAS_CPU_BLAS_LIB $cpuBlasLib" >> $NVBLAS_CONFIG_FILE \
  && echo "NVBLAS_GPU_LIST ALL" >> $NVBLAS_CONFIG_FILE \
  ## Install TensorRT
  ## libnvinfer is not yet available for Ubuntu 22.04 on sbsa (arm64)
  && if [ ${dpkgArch} = "amd64" -o ! ${BASE_IMAGE} = "ubuntu:22.04" ]; then \
    ## Install development libraries and headers
    ## if devel-flavor of CUDA image is used
    if [ ${CUDA_IMAGE_FLAVOR} = "devel" ]; then dev="-dev"; fi; \
    apt-get update; \
    apt-get -y install --no-install-recommends \
      libnvinfer${dev:-[0-9]+} \
      libnvinfer-plugin${dev:-[0-9]+}; \
    ## TensorFlow versions < 2.12 expect TensorRT libraries version 7
    ## Create symlink when only TensorRT libraries version > 7 are available
    trtRunLib=$(ls -d /usr/lib/$(uname -m)-linux-gnu/* | \
      grep 'libnvinfer.so.[0-9]\+$'); \
    trtPluLib=$(ls -d /usr/lib/$(uname -m)-linux-gnu/* | \
      grep 'libnvinfer_plugin.so.[0-9]\+$'); \
    if [ "$(echo $trtRunLib | sed -n 's/.*\([0-9]\+\)/\1/p')" -gt "7" ]; then \
      ln -rs $trtRunLib /usr/lib/$(uname -m)-linux-gnu/libnvinfer.so.7; \
      ln -rs $trtPluLib /usr/lib/$(uname -m)-linux-gnu/libnvinfer_plugin.so.7; \
    fi \
  fi \
  ## Clean up
  && rm -rf /var/lib/apt/lists/*
