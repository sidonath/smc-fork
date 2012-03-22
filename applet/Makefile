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
# Contributor(s):
#
# RCS ID
# $Id: Makefile,v 1.6 2006/04/22 12:45:23 cwrapp Exp $
#
# CHANGE LOG
# (See the bottom of this file.)
#

#################################################################
# Macros
#

TARGET=		Telephone

SM_SOURCES=	Telephone.sm

SOURCES=	$(SM_SOURCES:%.sm=%Context.java) \
		TimerEvent.java \
		TimerListener.java \
		Timer.java \
		Telephone.java

FSM_DIR=	../lib/Java

JAVAC=		javac
JAVAC_FLAGS=	-g -classpath ../lib/Java/statemap.jar

JAR=		jar
JAR_CREATE_FLAGS=	cmf manifest.txt
JAR_UPDATE_FLAGS=	uf
JAR_FILE=	$(TARGET).jar

SMC=		java -jar ../../smc/bin/Smc.jar
SMC_FLAGS=	-java -g

#################################################################
# Rules
#

all :		$(TARGET)

%Context.java : %.sm
		$(SMC) $(SMC_FLAGS) $<

$(TARGET) :	$(SOURCES)
		$(JAVAC) $(JAVAC_FLAGS) $(SOURCES)
		$(JAR) $(JAR_CREATE_FLAGS) $(JAR_FILE) *.class
		$(JAR) $(JAR_UPDATE_FLAGS) $(JAR_FILE) -C $(FSM_DIR) statemap
		-rm -f *.class

clean :
		-rm -f *Context.java *.class *.flc $(JAR_FILE)

realclean :	clean

#
# CHANGE LOG
# $Log: Makefile,v $
# Revision 1.6  2006/04/22 12:45:23  cwrapp
# Version 4.3.1
#
# Revision 1.5  2005/06/05 18:51:07  cwrapp
# Added output actions back into FSM.
#
# Revision 1.4  2005/05/28 19:41:44  cwrapp
# Update for SMC v. 4.0.0.
#
# Revision 1.1  2004/10/08 18:40:21  charlesr
# Correct classpath.
#
# Revision 1.0  2003/12/14 19:02:21  charlesr
# Initial revision
#
# Revision 1.2  2001/11/30 15:17:22  cwrapp
# Changes in release 1.0.2:
# + Placed the class files in Smc.jar in the net.sf.smc package.
# + Moved Java source files from smc/bin to net/sf/smc.
# + Corrected a C++ generation bug wherein arguments were written
#   to the .h file rather than the .cpp file.
#
# Revision 1.1  2001/06/26 22:16:23  cwrapp
# Changes in release 1.0.0:
# Checking in code for first production release.
# If SMC should crash, critical information are printed out along
# with instructions explaining where to send that information.
#
