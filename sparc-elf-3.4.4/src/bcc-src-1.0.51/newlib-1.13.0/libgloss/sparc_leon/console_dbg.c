/*

    LEON2/3 LIBIO low-level routines 
    Written by Jiri Gaisler.
    Copyright (C) 2004  Gaisler Research AB

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

*/
#include <stdlib.h>
#include <ctype.h>
#ifdef _HAVE_STDC
#include <stdarg.h>
#else
#include <varargs.h>
#endif
#include <asm-leon/leoncompat.h>
#include <asm-leon/leon.h>

static size_t lo_strnlen(const char * s, size_t count)
{
  const char *sc;
  
  for (sc = s; count-- && *sc != '\0'; ++sc)
    /* nothing */;
  return sc - s;
}

static int lo_vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
{
  int len;
  unsigned long long num;
  int i,j,n;
  char *str, *end, c;
  const char *s;
  int flags;
  int field_width;
  int precision;
  int qualifier;
  int filler;
  
  str = buf;
  end = buf + size - 1;
  
  if (end < buf - 1) {
    end = ((void *) -1);
    size = end - buf + 1;
  }
  
  for (; *fmt ; ++fmt) {
      if (*fmt != '%') {
	  if (*fmt == '\n') {
	      if (str <= end) {
		  *str = '\r';
	      }
	      str++;
	  }
	  if (str <= end)
	      *str = *fmt;
	  ++str;
	  continue;
      }
    
    /* process flags */
    flags = 0;
    /* get field width */
    field_width = 0;
    /* get the precision */
    precision = -1;
    /* get the conversion qualifier */
    qualifier = 'l';
    filler = ' ';
    
    ++fmt;
    
    if (*fmt == '0') {
      filler = '0';
      ++fmt;
    }
    
    while (isdigit(*fmt)) {
      field_width = field_width * 10 + ((*fmt) - '0');
      ++fmt;
    }
    
    /* default base */
    switch (*fmt) {
    case 'c':
      c = (unsigned char) va_arg(args, int);
      if (str <= end)
	*str = c;
      ++str;
      while (--field_width > 0) {
	if (str <= end)
	  *str = ' ';
	++str;
      }
      continue;
      
    case 's':
      s = va_arg(args, char *);
      if (!s)
	s = "<NULL>";
      
      len = lo_strnlen(s, precision);
      
      for (i = 0; i < len; ++i) {
	if (str <= end)
	  *str = *s;
	++str; ++s;
      }
      while (len < field_width--) {
	if (str <= end)
	  *str = ' ';
	++str;
      }
      continue;
      
      
    case '%':
      if (str <= end)
	*str = '%';
      ++str;
      continue;
      
    case 'x':
      break;
    case 'd':
      break;
      
    default:
      if (str <= end)
	*str = '%';
      ++str;
      if (*fmt) {
	if (str <= end)
	  *str = *fmt;
	++str;
      } else {
	--fmt;
      }
      continue;
    }
    num = va_arg(args, unsigned long);
    if (*fmt == 'd') {
      j=0;
      while (num && str <= end) {
	*str = (num % 10) + '0';
	num = num / 10;
	++str; j++;
      }
      /* flip */
      for (i = 0; i < (j / 2);i++) {
	n = str[(-j)+i];
	str[(-j)+i] = str[-(i+1)];
	str[-(i+1)] = n;
      }
      /* shift */
      if (field_width > j) {
	i = field_width - j;
	for (n = 1;n <= j;n++) {
	  if (str + i - n <= end) {
	    str[i - n] = str[-n];
	  }
	}
	for (i--;i >= 0;i--) {
	  str[i-j] = filler;
	}
	str += field_width - j;
	j = 1;
      }
    } else {
      for (j=0,i=0;i<8 && str <= end;i++) {
	if ( (n = ((unsigned long)(num & (0xf0000000ul>>(i*4)))) >> ((7-i)*4)) || j != 0) {
	  if (n >= 10)
	    n += 'a'-10;
	  else
	    n += '0';
	  *str = n;
	  ++str;
	  j++;
	}
      }

      /* shift */
      if (field_width > j) {
	i = field_width - j;
	for (n = 1;n <= j;n++) {
	  if (str + i - n <= end) {
	    str[i - n] = str[-n];
	  }
	}
	for (i--;i >= 0;i--) {
	  str[i-j] = filler;
	}
	str += field_width - j;
	j = 1;
      }
      
      
    }
    
    if (j == 0 && str <= end) {
      *str = '0';
      ++str;
    }
  }
  if (str <= end)
    *str = '\0';
  else if (size > 0)
    /* don't write out a null byte if the buf size is zero */
    *end = '\0';
  /* the trailing null byte doesn't count towards the total
   * ++str;
   */
  return str-buf;
}

/**
 * lo_vsprintf - Format a string and place it in a buffer
 * @buf: The buffer to place the result into
 * @fmt: The format string to use
 * @args: Arguments for the format string
 *
 * Call this function if you are already dealing with a va_list.
 * You probably want lo_sprintf instead.
 */
static int lo_vsprintf(char *buf, const char *fmt, va_list args)
{
	return lo_vsnprintf(buf, 0xFFFFFFFFUL, fmt, args);
}


int dbgleon_sprintf(char *buf, size_t size, const char *fmt, ...) {
  va_list args;
  int printed_len;
  
  va_start(args, fmt);
  printed_len = lo_vsnprintf(buf, size, fmt, args);
  va_end(args);
  return printed_len;
}

#define UART_TIMEOUT 100000
static LEON23_APBUART_Regs_Map *uart_regs = 0;
int dbgleon_printf(const char *fmt, ...)
{
  unsigned int i, loops, ch;
  amba_apb_device apbdevs[1];
  va_list args;
  int printed_len;
  char printk_buf[1024];
  char *p = printk_buf;
  
  /* Emit the output into the temporary buffer */
  va_start(args, fmt);
  printed_len = lo_vsnprintf(printk_buf, sizeof(printk_buf), fmt, args);
  va_end(args);
  
  //---------------------
  switch (LEONCOMPAT_VERSION) {
  case 3:
  default: 
    {
      if (!uart_regs) {
	if (i = leon3_getapbbase( VENDOR_GAISLER, GAISLER_APBUART, apbdevs, 1)) {
	  uart_regs = (LEON23_APBUART_Regs_Map *)apbdevs[0].start;
	}
      }
      if (uart_regs) {
	while (printed_len-- != 0) {
	  ch = *p++;
	  if (uart_regs) {
	    loops = 0;
	    while (!(uart_regs->status & LEON_REG_UART_STATUS_THE) && (loops < UART_TIMEOUT))
	      loops++;
	    uart_regs->data = ch;
	    loops = 0;
	    while (!(uart_regs->status & LEON_REG_UART_STATUS_TSE) && (loops < UART_TIMEOUT))
	      loops++;
	  }
	}
      }
    }
    break;
  }
  //---------------------
}
