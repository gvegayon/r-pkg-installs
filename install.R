# Check the version of the CRAN repo
message("R version : ", getRversion())
message("CRAN repo : ", getOption("repos")["CRAN"])

# Installing packages
install.packages("coda")