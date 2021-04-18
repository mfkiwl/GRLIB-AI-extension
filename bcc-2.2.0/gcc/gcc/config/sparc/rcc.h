/*

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

#undef STARTFILE_SPEC
#define STARTFILE_SPEC "%{qrtems|qbsp=*:crti.o%s crtbegin.o%s; :crt0.o%s}"

#undef ENDFILE_SPEC
#define ENDFILE_SPEC   "%{qrtems|qbsp=*:crtend.o%s crtn.o%s}"

#undef LINK_SPEC
#define LINK_SPEC      "%{qrtems|qbsp=*:-dc -dp -N}"

#undef DRIVER_SELF_SPECS
#define DRIVER_SELF_SPECS \
"%{qrtems:%{!B:%{!qbsp=*:%especify BSP with -qbsp or BSP folder with -B}}} \
 %{qbsp=*:-B %R/%*/lib}"

#undef LIB_SPEC
#define LIB_SPEC "%{!qrtems:%{!qbsp=*: " STD_LIB_SPEC "}}" \
"%{!nostdlib: %{qrtems|qbsp=*: --start-group \
 -lrtemsbsp %{qbsp=*: -lrtemsdefaultconfigbsp} -lrtemscpu \
 -latomic -lc -lgcc --end-group %{!qnolinkcmds: -T linkcmds%s}}}"