#ifndef _H_STOPLIGHT
#define _H_STOPLIGHT

/*
 * The contents of this file are subject to the Mozilla Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy
 * of the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an
 * "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 *
 * The Original Code is State Machine Compiler (SMC).
 *
 * The Initial Developer of the Original Code is Charles W. Rapp.
 * Portions created by Charles W. Rapp are
 * Copyright (C) 2000 - 2003 Charles W. Rapp.
 * All Rights Reserved.
 *
 * Contributor(s):
 *      Port to C by Francois Perrad, francois.perrad@gadz.org
 *
 * Name
 *	TheContext
 *
 * Description
 *	When a state map executes an action, it is really calling a
 *	member function in the context class.
 *
 * RCS ID
 * $Id: stoplight.h,v 1.4 2010/12/01 15:29:09 fperrad Exp $
 *
 * CHANGE LOG
 * $Log: stoplight.h,v $
 * Revision 1.4  2010/12/01 15:29:09  fperrad
 * C: refactor when package
 *
 * Revision 1.3  2009/11/25 22:30:18  cwrapp
 * Fixed problem between %fsmclass and sm file names.
 *
 * Revision 1.2  2007/08/05 13:43:36  cwrapp
 * Version 5.0.1 check-in. See net/sf/smc/CODE_README.txt for more information.
 *
 * Revision 1.1  2005/06/16 18:00:35  fperrad
 * Added C examples 1 - 4
 *
 */

#include "stoplight_sm.h"

enum LightColors
{
    GREEN = 0,
    YELLOW,
    RED
};

enum StopLights
{
    EWLIGHT = 1,
    NSLIGHT
};

enum Directions
{
    NORTH_SOUTH,
    EAST_WEST
};

struct smc_ex4_Stoplight
{
    struct smc_ex4_stoplightContext _fsm;
};

extern void smc_ex4_Stoplight_Init(struct smc_ex4_Stoplight*, enum Directions);
extern void smc_ex4_Stoplight_TurnLight(struct smc_ex4_Stoplight*, enum StopLights, enum LightColors);
extern void smc_ex4_Stoplight_SetTimer(struct smc_ex4_Stoplight*, int);
extern void smc_ex4_Stoplight_Timeout(struct smc_ex4_Stoplight*);

#endif
