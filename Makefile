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
# Copyright (C) 2000 - 2004. Charles W. Rapp.
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
#   Chris Liscio contributed Objective-C code generation and
#   examples/ObjC.
#
# RCS ID
# $Id: Makefile,v 1.15 2009/12/18 15:51:33 cwrapp Exp $
#
# CHANGE LOG
# (See the bottom of this file.)
#

#################################################################
# Macros.
#

# Include the official macros.
include ./smc.mk

TAR_FILE=	./smc_$(VERSION).tar
TAR_GZ_FILE=	$(TAR_FILE:.tar=.tar.gz)
GZIP_FILE=	$(TAR_FILE:.tar=.tgz)
ZIP_FILE=	./smc_$(VERSION).zip

SRC_TAR_FILE=	./staging/Releases/SmcSrc_$(VERSION).tar
SRC_TAR_GZ_FILE=	$(SRC_TAR_FILE:.tar=.tar.gz)
SRC_GZIP_FILE=	$(SRC_TAR_FILE:.tar=.tgz)
SRC_ZIP_FILE=	./staging/Releases/SmcSrc_$(VERSION).zip
SRC_TAR_LIST=	./smc/tar_list.txt
SRC_ZIP_LIST=	./smc/zip_list.txt

#################################################################
# Rules.
#

# Compile the Java documentation.
javadocs :
		$(JAVADOC) $(JAVADOC_FLAGS) @$(DOC_SOURCES)

# Copy all products to the staging directory.
install :	$(SMC_STAGING_DIR) javadocs
		-$(RM_RF) $(SMC_STAGING_DIR)/*
		$(MAKE) -C lib install
		$(MAKE) -C net/sf/smc install
		$(CP_RFP) ./docs $(SMC_STAGING_DIR)
		$(CP_RFP) ./examples $(SMC_STAGING_DIR)
		$(CP_RFP) ./tools $(SMC_STAGING_DIR)
		-find $(SMC_STAGING_DIR) -name CVS -type d -exec rm -fr {} \; -prune
		-find $(SMC_STAGING_DIR) -name .DS_Store -exec rm -fr {} \;
		$(MAKE) -C misc install
		$(CP_F) LICENSE.txt $(SMC_STAGING_DIR)
		$(CP_F) README.txt $(SMC_STAGING_DIR)
		$(CHMOD) 444 $(SMC_STAGING_DIR)/bin/Smc.jar

uninstall :
		$(MAKE) -C lib uninstall
		$(MAKE) -C net/sf/smc uninstall
		$(MAKE) -C misc uninstall
		$(RM_RF) $(SMC_STAGING_DIR)/examples
		-$(RM_F) $(SMC_STAGING_DIR)/LICENSE.txt
		-$(RM_F) $(SMC_STAGING_DIR)/README.txt

clean :
		$(MAKE) -C lib clean
		$(MAKE) -C ./net/sf/smc clean

smc_dist :	$(SMC_STAGING_DIR)
		-(cd $(RELEASE_DIR); \
		   $(RM_F) $(TAR_FILE) \
		           $(TAR_GZ_FILE) \
		           $(GZIP_FILE) \
		           $(ZIP_FILE))
		-$(RM_RF) $(SMC_RELEASE_DIR)
		$(MV) $(SMC_STAGING_DIR) $(SMC_RELEASE_DIR)
		(cd $(STAGING_DIR); \
		  tar cvf $(TAR_FILE) ./smc_$(VERSION); \
		  gzip $(TAR_FILE); \
		  $(MV) $(TAR_GZ_FILE) $(GZIP_FILE))
		(cd $(STAGING_DIR); \
		  zip -b . -r $(ZIP_FILE) ./smc_$(VERSION))

src_dist :	$(SMC_RELEASE_DIR)
		$(CP_F) lib/C++/statemap.h $(SMC_RELEASE_DIR)/lib
		$(CP_F) lib/Java/statemap.jar $(SMC_RELEASE_DIR)/lib
		(cd ..; \
		    $(RM_F) $(SRC_TAR_FILE) \
			  $(SRC_TAR_GZ_FILE) \
			  $(SRC_GZIP_FILE) \
			  $(SRC_ZIP_FILE); \
		    tar cvmpfT $(SRC_TAR_FILE) $(SRC_TAR_LIST); \
		    gzip $(SRC_TAR_FILE); \
		    $(MV) $(SRC_TAR_GZ_FILE) $(SRC_GZIP_FILE); \
		    zip -b . -r $(SRC_ZIP_FILE) ./smc -i@$(SRC_ZIP_LIST))

dist : 		install smc_dist src_dist

distclean :
		-(cd $(RELEASE_DIR); \
		    $(RM_F) $(TAR_FILE) \
		            $(TAR_GZ_FILE) \
		            $(GZIP_FILE) \
		            $(ZIP_FILE))
		-$(RM_RF) $(SMC_RELEASE_DIR)
		-(cd ..; \
		    $(RM_FR) $(SRC_TAR_FILE) \
			   $(SRC_TAR_GZ_FILE) \
			   $(SRC_GZIP_FILE) \
			   $(SRC_ZIP_FILE))

realclean :
		$(MAKE) -C lib realclean
		$(MAKE) -C ./net/sf/smc realclean

#
# CHANGE LOG
# $Log: Makefile,v $
# Revision 1.15  2009/12/18 15:51:33  cwrapp
# Created separate tar and zip file lists.
#
# Revision 1.14  2009/03/27 09:41:44  cwrapp
# Added F. Perrad changes back in.
#
# Revision 1.13  2009/03/01 18:20:36  cwrapp
# Preliminary v. 6.0.0 commit.
#
# Revision 1.12  2008/05/20 18:31:06  cwrapp
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
# Revision 1.11  2007/01/15 00:23:46  cwrapp
# Release 4.4.0 initial commit.
#
# Revision 1.10  2005/11/07 19:34:53  cwrapp
# Changes in release 4.3.0:
# New features:
#
# + Added -reflect option for Java, C#, VB.Net and Tcl code
#   generation. When used, allows applications to query a state
#   about its supported transitions. Returns a list of transition
#   names. This feature is useful to GUI developers who want to
#   enable/disable features based on the current state. See
#   Programmer's Manual section 11: On Reflection for more
#   information.
#
# + Updated LICENSE.txt with a missing final paragraph which allows
#   MPL 1.1 covered code to work with the GNU GPL.
#
# + Added a Maven plug-in and an ant task to a new tools directory.
#   Added Eiten Suez's SMC tutorial (in PDF) to a new docs
#   directory.
#
# Fixed the following bugs:
#
# + (GraphViz) DOT file generation did not properly escape
#   double quotes appearing in transition guards. This has been
#   corrected.
#
# + A note: the SMC FAQ incorrectly stated that C/C++ generated
#   code is thread safe. This is wrong. C/C++ generated is
#   certainly *not* thread safe. Multi-threaded C/C++ applications
#   are required to synchronize access to the FSM to allow for
#   correct performance.
#
# + (Java) The generated getState() method is now public.
#
# Revision 1.9  2005/09/11 15:28:47  cwrapp
# Changes in release 4.2.0:
# New features:
#
# + Added C, Perl and Ruby language generation.
#
# + Added method valueOf(int stateId) to Java, C# and VB.Net to
#   allow developers to hand-serialize and deserialize state
#   machines.
#
# Fixed the following bugs:
#
# + (C#) Removed extraneous "bool loopbackFlag = false" line
#   from Default state transitions.
#
# + (C#) Added "Trace.Listeners.Add(myWriter)" line when generating
#   debug code. By not having this line it prevented debug output
#   from being outuput.
#
# + Corrected parser abend when a transition was missing an
#   endstate.
#
# Revision 1.8  2005/06/18 18:28:36  cwrapp
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
# Revision 1.7  2005/06/08 11:08:58  cwrapp
# + Updated Python code generator to place "pass" in methods with empty
#   bodies.
# + Corrected FSM errors in Python example 7.
# + Removed unnecessary includes from C++ examples.
# + Corrected errors in top-level makefile's distribution build.
#
# Revision 1.6  2005/05/28 19:41:44  cwrapp
# Update for SMC v. 4.0.0.
#
# Revision 1.6  2004/10/30 15:34:17  charlesr
# Corrected dist rule and associated macros.
#
# Revision 1.5  2004/10/08 18:44:07  charlesr
# Changed version to 3.1.2.
#
# Revision 1.4  2004/10/02 19:59:18  charlesr
# Changed version to 3.1.1.
#
# Revision 1.3  2004/09/06 15:03:12  charlesr
# Updated for SMC v. 3.1.0.
#
# Revision 1.2  2004/05/31 15:18:29  charlesr
# Added rule for generating source distribution.
#
# Revision 1.1  2004/05/30 21:37:06  charlesr
# Changed version to 3.0.0.
#
# Revision 1.0  2003/12/14 21:07:53  charlesr
# Initial revision
#
