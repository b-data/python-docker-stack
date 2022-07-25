ARG PYTHON_VERSION
ARG NUMPY_VERSION=1.22.4
ARG SCIPY_VERSION=1.8.1
ARG CTAN_REPO=https://mirror.ctan.org/systems/texlive/tlnet

FROM registry.gitlab.b-data.ch/python/base:${PYTHON_VERSION}

ARG DEBIAN_FRONTEND=noninteractive

ARG NUMPY_VERSION
ARG SCIPY_VERSION
ARG CTAN_REPO

ENV NUMPY_VERSION=${NUMPY_VERSION} \
    SCIPY_VERSION=${SCIPY_VERSION} \
    CTAN_REPO=${CTAN_REPO} \
    PATH=/opt/TinyTeX/bin/linux:$PATH

RUN wget "https://travis-bin.yihui.name/texlive-local.deb" \
  && dpkg -i texlive-local.deb \
  && rm texlive-local.deb \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ffmpeg \
    fonts-roboto \
    ghostscript \
    libhunspell-dev \
    libicu-dev \
    libmagick++-dev \
    libpoppler-cpp-dev \
    qpdf \
    texinfo \
  ## Admin-based install of TinyTeX
  && wget -qO- "https://yihui.org/tinytex/install-unx.sh" \
    | sh -s - --admin --no-path \
  && mv ~/.TinyTeX /opt/TinyTeX \
  && ln -rs /opt/TinyTeX/bin/$(uname -m)-linux \
    /opt/TinyTeX/bin/linux \
  && /opt/TinyTeX/bin/linux/tlmgr path add \
  && tlmgr update --self \
  ## TeX packages as requested by the community
  && curl -sSLO https://yihui.org/gh/tinytex/tools/pkgs-yihui.txt \
  && tlmgr install $(cat pkgs-yihui.txt | tr '\n' ' ') \
  && rm -f pkgs-yihui.txt \
  ## TeX packages as in rocker/verse
  && tlmgr install \
    context \
    pdfcrop \
  ## TeX packages as in jupyter/scipy-notebook
  && tlmgr install \
    cm-super \
    dvipng \
  ## TeX packages specific for nbconvert
  && tlmgr install \
    oberdiek \
    titling \
  && tlmgr path add \
  && chown -R root:users /opt/TinyTeX \
  && chmod -R g+w /opt/TinyTeX \
  && chmod -R g+wx /opt/TinyTeX/bin \
  ## Build numpy and scipy using stock OpenBLAS
  && pip install --no-binary="numpy,scipy" \
    altair \
    beautifulsoup4 \
    bokeh \
    bottleneck \
    cloudpickle \
    cython \
    dask \
    dill \
    h5py \
    #ipympl \
    #ipywidgets \
    matplotlib \
    numba \
    numexpr \
    numpy==${NUMPY_VERSION} \
    pandas \
    patsy \
    protobuf \
    scikit-image \
    scikit-learn \
    scipy==${SCIPY_VERSION} \
    seaborn \
    sqlalchemy \
    statsmodels \
    sympy \
    tables \
    #widgetsnbextension \
    xlrd \
  ## Install facets
  #&& cd /tmp \
  #&& git clone https://github.com/PAIR-code/facets.git \
  #&& jupyter nbextension install facets/facets-dist/ --sys-prefix \
  #&& cd / \
  ## Clean up
  && rm -rf /tmp/* \
  && rm -rf /var/lib/apt/lists/* \
    $HOME/.cache \
    $HOME/.config \
    $HOME/.local \
    $HOME/.wget-hsts
