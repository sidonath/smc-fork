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
// $Id: stoplightdefs.h,v 1.1 2007/01/15 00:23:49 cwrapp Exp $
//
// CHANGE LOG
// (See bottom of this file)
//

typedef enum 
{
    GREEN = 0,
        YELLOW,
        RED
} LightColors;

typedef enum 
{
    EWLIGHT = 1,
        NSLIGHT
} StopLights;

typedef enum
{
    NORTH_SOUTH,
        EAST_WEST
}  Directions;

//
// CHANGE LOG
// $Log: stoplightdefs.h,v $
// Revision 1.1  2007/01/15 00:23:49  cwrapp
// Release 4.4.0 initial commit.
//
