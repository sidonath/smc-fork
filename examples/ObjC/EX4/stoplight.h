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
// $Id: stoplight.h,v 1.2 2009/11/25 22:30:18 cwrapp Exp $
//
// CHANGE LOG
// (See bottom of this file)
//

#import "stoplightdefs.h"
#import "stoplight_sm.h"

@interface Stoplight : NSObject
{
    stoplightContext *_fsm;    
}
- (id)initWithDirection:(Directions)dir;
- (void)TurnLight:(StopLights)light :(LightColors)color;
- (void)SetTimer:(int)time;
- (void)Timeout;
- (void)Initialize:(Directions)direction;
@end

//
// CHANGE LOG
// $Log: stoplight.h,v $
// Revision 1.2  2009/11/25 22:30:18  cwrapp
// Fixed problem between %fsmclass and sm file names.
//
// Revision 1.1  2007/01/15 00:23:49  cwrapp
// Release 4.4.0 initial commit.
//
