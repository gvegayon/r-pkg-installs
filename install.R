# Getting whether to use pak or not
use_pak <- Sys.getenv("_USE_PAK", "no")
cran    <- Sys.getenv("_CRAN", "https://cloud.r-project.org/")
r_pkg   <- Sys.getenv("_R_PKG", "")
verbose <- Sys.getenv("_VERBOSE", "no")

# Checking if we need to setup the proper CRAN repo
# for latest binaries on Linux
if (grep("__linux__/jammy/latest", cran) && R.version$os ) {
  options(
    repos = c(
      CRAN = sprintf(
        "https://p3m.dev/cran/latest/bin/linux/jammy-%s/%s",
        R.version["arch"],
        substr(getRversion(), 1, 3)
      )
    )
  )
}

if (r_pkg == "") {
  stop(
    "Please set the _R_PKG environment variable to the package ",
    "you want to install."
  )
}

options(repos = c(CRAN = cran))

# Check the version of the CRAN repo
message("R version : ", getRversion())
message("CRAN repo : ", getOption("repos")["CRAN"])
message("Installer : ", ifelse(use_pak == "yes", "pak", "install.packages"))

#' Function to install a package while setting opts
#' @param expr Expression to evaluate
#' @return
#' Invisible the output from R CMD BATCH
eval_with_cran <- function(expr) {
  
  expr <- deparse(substitute(expr)) |> as.character()
  temp_script <- tempfile(fileext = ".R")
  cran <- getOption("repos")["CRAN"]

  c(
    sprintf("options(repos = c(CRAN = '%s'))", cran),
    sprintf("r_pkg <- '%s'", r_pkg),
    expr
  ) |> writeLines(con = temp_script)

  system(
    sprintf(
      "R CMD BATCH --vanilla %s %s.out",
      temp_script,
      temp_script
      )
  )

  invisible(readLines(paste0(temp_script, ".out")))
}

# Installing packages
if (use_pak == "yes") {
  if (!requireNamespace("pak", quietly = TRUE)) {
    eval_with_cran({
        system("
        apt-get update && apt-get install -y --no-install-recommends libcurl4-openssl-dev &&
        install2.r pak
        ",
        intern = TRUE
      )
    })
  }
  install_time <- system.time({
    install_output <- eval_with_cran({
      pak::pkg_install(r_pkg)
    })
  })
} else {
  install_time <- system.time({
    install_output <- eval_with_cran({
      install.packages(r_pkg)
    })
  })
}

if (verbose != "no") {
  message("------------------ Installation output ----------------------")
  message(paste(install_output, collapse = "\n"))
}

message("Total install time: ", install_time["elapsed"], " seconds.")

# Retrieving information about the installed package:
# - What is the installed version
# - Whether it was installed from source or from binaries
# - What is the repository from which it was installed
installed_info <- packageDescription(r_pkg)

message("Installed version: ", installed_info$Version)
message("Installed from: ", ifelse(installed_info$Built == "", "source", "binary"))
message("Repository: ", installed_info$Repository)

# Creating a list to be saved as a yaml file
fn <- tempfile(fileext = ".yaml")

# Checking the installation type
if (use_pak) {
  installation_type <- ifelse(
      any(
        grepl(
          paste("^.\\s+Building", r_pkg), install_output)
      ),
      "source",
      "binary"
    )
} else {
  installation_type <- ifelse(
      any(grepl("installing [*]source[*]", install_output)), "source", "binary"
    )
}

writeLines(
  c(
    sprintf("r_pkg: %s", r_pkg),
    sprintf("use_pak: %s", use_pak),
    sprintf("cran: %s", getOption("repos")["CRAN"]),
    sprintf("installed_version: %s", installed_info$Version),
    sprintf("installed_from: %s", installation_type),
    sprintf("installed_repository: %s", installed_info$Repository),
    sprintf("install_time: %s", install_time["elapsed"]),
    sprintf("image: %s", Sys.getenv("_IMAGE", "")),
    sprintf("r_version: %s", getRversion()),
    sprintf("system: %s", R.version$system),
    sprintf("architecture: %s", R.version$arch),
    sprintf("timestamp: %s", Sys.time())
  ),
  con = fn
)

file.copy(
  from = fn, 
  to = 
    paste0(tools::md5sum(fn), ".yaml")
)

