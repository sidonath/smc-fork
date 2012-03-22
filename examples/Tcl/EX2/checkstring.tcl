#!/bin/sh
# -*- tab-width: 4; -*-
# \
exec tclsh "$0" "$@"

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
# checkstring --
#
#  This test program uses the state machine language to determine
#  is a string is of the form 0*1*.
#
# RCS ID
# $Id: checkstring.tcl,v 1.6 2009/03/27 09:41:47 cwrapp Exp $
#
# CHANGE LOG
# $Log: checkstring.tcl,v $
# Revision 1.6  2009/03/27 09:41:47  cwrapp
# Added F. Perrad changes back in.
#
# Revision 1.5  2009/03/01 18:20:40  cwrapp
# Preliminary v. 6.0.0 commit.
#
# Revision 1.4  2005/05/28 18:02:55  cwrapp
# Updated Tcl examples, removed EX6.
#
# Revision 1.1  2005/01/22 13:11:38  charlesr
# Added the statemap package location to auto_path.
#
# Revision 1.0  2003/12/14 20:27:12  charlesr
# Initial revision
#

lappend auto_path ../../../lib/Tcl

package require Itcl;
package require statemap;

namespace import ::itcl::*;
namespace import ::statemap::*;

source ./AppClass.tcl;

# Check if a string has been passed in.
if {[llength $argv] < 1} {
    puts stderr "No string to check.";
    set ErrorCode 1;
} else {
    AppClass mycontext;

    set ErrorCode 0;

    set InputString [lindex $argv 0];
    puts -nonewline stdout "The string \"$InputString\" is ";
    flush stdout;

    if {! [mycontext checkString $InputString]} {
	puts -nonewline stdout "not ";
    }

    puts stdout "acceptable.";
}

exit $ErrorCode;
