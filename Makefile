.PHONY: help install test headers

help: ## help
	@bash etc/help.sh $(MAKEFILE_LIST)

install: ## install
	pip install -r requirements.txt

test: ## test
	pytest

headers: ## update all the .md headers from etc/header.sh
	@find . -name '*.md' -exec bash etc/headers.sh {} \;

rq1: ## check RQ1
	@(cd src; bash RQ1.sh)

rq2: ## check RQ2
	@(cd src; bash RQ2.sh)


