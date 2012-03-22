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
// $Id: AppClass.h,v 1.1 2007/01/15 00:23:49 cwrapp Exp $
//
// CHANGE LOG
// (See bottom of this file)
//

#import "AppClass_sm.h"

@interface AppClass : NSObject
{
    AppClassContext *_fsm;
	BOOL isAcceptable;
}
- (BOOL)checkString:(char*)str;

// Methods called back from the fsm
- (void)Acceptable;
- (void)Unacceptable;
@end

//
// CHANGE LOG
// $Log: AppClass.h,v $
// Revision 1.1  2007/01/15 00:23:49  cwrapp
// Release 4.4.0 initial commit.
//
