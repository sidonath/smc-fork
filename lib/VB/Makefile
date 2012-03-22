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
# Copyright (C) 2004, 2005 Charles W. Rapp.
# All Rights Reserved.
# 
# Contributor(s):
#
# RCS ID
# $Id: Makefile,v 1.4 2009/03/01 18:20:41 cwrapp Exp $
#
# CHANGE LOG
# (See the bottom of this file.)
#

#################################################################
# Macros.
#

# Include the official macros.
include ../../smc.mk

LIB_SOURCES=    FSMContext.vb \
                State.vb \
                TransitionUndefinedException.vb \
                StateUndefinedException.vb

DLL_FILE=       $(PACKAGE_NAME).dll
PDB_FILE=       $(PACKAGE_NAME).pdb

LIB_STAGING_DIR=../../$(SMC_STAGING_DIR)/lib/VB

#################################################################
# Rules.
#

all :           $(DLL_FILE)

# .dll can only be built withing Dev Studio.

$(LIB_STAGING_DIR) :
		$(MKDIR) $@

$(LIB_STAGING_DIR)/Debug : $(LIB_STAGING_DIR)
		$(MKDIR) $@

$(LIB_STAGING_DIR)/Release : $(LIB_STAGING_DIR)
		$(MKDIR) $@

install :       install_debug install_release

install_debug : Debug/$(DLL_FILE) $(LIB_STAGING_DIR)/Debug
		$(CP_F) Debug/$(DLL_FILE) $(LIB_STAGING_DIR)/Debug
		$(CP_F) Debug/$(PDB_FILE) $(LIB_STAGING_DIR)/Debug

install_release : Release/$(DLL_FILE) $(LIB_STAGING_DIR)/Release
		$(CP_F) Release/$(DLL_FILE) $(LIB_STAGING_DIR)/Release

uninstall :
		-$(RM_F) $(LIB_STAGING_DIR)/Debug/$(DLL_FILE)
		-$(RM_F) $(LIB_STAGING_DIR)/Debug/$(PDB_FILE)
		-$(RM_F) $(LIB_STAGING_DIR)/Release/$(DLL_FILE)

clean :

realclean :     clean
		-$(RM_F) ./Debug/$(DLL_FILE)
		-$(RM_F) ./Debug/$(PDB_FILE)
		-$(RM_F) ./Release/$(DLL_FILE)

#
# CHANGE LOG
# $Log: Makefile,v $
# Revision 1.4  2009/03/01 18:20:41  cwrapp
# Preliminary v. 6.0.0 commit.
#
# Revision 1.3  2008/02/04 10:47:07  fperrad
# + use common variables
#
# Revision 1.2  2005/06/08 11:09:15  cwrapp
# + Updated Python code generator to place "pass" in methods with empty
#   bodies.
# + Corrected FSM errors in Python example 7.
# + Removed unnecessary includes from C++ examples.
# + Corrected errors in top-level makefile's distribution build.
#
# Revision 1.1  2005/05/28 18:47:13  cwrapp
# Updated C++, Java and Tcl libraries, added CSharp, Python and VB.
#
