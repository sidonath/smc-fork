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

#import "AppClass.h"

int main( int argc, char *argv[] )
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	AppClass *thisContext = [[AppClass alloc] init];
    int retcode = 0;

	if (argc < 2)
	{
        puts( "No string to check" );
        retcode = 2;
	}
    else if (argc > 2)
    {
        puts( "Only one argument is accepted." );
        retcode = 3;
    }
	else
	{
        printf( "The string %s is ", argv[1] );

        if ([thisContext checkString:argv[1]] == false)
        {
            puts( "not acceptable" );
            retcode = 1;
        }
        else
        {
            puts( "acceptable" );
        }
	}

    [pool release];

	return (retcode);
}

//
// CHANGE LOG
// $Log: main.m,v $
// Revision 1.1  2007/01/15 00:23:49  cwrapp
// Release 4.4.0 initial commit.
//
