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
# Copyright (C) 2005 Charles W. Rapp.
# All Rights Reserved.
# 
# Contributor(s):
#
# RCS ID
# $Id: Makefile,v 1.5 2009/03/01 18:20:41 cwrapp Exp $
#
# CHANGE LOG
# (See the bottom of this file.)
#

#################################################################
# Macros.
#

# Include the official macros.
include ../../smc.mk

SOURCES=        statemap.rb

LIB_STAGING_DIR=../../$(SMC_STAGING_DIR)/lib/Ruby

#################################################################
# Rules.
#

$(LIB_STAGING_DIR) :
		$(MKDIR) $@

install :       $(LIB_STAGING_DIR) $(SOURCES)
		$(CP_F) statemap.rb $(LIB_STAGING_DIR)/statemap.rb
		$(CP_F) README $(LIB_STAGING_DIR)/README

uninstall :
		-$(RM_F) $(LIB_STAGING_DIR)/statemap.rb
		-$(RM_F) $(LIB_STAGING_DIR)/README

clean :

realclean :     clean

#
# CHANGE LOG
# $Log: Makefile,v $
# Revision 1.5  2009/03/01 18:20:41  cwrapp
# Preliminary v. 6.0.0 commit.
#
# Revision 1.4  2008/02/04 10:46:38  fperrad
# + use common variables
#
# Revision 1.3  2007/10/11 12:48:35  fperrad
# - refactor: Makefile with variables
#
# Revision 1.2  2007/10/10 12:29:07  fperrad
# - fix Makefile (mkdir)
#
# Revision 1.1  2005/09/19 15:30:56  cwrapp
# Changes in release 4.2.2:
# New features:
#
# None.
#
# Fixed the following bugs:
#
# + (C#) -csharp not generating finally block closing brace.
#
