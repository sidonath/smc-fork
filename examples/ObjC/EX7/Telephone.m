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
// $Id: Telephone.m,v 1.2 2009/04/11 13:05:37 cwrapp Exp $
//
// CHANGE LOG
// (See bottom of this file)
//

#import "Telephone.h"
#import "Telephone_sm.h"

static NSArray *gSoundNameArray = nil;

@implementation Telephone

+ (void)initialize
{
    if ( !gSoundNameArray ) {
        gSoundNameArray = [NSArray arrayWithObjects: @"0" , @"1" , @"10" , @"11" , @"12" , @"13" , @"14" , @"15" , @"16" , @"17" , @"18" , @"19" , @"2" , @"20" , @"3" , @"30" , @"4" , @"40" , @"5" , @"50" , @"50_cents_please" , @"6" , @"7" , @"8" , @"9" , @"911" , @"AM" , @"PM" , @"and" , @"busy_signal" , @"could_not_be_completed" , @"dialtone" , @"error_signal" , @"exactly" , @"fast_busy_signal" , @"nyctemp" , @"oclock" , @"oh" , @"phone_off_hook" , @"ring" , @"second" , @"seconds" , @"the_number_you_have_dialed" , @"the_time_is" , @"touch_tone_0" , @"touch_tone_1" , @"touch_tone_10" , @"touch_tone_11" , @"touch_tone_2" , @"touch_tone_3" , @"touch_tone_4" , @"touch_tone_5" , @"touch_tone_6" , @"touch_tone_7" , @"touch_tone_8" , @"touch_tone_9", nil];
    }
}

- (NSMutableDictionary*)playingAudioDict
{
    return _playingAudioDict;
}

- (void)setPlayingAudioDict:(NSMutableDictionary*)aValue
{
    NSMutableDictionary* oldPlayingAudioDict = _playingAudioDict;
    _playingAudioDict = [aValue retain];
    [oldPlayingAudioDict release];
}

- (NSSound*)soundNamed:(NSString*)name
{
    NSSound *ret = [[[NSSound alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"au"] byReference:YES] autorelease];
    [ret setDelegate:self];
    return ret;
}

- (void)awakeFromNib
{
    _loopDict = [[NSMutableDictionary alloc] init];
    _timerDict = [[NSMutableDictionary alloc] init];
    _fsm = [[TelephoneContext alloc] initWithOwner:self];
    [_fsm setDebugFlag:YES];
    [_fsm enterStartState];
}

//
// UI Events
//
- (IBAction)digitPressed:(id)sender
{
    if ( [[sender title] isEqualToString:@"*"] ) {
        [_fsm Digit:@"10"];
    } else if ( [[sender title] isEqualToString:@"#"] ) {
        [_fsm Digit:@"11"];
    } else {
        [_fsm Digit:[sender title]];        
    }
}

- (IBAction)offHookPressed:(id)sender
{   
    [_fsm OffHook];
}

- (IBAction)onHookPressed:(id)sender
{
    [_fsm OnHook];    
}

//
// Actions
//

// Getting/setting actions
- (void)setType:(int)type
{
    _type = type;
}
- (int)type
{
    return _type;
}
- (void)addDisplay:(NSString*)str
{
    [_displayString appendString:str];
    [_numberDisplay setString:_displayString];
}
- (void)setDisplayString:(NSString*)d
{
    id old = _displayString;
    _displayString = [d mutableCopy];
    [old release];
}
- (NSString*)displayString
{
    return _displayString;
}
- (void)saveExchange:(NSString*)exch
{
    [_exchange appendString:exch];
    [self addDisplay:exch];
}
- (void)setExchange:(NSString*)exch
{
    id old = _exchange;
    _exchange = [exch mutableCopy];
    [old release];    
}
- (NSString*)exchange
{
    return _exchange;
}
- (void)saveAreaCode:(NSString*)ac
{
    [_areaCode appendString:ac];
    [self addDisplay:ac];
}
- (void)setAreaCode:(NSString*)ac
{
    id old = _areaCode;
    _areaCode = [ac mutableCopy];
    [old release];
}
- (NSString*)areaCode
{
    return _areaCode;
}
- (void)saveLocal:(NSString*)loc
{
    [_local appendString:loc];
    [self addDisplay:loc];
}
- (void)setLocal:(NSString*)loc
{
    id old = _local;
    _local = [loc mutableCopy];
    [old release];
}
- (NSString*)local
{
    return _local;
}

// Display actions
- (void)updateClock
{
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [_numberDisplay setString:[df stringFromDate:[NSDate date]]];
}
- (void)clearDisplay
{
    [self setLocal:@""];
    [self setExchange:@""];
    [self setAreaCode:@""];
    [self setDisplayString:@""];

    [_numberDisplay setString:@""];
}

// Receiver button actions
- (void)setReceiver:(SEL)command :(NSString*)text
{
    [_receiverButton setTitle:text];
    [_receiverButton setAction:command];
}

// Timer actions
- (void)startClockTimer
{
    
}
- (void)startTimer:(NSString*)timer :(int)duration
{
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[TelephoneContext instanceMethodSignatureForSelector:NSSelectorFromString(timer)]];
    [inv setTarget:_fsm];
    [inv setSelector:NSSelectorFromString(timer)];
    NSTimer *aTimer = [NSTimer scheduledTimerWithTimeInterval:(float)duration / 1000.0
                                                   invocation:inv
                                                      repeats:NO];
    
    [_timerDict setObject:aTimer forKey:timer];
}
- (void)stopTimer:(NSString*)timer
{
    NSTimer *aTimer = [_timerDict objectForKey:timer];
    [aTimer invalidate];
    [_timerDict removeObjectForKey:timer];
}
- (void)resetTimer:(NSString*)timer
{
    NSTimer *aTimer = [_timerDict objectForKey:timer];
    [aTimer invalidate];
    NSDate *fireDate = [NSDate date];
    [fireDate addTimeInterval:[aTimer timeInterval]];
    [aTimer setFireDate:fireDate];
    [[NSRunLoop currentRunLoop] addTimer:aTimer forMode:NSDefaultRunLoopMode];
}

// Phone related actions
- (void)routeCall:(int)type :(NSString*)area :(NSString*)exchange :(NSString*)local
{
    int route = 0;
    
    if (type == EMERGENCY)
    {
        route = EMERGENCY;
    } else if (type == LONG_DISTANCE &&
              [area isEqualToString:@"1212"] &&
              [exchange isEqualToString:@"555"] &&
              [local isEqualToString:@"1234"]) {
        route = NYC_TEMP;
    } else if ([exchange isEqualToString:@"555"])  {
        if ([local isEqualToString:@"1212"]) {
            route = TIME;
        } else {
            route = LINE_BUSY;
        }
    } else if (type == LOCAL) {
        route = DEPOSIT_MONEY;
    } else {
        route = INVALID_NUMBER;
    }
    
    [self performSelector:@selector(callRoute:) withObject:[NSNumber numberWithInt:route] afterDelay:0.1];
}

- (void)callRoute:(NSNumber*)route
{
    switch ([route intValue])
    {
        case EMERGENCY:
            [_fsm Emergency];
            break;
            
        case NYC_TEMP:
            [_fsm NYCTemp];
            break;
            
        case TIME:
            [_fsm Time];
            break;
            
        case DEPOSIT_MONEY:
            [_fsm DepositMoney];
            break;
            
        case LINE_BUSY:
            [_fsm LineBusy];
            break;
            
        case INVALID_NUMBER:
            [_fsm InvalidNumber];
            break;
    }
}

// Sound actions
- (void)loop:(NSString*)name
{
    if ( ![_loopDict objectForKey:name] ) {
        NSSound *sound = [self soundNamed:name];
        [sound setDelegate:self];
        [sound play];
        [_loopDict setObject:sound forKey:name];
    }
}

- (void)stopLoop:(NSString*)name
{
    [[_loopDict objectForKey:name] setDelegate:nil];
    [(NSSound*)[_loopDict objectForKey:name] stop];
    [_loopDict removeObjectForKey:name];
}

- (void)playSoundNamed:(NSString*)sound
{
    NSMutableDictionary *playingAudio = [NSMutableDictionary dictionary];
    NSMutableArray *playList = [NSMutableArray array];
    
    [playingAudio setObject:playList forKey:@"playlist"];
    [playingAudio setObject:[NSNumber numberWithInt:0] forKey:@"cur"];
    
    [playList addObject:[self soundNamed:sound]];
    
    [[playList objectAtIndex:0] play];
    
    [self setPlayingAudioDict:playingAudio];
}

- (void)playTT:(NSString*)num
{
    [[self soundNamed:[NSString stringWithFormat:@"touch_tone_%@", num]] play];
}

- (void)playEmergency
{
    [self playSoundNamed:@"911"];
}

- (void)playNYCTemp
{
    [self playSoundNamed:@"nyctemp"];
}

- (void)playDepositMoney
{
    [self playSoundNamed:@"50_cents_please"];
}

- (void)stopPlayback
{
    int index = [[[self playingAudioDict] objectForKey:@"cur"] intValue];
    NSArray *sounds = [[self playingAudioDict] objectForKey:@"playlist"];
    if ( index < [sounds count] ) {
        [(NSSound*)[sounds objectAtIndex:index] stop];        
    }
}

- (void)soundNumber:(int)num toList:(NSMutableArray*)playList withOh:(BOOL)oh;
{
    if ( num < 10 && oh ) {
        [playList addObject:[self soundNamed:@"oh"]];
        [playList addObject:[self soundNamed:[NSString stringWithFormat:@"%d",num]]];
    } else if ( num < 20 ) {
        [playList addObject:[self soundNamed:[NSString stringWithFormat:@"%d",num]]];
    } else {
        int ones = num % 10;
        int tens = num - ones;
        [playList addObject:[self soundNamed:[NSString stringWithFormat:@"%d",tens]]];
        if ( ones > 0 ) {
            [playList addObject:[self soundNamed:[NSString stringWithFormat:@"%d",ones]]];
        }
    }
}

- (void)soundMeridian:(BOOL)isAM toList:(NSMutableArray*)playList
{
    if ( isAM ) {
        [playList addObject:[self soundNamed:@"AM"]];
    } else {
        [playList addObject:[self soundNamed:@"PM"]];
    }    
}

- (void)playTime
{
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dc = [cal components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
    int hour = [dc hour];
    int minute = [dc minute];
    int seconds = [dc second];
    int isAM = (hour < 12)?1:0;
    hour = (hour<12)?hour:hour-12;
    
    NSMutableDictionary *playingAudio = [NSMutableDictionary dictionary];
    NSMutableArray *playList = [NSMutableArray array];
    
    [playingAudio setObject:playList forKey:@"playlist"];
    [playingAudio setObject:[NSNumber numberWithInt:0] forKey:@"cur"];
    
    [playList addObject:[self soundNamed:@"the_time_is"]];
    
    // Read the hour
    [playList addObject:[self soundNamed:[NSString stringWithFormat:@"%d", hour]]];
    
    if ( minute == 0 && seconds == 0 ) {
        [playList addObject:[self soundNamed:@"oclock"]];
        [self soundMeridian:isAM toList:playList];
        [playList addObject:[self soundNamed:@"exactly"]];
    } else {
        // Read the minute
        [self soundNumber:minute toList:playList withOh:YES];
        [self soundMeridian:isAM toList:playList];
        
        // Read the seconds
        if ( seconds == 0 ) {
            [playList addObject:[self soundNamed:@"exactly"]];
        } else {
            [playList addObject:[self soundNamed:@"and"]];
            [self soundNumber:seconds toList:playList withOh:NO];
            if ( seconds == 1 ) {
                [playList addObject:[self soundNamed:@"second"]];
            } else {
                [playList addObject:[self soundNamed:@"seconds"]];
            }
        }
    }
    
    [[playList objectAtIndex:0] play];
    
    [self setPlayingAudioDict:playingAudio];
}

- (void)soundPhoneNumber:(NSMutableArray*)list
{
    int i;
    // If this is a long distance number, sound out the
    // area code first.
    if ( [self type] == LONG_DISTANCE ) {
        for( i = 0; i < [[self areaCode] length]; i++ ) {
            [list addObject:[self soundNamed:[[self areaCode] substringWithRange:NSMakeRange(i,1)]]];
        }
    }
    // All types have an exchange.
    for( i = 0; i < [[self exchange] length]; i++ ) {
        [list addObject:[self soundNamed:[[self exchange] substringWithRange:NSMakeRange(i,1)]]];
    }
    // Only long distance and local numbers have a local
    // portion.
    if ([self type] == LONG_DISTANCE || [self type] == LOCAL) {
        for( i = 0; i < [[self local] length]; i++ ) {
            [list addObject:[self soundNamed:[[self local] substringWithRange:NSMakeRange(i,1)]]];
        }
    }
}

- (void)playInvalidNumber
{
    NSMutableDictionary *playingAudio = [NSMutableDictionary dictionary];
    NSMutableArray *playList = [NSMutableArray array];
    
    [playingAudio setObject:playList forKey:@"playlist"];
    [playingAudio setObject:[NSNumber numberWithInt:0] forKey:@"cur"];
    
    [playList addObject:[self soundNamed:@"the_number_you_have_dialed"]];
    [self soundPhoneNumber:playList];
    [playList addObject:[self soundNamed:@"could_not_be_completed"]];
    
    [[playList objectAtIndex:0] play];

    [self setPlayingAudioDict:playingAudio];
}

//
// NSSound delegate method
// 

- (BOOL)isLoopingSound:(NSSound*)sound
{
    NSEnumerator *e = [[_loopDict allValues] objectEnumerator];
    NSSound *s = nil;
    while ( s = [e nextObject] ) {
        if ( [s isEqual:sound] ) {
            return YES;
        }
    }
    return NO;
}

- (void)sound:(NSSound*)sound didFinishPlaying:(BOOL)didFinish
{
    if ( [self isLoopingSound:sound] ) {
        [sound play];
    } else {
        int index = [[[self playingAudioDict] objectForKey:@"cur"] intValue];
        NSArray *sounds = [[self playingAudioDict] objectForKey:@"playlist"];
        if ( index < [sounds count] && [sound isEqual:[sounds objectAtIndex:index]] ) {
            index++;
            [[self playingAudioDict] setObject:[NSNumber numberWithInt:index] forKey:@"cur"];
            if ( index < [sounds count] ) {
                [[sounds objectAtIndex:index] play];
            } else {
                [_fsm PlaybackDone];
            }
        }
    }
}
@end

//
// CHANGE LOG
// $Log: Telephone.m,v $
// Revision 1.2  2009/04/11 13:05:37  cwrapp
// Added enterStartState call.
//
// Revision 1.1  2009/03/01 18:20:39  cwrapp
// Preliminary v. 6.0.0 commit.
//
