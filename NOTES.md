# Notes

## Tweaks

These images are tweaked as follows:

### Environment variables

**Versions**

* `PYTHON_VERSION`
* `GIT_VERSION`
* `GIT_LFS_VERSION`
* `PANDOC_VERSION`
* `QUARTO_VERSION` (scipy image)

**Miscellaneous**

* `BASE_IMAGE`: Its very base, a [Docker Official Image](https://hub.docker.com/search?q=&type=image&image_filter=official).
* `PARENT_IMAGE`: The image it was derived from.
* `BUILD_DATE`: The date it was built (ISO 8601 format).
* `CTAN_REPO`: The CTAN mirror URL. (scipy image)

### TeX packages (scipy image)

In addition to the TeX packages used in
[rocker/verse](https://github.com/rocker-org/rocker-versioned2/blob/master/scripts/install_texlive.sh),
[jupyter/scipy-notebook](https://github.com/jupyter/docker-stacks/blob/main/scipy-notebook/Dockerfile)
and required for `nbconvert`, the
[packages requested by the community](https://yihui.org/gh/tinytex/tools/pkgs-yihui.txt)
are installed.

## Python

The latest Python version is installed at `/usr/local/bin`, regardless of
whether all packages – such as numba, tensorflow, etc. – are already compatible
with it.
