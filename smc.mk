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
# Copyright (C) 2000 - 2008. Charles W. Rapp.
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
#   Francois Perrord contributed the Python code generator and
#   examples/Python.
#   Chris Liscio contributed Objective-C code generation and
#   examples/ObjC.
#
# RCS ID
# $Id: smc.mk,v 1.21 2011/11/20 14:58:32 cwrapp Exp $
#
# CHANGE LOG
# (See the bottom of this file.)
#

#################################################################
# Macros.
#

VERSION=        6_1_0

STAGING_DIR=    ../staging
SMC_STAGING_DIR=$(STAGING_DIR)/smc
SMC_RELEASE_DIR=$(STAGING_DIR)/smc_$(VERSION)
RELEASE_DIR=    $(STAGING_DIR)/releases

PACKAGE_NAME=   statemap

CP_F=		cp -f
CP_RFP=		cp -R -f -p
CHMOD=		chmod
MKDIR=		mkdir -p
MV=		mv
RM_F=		rm -f
RM_RF=		rm -rf

JAVADOC=		javadoc
DOC_VERSION=	$(VERSION)
DOC_DIR=		docs/javadocs
DOC_SOURCES=	./doc_sources.txt

WINDOW_TITLE=	"SMC v. $(DOC_VERSION) API Specification"
DOC_TITLE=	"SMC v. $(DOC_VERSION) API Specification"
HEADER=		"<b>SMC</b><br><font size="-1">$(DOC_VERSION)</font>"
FOOTER=		"<font size=-1>Copyright &copy; 2009. Charles W. Rapp. All Rights Reserved. Use is subject to <a href=\"\">license terms</a>.</font>"
OVERVIEW=	./overview.html

JAVADOC_FLAGS=	-protected \
		-d ./$(DOC_DIR) \
		-sourcepath . \
		-classpath ./lib/statemap.jar \
		-overview $(OVERVIEW) \
		-windowtitle $(WINDOW_TITLE) \
		-doctitle $(DOC_TITLE) \
		-header $(HEADER) \
		-bottom $(FOOTER)

# Alternate version based on Perl (compatible Windows / *nix)
#CP=             perl -MExtUtils::Command -e cp
#CHMOD=          perl -MExtUtils::Command -e ExtUtils::Command::chmod
#MKDIR=          perl -MExtUtils::Command -e mkpath
#RM_F=           perl -MExtUtils::Command -e rm_f
#RM_RF=          perl -MExtUtils::Command -e rm_rf


#################################################################
# Rules.
#

# Create the staging directories if needed
$(STAGING_DIR) :
		$(MKDIR) $(STAGING_DIR)

$(SMC_STAGING_DIR) :    $(STAGING_DIR)
		-$(RM_RF) $(SMC_STAGING_DIR)
		$(MKDIR) $(SMC_STAGING_DIR)

#
# CHANGE LOG
# $Log: smc.mk,v $
# Revision 1.21  2011/11/20 14:58:32  cwrapp
# Check in for SMC v. 6.1.0
#
# Revision 1.20  2009/09/05 15:39:16  cwrapp
# Checking in fixes for 1944542, 1983929, 2731415, 2803547 and feature 2797126.
#
# Revision 1.19  2009/03/27 09:41:44  cwrapp
# Added F. Perrad changes back in.
#
# Revision 1.18  2009/03/01 18:20:36  cwrapp
# Preliminary v. 6.0.0 commit.
#
# Revision 1.17  2008/05/20 18:31:06  cwrapp
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
# Revision 1.16  2008/02/04 10:39:48  fperrad
# + common variables
#
# Revision 1.15  2008/01/14 19:59:18  cwrapp
# Release 5.0.2 check-in.
#
# Revision 1.14  2007/08/05 12:57:18  cwrapp
# Version 5.0.1 check-in. See net/sf/smc/CODE_README.txt for more information.
#
# Revision 1.13  2007/03/31 13:48:22  cwrapp
# Version 5.0.0 check-in.
#
# Revision 1.12  2007/01/15 00:23:46  cwrapp
# Release 4.4.0 initial commit.
#
# Revision 1.11  2006/09/16 15:04:27  cwrapp
# Initial v. 4.3.3 check-in.
#
# Revision 1.10  2006/07/11 18:33:20  cwrapp
# Updated version.
#
# Revision 1.9  2006/04/22 12:45:22  cwrapp
# Version 4.3.1
#
# Revision 1.8  2005/11/07 19:34:53  cwrapp
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
# Revision 1.7  2005/09/19 15:20:01  cwrapp
# Changes in release 4.2.2:
# New features:
#
# None.
#
# Fixed the following bugs:
#
# + (C#) -csharp not generating finally block closing brace.
#
# Revision 1.6  2005/09/14 01:51:33  cwrapp
# Changes in release 4.2.0:
# New features:
#
# None.
#
# Fixed the following bugs:
#
# + (Java) -java broken due to an untested minor change.
#
# Revision 1.5  2005/08/26 15:21:33  cwrapp
# Final commit for release 4.2.0. See README.txt for more information.
#
# Revision 1.4  2005/06/30 10:44:02  cwrapp
# Added %access keyword which allows developers to set the generate Context
# class' accessibility level in Java and C#.
#
# Revision 1.3  2005/06/18 18:28:36  cwrapp
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
# Revision 1.2  2005/06/08 11:08:58  cwrapp
# + Updated Python code generator to place "pass" in methods with empty
#   bodies.
# + Corrected FSM errors in Python example 7.
# + Removed unnecessary includes from C++ examples.
# + Corrected errors in top-level makefile's distribution build.
#
# Revision 1.1  2005/05/28 19:41:44  cwrapp
# Update for SMC v. 4.0.0.
#
