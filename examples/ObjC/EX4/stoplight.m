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
// $Id: stoplight.m,v 1.2 2009/11/25 22:30:18 cwrapp Exp $
//
// CHANGE LOG
// (See bottom of this file)
//

#import <sys/time.h>
#import <stdlib.h>
#import "stoplight.h"

extern int NSGreenTimer;
extern int EWGreenTimer;

@implementation Stoplight

- (id)initWithDirection:(Directions)dir
{
    self = [super init];
    if ( !self ) {
        return nil;
    }
    
    _fsm = [[stoplightContext alloc] initWithOwner:self];
    [self Initialize:dir];

    // Uncomment to see debug messages.
    // [_fsm setDebugFlag:YES];
    
    return self;
}

- (void)TurnLight:(StopLights)light :(LightColors)color;
{
    printf("Turning the ");

    switch(light)
    {
        case EWLIGHT:
            printf( "east-west lights " );
            break;

        case NSLIGHT:
            printf( "north-south lights " );
            break;
    }

    switch(color)
    {
        case GREEN:
            printf( "green." );
            break;

        case YELLOW:
            printf( "yellow." );
            break;

        case RED:
            printf( "red." );
            break;
    }

    printf( "\n" );
}

- (void)SetTimer:(int)seconds
{
    struct itimerval timeout;

    timeout.it_value.tv_sec = seconds;
    timeout.it_value.tv_usec = 0;
    timeout.it_interval.tv_sec = 0;
    timeout.it_interval.tv_usec = 0;

    if (setitimer(ITIMER_REAL, &timeout, (struct itimerval *) NULL) < 0) {
        puts("Failed to set timer. Quitting application.");
        exit(1);
    }
}
    
- (void)Initialize:(Directions)direction
{
    switch(direction)
    {
        case NORTH_SOUTH:
            puts("Turning the north-south lights green.");
            [_fsm setState:[StopMap NorthSouthGreen]];
            [self SetTimer:NSGreenTimer];
            break;

        case EAST_WEST:
            puts("Turning the east-west lights green.");
            [_fsm setState:[StopMap EastWestGreen]];
            [self SetTimer:EWGreenTimer];
            break;
    }
}

- (void)Timeout
{
    [_fsm Timeout];
}

@end

//
// CHANGE LOG
// $Log: stoplight.m,v $
// Revision 1.2  2009/11/25 22:30:18  cwrapp
// Fixed problem between %fsmclass and sm file names.
//
// Revision 1.1  2007/01/15 00:23:49  cwrapp
// Release 4.4.0 initial commit.
//
