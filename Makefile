

default: help

BEASTGCCALPINE = beast1.8.4-gcc-alpine
BEASTGCCCENTOS = beast1.8.4-gcc-centos7
BEASTPGCUBUNTU = beast1.8.4-pgc-ubuntu16.04

# NOTE: this code taken from https://gist.github.com/rcmachado/af3db315e31383502660
help: 
	$(info Available targets:)
	@awk '/^[a-zA-Z\-\_0-9]+:/ {                                   \
          nb = sub( /^## /, "", helpMsg );                             \
          if(nb == 0) {                                                \
            helpMsg = $$0;                                             \
            nb = sub( /^[^:]*:.* ## /, "", helpMsg );                  \
          }                                                            \
          if (nb)                                                      \
            printf "\033[1;31m%-" width "s\033[0m %s\n", $$1, helpMsg; \
        }                                                              \
        { helpMsg = $$0 }'                                             \
        width=$$(grep -o '^[a-zA-Z_0-9]\+:' $(MAKEFILE_LIST) | wc -L)  \
	$(MAKEFILE_LIST)

build-gcc-centos: ## build beast using gcc in a centos base image
	docker build -f ${BEASTGCCCENTOS}.dock -t ${BEASTGCCCENTOS} .
runtest-gcc-centos: ## run the gcc-centos image and start beast
	docker run --rm -it ${BEASTGCCCENTOS}
run-gcc-centos: ## run the gcc-centos image interactively
	docker run --rm -it ${BEASTGCCCENTOS} bash
#--
build-gcc-alpine: ## build beast using gcc in an alpine base image
	docker build -f ${BEASTGCCALPINE}.dock -t ${BEASTGCCALPINE} .
runtest-gcc-alpine: ## run the gcc-alpine image and start beast
	docker run --rm -it ${BEASTGCCALPINE}
run-gcc-alpine: ## run the gcc-alpine image interactively
	docker run --rm -it ${BEASTGCCALPINE} sh
#--
build-pgc-ubuntu: ## build beast using pgc in an ubuntu 16.06  base image
	docker build -f ${BEASTPGCUBUNTU}.dock -t ${BEASTPGCUBUNTU} .
runtest-pgc-ubuntu: ## run the pgc-ubuntu image and start beast
	docker run --rm -it ${BEASTPGCUBUNTU}
run-pgc-ubuntu: ## run the pgc-ubuntu image interactively
	docker run --rm -it ${BEASTPGCUBUNTU} bash

build-all: build-gcc-centos build-gcc-alpine build-pgc-ubuntu ## build all three images

