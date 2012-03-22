# 
# The contents of this file are subject to the Mozilla Public
# License Version 1.1 (the "License"); you may not use this file
# except in compliance with the License. You may obtain a copy
# of the License at http://www.mozilla.org/MPL/
# 
# Software distributed under the License is distributed on an
# "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
# implied. See the License for the specific language governing
# rights and limitations under the License.
# 
# The Original Code is State Machine Compiler (SMC).
# 
# The Initial Developer of the Original Code is Charles W. Rapp.
# Portions created by Charles W. Rapp are
# Copyright (C) 2000 - 2009. Charles W. Rapp.
# All Rights Reserved.
# 
# Contributor(s):
#
# AppClass --
#
#  This class contains the 0*1* state machine and decides whether a
#  a particular string fits the pattern or not.
#
# RCS ID
# $Id: AppClass.tcl,v 1.5 2009/03/01 18:20:39 cwrapp Exp $
#
# CHANGE LOG
# $Log: AppClass.tcl,v $
# Revision 1.5  2009/03/01 18:20:39  cwrapp
# Preliminary v. 6.0.0 commit.
#
# Revision 1.4  2005/05/28 18:02:52  cwrapp
# Updated Tcl examples, removed EX6.
#
# Revision 1.0  2003/12/14 20:25:26  charlesr
# Initial revision
#

package require statemap;

source ./AppClass_sm.tcl;

class AppClass {
# Member data.
    private variable _is_acceptable;
    private variable _fsm;

# Member functions.
    constructor {} {
        set _fsm [AppClassContext #auto $this];
        set _is_acceptable 0;

        # Uncomment to see debug output;
        # $_fsm setDebugFlag 1;
    }

    public method checkString {astring} {

        $_fsm enterStartState;

        # If the string is {}, then it is an empty string.
        # In that case, issue the EOS transition now.
        if {$astring != ""} {
            set string_length [string length $astring];
            for {set i 0} {$i < $string_length} {incr i} {
                switch -exact -- [string index $astring $i] {
                    0 { $_fsm Zero; }
                    1 { $_fsm One; }
                    default { $_fsm Unknown; }
                }
            }
        }

        $_fsm EOS;

        return -code ok $_is_acceptable;
    }

    public method Acceptable {} {
        set _is_acceptable 1;
    }

    public method Unacceptable {} {
        set _is_acceptable 0;
    }
}
