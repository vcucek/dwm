# dwm - dynamic window manager
# See LICENSE file for copyright and license details.

include config.mk

BUILDDIR=build

SRC = drw.c dwm.c util.c
OBJ = $(patsubst %.c,$(BUILDDIR)/%.o,$(SRC))

all: options dir ${BUILDDIR}/dwm

dir:
	mkdir -p ${BUILDDIR}

options:
	@echo dwm build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

${BUILDDIR}/%.o: %.c
	${CC} -c ${CFLAGS} $< -o $@

${OBJ}: config.h config.mk

config.h:
	cp config.def.h $@

${BUILDDIR}/dwm: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f ${BUILDDIR}/dwm ${BUILDDIR}/*.o ${BUILDDIR}/dwm-${VERSION}.tar.gz

dist: clean
	mkdir -p ${BUILDDIR}/dwm-${VERSION}
	cp -R LICENSE Makefile README config.def.h config.mk\
		dwm.1 drw.h util.h ${SRC} dwm.png transient.c ${BUILDDIR}/dwm-${VERSION}
	tar -cf ${BUILDDIR}/dwm-${VERSION}.tar ${BUILDDIR}/dwm-${VERSION}
	gzip ${BUILDDIR}/dwm-${VERSION}.tar
	rm -rf ${BUILDDIR}/dwm-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f ${BUILDDIR}/dwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/dwm
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < dwm.1 > ${DESTDIR}${MANPREFIX}/man1/dwm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/dwm.1

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/dwm\
		${DESTDIR}${MANPREFIX}/man1/dwm.1

.PHONY: all options clean dist install uninstall
