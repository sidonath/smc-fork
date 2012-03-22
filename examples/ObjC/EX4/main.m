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
// $Id: main.m,v 1.1 2007/01/15 00:23:49 cwrapp Exp $
//
// CHANGE LOG
// (See bottom of this file)
//

#import "stoplight.h"
#import <stdlib.h>
#import <signal.h>

#ifndef SA_NOMASK
#define SA_NOMASK 0
#endif

Stoplight *TheLight;
int KeepGoing = 1;
int YellowTimer = 2;
int NSGreenTimer = 8;
int EWGreenTimer = 5;

int main()
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	void SigintHandler(int dummy);

	struct sigaction signalAction;

	void SigalrmHandler(int dummy);

	signalAction.sa_handler = SigintHandler;
	sigemptyset(&signalAction.sa_mask);
	signalAction.sa_flags = SA_NOMASK;
	if (sigaction(SIGINT, &signalAction, (struct sigaction *) NULL) != 0) {
        puts("Unable to set SIGINT handling function.");
		exit(1);
	}

	signalAction.sa_handler = SigalrmHandler;
	sigemptyset(&signalAction.sa_mask);

	signalAction.sa_flags = SA_NOMASK;
	if (sigaction(SIGALRM, &signalAction, (struct sigaction *) NULL) != 0) {
		puts( "Unable to set SIGALRM handling function." );
		exit(1);
	}

    TheLight = [[Stoplight alloc] initWithDirection:EAST_WEST];
	if (TheLight == nil) {
		puts("Failed to create stoplight object.");
		exit(1);
	}

	while (KeepGoing)
        ;

    puts( "Terminating application.");
    [pool release];
	return(0);
}

void SigintHandler(int dummy)
{
	KeepGoing = 0;
	return;
}

void SigalrmHandler(int dummy)
{
	[TheLight Timeout];
	return;
}

//
// CHANGE LOG
// $Log: main.m,v $
// Revision 1.1  2007/01/15 00:23:49  cwrapp
// Release 4.4.0 initial commit.
//
