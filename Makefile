.PHONY: sattools minisat picosat cryptominisat

all: build

SAT = src/dimacs.cmi src/sattools.cmi src/tseitin.cmi \
			src/sattools.cma src/sattools.cmxa src/sattools.a
PICO = picosat/dllopicosat.so picosat/libopicosat.a picosat/opicosat.cma \
			 picosat/opicosat.cmxa picosat/picosat.cmi picosat/opicosat.a
MINI = minisat/dllominisat.so minisat/libominisat.a minisat/ominisat.cma \
			 minisat/ominisat.cmxa minisat/minisat.cmi minisat/ominisat.a
CRYPTO = cryptominisat/dllocryptominisat.so cryptominisat/libocryptominisat.a \
				 cryptominisat/ocryptominisat.cma cryptominisat/ocryptominisat.cmxa \
				 cryptominisat/cryptominisat.cmi cryptominisat/ocryptominisat.a

WITH_PICO = $(shell which picosat > /dev/null 2>&1; echo $$?)
WITH_MINI = $(shell which minisat > /dev/null 2>&1; echo $$?)
WITH_CRYPTO = $(shell which cryptominisat4_simple > /dev/null 2>&1; echo $$?)

BUILDS = sattools
INSTALLS = $(SAT)
ifeq ($(WITH_PICO), 0)
	BUILDS += picosat
	INSTALLS += $(PICO)
endif
ifeq ($(WITH_MINI), 0)
	BUILDS += minisat
	INSTALLS += $(MINI)
endif
ifeq ($(WITH_CRYPTO), 0)
	BUILDS += cryptominisat
	INSTALLS += $(CRYPTO)
endif

build: $(BUILDS)
	echo "built $(BUILDS)"

sattools:
	make -C src

minisat:
	make -C minisat

picosat:
	make -C picosat

cryptominisat:
	make -C cryptominisat

install:
	ocamlfind install sattools META $(INSTALLS)

uninstall:
	ocamlfind remove sattools

clean:
	make -C src clean
	make -C minisat clean
	make -C picosat clean
	make -C cryptominisat clean

