//
// The contents of this file are subject to the Mozilla Public
// License Version 1.1 (the "License"); you may not use this file
// except in compliance with the License. You may obtain a copy
// of the License at http://www.mozilla.org/MPL/
// 
// Software distributed under the License is distributed on an
// "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
// implied. See the License for the specific language governing
// rights and limitations under the License.
// 
// The Original Code is State Machine Compiler (SMC).
// 
// The Initial Developer of the Original Code is Charles W. Rapp.
// Portions created by Charles W. Rapp are
// Copyright (C) 2007. Charles W. Rapp.
// All Rights Reserved.
//
// Author
//	Chris Liscio
//
// RCS ID
// $Id: AppClass.m,v 1.1 2007/01/15 00:23:49 cwrapp Exp $
//
// CHANGE LOG
// (See bottom of this file)
//

#include <unistd.h>
#include <sys/time.h>
#include <memory.h>
#include "AppClass.h"

@implementation AppClass

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _fsm = [[AppClassContext alloc] initWithOwner:self];
    _number_of_requests = 0;
    _continue_running = 1;

    //[_fsm setDebugFlag:YES];
    
    return self;
}

- (void)Run
{
	while (_continue_running)
	{
	    pause();
	}
}

- (void)ReceiveRequest:(const char *)message
{
	if (strncmp(message, "stop", 4) == 0) {
		// Stop processing messages.
		_continue_running = 0;
	} else {
		// Increment the request count.
		++_number_of_requests;

		// Process this message.
		[_fsm RequestReceived];
	}
}

- (void)CheckForRequest
{
	if (_number_of_requests > 0) {
		[_fsm ProcessRequest];
	} else if (_number_of_requests < 0) {
		printf( "The number of outstanding requests is less than zero (%d); resetting to zero.\n", _number_of_requests );
		_number_of_requests = 0;
	}
}

- (void)DoRequest
{
	// Decrement the request count.
	--_number_of_requests;

	// Local variable decalarations.
	struct itimerval nextTimeout;

	// Sleep on this request.
	(void) memset((char *) &nextTimeout, 0, sizeof(nextTimeout));
	nextTimeout.it_value.tv_sec = 5;
	if (setitimer(ITIMER_REAL, &nextTimeout, (struct itimerval *) NULL) < 0) {
	    // Failed to start process timer - quit.
		_continue_running = 0;
	} else {
	    puts( "Processing request ..." );
	}
}

- (void)ProcessingCompleted
{
    puts( "... Processing completed." );

    [_fsm ProcessingDone];
}

@end

//
// CHANGE LOG
// $Log: AppClass.m,v $
// Revision 1.1  2007/01/15 00:23:49  cwrapp
// Release 4.4.0 initial commit.
//
