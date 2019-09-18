all: build

build:
	@docker build -t fekide/fusiondirectory-openldap:latest .

release: build
	@docker build -t fekide/fusiondirectory-openldap:$(shell cat VERSION) .

.PHONY: test
test:
	@docker build -t fekide/fusiondirectory-openldap:bats .
	bats test
