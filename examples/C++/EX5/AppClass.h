#ifndef _H_APPCLASS
#define _H_APPCLASS

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
// Name
//	AppClass
//
// Description
//	When a state map executes an action, it is really calling a
//	member function in the context class.
//
// RCS ID
// $Id: AppClass.h,v 1.4 2005/05/28 13:31:18 cwrapp Exp $
//
// CHANGE LOG
// $Log: AppClass.h,v $
// Revision 1.4  2005/05/28 13:31:18  cwrapp
// Updated C++ examples.
//
// Revision 1.0  2003/12/14 19:29:51  charlesr
// Initial revision
//

#include "AppClass_sm.h"

class AppClass
{
private:
    // This class' state machine.
    AppClassContext _fsm;

    // The number of requests outstanding.
    int _number_of_requests;

    // 1 - continue processing messages; 0 - stop processing.
    int _continue_running;

public:
	AppClass();
		// Default constructor.

	inline ~AppClass() {};
		// Destructor.

	void Run();
	    // Start the message processing.

	void ReceiveRequest(const char *message);
	    // Increment the number of requests and issue a RequestReceived
		// transition.

	void CheckForRequest();
	    // Check to see if there is another request to process.

	void DoRequest();
	    // Handle all messages the same way: sleep on it.

	void ProcessingCompleted();
	    // The processing of the current request has finished.
};

#endif

