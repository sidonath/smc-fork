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
# Port to Groovy by Francois Perrad, francois.perrad@gadz.org
# Copyright 2007, Francois Perrad.
# All Rights Reserved.
#
# Contributor(s):
#
# RCS ID
# $Id: Makefile,v 1.5 2009/03/01 18:20:40 cwrapp Exp $
#
# CHANGE LOG
# (See the bottom of this file.)
#

#################################################################
# Macros.
#

# Include the official macros.
include ../../smc.mk

LIB_SOURCES=    $(PACKAGE_NAME).groovy

GROOVYC=        groovyc
JAR=            jar
JAR_FLAGS=      cvf
JAR_FILE=       $(PACKAGE_NAME).jar

LIB_STAGING_DIR=../../$(SMC_STAGING_DIR)/lib/Groovy

#################################################################
# Rules.
#

all :           $(JAR_FILE)

$(JAR_FILE) :   $(LIB_SOURCES)
		$(GROOVYC) $(LIB_SOURCES)
		$(JAR) $(JAR_FLAGS) $(JAR_FILE) $(PACKAGE_NAME)

$(LIB_STAGING_DIR) :
		$(MKDIR) $@

install :       $(LIB_STAGING_DIR) $(JAR_FILE)
		$(CP_F) $(JAR_FILE) $(LIB_STAGING_DIR)
		-$(CHMOD) 444 $(LIB_STAGING_DIR)/$(JAR_FILE)

uninstall :
		-$(RM_F) ../$(JAR_FILE)
		-$(RM_F) $(LIB_STAGING_DIR)/$(JAR_FILE)

clean :
		-$(RM_F) $(JAR_FILE) $(PACKAGE_NAME)/*

realclean :     clean
		-$(RM_RF) $(PACKAGE_NAME)

#
# CHANGE LOG
# $Log: Makefile,v $
# Revision 1.5  2009/03/01 18:20:40  cwrapp
# Preliminary v. 6.0.0 commit.
#
# Revision 1.4  2008/02/04 10:45:01  fperrad
# + use common variables
#
# Revision 1.3  2008/01/14 19:59:23  cwrapp
# Release 5.0.2 check-in.
#
# Revision 1.2  2007/10/10 12:29:06  fperrad
# - fix Makefile (mkdir)
#
# Revision 1.1  2007/07/16 06:29:37  fperrad
# + Added Groovy.
#
#
