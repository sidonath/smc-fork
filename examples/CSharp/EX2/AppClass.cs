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
// Copyright (C) 2004. Charles W. Rapp.
// All Rights Reserved.
// 
// Contributor(s):
//   Eitan Suez contributed examples/Ant.
//   (Name withheld) contributed the C# code generation and
//   examples/C#.
//
// Name
//  AppClass
//
// Description
//   When a state machine executes an action, it is really calling a
//   member function in the context class.
//
// RCS ID
// $Id: AppClass.cs,v 1.2 2009/12/17 19:51:43 cwrapp Exp $
//
// CHANGE LOG
// $Log: AppClass.cs,v $
// Revision 1.2  2009/12/17 19:51:43  cwrapp
// Testing complete.
//
// Revision 1.1  2005/05/28 13:05:17  cwrapp
// Added CSharp examples 1 - 3.
//
// Revision 1.0  2004/09/06 15:37:14  charlesr
// Initial revision
//

public class AppClass
{
    private AppClassContext _fsm;
    private bool _is_acceptable;
    private bool _abort;

    public AppClass()
    {
        _fsm = new AppClassContext(this);
        _is_acceptable = false;
        _abort = false;
    }

    public bool CheckString(string inputString)
    {
        int i, Length;

        _fsm.EnterStartState();

        for (i = 0, Length = inputString.Length ; i < Length ; ++i)
        {
            if (_abort == true)
                break;

            switch (inputString[i])
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

    

    public bool Acceptable
    {
        get {return _is_acceptable;}
        set {_is_acceptable = value;}
    }

    public bool AcceptableM(bool state)
    {
        return _is_acceptable = state;
    }

    public void Unacceptable()
    {
        _is_acceptable = false;
    }

    public void SignalError()
    {
        _abort = true;
    }
}
