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
// Port to Groovy by Francois Perrad, francois.perrad@gadz.org
// Copyright 2007, Francois Perrad.
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
// $Id: AppClass.groovy,v 1.2 2009/04/11 14:28:05 cwrapp Exp $
//
// CHANGE LOG
// $Log: AppClass.groovy,v $
// Revision 1.2  2009/04/11 14:28:05  cwrapp
// Added called to enterStartState.
//
// Revision 1.1  2007/07/16 06:31:21  fperrad
// + Added Groovy examples 1 - 3.
//
//

class AppClass {
    private def _fsm
    private boolean _is_acceptable

    AppClass () {
        _fsm = new AppClassContext(this)
        _is_acceptable = false

        // Uncomment to see debug output.
        // _fsm.setDebugFlag(true)
    }

    def CheckString (String string) {
        _fsm.enterStartState()
        for (c in string) {
            switch (c) {
                case '0':
                    _fsm.Zero()
                    break
                case '1':
                    _fsm.One()
                    break
                default:
                    _fsm.Unknown()
            }
        }
        _fsm.EOS();
        return _is_acceptable
    }

    def Acceptable () {
        _is_acceptable = true
    }

    def Unacceptable (){
        _is_acceptable = false
    }
}

