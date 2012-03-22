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
# Copyright (C) 2007. Charles W. Rapp.
# All Rights Reserved.
# 
# Contributor(s):
#
# RCS ID
# $Id: Makefile,v 1.3 2009/03/01 18:20:41 cwrapp Exp $
#
# CHANGE LOG
# (See the bottom of this file.)
#

#################################################################
# Macros.
#

# Include the official macros.
include ../../smc.mk

SOURCES=        statemap.h statemap.m

LIB_STAGING_DIR=../../$(SMC_STAGING_DIR)/lib/ObjC

#################################################################
# Rules.
#

$(LIB_STAGING_DIR) :
		$(MKDIR) $@

install :       $(LIB_STAGING_DIR) $(SOURCES)
		$(CP_F) README.txt $(LIB_STAGING_DIR)/README.txt
		$(CP_F) statemap.h $(LIB_STAGING_DIR)/statemap.h
		$(CP_F) statemap.m $(LIB_STAGING_DIR)/statemap.m

uninstall :
		-$(RM_F) $(LIB_STAGING_DIR)/README.txt
		-$(RM_F) $(LIB_STAGING_DIR)/statemap.h
		-$(RM_F) $(LIB_STAGING_DIR)/statemap.m

clean :

realclean :     clean

#
# CHANGE LOG
# $Log: Makefile,v $
# Revision 1.3  2009/03/01 18:20:41  cwrapp
# Preliminary v. 6.0.0 commit.
#
# Revision 1.2  2008/02/04 10:45:49  fperrad
# + use common variables
#
# Revision 1.1  2007/01/15 00:23:50  cwrapp
# Release 4.4.0 initial commit.
#
