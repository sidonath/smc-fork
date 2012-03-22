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
# $Id: Makefile,v 1.7 2009/03/01 18:20:41 cwrapp Exp $
#
# CHANGE LOG
# (See the bottom of this file.)
#

#################################################################
# Macros.
#

# Include the official macros.
include ../../smc.mk

SOURCES=        Makefile.PL MANIFEST README Changes Statemap.pm test.pl

LIB_STAGING_DIR=../../$(SMC_STAGING_DIR)/lib/Perl

#################################################################
# Rules.
#

$(LIB_STAGING_DIR) :
		$(MKDIR) $@

$(LIB_STAGING_DIR)/lib : $(LIB_STAGING_DIR)
		$(MKDIR) $@

$(LIB_STAGING_DIR)/lib/DFA : $(LIB_STAGING_DIR)/lib
		$(MKDIR) $@

install :       $(LIB_STAGING_DIR)/lib/DFA $(SOURCES)
		$(CP_F) Makefile.PL $(LIB_STAGING_DIR)/Makefile.PL
		$(CP_F) MANIFEST $(LIB_STAGING_DIR)/MANIFEST
		$(CP_F) README $(LIB_STAGING_DIR)/README
		$(CP_F) Changes $(LIB_STAGING_DIR)/Changes
		$(CP_F) Statemap.pm $(LIB_STAGING_DIR)/lib/DFA/Statemap.pm
		$(CP_F) test.pl $(LIB_STAGING_DIR)/test.pl

uninstall :     $(LIB_STAGING_DIR)
		-$(RM_F) $(LIB_STAGING_DIR)/Makefile.PL
		-$(RM_F) $(LIB_STAGING_DIR)/MANIFEST
		-$(RM_F) $(LIB_STAGING_DIR)/README
		-$(RM_F) $(LIB_STAGING_DIR)/lib/DFA/Statemap.pm
		-$(RM_F) $(LIB_STAGING_DIR)/test.pl

clean :

realclean :     clean

#
# CHANGE LOG
# $Log: Makefile,v $
# Revision 1.7  2009/03/01 18:20:41  cwrapp
# Preliminary v. 6.0.0 commit.
#
# Revision 1.6  2008/02/07 16:54:51  fperrad
# Perl : StateMachine::Statemap -> DFA::Statemap
#
# Revision 1.5  2008/02/04 10:46:03  fperrad
# + use common variables
#
# Revision 1.4  2007/10/11 12:48:35  fperrad
# - refactor: Makefile with variables
#
# Revision 1.3  2007/10/10 13:04:38  fperrad
# - fix Makefile (Changes)
#
# Revision 1.2  2007/10/10 12:29:06  fperrad
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
