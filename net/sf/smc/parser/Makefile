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
# Copyright (C) 2009. Charles W. Rapp.
# All Rights Reserved.
#
# Contributor(s):
#   Eitan Suez contributed examples/Ant.
#   (Name withheld) contributed the C# code generation and
#   examples/C#.
#   Francois Perrad contributed the Python code generation and
#   examples/Python, Perl code generation and examples/Perl,
#   Ruby code generation and examples/Ruby, Lua code generation
#   and examples/Lua, Groovy code generation and examples/Groovy,
#   Scala code generation and examples/Scala.
#   Chris Liscio contributed the Objective-C code generation
#   and examples/ObjC.
#
# RCS ID
# $Id: Makefile,v 1.1 2009/03/01 18:20:42 cwrapp Exp $
#
# CHANGE LOG
# (See the bottom of this file.)
#

#################################################################
# Macros
#

SM_SOURCES= \
		SmcLexer.sm \
		SmcParser.sm

SOURCES= \
		$(SM_SOURCES:%.sm=%Context.java) \
		SmcMessage.java \
		SmcLexer.java \
		SmcParser.java

PACKAGE_NAME=	net.sf.smc.parser
PACKAGE_DIR=	$(subst .,/,$(PACKAGE_NAME))

STATEMAP_LIB_DIR=	../../../../lib/Java
APP_CLASSPATH=	../../../..:$(STATEMAP_LIB_DIR)/statemap.jar

BIN_DIR=		../../../../bin
INSTALL_DIR=	../../../../../staging/smc/lib/Java

JAVAC=		javac
JAVAC_FLAGS=	-d . -g -Xlint:unchecked -classpath $(APP_CLASSPATH)

JAR=		jar
JAR_CREATE_FLAGS=	cf
JAR_FILE=	SmcParser.jar

SMC=		java -jar $(BIN_DIR)/Smc.jar
SMC_FLAGS=	-java -g

CP=		cp
MKDIR=		mkdir -p
MV=		mv
RM_F=		rm -f
RM_RF=		rm -rf

#################################################################
# Rules
#

all :		$(JAR_FILE)

%Context.java :	%.sm
		$(SMC) $(SMC_FLAGS) $<

$(JAR_FILE) :	$(SOURCES)
		$(JAVAC) $(JAVAC_FLAGS) $(SOURCES)
		$(JAR) $(JAR_CREATE_FLAGS) $(JAR_FILE) \
			$(PACKAGE_DIR)/*.class

install :	$(INSTALL_DIR) $(JAR_FILE)
		-$(RM_F) $(INSTALL_DIR)/$(JAR_FILE)
		$(CP) $(JAR_FILE) $(INSTALL_DIR)

uninstall :
		-$(RM_F) $(INSTALL_DIR)/$(JAR_FILE)

clean :
		-$(RM_F) $(JAR_FILE)
		-$(RM_F) *Context.java
		-$(RM_F) $(PACKAGE_DIR)/*.class

realclean :	clean
		-$(RM_F) *.flc *~
		-$(RM_RF) ./net

#
# CHANGE LOG
# $Log: Makefile,v $
# Revision 1.1  2009/03/01 18:20:42  cwrapp
# Preliminary v. 6.0.0 commit.
#
