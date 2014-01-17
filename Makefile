# zenlisp Makefile
# By Nils M Holm, 2007, 2008
# See the file LICENSE for conditions of use.

V=	2

PREFIX?=/usr/local
BINOWN?=bin
BINGRP?=bin

BINDIR=	$(PREFIX)/bin
SHRDIR=	$(PREFIX)/share/zenlisp
MANDIR=	$(PREFIX)/man/man1
DOCDIR=	$(PREFIX)/share/doc/zenlisp
IMAGE=	$(PREFIX)/share/zenlisp/zenlisp

LIBS=	base.l imath.l iter.l nmath.l rmath.l

CFLAGS=		-O -DDEFAULT_IMAGE="\"$(IMAGE)\""
LINTFLAGS=	-Wall -ansi -pedantic -Wmissing-prototypes -DLINT

all:	zl zenlisp

zl:	zl.c
	$(CC) $(CFLAGS) -o zl zl.c

lint:
	$(CC) $(CFLAGS) $(LINTFLAGS) -o zl zl.c

zenlisp:	zl base.l
	echo '(load base) (dump-image zenlisp)' | ./zl -bi -n 12K

test:	zl
	rm -f delete-me
	ZENSRC=. ./zl -i <test.l | tee _test
	sed -i '' -e 's/^\* [0-9]*: /\* /' _test
	diff test.OK _test && rm _test delete-me

# Set $C to -c, if your system does not copy files by default.
C=
install: all
	strip zl
	install -o $(BINOWN) -g $(BINGRP) -d -m 0755 $(SHRDIR)
	install -o $(BINOWN) -g $(BINGRP) -d -m 0755 $(DOCDIR)
	install -o $(BINOWN) -g $(BINGRP) $C -m 0755 zl $(BINDIR)
	install -o $(BINOWN) -g $(BINGRP) $C -m 0644 zenlisp $(SHRDIR)
	install -o $(BINOWN) -g $(BINGRP) $C -m 0644 $(LIBS) $(SHRDIR)
	install -o $(BINOWN) -g $(BINGRP) $C -m 0644 src/*/*.l $(SHRDIR)
	install -o $(BINOWN) -g $(BINGRP) $C -m 0644 zl.1 $(MANDIR)
	install -o $(BINOWN) -g $(BINGRP) $C -m 0644 LICENSE $(SHRDIR)
	install -o $(BINOWN) -g $(BINGRP) $C -m 0644 zenlisp.txt $(DOCDIR)

clean:
	rm -f *.o *.a *.core core zl zenlisp _test delete-me \
		zenlisp$V.tgz
