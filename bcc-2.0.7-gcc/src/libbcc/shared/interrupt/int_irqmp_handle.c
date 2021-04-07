/*
 * Copyright (c) 2017, Cobham Gaisler AB
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE. 
 */

#include <stdint.h>
#include <bsp.h>
#include "bcc/bcc_param.h"

#ifndef __BSP_INT_IRQMP_EIRQ
 #define __BSP_INT_IRQMP_EIRQ 0
#endif

#ifndef __BSP_INT_IRQMP_MAP
 #define __BSP_INT_IRQMP_MAP 0
#endif

#ifndef __BSP_INT_IRQMP_NTS
 #define __BSP_INT_IRQMP_NTS 0
#endif

#ifndef __BSP_INT_HANDLE
 #define __BSP_INT_HANDLE 0
#endif

uint32_t __bcc_int_handle = __BSP_INT_HANDLE;
int __bcc_int_irqmp_eirq = __BSP_INT_IRQMP_EIRQ;
int __bcc_int_irqmp_map = __BSP_INT_IRQMP_MAP;
int __bcc_int_irqmp_nts = __BSP_INT_IRQMP_NTS;

