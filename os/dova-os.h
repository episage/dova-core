/* dova-os.h
 *
 * Copyright (C) 2010  Jürg Billeter
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.

 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 * Author:
 * 	Jürg Billeter <j@bitron.ch>
 */

#ifndef __DOVA_OS_H__
#define __DOVA_OS_H_

#include <dova-types.h>

#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <math.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <time.h>

#ifdef __GNUC__
#include "dova-atomic-gcc.h"
#elif defined(_MSC_VER)
#include "dova-atomic-msc.h"
#endif

#ifndef _WIN32
#include "dova-threads-pthread.h"
#else
#include "dova-threads-win32.h"
#endif

#ifndef _WIN32
#include "dova-io-linux.h"
#else
#include "dova-io-win32.h"
#endif

#ifndef _WIN32
#if defined(__x86_64__)
#include "dova-ucontext-x86_64.h"
#elif defined(__i386__)
#include "dova-ucontext-x86.h"
#else
#include "dova-ucontext-posix.h"
#endif
#endif

char **getargv (void);
void setargv (char **argv);

#endif
