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
# $Id: Makefile,v 1.10 2009/03/01 18:20:40 cwrapp Exp $
#
# CHANGE LOG
# (See the bottom of this file.)
#

#################################################################
# Macros.
#

# Include the official macros.
include ../../smc.mk

SOURCES=        statemap.h

LIB_STAGING_DIR=../../$(SMC_STAGING_DIR)/lib/C++

#################################################################
# Rules.
#

$(LIB_STAGING_DIR) :
		$(MKDIR) $@

install :       $(LIB_STAGING_DIR) $(SOURCES)
		$(CP_F) statemap.h ..
		$(CP_F) statemap.h $(LIB_STAGING_DIR)/statemap.h

uninstall :
		-$(RM_F) $(LIB_STAGING_DIR)/statemap.h

clean :

realclean :     clean

#
# CHANGE LOG
# $Log: Makefile,v $
# Revision 1.10  2009/03/01 18:20:40  cwrapp
# Preliminary v. 6.0.0 commit.
#
# Revision 1.9  2008/04/23 16:21:21  fperrad
# + fix #1934474 : wrong include path in C++ examples
#
# Revision 1.8  2008/02/04 10:41:23  fperrad
# + use common variables
#
# Revision 1.7  2005/06/08 11:09:14  cwrapp
# + Updated Python code generator to place "pass" in methods with empty
#   bodies.
# + Corrected FSM errors in Python example 7.
# + Removed unnecessary includes from C++ examples.
# + Corrected errors in top-level makefile's distribution build.
#
# Revision 1.6  2005/05/28 18:44:13  cwrapp
# Updated C++, Java and Tcl libraries, added CSharp, Python and VB.
#
# Revision 1.2  2005/02/21 19:02:06  charlesr
# Including smc.mk standard makefile.
#
# Revision 1.1  2004/10/30 15:54:40  charlesr
# Added -f option to install copy.
#
# Revision 1.0  2003/12/14 20:37:20  charlesr
# Initial revision
#
