ifndef _R_PKG
_R_PKG := data.table
endif

ifndef _VERSION
_VERSION := latest
endif

ifndef _USE_PAK
_USE_PAK := no
endif

ifndef _CRAN
_CRAN := https://cloud.r-project.org/
endif

ifndef _CONTAINER
_CONTAINER := docker
endif

ifndef _VERBOSE
_VERBOSE := no
endif

ifeq ($(OS), Windows_NT)
	_WORKSPACE := C:/workspace
else
	_WORKSPACE := /workspace
endif

_PWD := $(shell pwd)

_IMAGE := rocker/r-ver:$(_VERSION)

help:
	@echo "Run the R script in a container"
	@echo "Usage: make run"

run:
	$(_CONTAINER) run -i --rm \
		--mount type=bind,source="$(_PWD)",target=$(_WORKSPACE) \
		--workdir $(_WORKSPACE) \
		--env _R_PKG=$(_R_PKG) \
		--env _USE_PAK=$(_USE_PAK) \
		--env _CRAN=$(_CRAN) \
		--env _IMAGE=$(_IMAGE) \
		--env _VERBOSE=$(_VERBOSE) \
		$(_IMAGE) bash

test:
	$(_CONTAINER) run --rm \
		--mount type=bind,source="$(_PWD)",target=$(_WORKSPACE) \
		--env _R_PKG=$(_R_PKG) \
		--env _USE_PAK=$(_USE_PAK) \
		--env _CRAN=$(_CRAN) \
		--env _IMAGE=$(_IMAGE) \
		--workdir $(_WORKSPACE) \
		--env _VERBOSE=$(_VERBOSE) \
		$(_IMAGE) Rscript -e 'source("install.R")'

.PHONY: help run test
