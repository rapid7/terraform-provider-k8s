.PHONY: build
build:
	go install -v

buildall:
	@sh -c "'$(CURDIR)/scripts/build_all.sh'"