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
// Name
//  AppClass
//
// Description
//  When a state machine executes an action, it is really calling a
//  member function in the context class.
//
// RCS ID
// $Id: AppClass.java,v 1.2 2007/08/05 13:05:15 cwrapp Exp $
//
// CHANGE LOG
// $Log: AppClass.java,v $
// Revision 1.2  2007/08/05 13:05:15  cwrapp
// Version 5.0.1 check-in. See net/sf/smc/CODE_README.txt for more information.
//
// Revision 1.1  2005/05/28 12:49:21  cwrapp
// Added Ant examples 1 - 7.
//
// Revision 1.0  2004/05/30 21:41:42  charlesr
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

public class AppClass
{
    private AppClassContext _fsm;
    private boolean _is_acceptable;

    public AppClass()
    {
        _fsm = new AppClassContext(this);
        _is_acceptable = false;

        // Uncomment to see debug output.
        // _fsm.setDebugFlag(true);
    }

    public boolean CheckString(String string)
    {
        int i,
            Length;
        char c;

        for (i = 0, Length = string.length();
             i < Length;
             ++i)
        {
            switch (string.charAt(i))
            {
                case '0':
                    _fsm.Zero();
                    break;

                case '1':
                    _fsm.One();
                    break;

                default:
                    _fsm.Unknown();
                    break;
            }
        }

        _fsm.EOS();

        return(_is_acceptable);
    }

    public void Acceptable()
    {
        _is_acceptable = true;
    }

    public void Unacceptable()
    {
        _is_acceptable = false;
    }
}
