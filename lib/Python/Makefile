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
# Copyright (C) 2005. Charles W. Rapp.
# All Rights Reserved.
#
# Port to Python by Francois Perrad, francois.perrad@gadz.org
# Copyright 2004, Francois Perrad.
# All Rights Reserved.
# 
# Contributor(s):
#   Eitan Suez contributed examples/Ant.
#   (Name withheld) contributed the C# code generation and
#   examples/C#.
#   Francois Perrad contributed the Python code generator and
#   examples/Python.
#
# RCS ID
# $Id: Makefile,v 1.10 2009/03/01 18:20:41 cwrapp Exp $
#
# CHANGE LOG
# (See the bottom of this file.)
#

#################################################################
# Macros.
#

# Include the official macros.
include ../../smc.mk

SOURCES=        setup.py statemap.py

LIB_STAGING_DIR=../../$(SMC_STAGING_DIR)/lib/Python

#################################################################
# Rules.
#

$(LIB_STAGING_DIR) :
		$(MKDIR) $@

install :       $(LIB_STAGING_DIR) $(SOURCES)
		$(CP_F) README.py $(LIB_STAGING_DIR)/README.py
		$(CP_F) statemap.py $(LIB_STAGING_DIR)/statemap.py
		$(CP_F) setup.py $(LIB_STAGING_DIR)/setup.py

uninstall :
		-$(RM_F) $(LIB_STAGING_DIR)/*.py

clean :

realclean :     clean

#
# CHANGE LOG
# $Log: Makefile,v $
# Revision 1.10  2009/03/01 18:20:41  cwrapp
# Preliminary v. 6.0.0 commit.
#
# Revision 1.9  2008/02/04 10:46:22  fperrad
# + use common variables
#
# Revision 1.8  2007/12/28 12:34:40  cwrapp
# Version 5.0.1 check-in.
#
# Revision 1.7  2007/10/11 12:48:35  fperrad
# - refactor: Makefile with variables
#
# Revision 1.6  2007/10/10 12:29:06  fperrad
# - fix Makefile (mkdir)
#
# Revision 1.5  2005/06/18 18:28:42  cwrapp
# SMC v. 4.0.1
#
# New Features:
#
# (No new features.)
#
# Bug Fixes:
#
# + (C++) When the .sm is in a subdirectory the forward- or
#   backslashes in the file name are kept in the "#ifndef" in the
#   generated header file. This is syntactically wrong. SMC now
#   replaces the slashes with underscores.
#
# + (Java) If %package is specified in the .sm file, then the
#   generated *Context.java class will have package-level access.
#
# + The Programmer's Manual had incorrect HTML which prevented the
#   pages from rendering correctly on Internet Explorer.
#
# + Rewrote the Programmer's Manual section 1 to make it more
#   useful.
#
# Revision 1.4  2005/06/18 11:49:46  cwrapp
# *** empty log message ***
#
# Revision 1.2  2005/06/08 11:09:14  cwrapp
# + Updated Python code generator to place "pass" in methods with empty
#   bodies.
# + Corrected FSM errors in Python example 7.
# + Removed unnecessary includes from C++ examples.
# + Corrected errors in top-level makefile's distribution build.
#
# Revision 1.1  2005/05/28 18:47:13  cwrapp
# Updated C++, Java and Tcl libraries, added CSharp, Python and VB.
#
# Revision 1.0  2005/02/21 19:05:27  charlesr
# Initial revision
#
