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
// $Id: AppClass.m,v 1.2 2009/04/11 13:04:47 cwrapp Exp $
//
// CHANGE LOG
// (See bottom of this file)
//

#import "AppClass.h"

@implementation AppClass

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _fsm = [[AppClassContext alloc] initWithOwner:self];
    
    //[_fsm setDebugFlag:YES];
    
    return self;
}

- (BOOL)checkString:(char *)theString
{
    [_fsm enterStartState];
	while(*theString)
	{
		switch(*theString)
		{
		case '0':
            [_fsm Zero];
			break;

		case '1':
            [_fsm One];
			break;
			
		case 'c':
		case 'C':
			[_fsm C];
			break;			

		default:
            [_fsm Unknown];
			break;
		}
		++theString;
	}

	// end of string has been reached - send the EOS transition.
    [_fsm EOS];

	return isAcceptable;
}

- (void)Acceptable
{
    isAcceptable = YES;
}

- (void)Unacceptable
{
    isAcceptable = NO;
}

@end

//
// CHANGE LOG
// $Log: AppClass.m,v $
// Revision 1.2  2009/04/11 13:04:47  cwrapp
// Added enterStartState call.
//
// Revision 1.1  2007/01/15 00:23:49  cwrapp
// Release 4.4.0 initial commit.
//
