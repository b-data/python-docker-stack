ARG BUILD_ON_IMAGE=glcr.b-data.ch/python/base
ARG PYTHON_VERSION
ARG QUARTO_VERSION=1.8.27
ARG CTAN_REPO=https://mirror.ctan.org/systems/texlive/tlnet

FROM ${BUILD_ON_IMAGE}${PYTHON_VERSION:+:$PYTHON_VERSION}

ARG DEBIAN_FRONTEND=noninteractive

ARG NB_GID=100

ARG BUILD_ON_IMAGE
ARG QUARTO_VERSION
ARG CTAN_REPO
ARG CTAN_REPO_BUILD_LATEST
ARG BUILD_START

ENV PARENT_IMAGE=${BUILD_ON_IMAGE}${PYTHON_VERSION:+:$PYTHON_VERSION} \
    QUARTO_VERSION=${QUARTO_VERSION} \
    BUILD_DATE=${BUILD_START}

ENV PATH=/opt/TinyTeX/bin/linux:/opt/quarto/bin:$PATH

RUN dpkgArch="$(dpkg --print-architecture)" \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    fonts-roboto \
    ghostscript \
    librsvg2-bin \
    qpdf \
    texinfo \
    ## Python: For h5py wheels (arm64)
    libhdf5-dev \
  ## Install quarto
  && curl -sLO https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-${dpkgArch}.tar.gz \
  && mkdir -p /opt/quarto \
  && tar -xzf quarto-${QUARTO_VERSION}-linux-${dpkgArch}.tar.gz -C /opt/quarto --no-same-owner --strip-components=1 \
  && rm quarto-${QUARTO_VERSION}-linux-${dpkgArch}.tar.gz \
  ## Exempt quarto from address space limit
  && sed -i 's/"${QUARTO_DENO}"/prlimit --as=unlimited: "${QUARTO_DENO}"/g' \
    /opt/quarto/bin/quarto \
  ## Remove quarto pandoc
  && rm /opt/quarto/bin/tools/$(uname -m)/pandoc \
  ## Link to system pandoc
  && ln -s /usr/bin/pandoc /opt/quarto/bin/tools/$(uname -m)/pandoc \
  ## Tell APT about the TeX Live installation
  ## by building a dummy package using equivs
  && apt-get install -y --no-install-recommends equivs \
  && cd /tmp \
  && wget https://github.com/scottkosty/install-tl-ubuntu/raw/master/debian-control-texlive-in.txt \
  && equivs-build debian-* \
  && mv texlive-local*.deb texlive-local.deb \
  && dpkg -i texlive-local.deb \
  && apt-get -y purge equivs \
  && apt-get -y autoremove \
  ## Admin-based install of TinyTeX
  && CTAN_REPO_ORIG=${CTAN_REPO} \
  && CTAN_REPO=${CTAN_REPO_BUILD_LATEST:-$CTAN_REPO} \
  && export CTAN_REPO \
  && wget -qO- "https://yihui.org/tinytex/install-unx.sh" \
    | sh -s - --admin --no-path \
  && mv ${HOME}/.TinyTeX /opt/TinyTeX \
  && sed -i "s|${HOME}/.TinyTeX|/opt/TinyTeX|g" \
    /opt/TinyTeX/texmf-var/fonts/conf/texlive-fontconfig.conf \
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
  && tlmgr option repository ${CTAN_REPO_ORIG} \
  && chown -R root:${NB_GID} /opt/TinyTeX \
  && chmod -R g+w /opt/TinyTeX \
  && chmod -R g+wx /opt/TinyTeX/bin \
  ## Make the TeX Live fonts available as system fonts
  && cp /opt/TinyTeX/texmf-var/fonts/conf/texlive-fontconfig.conf \
    /etc/fonts/conf.d/09-texlive.conf \
  && fc-cache -fsv \
  ## Install Python packages
  && export PIP_BREAK_SYSTEM_PACKAGES=1 \
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
    tables \
    #widgetsnbextension \
    xlrd \
  ## Clean up
  && rm -rf /tmp/* \
  && rm -rf /var/lib/apt/lists/* \
    ${HOME}/.cache \
    ${HOME}/.config \
    ${HOME}/.local \
    ${HOME}/.wget-hsts

ENV CTAN_REPO=${CTAN_REPO}
