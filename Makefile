.PHONY: help install test headers check pull push site xxx

SHELL=bash
WANT=gawk git tmux vim mc tree cmatrix rain npm lua pandoc ncdu
SITE=../sehero.github.io

help: ## help
	@bash etc/help.sh $(MAKEFILE_LIST)

install: ## install
	pip install -r requirements.txt

check: ## look for missing executables
	@bash etc/missing.sh $(WANT)
	
test: ## test
	pytest

headers: ## update all the .md headers from etc/header.sh
	@find . -name '*.md' -exec bash etc/headers.sh {} \;

pull: ## download from Git
	git pull

push: ## upload changes to Git
	@git commit -am "pushing"
	@git pull
	@git status

CODE=$(shell ls src/*.lua | gawk '{sub(/^src/,"$(SITE)/src"); sub(/\.lua$$/,".html"); print}')
MD=$(shell   ls doc/*.md  | gawk '{sub(/^doc/,"$(SITE)/doc"); sub(/\.md$$/, ".html"); print}')

site:  create $(SITE)/index.html #$(CODE) $(MD) over ## build site

create: $(SITE)
	@mkdir -p $(SITE)/src
	@mkdir -p $(SITE)/doc
	@cp -r doc/etc/ $(SITE)

over:
	@cd $(SITE); \
	@git add .nojekyll * */* 
	@git commit -am updated
	@git push

PAN=                               \
  -s                                \
  --mathjax                          \
  --from=markdown                     \
  --table-of-contents                  \
  -V numberLines=true                   \
  --include-after=doc/tail.txt           \
  --include-before=doc/head.txt           \
  --indented-code-classes=lua,numberLines  \
  --css='https://fonts.googleapis.com/css2?family=Muli&display=swap'                \
  --css='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/all.min.css' \ 
  --css='https://raw.githubusercontent.com/sehero/sehero.github.io/master/style.css'

$(SITE)/index.html:  etc/index.md
	pandoc $< --metadata title="$(notdir $<)" $(PAN) -o $@

$(SITE)/src/%.html:  src/*.lua
	gawk -f etc/2md.awk $< \
	| pandoc --metadata title="$(notdir $<)" $(PAN) -o $@

$(SITE)/doc/%.html:  doc/*.md
	pandoc $< --metadata title="$(notdir $<)" $(PAN) -o $@
