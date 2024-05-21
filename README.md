[![minimal-readme compliant](https://img.shields.io/badge/readme%20style-minimal-brightgreen.svg)](https://github.com/RichardLitt/standard-readme/blob/master/example-readmes/minimal-readme.md) [![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) <a href="https://liberapay.com/benz0li/donate"><img src="https://liberapay.com/assets/widgets/donate.svg" alt="Donate using Liberapay" height="20"></a>

| See the [CUDA-enabled Python docker stack](CUDA.md) for GPU accelerated docker images. |
|----------------------------------------------------------------------------------------|

# Python docker stack

Multi-arch (`linux/amd64`, `linux/arm64/v8`) docker images:

* [`glcr.b-data.ch/python/ver`](https://gitlab.b-data.ch/python/ver/container_registry)
* [`glcr.b-data.ch/python/base`](https://gitlab.b-data.ch/python/base/container_registry)
* [`glcr.b-data.ch/python/scipy`](https://gitlab.b-data.ch/python/scipy/container_registry)

Images considered stable for Python versions ≥ 3.10.5.

**Build chain**

ver → base → scipy

**Features**

`glcr.b-data.ch/python/ver` serves as parent image for
`glcr.b-data.ch/jupyterlab/python/base`.

The other images are counterparts to the JupyterLab images but **without**

* code-server
* IPython
* JupyterHub
* JupyterLab
  * JupyterLab Extensions
  * JupyterLab Integrations
* Jupyter Notebook
  * Jupyter Notebook Conversion
* LSP Server
* Oh My Zsh
  * Powerlevel10k Theme
  * MesloLGS NF Font
* Widgets

and any configuration thereof.

## Table of Contents

* [Prerequisites](#prerequisites)
* [Install](#install)
* [Usage](#usage)
* [Contributing](#contributing)
* [License](#license)

## Prerequisites

This projects requires an installation of docker.

## Install

To install docker, follow the instructions for your platform:

* [Install Docker Engine | Docker Documentation > Supported platforms](https://docs.docker.com/engine/install/#supported-platforms)
* [Post-installation steps for Linux](https://docs.docker.com/engine/install/linux-postinstall/)

## Usage

### Build image (ver)

*latest*:

```bash
docker build \
  --build-arg PYTHON_VERSION=3.12.3 \
  -t python/ver \
  -f ver/latest.Dockerfile .
```

*version*:

```bash
docker build \
  -t python/ver:MAJOR.MINOR.PATCH \
  -f ver/MAJOR.MINOR.PATCH.Dockerfile .
```

For `MAJOR.MINOR.PATCH` ≥ `3.10.5`.

### Run container

self built:

```bash
docker run -it --rm python/ver[:MAJOR.MINOR.PATCH]
```

from the project's GitLab Container Registries:

```bash
docker run -it --rm \
  IMAGE[:MAJOR[.MINOR[.PATCH]]]
```

`IMAGE` being one of

* [`glcr.b-data.ch/python/ver`](https://gitlab.b-data.ch/python/ver/container_registry)
* [`glcr.b-data.ch/python/base`](https://gitlab.b-data.ch/python/base/container_registry)
* [`glcr.b-data.ch/python/scipy`](https://gitlab.b-data.ch/python/scipy/container_registry)

## Contributing

PRs accepted.

This project follows the
[Contributor Covenant](https://www.contributor-covenant.org)
[Code of Conduct](CODE_OF_CONDUCT.md).

## License

Copyright © 2022 b-data GmbH

Distributed under the terms of the [MIT License](LICENSE).
