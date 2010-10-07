AC_INIT([dova-core], [0.1.0], [j@bitron.ch], [dova-core])
AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_HEADERS(config.h)
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([dist-bzip2 silent-rules])
AM_MAINTAINER_MODE

# Checks for programs.
AC_PROG_CC
AM_PROG_CC_C_O
AC_DISABLE_STATIC
AC_PROG_LIBTOOL

AM_PROG_VALAC([0.9.1])

case $host in
*-*-mingw*)
	dova_os_win32=yes
	;;
*-*-linux*)
	dova_os_linux=yes
	;;
esac

AM_CONDITIONAL(OS_POSIX, test "$dova_os_win32" != "yes")
AM_CONDITIONAL(OS_LINUX, test "$dova_os_linux" = "yes")
AM_CONDITIONAL(OS_WIN32, test "$dova_os_win32" = "yes")

AC_SUBST(VALAFLAGS)
AC_SUBST(CFLAGS)
AC_SUBST(CPPFLAGS)
AC_SUBST(LDFLAGS)

AC_CONFIG_FILES([Makefile
           dova-core-0.1.pc
           types/Makefile
           os/Makefile
           src/Makefile
           tests/Makefile])

AC_OUTPUT
