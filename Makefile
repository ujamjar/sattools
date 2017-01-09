.PHONY: build clean tag prepare publish

all: build

INC=`opam config var ctypes:lib`
WITH_MINISAT=$(shell (which minisat > /dev/null 2>&1 && echo true) || echo false)
WITH_PICOSAT=$(shell (which picosat > /dev/null 2>&1 && echo true) || echo false)
WITH_CRYPTOMINISAT=$(shell (which cryptominisat4_simple > /dev/null 2>&1 && echo true) || echo false)

pkg/META: pkg/META.in 
	cp pkg/META.in pkg/META

build: pkg/META
	CTYPES_INC_DIR=$(INC) ocaml pkg/pkg.ml build \
		--with-minisat $(WITH_MINISAT) \
		--with-picosat $(WITH_PICOSAT) \
		--with-cryptominisat  $(WITH_CRYPTOMINISAT)

clean:
	ocaml pkg/pkg.ml clean

VERSION      := $$(opam query --version)
NAME_VERSION := $$(opam query --name-version)
ARCHIVE      := $$(opam query --archive)

tag:
	git tag -a "v$(VERSION)" -m "v$(VERSION)."
	git push origin v$(VERSION)

prepare:
	opam publish prepare -r hardcaml $(NAME_VERSION) $(ARCHIVE)

publish:
	opam publish submit -r hardcaml $(NAME_VERSION)
	rm -rf $(NAME_VERSION)
