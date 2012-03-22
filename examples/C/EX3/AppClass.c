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
 *	AppClass
 *
 * RCS ID
 * $Id: AppClass.c,v 1.4 2009/03/27 15:26:55 fperrad Exp $
 *
 * CHANGE LOG
 * $Log: AppClass.c,v $
 * Revision 1.4  2009/03/27 15:26:55  fperrad
 * C : the function Context_EnterStartState is generated only if FSM hasEntryActions
 *
 * Revision 1.3  2009/03/01 18:20:37  cwrapp
 * Preliminary v. 6.0.0 commit.
 *
 * Revision 1.2  2007/08/05 13:41:14  cwrapp
 * Version 5.0.1 check-in. See net/sf/smc/CODE_README.txt for more information.
 *
 * Revision 1.1  2005/06/16 18:00:35  fperrad
 * Added C examples 1 - 4
 *
 */

#include "AppClass.h"

const static char _rcs_id[] = "$Id: AppClass.c,v 1.4 2009/03/27 15:26:55 fperrad Exp $";

const struct AppClassState* AppStack[10];

void AppClass_Init(struct AppClass *this)
{
	this->isAcceptable = 0;

	AppClassContext_Init(&this->_fsm, this);
	FSM_STACK(&this->_fsm, AppStack);

	/* Uncomment to see debug output. */
	/* setDebugFlag(&this->_fsm, 1); */
}

void AppClass_Acceptable(struct AppClass *this)
{
	this->isAcceptable = 1;
}

void AppClass_Unacceptable(struct AppClass *this)
{
	this->isAcceptable = 0;
}

int AppClass_CheckString(struct AppClass *this, const char *theString)
{
	while (*theString)
	{
		switch (*theString)
		{
		case '0':
			AppClassContext_Zero(&this->_fsm);
			break;

		case '1':
			AppClassContext_One(&this->_fsm);
			break;

		case 'c':
		case 'C':
			AppClassContext_C(&this->_fsm);
			break;

		default:
			AppClassContext_Unknown(&this->_fsm);
			break;
		}
		++theString;
	}

	/* end of string has been reached - send the EOS transition. */
	AppClassContext_EOS(&this->_fsm);

	return this->isAcceptable;
}

