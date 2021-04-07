/*
 * Copyright 2018 Cobham Gaisler AB
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include <drv/grspw.h>
#include <drv/drvret.h>

int grspw_rmap_set_destkey(struct grspw_priv *priv, uint32_t destkey)
{
        priv->regs->destkey = destkey & GRSPW_DK_DESTKEY;
        return DRV_OK;
}

uint32_t grspw_rmap_get_destkey(struct grspw_priv *priv)
{
        return priv->regs->destkey & GRSPW_DK_DESTKEY;
}

