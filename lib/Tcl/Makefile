# 
# The contents of this file are subject to the Mozilla Public
# License Version 1.1 (the "License"); you may not use this file
# except in compliance with the License. You may obtain a copy of
# the License at http://www.mozilla.org/MPL/
# 
# Software distributed under the License is distributed on an "AS
# IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
# implied. See the License for the specific language governing
# rights and limitations under the License.
# 
# The Original Code is State Machine Compiler (SMC).
# 
# The Initial Developer of the Original Code is Charles W. Rapp.
# Portions created by Charles W. Rapp are
# Copyright (C) 2000 - 2005 Charles W. Rapp.
# All Rights Reserved.
# 
# Contributor(s):
#
# RCS ID
# $Id: Makefile,v 1.9 2009/03/01 18:20:41 cwrapp Exp $
#
# CHANGE LOG
# (See the bottom of this file.)
#

#################################################################
# Macros.
#

# Include the official macros.
include ../../smc.mk

SOURCES=        statemap.tcl pkgIndex.tcl

LIB_STAGING_DIR=../../$(SMC_STAGING_DIR)/lib/Tcl
TCL_STAGING_DIR=$(LIB_STAGING_DIR)/statemap1.0

#################################################################
# Rules.
#

$(LIB_STAGING_DIR) :
		$(MKDIR) $@

$(TCL_STAGING_DIR) : $(LIB_STAGING_DIR)
		$(MKDIR) $@

install :       $(TCL_STAGING_DIR) $(SOURCES)
		$(CP_F) statemap.tcl $(TCL_STAGING_DIR)/statemap.tcl
		$(CP_F) pkgIndex.tcl $(TCL_STAGING_DIR)/pkgIndex.tcl

uninstall :
		-$(RM_F) $(TCL_STAGING_DIR)/statemap.tcl
		-$(RM_F) $(TCL_STAGING_DIR)/pkgIndex.tcl

clean :

realclean :     clean

#
# CHANGE LOG
# $Log: Makefile,v $
# Revision 1.9  2009/03/01 18:20:41  cwrapp
# Preliminary v. 6.0.0 commit.
#
# Revision 1.8  2008/02/04 10:46:51  fperrad
# + use common variables
#
# Revision 1.7  2005/06/08 11:09:15  cwrapp
# + Updated Python code generator to place "pass" in methods with empty
#   bodies.
# + Corrected FSM errors in Python example 7.
# + Removed unnecessary includes from C++ examples.
# + Corrected errors in top-level makefile's distribution build.
#
# Revision 1.6  2005/05/28 18:47:13  cwrapp
# Updated C++, Java and Tcl libraries, added CSharp, Python and VB.
#
# Revision 1.2  2005/02/21 19:06:27  charlesr
# Including standard SMC macros.
#
# Revision 1.1  2004/10/30 15:56:29  charlesr
# Added -f option to the install copy.
#
# Revision 1.0  2003/12/14 20:42:05  charlesr
# Initial revision
#
