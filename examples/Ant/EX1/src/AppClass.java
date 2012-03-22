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
//   When a state machine executes an action, it is really calling a
//   member function in the context class.
//
// RCS ID
// $Id: AppClass.java,v 1.2 2007/08/05 13:03:43 cwrapp Exp $
//
// CHANGE LOG
// $Log: AppClass.java,v $
// Revision 1.2  2007/08/05 13:03:43  cwrapp
// Version 5.0.1 check-in. See net/sf/smc/CODE_README.txt for more information.
//
// Revision 1.1  2005/05/28 12:49:21  cwrapp
// Added Ant examples 1 - 7.
//
// Revision 1.1  2004/05/31 12:54:53  charlesr
// Updated to latest version.
//
// Revision 1.0  2003/12/14 19:50:16  charlesr
// Initial revision
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
