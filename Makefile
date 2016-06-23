all: build

build:
	@docker build --tag=hrektts/fusiondirectory-openldap:latest .

release: build
	@docker build --tag=hrektts/fusiondirectory-openldap:$(shell cat VERSION) .
