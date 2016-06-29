all: build

build:
	@docker build -t hrektts/fusiondirectory-openldap:latest .

release: build
	@docker build -t hrektts/fusiondirectory-openldap:$(shell cat VERSION) .

.PHONY: test
test:
	@docker build -t hrektts/fusiondirectory-openldap:bats .
	bats test
