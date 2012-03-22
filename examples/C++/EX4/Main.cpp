//
// The contents of this file are subject to the Mozilla Public
// License Version 1.1 (the "License"); you may not use this file
// except in compliance with the License. You may obtain a copy of
// the License at http://www.mozilla.org/MPL/
// 
// Software distributed under the License is distributed on an "AS
// IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
// implied. See the License for the specific language governing
// rights and limitations under the License.
// 
// The Original Code is State Machine Compiler (SMC).
// 
// The Initial Developer of the Original Code is Charles W. Rapp.
// Portions created by Charles W. Rapp are
// Copyright (C) 2000 - 2003 Charles W. Rapp.
// All Rights Reserved.
// 
// Contributor(s): 
//
// Function
//	Main
//
// Description
//  This routine starts the finite state machine running.
//
// RCS ID
// $Id: Main.cpp,v 1.8 2009/03/27 09:41:45 cwrapp Exp $
//
// CHANGE LOG
// $Log: Main.cpp,v $
// Revision 1.8  2009/03/27 09:41:45  cwrapp
// Added F. Perrad changes back in.
//
// Revision 1.7  2009/03/01 18:20:37  cwrapp
// Preliminary v. 6.0.0 commit.
//
// Revision 1.6  2005/06/08 11:09:12  cwrapp
// + Updated Python code generator to place "pass" in methods with empty
//   bodies.
// + Corrected FSM errors in Python example 7.
// + Removed unnecessary includes from C++ examples.
// + Corrected errors in top-level makefile's distribution build.
//
// Revision 1.5  2005/05/28 13:31:18  cwrapp
// Updated C++ examples.
//
// Revision 1.0  2003/12/14 19:21:11  charlesr
// Initial revision
//

#include "stoplight.h"
#include <stdlib.h>
#include <signal.h>

using namespace std;

#ifndef WIN32
#ifndef SA_NOMASK
#define SA_NOMASK 0
#endif
#endif

const static char _rcs_id[] = "$Id: Main.cpp,v 1.8 2009/03/27 09:41:45 cwrapp Exp $";

using namespace cpp_ex4;

Stoplight *TheLight;
int KeepGoing = 1;

int YellowTimer = 2;
	// Yellow lights last 2 seconds.

int NSGreenTimer = 8;
	// North-south green lasts 8 seconds.

int EWGreenTimer = 5;
	// East-west green lasts 5 seconds.

#ifdef WIN32
// Number of milliseconds until the next timeout.
DWORD Gtimeout;
#endif

int main()
{
	void SigintHandler(int);

#ifdef WIN32
    // Windows kinda supports signals.
    (void) signal(SIGINT, SigintHandler);
#else
	struct sigaction signalAction;

	void SigalrmHandler(int);

	signalAction.sa_handler = SigintHandler;
#if defined(__hpux) || defined (__linux__)
	sigemptyset(&signalAction.sa_mask);
#if defined(__linux__)
	signalAction.sa_restorer = NULL;
#endif
#endif
	signalAction.sa_flags = SA_NOMASK;
	if (sigaction(SIGINT, &signalAction, (struct sigaction *) NULL) != 0)
	{
		cerr << "Unable to set SIGINT handling function." << endl;
		exit(1);
	}

	signalAction.sa_handler = SigalrmHandler;
#if defined(__hpux) || defined(__linux__)
	sigemptyset(&signalAction.sa_mask);
#if defined(__linux__)
	signalAction.sa_restorer = NULL;
#endif
#endif
	signalAction.sa_flags = SA_NOMASK;
	if (sigaction(SIGALRM, &signalAction, (struct sigaction *) NULL) != 0)
	{
		cerr << "Unable to set SIGALRM handling function." << endl;
		exit(1);
	}
#endif

	TheLight = Stoplight::Initialize(EAST_WEST);
	if (TheLight == (Stoplight *) NULL)
	{
		cerr << "Failed to create stoplight object." << endl;
		exit(1);
	}

    TheLight->start();

#ifdef WIN32
    // Wait for either the app to end or for timers to expire.
    while (KeepGoing)
    {
        // Because this demo only has one timer, just
        // sleep for that specified time period but for
        // only a half a second at a time to allow SIGINTs
        // to be received.
        while (Gtimeout > 0)
        {
            Gtimeout -= 500;
            Sleep(500);
        }

        TheLight->Timeout();
    }
#else
	while (KeepGoing)
        ;
#endif

	cout << "Terminating application." << endl;
	return(0);
}

void SigintHandler(int)
{
	KeepGoing = 0;
	return;
}

#ifndef WIN32
void SigalrmHandler(int)
{
	TheLight->Timeout();
	return;
}
#endif
