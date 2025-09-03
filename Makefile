ifndef _VERSION
_VERSION := latest
endif

ifndef _USE_PAK
_USE_PAK := no
endif

ifndef _CRAN
_CRAN := https://p3m.dev/cran/latest
endif

_IMAGE := rocker/r-ver:$(_VERSION)

help:
	@echo "Run the R script in a container"
	@echo "Usage: make run"

run:
	podman run -i --rm \
		--mount type=bind,source="$(shell pwd)",target=/mnt \
		--workdir /mnt \
		--env _USE_PAK=$(_USE_PAK) \
		--env _CRAN=$(_CRAN) \
		--env _IMAGE=$(_IMAGE) \
		$(_IMAGE) bash

test:
	podman run --rm \
		--mount type=bind,source="$(shell pwd)",target=/mnt \
		--env _USE_PAK=$(_USE_PAK) \
		--env _CRAN=$(_CRAN) \
		--env _IMAGE=$(_IMAGE) \
		--workdir /mnt \
		$(_IMAGE) Rscript -e 'source("install.R")'
