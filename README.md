
# How R packages are installed

## Random observations

- The posit public package manager (p3m) seems to contain multiple snapshot versions of compiled packages. As of September 3, 2025, the latest 8 versions of data.table (from 1.16.0 in October 10, 2024 up to 1.17.8 in July 10, 2025) are available as binaries for Mac OS arm64 chips. Nonetheless, running the same installer in the `rocker/r-ver:4.5.1` container results in a different behavior, always installing the source version of the package.