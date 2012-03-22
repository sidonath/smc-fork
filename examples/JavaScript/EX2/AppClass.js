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
// Name
//  AppClass
//
// Description
//   When a state machine executes an action, it is really calling a
//   member function in the context class.
//
// RCS ID
// $Id: AppClass.js,v 1.2 2011/04/23 13:13:06 fperrad Exp $
//
// CHANGE LOG
// $Log: AppClass.js,v $
// Revision 1.2  2011/04/23 13:13:06  fperrad
// clean up CVS change log
//
// Revision 1.1  2011/02/16 18:25:10  nitin-nizhawan
// added second example
//
// Revision 1.2  2011/02/16 18:00:30  nitin-nizhawan
// minor changes
//


function AppClass() {

    // Uncomment to see debug output.
    //this._fsm.setDebugFlag(true);
}

AppClass.prototype.CheckString = function(str) {
    var  i,len,c;
    this._fsm = new AppClass_sm(this);
    this._is_acceptable = false;
    this._fsm.enterStartState();

    for (i=0,len = str.length;i < len;i++) {
        switch (str.charAt(i)) {
            case '0':
                this._fsm.Zero();
                break;
            case '1':
                this._fsm.One();
                break;
            default:
                this._fsm.Unknown();
                break;
        }
    }

    this._fsm.EOS();

    return(this._is_acceptable);
}

AppClass.prototype.Acceptable=function() {
     this._is_acceptable = true;
}

AppClass.prototype.Unacceptable=function() {
     this._is_acceptable = false;
}
