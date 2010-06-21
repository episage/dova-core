NULL =

AM_CPPFLAGS = \
	-I$(srcdir)/../src \
	$(NULL)

check_PROGRAMS = \
	test-base \
	$(NULL)

test_base_SOURCES = \
	list.vala \
	$(NULL)

test_base_VALAFLAGS = --profile dova --vapidir $(srcdir)/../vapi

test_base_LDFLAGS = -pthread

test_base_LDADD = \
	../src/libdova-core.la \
	$(NULL)

TESTS = $(check_PROGRAMS)
