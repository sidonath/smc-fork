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
# Copyright (C) 2011. Charles W. Rapp.
# All Rights Reserved.
# 
# Contributor(s):
#
# RCS ID
# $Id: Makefile,v 1.1 2011/11/20 15:07:53 cwrapp Exp $
#
# CHANGE LOG
# (See the bottom of this file.)
#

#################################################################
# Macros.
#

# Include the official macros.
include ../../smc.mk

LIB_STAGING_DIR=../../$(SMC_STAGING_DIR)/lib/JavaScript
LIB_FILE=statemap.js

#################################################################
# Rules.
#

$(LIB_STAGING_DIR) :
		$(MKDIR) $@

install :       $(LIB_STAGING_DIR) $(LIB_FILE)
		$(CP_F) $(LIB_FILE) $(LIB_STAGING_DIR)/$(LIB_FILE)

uninstall :
		-$(RM_F) ../$(JAR_FILE)
		-$(RM_F) $(LIB_STAGING_DIR)/lib/$(LIB_FILE)

clean :

realclean :     clean

#
# CHANGE LOG
# $Log: Makefile,v $
# Revision 1.1  2011/11/20 15:07:53  cwrapp
# Check in for SMC v. 6.1.0
#