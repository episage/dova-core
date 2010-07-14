ACLOCAL_AMFLAGS = -I m4
NULL =

SUBDIRS = \
	os \
	src \
	tests \
	$(NULL)

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = dova-core-0.1.pc

dist-hook: gen-ChangeLog

.PHONY: gen-ChangeLog
gen-ChangeLog:
	if test -d .git; then						\
	  $(top_srcdir)/gitlog-to-changelog				\
	    > $(distdir)/cl-t;		\
	  rm -f $(distdir)/ChangeLog;					\
	  mv $(distdir)/cl-t $(distdir)/ChangeLog;			\
	fi

EXTRA_DIST = \
	gitlog-to-changelog \
	MAINTAINERS \
	$(NULL)

