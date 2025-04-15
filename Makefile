VERSION = $(shell python3 -c "import re; f=open('setup.py').read(); print(re.search(r'VERSION\s*=\s*[\"\\\'](.*?)[\"\\\']', f).group(1))")
VENV_DIR = tests/.venv

sdist: oz.spec.in
        python3 setup.py sdist

oz.spec: sdist

signed-tarball: sdist
        gpg --detach-sign --armor -o dist/oz-$(VERSION).tar.gz.sign dist/oz-$(VERSION).tar.gz

signed-rpm: oz.spec
        rpmbuild -ba oz.spec --define "_sourcedir `pwd`/dist"

rpm: oz.spec
        rpmbuild -ba oz.spec --define "_sourcedir `pwd`/dist"

srpm: oz.spec
        rpmbuild -bs oz.spec --define "_sourcedir `pwd`/dist"

deb:
        debuild -i -uc -us -b

release: signed-rpm signed-tarball deb

man2html:
        @for file in oz-install oz-customize oz-generate-icicle oz-cleanup-cache oz-examples; do \
                echo "Generating $$file HTML page from man" ; \
                groff -mandoc -mwww man/$$file.1 -T html > man/$$file.html ; \
        done

virtualenv:
        @virtualenv --system-site-packages $(VENV_DIR)
        @$(VENV_DIR)/bin/pip install pytest pytest-cov
        @[[ "$$PWD" =~ \ |\' ]] && ( \
        echo "Resolving potential problems where '$$PWD' contains spaces" ; \
        for MATCH in $$(grep '^#!"/' $(VENV_DIR)/bin/* -l) ; do \
                sed -i '1s|^#!".*/\([^/]*\)"|#!/usr/bin/env \1|' "$$MATCH" ; \
        done ) || true

unittests:
        @$(VENV_DIR)/bin/pytest tests

tests: unittests

test-coverage:
        @$(VENV_DIR)/bin/pytest --cov=oz --cov-report=html tests
        @xdg-open htmlcov/index.html || echo "Open htmlcov/index.html manually"

pylint:
        $(VENV_DIR)/bin/pylint --rcfile=pylint.conf oz oz-install oz-customize oz-cleanup-cache oz-generate-icicle

flake8:
        flake8-3 --ignore=E501 oz

clean:
        rm -rf MANIFEST build dist usr *~ oz.spec *.pyc oz/*~ oz/*.pyc examples/*~ oz/auto/*~ man/*~ docs/*~ man/*.html $(VENV_DIR) tests/tdl/*~ tests/factory/*~ tests/results.xml htmlcov

.PHONY: sdist oz.spec signed-tarball signed-rpm rpm srpm deb release man2html virtualenv unittests tests test-coverage pylint clean
