ifndef VERSION
VERSION := latest
endif

IMAGE := rocker/r-ver:$(VERSION)

help:
	@echo "Run the R script in a container"
	@echo "Usage: make run"

run:
	podman run --rm \
		--mount type=bind,source="$(shell pwd)",target=/mnt \
		--workdir /mnt \
		$(IMAGE) Rscript -e 'source("install.R")'
