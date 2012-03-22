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
// Function
//   Main
//
// Description
//  This routine starts the finite state machine running.
//
// RCS ID
// $Id: checkstring.groovy,v 1.1 2007/07/16 06:31:10 fperrad Exp $
//
// CHANGE LOG
// $Log: checkstring.groovy,v $
// Revision 1.1  2007/07/16 06:31:10  fperrad
// + Added Groovy examples 1 - 3.
//
//

int retcode = 0

if (args.size() < 1) {
    System.err.println 'No string to check.'
    retcode = 2
}
else if (args.size() > 1) {
    System.err.println 'Only one argument is accepted.'
    retcode = 3
}
else {
    def appobject = new AppClass()
    def result

    if (appobject.CheckString(args[0])) {
        result = 'acceptable.'
    }
    else {
        result = 'not acceptable.'
        retcode = 1
    }
    println "The string \"${args[0]}\" is $result."
}

System.exit(retcode)

