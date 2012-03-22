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
# Copyright (C) 2000 - 2005 Charles W. Rapp.
# All Rights Reserved.
#
# Port to Scala by Francois Perrad, francois.perrad@gadz.org
# Copyright 2008, Francois Perrad.
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

LIB_SOURCES=    $(PACKAGE_NAME).scala

SCALAC=         scalac
SCALAC_FLAGS=   -d . -g
JAR=            jar
JAR_FLAGS=      cvf
JAR_FILE=       $(PACKAGE_NAME).jar

LIB_STAGING_DIR=../../$(SMC_STAGING_DIR)/lib/Scala

#################################################################
# Rules.
#

all :           $(JAR_FILE)

$(JAR_FILE) :   $(LIB_SOURCES)
		$(SCALAC) $(SCALAC_FLAGS) $(LIB_SOURCES)
		$(JAR) $(JAR_FLAGS) $(JAR_FILE) $(PACKAGE_NAME)

$(LIB_STAGING_DIR) :
		$(MKDIR) $@

install :       $(LIB_STAGING_DIR) $(JAR_FILE)
		$(CP_F) $(JAR_FILE) $(LIB_STAGING_DIR)
		-$(CHMOD) 444 $(LIB_STAGING_DIR)/$(JAR_FILE)
		$(CP_F) $(LIB_SOURCES) $(LIB_STAGING_DIR)
		-$(CHMOD) 444 $(LIB_STAGING_DIR)/$(LIB_SOURCES)

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
# Revision 1.3  2009/03/01 18:20:41  cwrapp
# Preliminary v. 6.0.0 commit.
#
# Revision 1.2  2008/05/20 18:31:13  cwrapp
# ----------------------------------------------------------------------
#
# Committing release 5.1.0.
#
# Modified Files:
# 	Makefile README.txt smc.mk tar_list.txt bin/Smc.jar
# 	examples/Ant/EX1/build.xml examples/Ant/EX2/build.xml
# 	examples/Ant/EX3/build.xml examples/Ant/EX4/build.xml
# 	examples/Ant/EX5/build.xml examples/Ant/EX6/build.xml
# 	examples/Ant/EX7/build.xml examples/Ant/EX7/src/Telephone.java
# 	examples/Java/EX1/Makefile examples/Java/EX4/Makefile
# 	examples/Java/EX5/Makefile examples/Java/EX6/Makefile
# 	examples/Java/EX7/Makefile examples/Ruby/EX1/Makefile
# 	lib/statemap.jar lib/C++/statemap.h lib/Java/Makefile
# 	lib/Php/statemap.php lib/Scala/Makefile
# 	lib/Scala/statemap.scala net/sf/smc/CODE_README.txt
# 	net/sf/smc/README.txt net/sf/smc/Smc.java
# ----------------------------------------------------------------------
#
# Revision 1.1  2008/02/04 10:48:47  fperrad
# + Added Scala library
#
#
