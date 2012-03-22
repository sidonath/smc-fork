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
// $Id: main.m,v 1.1 2007/01/15 00:23:50 cwrapp Exp $
//
// CHANGE LOG
// (See bottom of this file)
//

#import "AppClass.h"
#import <signal.h>

#ifndef SA_NOMASK
#define SA_NOMASK 0
#endif

// Global variable declarations.
AppClass *appObject;

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	// External routine declarations.
	void SigintHandler(int dummy);

	// Local variable declarations.
	struct sigaction signalAction;

	// External routine declarations.
	void SigalrmHandler(int dummy);

	// Set up the SIGINT handler.
	signalAction.sa_handler = SigintHandler;
	sigemptyset(&signalAction.sa_mask);
	signalAction.sa_flags = SA_NOMASK;
	if (sigaction(SIGINT, &signalAction, (struct sigaction *) NULL) != 0) {
		puts( "Unable to set SIGINT handling function." );
		exit(1);
	}

	// Set up the SIGALRM handler.
	signalAction.sa_handler = SigalrmHandler;
	sigemptyset(&signalAction.sa_mask);
	signalAction.sa_flags = SA_NOMASK;
	if (sigaction(SIGALRM, &signalAction, (struct sigaction *) NULL) != 0) {
		puts( "Unable to set SIGALRM handling function." );
		exit(1);
	}

    appObject = [[AppClass alloc] init];
    if ( !appObject ) {
        puts( "Could not allocate appObject" );
        exit(1);
    }

	puts( "Starting message processor." );
    [appObject Run];
	puts( "Stopping message processor." );

    [pool release];

	return(0);
}

void SigintHandler(int dummy)
{    // Local variable declarations.
    char theMessage[21];

	printf( "Enter a one word message> " );
	fflush( stdout );
	
	fgets( theMessage, sizeof(theMessage), stdin );

	// Send the message to the context.
	[appObject ReceiveRequest:theMessage];

	return;
}

void SigalrmHandler(int dummy)
{
    [appObject ProcessingCompleted];
}

//
// CHANGE LOG
// $Log: main.m,v $
// Revision 1.1  2007/01/15 00:23:50  cwrapp
// Release 4.4.0 initial commit.
//
