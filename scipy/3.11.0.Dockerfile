ARG BUILD_ON_IMAGE=registry.gitlab.b-data.ch/python/base
ARG PYTHON_VERSION=3.11.0
ARG QUARTO_VERSION=1.2.269
ARG CTAN_REPO=https://mirror.ctan.org/systems/texlive/tlnet

FROM ${BUILD_ON_IMAGE}:${PYTHON_VERSION}

ARG DEBIAN_FRONTEND=noninteractive

ARG BUILD_ON_IMAGE
ARG QUARTO_VERSION
ARG CTAN_REPO

ENV PARENT_IMAGE=${BUILD_ON_IMAGE}:${PYTHON_VERSION} \
    CTAN_REPO=${CTAN_REPO} \
    PATH=/opt/TinyTeX/bin/linux:/opt/quarto/bin:$PATH

RUN dpkgArch="$(dpkg --print-architecture)" \
  && wget "https://travis-bin.yihui.name/texlive-local.deb" \
  && dpkg -i texlive-local.deb \
  && rm texlive-local.deb \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    fonts-roboto \
    ghostscript \
    qpdf \
    texinfo \
    ## For tables wheels
    libblosc-dev \
    libbz2-dev \
    libhdf5-dev \
    liblzo2-dev \
  && if [ ${dpkgArch} = "amd64" ]; then \
    ## Install quarto
    curl -sLO https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-${dpkgArch}.tar.gz; \
    mkdir -p /opt/quarto; \
    tar -xzf quarto-${QUARTO_VERSION}-linux-${dpkgArch}.tar.gz -C /opt/quarto --no-same-owner --strip-components=1; \
    rm quarto-${QUARTO_VERSION}-linux-${dpkgArch}.tar.gz; \
    ## Apply patch
    echo '\n\
    79064,79065c79064,79069\n\
    <         const sep = path.startsWith("/") ? "" : "/";\n\
    <         const browseUrl = vsCodeServerProxyUri().replace("{{port}}", `${port}`) + sep + path;\n\
    ---\n\
    >         if (vsCodeServerProxyUri().endsWith("/")) {\n\
    >             path = path.startsWith("/") ? path.slice(1) : path;\n\
    >         } else {\n\
    >             path = path.startsWith("/") ? path : "/" + path;\n\
    >         }\n\
    >         const browseUrl = vsCodeServerProxyUri().replace("{{port}}", `${port}`) + path;\n\
    ' | patch /opt/quarto/bin/quarto.js; \
    ## Remove quarto pandoc
    rm /opt/quarto/bin/tools/pandoc; \
    ## Link to system pandoc
    ln -s /usr/bin/pandoc /opt/quarto/bin/tools/pandoc; \
  fi \
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
  && chown -R root:${NB_GID} /opt/TinyTeX \
  && chmod -R g+w /opt/TinyTeX \
  && chmod -R g+wx /opt/TinyTeX/bin \
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
    #numba \
    numexpr \
    numpy \
    pandas \
    patsy \
    protobuf \
    scikit-image \
    scikit-learn \
    scipy \
    seaborn \
    sqlalchemy \
    statsmodels \
    sympy \
    git+https://github.com/PyTables/PyTables.git@master \
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
