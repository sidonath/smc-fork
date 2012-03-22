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
 * $Id: main.c,v 1.2 2007/08/05 13:39:13 cwrapp Exp $
 *
 * CHANGE LOG
 * $Log: main.c,v $
 * Revision 1.2  2007/08/05 13:39:13  cwrapp
 * Version 5.0.1 check-in. See net/sf/smc/CODE_README.txt for more information.
 *
 * Revision 1.1  2005/06/16 18:00:15  fperrad
 * Added C examples 1 - 4
 *
 */

#include <stdio.h>
#include "AppClass.h"

const static char _rcs_id[] = "$Id: main.c,v 1.2 2007/08/05 13:39:13 cwrapp Exp $";

int main(int argc, char *argv[])
{
	struct AppClass thisContext;
	int retcode = 0;
	char *result;

	if (argc < 2)
	{
		fprintf(stderr, "No string to check.\n");
		retcode = 2;
	}
	else if (argc > 2)
	{
		fprintf(stderr, "Only one argument is accepted.\n");
		retcode = 3;
	}
	else
	{
		AppClass_Init(&thisContext);
		if (AppClass_CheckString(&thisContext, argv[1]) == 0)
		{
			result = "not acceptable";
			retcode = 1;
		}
		else
		{
			result = "acceptable";
		}
		printf("The string \"%s\" is %s\n", argv[1], result);
	}

	return retcode;
}
