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
// Copyright (C) 2000 - 2003 Charles W. Rapp.
// All Rights Reserved.
// 
// Contributor(s): 
//
// Function
//  Main
//
// Description
//  This routine starts the finite state machine running.
//
// RCS ID
// $Id: checkstring.java,v 1.2 2007/08/05 13:05:16 cwrapp Exp $
//
// CHANGE LOG
// $Log: checkstring.java,v $
// Revision 1.2  2007/08/05 13:05:16  cwrapp
// Version 5.0.1 check-in. See net/sf/smc/CODE_README.txt for more information.
//
// Revision 1.1  2005/05/28 12:49:21  cwrapp
// Added Ant examples 1 - 7.
//
// Revision 1.1  2004/09/06 15:12:09  charlesr
// Updated for SMC v. 3.1.0. Using new -d option.
//
// Revision 1.0  2004/05/30 21:41:50  charlesr
// Initial revision
//
// Revision 1.1.1.2  2001/03/26 14:41:47  cwrapp
// Corrected Entry/Exit action semantics. Exit actions are now
// executed only by simple transitions and pop transitions.
// Entry actions are executed by simple transitions and push
// transitions. Loopback transitions do not execute either Exit
// actions or entry actions. See SMC Programmer's manual for
// more information.
//
// Revision 1.1.1.1  2001/01/03 03:14:00  cwrapp
//
// ----------------------------------------------------------------------
// SMC - The State Map Compiler
// Version: 1.0, Beta 3
//
// SMC compiles state map descriptions into a target object oriented
// language. Currently supported languages are: C++, Java and [incr Tcl].
// SMC finite state machines have such features as:
// + Entry/Exit actions for states.
// + Transition guards
// + Transition arguments
// + Push and Pop transitions.
// + Default transitions. 
// ----------------------------------------------------------------------
//
// Revision 1.1.1.1  2000/08/02 12:51:02  charlesr
// Initial source import, SMC v. 1.0, Beta 1.
//

public class checkstring
{
    public static void main(String[] args)
    {
        AppClass appobject = new AppClass();
        int retcode = 0;

        if (args.length < 1)
        {
            System.err.println("No string to check.");
            retcode = 2;
        }
        else if (args.length > 1)
        {
            System.err.println("Only one argument is accepted.");
            retcode = 3;
        }
        else
        {
            System.out.print("The string \"");
            System.out.print(args[0]);
            System.out.print("\" is ");

            if (appobject.CheckString(args[0]) == false)
            {
                System.out.println("not acceptable.");
                retcode = 1;
            }
            else
            {
                System.out.println("acceptable.");
            }
        }

        System.exit(retcode);
    }
}
