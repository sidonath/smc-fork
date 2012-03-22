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
// $Id: Main.cpp,v 1.6 2007/12/28 12:34:40 cwrapp Exp $
//
// CHANGE LOG
// $Log: Main.cpp,v $
// Revision 1.6  2007/12/28 12:34:40  cwrapp
// Version 5.0.1 check-in.
//
// Revision 1.5  2005/06/08 11:09:12  cwrapp
// + Updated Python code generator to place "pass" in methods with empty
//   bodies.
// + Corrected FSM errors in Python example 7.
// + Removed unnecessary includes from C++ examples.
// + Corrected errors in top-level makefile's distribution build.
//
// Revision 1.4  2005/05/28 13:31:18  cwrapp
// Updated C++ examples.
//
// Revision 1.0  2003/12/14 19:30:51  charlesr
// Initial revision
//

#include "AppClass.h"
#include <signal.h>

using namespace std;

#ifndef WIN32
#ifndef SA_NOMASK
#define SA_NOMASK 0
#endif
#endif

const static char _rcs_id[] = "$Id: Main.cpp,v 1.6 2007/12/28 12:34:40 cwrapp Exp $";

// Global variable declarations.
AppClass appObject;

int main(int, char**)
{
	// External routine declarations.
	void SigintHandler(int);

#ifdef WIN32
    // Windows kinda supports signals.
    (void) signal(SIGINT, SigintHandler);
#else
	// Local variable declarations.
	struct sigaction signalAction;

	// External routine declarations.
	void SigalrmHandler(int);

	// Set up the SIGINT handler.
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

	// Set up the SIGALRM handler.
	signalAction.sa_handler = SigalrmHandler;
#if defined(__hpux) || defined (__linux__)
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

	cout << "Starting message processor." << endl;
	appObject.Run();
	cout << "Stopping message processor." << endl;

	return(0);
}

void SigintHandler(int)
{    // Local variable declarations.
    char theMessage[21];

	cout << "Enter a one word message> " << flush;
	cin >> theMessage;

	// Send the message to the context.
	appObject.ReceiveRequest(theMessage);

#ifdef WIN32
    // Windows removes the SIGINT callback. So put
    // the callback back in place.
    (void) signal(SIGINT, SigintHandler);
#endif

	return;
}

#ifndef WIN32
void SigalrmHandler(int)
{
	appObject.ProcessingCompleted();
}
#endif
