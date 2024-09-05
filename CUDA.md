# CUDA-based Python docker stack

GPU accelerated, multi-arch (`linux/amd64`, `linux/arm64/v8`) docker images:

* [`glcr.b-data.ch/cuda/python/ver`](https://gitlab.b-data.ch/cuda/python/ver/container_registry)
* [`glcr.b-data.ch/cuda/python/base`](https://gitlab.b-data.ch/cuda/python/base/container_registry)
* [`glcr.b-data.ch/cuda/python/scipy`](https://gitlab.b-data.ch/cuda/python/scipy/container_registry)

Images available for Python versions ≥ 3.11.1.

**Build chain**

The same as the [Python docker stack](README.md#python-docker-stack).

**Features**

`glcr.b-data.ch/cuda/python/ver:*-devel` serves as parent image for
`glcr.b-data.ch/jupyterlab/cuda/python/base`.

Otherwise the same as the [Python docker stack](README.md#python-docker-stack) plus

* CUDA runtime,
  [CUDA math libraries](https://developer.nvidia.com/gpu-accelerated-libraries),
  [NCCL](https://developer.nvidia.com/nccl) and
  [cuDNN](https://developer.nvidia.com/cudnn)
* TensortRT and TensorRT plugin libraries

## Table of Contents

* [Prerequisites](#prerequisites)
* [Install](#install)
* [Usage](#usage)

## Prerequisites

The same as the [Python docker stack](README.md#prerequisites) plus

* NVIDIA GPU
* NVIDIA Linux driver
* NVIDIA Container Toolkit

:information_source: The host running the GPU accelerated images only requires
the NVIDIA driver, the CUDA toolkit does not have to be installed.

## Install

To install the NVIDIA Container Toolkit, follow the instructions for your
platform:

* [Installation Guide &mdash; NVIDIA Cloud Native Technologies documentation](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#supported-platforms)

## Usage

### Build image (ver)

latest:

*stage 1*

```bash
docker build \
  --build-arg BASE_IMAGE=ubuntu \
  --build-arg BASE_IMAGE_TAG=22.04 \
  --build-arg CUDA_IMAGE=nvidia/cuda \
  --build-arg CUDA_VERSION=12.6.1 \
  --build-arg CUDA_IMAGE_SUBTAG=runtime-ubuntu22.04 \
  --build-arg PYTHON_VERSION=3.12.5 \
  -t cuda/python/ver \
  -f ver/latest.Dockerfile .
```

*stage 2*

```bash
docker build \
  --build-arg BUILD_ON_IMAGE=cuda/python/ver \
  --build-arg CUDNN_VERSION=8.9.7.29 \
  --build-arg CUDNN_CUDA_VERSION_MAJ_MIN=12.2 \
  --build-arg LIBNVINFER_VERSION=10.3.0.26 \
  --build-arg LIBNVINFER_CUDA_VERSION_MAJ_MIN=12.5 \
  --build-arg CUDA_IMAGE_FLAVOR=runtime \
  -t cuda/python/ver \
  -f cuda/latest.Dockerfile .
```

version:

*stage 1*

```bash
docker build \
  --build-arg BASE_IMAGE=ubuntu \
  --build-arg BASE_IMAGE_TAG=22.04 \
  --build-arg CUDA_IMAGE=nvidia/cuda \
  --build-arg CUDA_IMAGE_SUBTAG=[cudnn8-]runtime-ubuntu22.04 \
  -t cuda/python/ver:MAJOR.MINOR.PATCH \
  -f ver/MAJOR.MINOR.PATCH.Dockerfile .
```

*stage 2*

```bash
docker build \
  --build-arg BUILD_ON_IMAGE=cuda/python/ver:MAJOR.MINOR.PATCH \
  --build-arg CUDA_IMAGE_FLAVOR=runtime \
  -t cuda/python/ver:MAJOR.MINOR.PATCH \
  -f cuda/MAJOR.MINOR.PATCH.Dockerfile .
```

For `MAJOR.MINOR.PATCH` ≥ `3.11.1`.

### Run container

self built:

```bash
docker run -it --rm \
  --gpus '"device=all"' \
  cuda/python/ver[:MAJOR.MINOR.PATCH]
```

from the project's GitLab Container Registries:

```bash
docker run -it --rm \
  --gpus '"device=all"' \
  IMAGE[:MAJOR[.MINOR[.PATCH]]]
```

`IMAGE` being one of

* [`glcr.b-data.ch/cuda/python/ver`](https://gitlab.b-data.ch/cuda/python/ver/container_registry)
* [`glcr.b-data.ch/cuda/python/base`](https://gitlab.b-data.ch/cuda/python/base/container_registry)
* [`glcr.b-data.ch/cuda/python/scipy`](https://gitlab.b-data.ch/cuda/python/scipy/container_registry)

See [Notes](NOTES.md) for tweaks.
