
[![Install an R package](https://github.com/gvegayon/r-pkg-installs/actions/workflows/install_an_r_package.yaml/badge.svg)](https://github.com/gvegayon/r-pkg-installs/actions/workflows/install_an_r_package.yaml)

# How R packages are installed

This repository contains a workflow that analyzes different strategies for installing R packages. Particularly, it compares using `install.packages()` vs `pak::pkg_install()` in different combinations of CRAN versions as well as architectures. The main workflow [here](./.github/workflows/install_an_r_package.yaml) runs the installs and saves the output as csv files under [data](./data).

## Random observations

- The posit public package manager (p3m) seems to contain multiple snapshot versions of compiled packages. As of September 3, 2025, the latest 8 versions of data.table (from 1.16.0 in October 10, 2024 up to 1.17.8 in July 10, 2025) are available as binaries for Mac OS arm64 chips. Nonetheless, running the same installer in the `rocker/r-ver:4.5.1` container results in a different behavior, always installing the source version of the package.