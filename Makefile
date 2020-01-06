ROOT := $(dir $(lastword $(MAKEFILE_LIST)))
BARN_URL="git@github.com:owlbarn/owlbarn.github.io.git"
BARN_DIR="${ROOT}_barn/owlbarn.github.io"


all:
	cd ${ROOT}book && make html && cd -


publish:
	-git commit -am "edit ..." && git push origin master
	@if test ! -d ${BARN_DIR}; then mkdir -p ${BARN_DIR} && git clone ${BARN_URL} ${BARN_DIR}; else cd ${BARN_DIR} && git pull origin master; fi
	cp -r ${ROOT}book/_build/html/* ${BARN_DIR}
	cd ${BARN_DIR} && git commit -am "update doc by script ..." && git push origin master


clean:
	rm -rf ${ROOT}book/_build
	rm -rf ${ROOT}book/apidoc/*.rst
	rm -rf ${ROOT}_barn ${ROOT}_fork
	rm -rf *.html *.css


sphinx:
	pip install sphinx sphinxcontrib-bibtex


.PHONY: push
push:
	git commit -am "coding ..." && \
	git push origin `git branch | grep \* | cut -d ' ' -f2`
