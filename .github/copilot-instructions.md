- This repository is for investigating and documenting the different aspects of how R packages are installed and managed.

- The repository will illustrate different events in which we try to install a handful of R package and focus on whether these were installed from a binary source or not.

- The preferred technology is podman.

- The scripts should be architecture-agnostic, so it should work in any environment (linux, mac, windows).

- Container files should be simple and avoid using complex build steps or dependencies, including docker-compose.

- For R, we will be using two base images: `rocker/r-ver:4.5.0` and `rocker/r-ver:latest`.

- The tests should be in the form of running R scripts that install a specific set of packages (TBD) and check the version of them, including how these were installed (either binary or source).