//
// The contents of this file are subject to the Mozilla Public
// License Version 1.1 (the "License"); you may not use this file
// except in compliance with the License. You may obtain a copy of
// the License at http://www.mozilla.org/MPL/
// 
// Software distributed under the License is distributed on an "AS
// IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
// implied. See the License for the specific language governing
// rights and limitations under the License.
// 
// The Original Code is State Machine Compiler (SMC).
// 
// The Initial Developer of the Original Code is Charles W. Rapp.
// Portions created by Charles W. Rapp are
// Copyright (C) 2000 - 2003 Charles W. Rapp.
// All Rights Reserved.
// 
// Contributor(s): 
//
// Function
//	Main
//
// Description
//  This routine starts the finite state machine running.
//
// RCS ID
// $Id: Main.cpp,v 1.7 2006/06/03 19:39:24 cwrapp Exp $
//
// CHANGE LOG
// $Log: Main.cpp,v $
// Revision 1.7  2006/06/03 19:39:24  cwrapp
// Final v. 4.3.1 check in.
//
// Revision 1.6  2006/04/22 12:45:24  cwrapp
// Version 4.3.1
//
// Revision 1.5  2005/06/08 11:09:12  cwrapp
// + Updated Python code generator to place "pass" in methods with empty
//   bodies.
// + Corrected FSM errors in Python example 7.
// + Removed unnecessary includes from C++ examples.
// + Corrected errors in top-level makefile's distribution build.
//
// Revision 1.4  2005/05/28 13:31:16  cwrapp
// Updated C++ examples.
//
// Revision 1.1  2004/09/06 15:23:39  charlesr
// Updated for SMC v. 3.1.0.
//
// Revision 1.0  2003/12/14 19:12:12  charlesr
// Initial revision
//

#include "AppClass.h"

const static char _rcs_id[] = "$Id: Main.cpp,v 1.7 2006/06/03 19:39:24 cwrapp Exp $";

using namespace std;
using namespace statemap;

int main(int argc, char *argv[])
{
	AppClass thisContext;
    int retcode = 0;

	if (argc < 2)
	{
		cerr << "No string to check." << endl;
        retcode = 2;
	}
    else if (argc > 2)
    {
        cerr << "Only one argument is accepted." << endl;
        retcode = 3;
    }
	else
	{
		cout << "The string \"" << argv[1] << "\" is ";

        try
        {
            if (thisContext.CheckString(argv[1]) == false)
            {
                cout << "not acceptable." << endl;
                retcode = 1;
            }
            else
            {
                cout << "acceptable." << endl;
            }
        }
        catch (SmcException smcex)
        {
            cout << "not acceptable - "
                 << smcex.what()
                 << '.'
                 << endl;

            retcode = 1;
        }
	}

	return (retcode);
}
