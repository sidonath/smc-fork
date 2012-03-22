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
// Port to Scala by Francois Perrad, francois.perrad@gadz.org
// Copyright 2008, Francois Perrad.
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
// $Id: checkstring.scala,v 1.1 2008/02/04 12:47:46 fperrad Exp $
//
// CHANGE LOG
// $Log: checkstring.scala,v $
// Revision 1.1  2008/02/04 12:47:46  fperrad
// Added Scala examples 1 - 3
//
//

object checkstring {
    def main(args: Array[String]) {
        var retcode: Int = 0

        if (args.length < 1) {
            System.err.println("No string to check.")
            retcode = 2
        }
        else if (args.length > 1) {
            System.err.println("Only one argument is accepted.")
            retcode = 3
        }
        else {
            val appobject = new AppClass()

            System.out.print("The string \"")
            System.out.print(args(0))
            System.out.print("\" is ")

            if (appobject.CheckString(args(0)) == false) {
                System.out.println("not acceptable.")
                retcode = 1
            }
            else {
                System.out.println("acceptable.")
            }
        }
        System.exit(retcode)
    }
}
