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
 * Class
 *	Stoplight
 *
 * Member Functions
 *	Stoplight()                        - Default constructor.
 *	Stoplight(Directions)              - Set initial direction.
 *	TurnLight(StopLights, LightColors) - Change directions.
 *	SetTimer(int)                      - Start a timer.
 *	Initialize(Directions)             - Set start state and timer.
 *
 * RCS ID
 * $Id: stoplight.c,v 1.6 2010/12/01 15:29:09 fperrad Exp $
 *
 * CHANGE LOG
 * $Log: stoplight.c,v $
 * Revision 1.6  2010/12/01 15:29:09  fperrad
 * C: refactor when package
 *
 * Revision 1.5  2009/11/25 22:30:18  cwrapp
 * Fixed problem between %fsmclass and sm file names.
 *
 * Revision 1.4  2009/03/27 15:26:55  fperrad
 * C : the function Context_EnterStartState is generated only if FSM hasEntryActions
 *
 * Revision 1.3  2009/03/01 18:20:37  cwrapp
 * Preliminary v. 6.0.0 commit.
 *
 * Revision 1.2  2007/08/05 13:43:36  cwrapp
 * Version 5.0.1 check-in. See net/sf/smc/CODE_README.txt for more information.
 *
 * Revision 1.1  2005/06/16 18:00:35  fperrad
 * Added C examples 1 - 4
 *
 */

#ifndef WIN32
#include <unistd.h>
#endif
#include "stoplight.h"

const static char _rcs_id[] = "$Id: ";

extern int NSGreenTimer;
extern int EWGreenTimer;
#ifdef WIN32
extern long Gtimeout;
#endif

void smc_ex4_Stoplight_Init(struct smc_ex4_Stoplight* this, enum Directions direction)
{
    smc_ex4_stoplightContext_Init(&this->_fsm, this);

    switch(direction)
    {
        case NORTH_SOUTH:
            printf("Turning the north-south lights green.\n");
            setState(&this->_fsm, &smc_ex4_StopMap_NorthSouthGreen);
            smc_ex4_Stoplight_SetTimer(this, NSGreenTimer);
            break;

        case EAST_WEST:
            printf("Turning the east-west lights green.\n");
            setState(&this->_fsm, &smc_ex4_StopMap_EastWestGreen);
            smc_ex4_Stoplight_SetTimer(this, EWGreenTimer);
            break;
    }

    /* Uncomment to see debug messages. */
    /* setDebugFlag(&this->_fsm, 1); */
}

void smc_ex4_Stoplight_TurnLight(struct smc_ex4_Stoplight* this, enum StopLights light, enum LightColors color)
{
    printf("Turning the ");

    switch (light)
    {
        case EWLIGHT:
            printf("east-west lights ");
            break;

        case NSLIGHT:
            printf("north-south lights ");
            break;
    }

    switch(color)
    {
        case GREEN:
            printf("green.\n");
            break;

        case YELLOW:
            printf("yellow.\n");
            break;

        case RED:
            printf("red.\n");
            break;
    }
}

void smc_ex4_Stoplight_SetTimer(struct smc_ex4_Stoplight* this, int seconds)
{
#ifdef WIN32
    Gtimeout = seconds * 1000;
#else
    alarm(seconds);
#endif
}

void smc_ex4_Stoplight_Timeout(struct smc_ex4_Stoplight* this)
{
    smc_ex4_stoplightContext_Timeout(&this->_fsm);
}



