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
# $Id: AppClass.tcl,v 1.6 2009/12/17 19:51:43 cwrapp Exp $
#
# CHANGE LOG
# $Log: AppClass.tcl,v $
# Revision 1.6  2009/12/17 19:51:43  cwrapp
# Testing complete.
#
# Revision 1.5  2009/03/01 18:20:40  cwrapp
# Preliminary v. 6.0.0 commit.
#
# Revision 1.4  2005/05/28 18:02:55  cwrapp
# Updated Tcl examples, removed EX6.
#
# Revision 1.0  2003/12/14 20:27:42  charlesr
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

        # Uncomment to see reflection output.
        # Be sure to compile with -reflect flag.
        # foreach state [$_fsm getStates] {
        #     puts stdout "State $state";
        #     puts stdout "  Transitions:";
        # 
        #     foreach transition [$state getTransitions] {
        #         puts stdout "    $transition";
        #     }
        # }
    }

    public method CheckString {astring} {

        $_fsm enterStartState;

        set string_length [string length $astring];
        for {set i 0} {$i < $string_length} {incr i} {
            switch -exact -- [string index $astring $i] {
                0 { set Transition Zero; }
                1 { set Transition One; }
                C -
                c {
                    set Transition C;

                    # Uncomment to see serialization output.
                    # Be sure to compile FSM with -serial flag.
                    # set filename "./fsm_serial.dat";
                    # 
                    # if [catch {
                    #     puts stdout "";
                    #     serialize $filename;
                    #     deserialize $filename;
                    # } result] {
                    #     puts stdout "FSM serialization error, reason ${result}.";
                    # }
                }
                default { set Transition Unknown; }
            }

            # puts stdout "TRANSITION: $Transition";

            $_fsm $Transition;
        }

        # puts stdout "TRANSITION: EOS";
        $_fsm EOS;

        return -code ok $_is_acceptable;
    }

    public method Acceptable {} {
        set _is_acceptable 1;
    }

    public method Unacceptable {} {
        set _is_acceptable 0;
    }

    # Uncomment to see serialization output.
    # Be sure to compile FSM with -serial flag.
    # private method serialize {filename} {
    #     puts stdout "Serializing FSM.";
    # 
    #     if [catch {open $filename w 0644} fileId] {
    #         set retcode error;
    #         set retval "${filename} open failed.";
    #     } else {
    #         set state [$_fsm getState];
    #         set states {};
    # 
    #         lappend states [$state getId];
    # 
    #         while {[catch {$_fsm popState} retcode] == 0} {
    #             set state [$_fsm getState];
    #             set states [linsert $states 0 [$state getId]];
    #         }
    # 
    #         set size [llength $states];
    #         puts $fileId $size;
    # 
    #         foreach stateId $states {
    #             puts $fileId $stateId;
    #         }
    # 
    #         close $fileId;
    # 
    #         set retcode ok;
    #         set retval "";
    #     }
    # 
    #     return -code ${retcode} ${retval};
    # }
    # 
    # private method deserialize {filename} {
    #     puts stdout "Deserializing FSM.";
    # 
    #     if [catch {open $filename r} fileId] {
    #         set retcode error;
    #         set retval "${filename} open failed.";
    #     } else {
    #         $_fsm clearState;
    # 
    #         gets $fileId size;
    # 
    #         for {set i 0} {$i < $size} {incr i} {
    #             gets $fileId stateId;
    #             set state [$_fsm valueOf $stateId];
    # 
    #             $_fsm pushState $state;
    #         }
    # 
    #         set retcode ok;
    #         set retval "";
    #     }
    # 
    #     return -code ${retcode} ${retval}
    # }
}
