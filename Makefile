ifndef _VERSION
_VERSION := latest
endif

ifndef _USE_PAK
_USE_PAK := no
endif

ifndef _CRAN
_CRAN := cloud
endif

ifndef _CONTAINER
_CONTAINER := docker
endif

_IMAGE := rocker/r-ver:$(_VERSION)

help:
	@echo "Run the R script in a container"
	@echo "Usage: make run"

run:
	$(_CONTAINER) run -i --rm \
		--mount type=bind,source="$(shell pwd)",target=/workspace \
		--workdir /workspace \
		--env _USE_PAK=$(_USE_PAK) \
		--env _CRAN=$(_CRAN) \
		--env _IMAGE=$(_IMAGE) \
		$(_IMAGE) bash

test:
	$(_CONTAINER) run --rm \
		--mount type=bind,source="$(shell pwd)",target=/workspace \
		--env _USE_PAK=$(_USE_PAK) \
		--env _CRAN=$(_CRAN) \
		--env _IMAGE=$(_IMAGE) \
		--workdir /workspace \
		$(_IMAGE) Rscript -e 'source("install.R")'

.PHONY: help run test
