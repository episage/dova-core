NULL =

lib_LTLIBRARIES = \
	libdova-core.la \
	$(NULL)

libdova_core_la_SOURCES = \
	array.vala \
	bool.vala \
	byte.vala \
	char.vala \
	date.vala \
	datetime.vala \
	dayofweek.vala \
	decimal.vala \
	double.vala \
	duration.vala \
	float.vala \
	int.vala \
	long.vala \
	object.vala \
	sbyte.vala \
	short.vala \
	stream.vala \
	string.vala \
	textreader.vala \
	textwriter.vala \
	time.vala \
	timeofday.vala \
	uint.vala \
	ulong.vala \
	ushort.vala \
	value.vala \
	$(NULL)

dovaincludedir = $(includedir)/dova-core-0.1

dovainclude_HEADERS = \
	dova-core.h \
	$(NULL)

libdova_core_la_VALAFLAGS = --profile dova --nostdpkg --vapidir $(srcdir)/../vapi --pkg posix -H dova-core.h --vapi dova-core-0.1.vapi

vapidir = $(datadir)/vala/vapi

dist_vapi_DATA = \
        dova-core-0.1.vapi \
        $(NULL)

