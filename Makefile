# Please only configure API_SRC to point to correct Owl src folder.
API_SRC="/Users/liang.wang/code/owl/src/"
FORK_URL="https://github.com/ryanrhymes/owlbarn.github.io.git"
FORK_DIR="${ROOT}_fork/owlbarn.github.io"

# No need to touch the following settings.
ROOT := $(dir $(lastword $(MAKEFILE_LIST)))
PARSER ="${ROOT}bin/apidoc.ml"
API_DST="${ROOT}book/apidoc/"
API_LST="${ROOT}bin/module.txt"

# owlbarn github url and local folder
BARN_URL="https://github.com/owlbarn/owlbarn.github.io.git"
BARN_DIR="${ROOT}_barn/owlbarn.github.io"


all:
	${PARSER} ${API_SRC} ${API_DST} ${API_LST}
	cd ${ROOT}book && make html && cd -


cambridge:
	# scp -r -i ~/.ssh/id_cam book/_build/html/* lw525@slogin.cl.cam.ac.uk:~/public_html/owl/
	# kinit lw525@AD.CL.CAM.AC.UK
	scp -o GSSAPIAuthentication=yes -r book/_build/html/* lw525@slogin-serv.cl.cam.ac.uk:~/public_html/owl/


publish:
	-git commit -am "edit ..." && git push origin master
	@if test ! -d ${BARN_DIR}; then mkdir -p ${BARN_DIR} && git clone ${BARN_URL} ${BARN_DIR}; else cd ${BARN_DIR} && git pull origin master; fi
	cp -r ${ROOT}book/_build/html/* ${BARN_DIR}
	-cd ${BARN_DIR} && git commit -am "update doc by script ..." && git push origin master


pull-request:
	@if test ! -d ${FORK_DIR}; then mkdir -p ${FORK_DIR} && git clone ${FORK_URL} ${FORK_DIR}; else cd ${FORK_DIR} && git pull origin master; fi
	-cd ${FORK_DIR} && git remote add upstream ${BARN_URL}
	-cd ${FORK_DIR} && git fetch upstream
	-cd ${FORK_DIR} && git merge upstream/master
	cp -r ${ROOT}book/_build/html/* ${FORK_DIR}
	-cd ${FORK_DIR} && git commit -am "update doc by script ..."
	-cd ${FORK_DIR} && git push origin master
	-cd ${FORK_DIR} && hub pull-request -m "pull-request by script ..."


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
