

default: help

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

build: ## build the beast1.8.4 image from the provided docker file
	docker build -t beast1.8.4 .

save: ## save the beast1.8.4 image to a file 'beast1.8.4-image.tar'
	docker save beast1.8.4 > beast1.8.4-image.tar
runtest: ## run the beast1.8.4 image and start beast
	docker run --rm -it beast1.8.4 
run: ## run the beast1.8.4 image interactively
	# docker run -e LD_LIBRARY_PATH=/usr/local/beagle-lib-master/lib -it beast1.8.4 bash
	docker run --rm -it beast1.8.4 bash
