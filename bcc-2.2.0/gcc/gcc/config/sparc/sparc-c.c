/* Subroutines used for macro/preprocessor support on SPARC.
   Copyright (C) 2011-2020 Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GCC; see the file COPYING3.  If not see
<http://www.gnu.org/licenses/>.  */

#define IN_TARGET_CODE 1

#include "config.h"
#include "system.h"
#include "coretypes.h"
#include "tm.h"
#include "c-family/c-common.h"
#include "c-family/c-pragma.h"

void
sparc_target_macros (void)
{
#ifdef TARGET_GAISLER_VXWORKS
  /* Do not define sparc */
  builtin_define_std ("__sparc");
  builtin_define_std ("__sparc__");
#else
  /* Defines sparc, __sparc, and __sparc__ */
  builtin_define_std ("sparc");
#endif

  cpp_define (parse_in, "__BIG_ENDIAN__");

  if (sparc_fix_b2bst)
    cpp_define (parse_in, "__FIX_LEON3FT_B2BST");
  if (sparc_fix_ut700)
    cpp_define (parse_in, "__FIX_LEON3FT_TN0010");
  if (sparc_fix_gr712rc)
    cpp_define (parse_in, "__FIX_LEON3FT_TN0011");

  if (TARGET_ARCH64)
    {
      cpp_assert (parse_in, "cpu=sparc64");
      cpp_assert (parse_in, "machine=sparc64");
    }
  else
    {
      cpp_assert (parse_in, "cpu=sparc");
      cpp_assert (parse_in, "machine=sparc");
    }

  if (TARGET_VIS4B)
    {
      cpp_define (parse_in, "__VIS__=0x410");
      cpp_define (parse_in, "__VIS=0x410");
    }
  else if (TARGET_VIS4)
    {
      cpp_define (parse_in, "__VIS__=0x400");
      cpp_define (parse_in, "__VIS=0x400");
    }
  else if (TARGET_VIS3)
    {
      cpp_define (parse_in, "__VIS__=0x300");
      cpp_define (parse_in, "__VIS=0x300");
    }
  else if (TARGET_VIS2)
    {
      cpp_define (parse_in, "__VIS__=0x200");
      cpp_define (parse_in, "__VIS=0x200");
    }
  else if (TARGET_VIS)
    {
      cpp_define (parse_in, "__VIS__=0x100");
      cpp_define (parse_in, "__VIS=0x100");
    }
}