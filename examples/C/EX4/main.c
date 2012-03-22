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
 * Function
 *	Main
 *
 * Description
 *  This routine starts the finite state machine running.
 *
 * RCS ID
 * $Id: main.c,v 1.2 2007/08/05 13:43:36 cwrapp Exp $
 *
 * CHANGE LOG
 * $Log: main.c,v $
 * Revision 1.2  2007/08/05 13:43:36  cwrapp
 * Version 5.0.1 check-in. See net/sf/smc/CODE_README.txt for more information.
 *
 * Revision 1.1  2005/06/16 18:00:35  fperrad
 * Added C examples 1 - 4
 *
 */

#include <stdlib.h>
#include <signal.h>
#include "stoplight.h"

const static char _rcs_id[] = "$Id: main.c,v 1.2 2007/08/05 13:43:36 cwrapp Exp $";

int KeepGoing = 1;

struct smc_ex4_Stoplight TheLight;

int YellowTimer = 2;	/* Yellow lights last 2 seconds. */

int NSGreenTimer = 8;	/* North-south green lasts 8 seconds. */

int EWGreenTimer = 5;	/* East-west green lasts 5 seconds. */

#ifdef WIN32
long Gtimeout;		/* Number of milliseconds until the next timeout. */
#endif

void SigintHandler(int sig)
{
	KeepGoing = 0;
}

#ifndef WIN32
void SigalrmHandler(int sig)
{
	smc_ex4_Stoplight_Timeout(&TheLight);
}
#endif

int main()
{

	signal(SIGINT, SigintHandler);
#ifndef WIN32
	signal(SIGALRM, SigalrmHandler);
#endif

	smc_ex4_Stoplight_Init(&TheLight, EAST_WEST);

	while (KeepGoing) {
#ifdef WIN32
		while (Gtimeout > 0)
		{
			Gtimeout -= 500;
			sleep(500);
		}

		smc_ex4_Stoplight_Timeout(&TheLight);
#endif
	}

	printf("Terminating application.");

	return 0;
}


