NULL =

AM_CPPFLAGS = \
	-I$(top_srcdir)/types \
	-I$(top_srcdir)/src \
	$(NULL)

check_PROGRAMS = \
	test-base \
	$(NULL)

test_base_SOURCES = \
	base.vala \
	list.vala \
	string.vala \
	$(NULL)

test_base_VALAFLAGS = --profile dova --vapidir $(srcdir)/../vapi

test_base_LDFLAGS = -pthread

test_base_LDADD = \
	../src/libdova-core.la \
	$(NULL)

TESTS = $(check_PROGRAMS)
