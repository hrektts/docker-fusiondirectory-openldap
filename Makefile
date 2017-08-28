all: build

build:
	@docker build -t ramencloud/fusiondirectory-openldap:latest .

release: build
	@docker build -t ramencloud/fusiondirectory-openldap:$(shell cat VERSION) .

.PHONY: test
test:
	@docker build -t ramencloud/fusiondirectory-openldap:bats .
	bats test
