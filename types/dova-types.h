/* dova-types.h
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

#ifndef __DOVA_TYPES_H__
#define __DOVA_TYPES_H_

#include <dova-features.h>

#include <stddef.h>
#include <stdint.h>

#ifdef _MSC_VER
typedef unsigned char _Bool;
#define bool _Bool
#define true 1
#define false 0
#else
#include <stdbool.h>
#endif

#ifdef _MSC_VER
typedef double _Decimal128;
#endif
#define decimal128 _Decimal128

#endif
