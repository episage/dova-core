NULL =

AM_CPPFLAGS = \
	-I$(top_srcdir)/os \
	$(NULL)

noinst_LTLIBRARIES = \
	libdova-base.la \
	libdova-file.la \
	libdova-io.la \
	libdova-model.la \
	libdova-net.la \
	libdova-task.la \
	libdova-app.la \
	$(NULL)

lib_LTLIBRARIES = \
	libdova-core.la \
	$(NULL)

libdova_base_la_SOURCES = \
	array.vala \
	bool.vala \
	byte.vala \
	char.vala \
	char_case_props_data.vala \
	char_props_data.vala \
	datetime.vala \
	decimal.vala \
	delegate.vala \
	double.vala \
	error.vala \
	float.vala \
	int.vala \
	iterator.vala \
	list.vala \
	long.vala \
	map.vala \
	node.vala \
	object.vala \
	random.vala \
	sbyte.vala \
	set.vala \
	short.vala \
	string.vala \
	timer.vala \
	tuple.vala \
	uint.vala \
	ulong.vala \
	uri.vala \
	ushort.vala \
	value.vala \
	$(NULL)

libdova_base_la_VALAFLAGS = --profile dova --nostdpkg $(top_srcdir)/os/dova-os.vapi -H dova-base.h --vapi dova-base-0.1.vapi

libdova_task_la_SOURCES = \
	task.vala \
	$(NULL)

libdova_task_la_VALAFLAGS = --profile dova --nostdpkg $(top_srcdir)/os/dova-os.vapi dova-base-0.1.vapi -H dova-task.h --vapi dova-task-0.1.vapi

$(srcdir)/libdova_task_la_vala.stamp: $(srcdir)/dova-base-0.1.vapi

libdova_io_la_SOURCES = \
	stream.vala \
	textreader.vala \
	textwriter.vala \
	$(NULL)

libdova_io_la_VALAFLAGS = --profile dova --nostdpkg $(top_srcdir)/os/dova-os.vapi dova-base-0.1.vapi -H dova-io.h --vapi dova-io-0.1.vapi

$(srcdir)/libdova_io_la_vala.stamp: $(srcdir)/dova-base-0.1.vapi

libdova_file_la_SOURCES = \
	file.vala \
	$(NULL)

libdova_file_la_VALAFLAGS = --profile dova --nostdpkg $(top_srcdir)/os/dova-os.vapi dova-base-0.1.vapi dova-io-0.1.vapi -H dova-file.h --vapi dova-file-0.1.vapi

$(srcdir)/libdova_file_la_vala.stamp: $(srcdir)/dova-base-0.1.vapi $(srcdir)/dova-io-0.1.vapi

libdova_net_la_SOURCES = \
	net.vala \
	$(NULL)

libdova_net_la_VALAFLAGS = --profile dova --nostdpkg $(top_srcdir)/os/dova-os.vapi dova-base-0.1.vapi dova-io-0.1.vapi dova-task-0.1.vapi -H dova-net.h --vapi dova-net-0.1.vapi

$(srcdir)/libdova_net_la_vala.stamp: $(srcdir)/dova-base-0.1.vapi $(srcdir)/dova-io-0.1.vapi $(srcdir)/dova-task-0.1.vapi

libdova_model_la_SOURCES = \
	arraylist.vala \
	hashmap.vala \
	hashset.vala \
	iterable.vala \
	model.vala \
	priorityqueue.vala \
	$(NULL)

libdova_model_la_VALAFLAGS = --profile dova --nostdpkg $(top_srcdir)/os/dova-os.vapi dova-base-0.1.vapi -H dova-model.h --vapi dova-model-0.1.vapi

$(srcdir)/libdova_model_la_vala.stamp: $(srcdir)/dova-base-0.1.vapi

libdova_app_la_SOURCES = \
	app.vala \
	$(NULL)

libdova_app_la_VALAFLAGS = --profile dova --nostdpkg $(top_srcdir)/os/dova-os.vapi dova-base-0.1.vapi dova-task-0.1.vapi -H dova-app.h --vapi dova-app-0.1.vapi

$(srcdir)/libdova_app_la_vala.stamp: $(srcdir)/dova-base-0.1.vapi $(srcdir)/dova-task-0.1.vapi

libdova_core_la_SOURCES = \
	module.vala \
	thread.vala \
	$(NULL)

libdova_core_la_VALAFLAGS = --profile dova --nostdpkg $(top_srcdir)/os/dova-os.vapi dova-base-0.1.vapi dova-file-0.1.vapi dova-io-0.1.vapi dova-model-0.1.vapi dova-net-0.1.vapi dova-task-0.1.vapi dova-app-0.1.vapi -H dova-core.h --vapi dova-core-0.1.vapi

$(srcdir)/libdova_core_la_vala.stamp: $(srcdir)/dova-base-0.1.vapi $(srcdir)/dova-file-0.1.vapi $(srcdir)/dova-io-0.1.vapi $(srcdir)/dova-model-0.1.vapi $(srcdir)/dova-net-0.1.vapi $(srcdir)/dova-task-0.1.vapi $(srcdir)/dova-app-0.1.vapi

libdova_core_la_LIBADD = \
	../os/libdova-os.la \
	libdova-base.la \
	libdova-file.la \
	libdova-io.la \
	libdova-model.la \
	libdova-net.la \
	libdova-task.la \
	libdova-app.la \
	-lm \
	-lrt \
	-ldl \
	$(NULL)

dovaincludedir = $(includedir)/dova-core-0.1

dovainclude_HEADERS = \
	dova-base.h \
	dova-core.h \
	dova-file.h \
	dova-io.h \
	dova-model.h \
	dova-net.h \
	dova-task.h \
	dova-app.h \
	$(NULL)

vapidir = $(datadir)/vala/vapi

dist_vapi_DATA = \
	dova-base-0.1.vapi \
	dova-core-0.1.deps \
	dova-core-0.1.vapi \
	dova-file-0.1.vapi \
	dova-io-0.1.vapi \
	dova-model-0.1.vapi \
	dova-net-0.1.vapi \
	dova-task-0.1.vapi \
	dova-app-0.1.vapi \
	$(NULL)

