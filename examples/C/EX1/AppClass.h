#ifndef _H_THECONTEXT
#define _H_THECONTEXT

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
 *	AppClass
 *
 * Description
 *	When a state map executes an action, it is really calling a
 *	member function in the context class.
 *
 * RCS ID
 * $Id: AppClass.h,v 1.2 2007/08/05 13:36:32 cwrapp Exp $
 *
 * CHANGE LOG
 * $Log: AppClass.h,v $
 * Revision 1.2  2007/08/05 13:36:32  cwrapp
 * Version 5.0.1 check-in. See net/sf/smc/CODE_README.txt for more information.
 *
 * Revision 1.1  2005/06/16 18:00:15  fperrad
 * Added C examples 1 - 4
 *
 */

#include "AppClass_sm.h"

struct AppClass
{
	/* If a string is acceptable, then this variable is set to YES;
	 * NO, otherwise.
	 */
	int isAcceptable;

	struct AppClassContext _fsm;
};

extern void AppClass_Init(struct AppClass *);
extern int AppClass_CheckString(struct AppClass *, const char*);
extern void AppClass_Acceptable(struct AppClass *);
extern void AppClass_Unacceptable(struct AppClass *);

#endif
