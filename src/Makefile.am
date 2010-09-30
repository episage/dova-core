NULL =

if OS_POSIX
os_vapis = \
	$(top_srcdir)/os/dova-os.vapi \
	$(top_srcdir)/os/posix.vapi \
	$(NULL)
endif

AM_CPPFLAGS = \
	-I$(top_srcdir)/types \
	-I$(top_srcdir)/os \
	$(NULL)

noinst_LTLIBRARIES = \
	libdova-app.la \
	libdova-base.la \
	libdova-file.la \
	libdova-io.la \
	libdova-model.la \
	libdova-module.la \
	libdova-net.la \
	libdova-task.la \
	libdova-text.la \
	libdova-thread.la \
	$(NULL)

lib_LTLIBRARIES = \
	libdova-core.la \
	$(NULL)

libdova_base_la_SOURCES = \
	array.vala \
	bool.vala \
	char.vala \
	char_case_props_data.vala \
	char_props_data.vala \
	datetime.vala \
	decimal.vala \
	delegate.vala \
	double.vala \
	error.vala \
	float.vala \
	integer.vala \
	iterator.vala \
	list.vala \
	map.vala \
	node.vala \
	object.vala \
	random.vala \
	set.vala \
	string.vala \
	timer.vala \
	tuple.vala \
	uri.vala \
	value.vala \
	$(NULL)

libdova_base_la_VALAFLAGS = --profile dova --nostdpkg $(os_vapis) -H dova-base.h --vapi dova-base-0.1.vapi

if OS_POSIX
libdova_thread_la_SOURCES = \
	thread-posix.vala \
	$(NULL)
endif

libdova_thread_la_VALAFLAGS = --profile dova --nostdpkg $(os_vapis) dova-base-0.1.vapi -H dova-thread.h --vapi dova-thread-0.1.vapi

$(srcdir)/libdova_thread_la_vala.stamp: $(srcdir)/dova-base-0.1.vapi

libdova_task_la_SOURCES = \
	task.vala \
	$(NULL)

libdova_task_la_VALAFLAGS = --profile dova --nostdpkg $(os_vapis) dova-base-0.1.vapi -H dova-task.h --vapi dova-task-0.1.vapi

$(srcdir)/libdova_task_la_vala.stamp: $(srcdir)/dova-base-0.1.vapi

libdova_io_la_SOURCES = \
	stream.vala \
	$(NULL)

libdova_io_la_VALAFLAGS = --profile dova --nostdpkg $(os_vapis) dova-base-0.1.vapi -H dova-io.h --vapi dova-io-0.1.vapi

$(srcdir)/libdova_io_la_vala.stamp: $(srcdir)/dova-base-0.1.vapi

libdova_text_la_SOURCES = \
	text.vala \
	$(NULL)

libdova_text_la_VALAFLAGS = --profile dova --nostdpkg $(top_srcdir)/os/dova-os.vapi dova-base-0.1.vapi dova-io-0.1.vapi -H dova-text.h --vapi dova-text-0.1.vapi

$(srcdir)/libdova_text_la_vala.stamp: $(srcdir)/dova-base-0.1.vapi $(srcdir)/dova-io-0.1.vapi

libdova_file_la_SOURCES = \
	file.vala \
	$(NULL)

if OS_POSIX
libdova_file_la_SOURCES += file-posix.vala
endif

libdova_file_la_VALAFLAGS = --profile dova --nostdpkg $(os_vapis) dova-base-0.1.vapi dova-io-0.1.vapi -H dova-file.h --vapi dova-file-0.1.vapi

$(srcdir)/libdova_file_la_vala.stamp: $(srcdir)/dova-base-0.1.vapi $(srcdir)/dova-io-0.1.vapi

libdova_net_la_SOURCES = \
	net.vala \
	$(NULL)

libdova_net_la_VALAFLAGS = --profile dova --nostdpkg $(os_vapis) dova-base-0.1.vapi dova-io-0.1.vapi dova-task-0.1.vapi -H dova-net.h --vapi dova-net-0.1.vapi

$(srcdir)/libdova_net_la_vala.stamp: $(srcdir)/dova-base-0.1.vapi $(srcdir)/dova-io-0.1.vapi $(srcdir)/dova-task-0.1.vapi

libdova_model_la_SOURCES = \
	arraylist.vala \
	hashmap.vala \
	hashset.vala \
	iterable.vala \
	model.vala \
	priorityqueue.vala \
	$(NULL)

libdova_model_la_VALAFLAGS = --profile dova --nostdpkg $(os_vapis) dova-base-0.1.vapi -H dova-model.h --vapi dova-model-0.1.vapi

$(srcdir)/libdova_model_la_vala.stamp: $(srcdir)/dova-base-0.1.vapi

libdova_module_la_SOURCES = \
	module.vala \
	$(NULL)

libdova_module_la_VALAFLAGS = --profile dova --nostdpkg $(os_vapis) dova-base-0.1.vapi dova-file-0.1.vapi dova-io-0.1.vapi -H dova-module.h --vapi dova-module-0.1.vapi

$(srcdir)/libdova_module_la_vala.stamp: $(srcdir)/dova-base-0.1.vapi $(srcdir)/dova-file-0.1.vapi $(srcdir)/dova-io-0.1.vapi

libdova_app_la_SOURCES = \
	app.vala \
	$(NULL)

libdova_app_la_VALAFLAGS = --profile dova --nostdpkg $(os_vapis) dova-base-0.1.vapi dova-file-0.1.vapi dova-io-0.1.vapi dova-task-0.1.vapi dova-text-0.1.vapi -H dova-app.h --vapi dova-app-0.1.vapi

$(srcdir)/libdova_app_la_vala.stamp: $(srcdir)/dova-base-0.1.vapi $(srcdir)/dova-file-0.1.vapi $(srcdir)/dova-io-0.1.vapi $(srcdir)/dova-task-0.1.vapi $(srcdir)/dova-text-0.1.vapi

libdova_core_la_SOURCES = \
	$(NULL)

libdova_core_la_LIBADD = \
	../os/libdova-os.la \
	libdova-base.la \
	libdova-file.la \
	libdova-io.la \
	libdova-model.la \
	libdova-module.la \
	libdova-net.la \
	libdova-task.la \
	libdova-text.la \
	libdova-thread.la \
	libdova-app.la \
	-lm \
	-lrt \
	-ldl \
	$(NULL)

dovaincludedir = $(includedir)/dova-core-0.1

dovainclude_HEADERS = \
	dova-base.h \
	dova-file.h \
	dova-io.h \
	dova-model.h \
	dova-module.h \
	dova-net.h \
	dova-task.h \
	dova-text.h \
	dova-thread.h \
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
	dova-module-0.1.vapi \
	dova-net-0.1.vapi \
	dova-task-0.1.vapi \
	dova-text-0.1.vapi \
	dova-thread-0.1.vapi \
	dova-app-0.1.vapi \
	$(NULL)

