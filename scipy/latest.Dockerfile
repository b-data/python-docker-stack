ARG PYTHON_VERSION
ARG CTAN_REPO=https://mirror.ctan.org/systems/texlive/tlnet

FROM registry.gitlab.b-data.ch/python/base:${PYTHON_VERSION}

ARG DEBIAN_FRONTEND=noninteractive

ARG CTAN_REPO

ENV CTAN_REPO=${CTAN_REPO} \
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
  && tlmgr install \
    ae \
    cm-super \
    context \
    dvipng \
    listings \
    makeindex \
    parskip \
    pdfcrop \
  && tlmgr path add \
  && chown -R root:users /opt/TinyTeX \
  && chmod -R g+w /opt/TinyTeX \
  && chmod -R g+wx /opt/TinyTeX/bin \
  ## Build numpy and scipy using stock OpenBLAS
  && pip install --no-binary=":all:" \
    numpy \
    scipy \
  ## Install Python packages
  && pip install \
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
    pandas \
    patsy \
    protobuf \
    scikit-image \
    scikit-learn \
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
