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
// $Id: Telephone.h,v 1.1 2009/03/01 18:20:39 cwrapp Exp $
//
// CHANGE LOG
// (See bottom of this file)
//

#import <Cocoa/Cocoa.h>

#define LONG_DISTANCE   1 
#define LOCAL   2 
#define EMERGENCY   3 

#define NYC_TEMP   4 
#define TIME   5 
#define DEPOSIT_MONEY   6 
#define LINE_BUSY   7 
#define INVALID_NUMBER   8 

@class TelephoneContext;

@interface Telephone : NSObject {
    IBOutlet NSTextView *_numberDisplay;
    IBOutlet NSButton *_receiverButton;
    
    int _type;
    NSMutableDictionary *_playingAudioDict;
    NSMutableString *_exchange;
    NSMutableString *_areaCode;
    NSMutableString *_local;
    NSMutableString *_displayString;
    NSMutableDictionary *_timerDict;    
    NSMutableDictionary *_loopDict;
    TelephoneContext *_fsm;
}

- (IBAction)digitPressed:(id)sender;
- (IBAction)offHookPressed:(id)sender;
- (IBAction)onHookPressed:(id)sender;

@end

//
// CHANGE LOG
// $Log: Telephone.h,v $
// Revision 1.1  2009/03/01 18:20:39  cwrapp
// Preliminary v. 6.0.0 commit.
//
