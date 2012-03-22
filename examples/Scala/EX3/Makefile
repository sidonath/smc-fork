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
# Copyright (C) 2000 - 2006. Charles W. Rapp.
# All Rights Reserved.
#
# Contributor(s):
#       Port to Scala by Francois Perrad, francois.perrad@gadz.org
#
# RCS ID
# $Id: Makefile,v 1.3 2008/07/29 06:51:09 fperrad Exp $
#
# CHANGE LOG
# (See the bottom of this file.)
#

#################################################################
# Macros.
#

SM_SOURCES=     AppClass.sm
SOURCES=        $(SM_SOURCES:%.sm=%Context.scala) \
                AppClass.scala \
                checkstring.scala
OBJECTS=        $(SOURCES:%.scala=%.class)
CHECKSTRING=    $(SCALA) $(SCALA_FLAGS) checkstring

# Uncomment to turn on debug message generation.
TRACE=          -g

# Uncomment to turn on serialization.
# SERIAL=         -serial

# Uncomment to turn on synchronized.
# SYNC=           -sync

# Uncomment to turn on reflection.
# REFLECT=        -reflect

SMC=            java -jar ../../../bin/Smc.jar
SMC_FLAGS=      -scala $(TRACE) $(SERIAL) $(SYNC) $(REFLECT)

SCALAC=         scalac
SCALAC_FLAGS=   -g ../../../lib/Scala/statemap.scala

SCALA=          scala
SCALA_FLAGS=

RM_F=           rm -f
RM_RF=          rm -rf

#################################################################
# Rules.
#

%Context.scala : %.sm
		$(SMC) $(SMC_FLAGS) $<

%_sm.dot :      %.sm
		$(SMC) -graph -glevel 1 $<

%_sm.png :      %_sm.dot
		dot -T png -o $@ $<

%_sm.html :     %.sm
		$(SMC) -table $<

all :           checkstring

checkstring :   $(SOURCES)
		$(SCALAC) $(SCALAC_FLAGS) $(SOURCES)

test :          $(OBJECTS)
		-$(CHECKSTRING) ""
		-$(CHECKSTRING) 00
		-$(CHECKSTRING) 1c
		-$(CHECKSTRING) 0c
		-$(CHECKSTRING) abcba
		-$(CHECKSTRING) 110010c010011
		-$(CHECKSTRING) 110010c110010

graph :         $(SM_SOURCES:%.sm=%_sm.dot)

png :           $(SM_SOURCES:%.sm=%_sm.png)

table :         $(SM_SOURCES:%.sm=%_sm.html)

clean :
		-$(RM_RF) statemap
		-$(RM_F) *.class
		-$(RM_F) *Context.scala
		-$(RM_F) *_sm.dot
		-$(RM_F) *_sm.png
		-$(RM_F) *_sm.html

#
# CHANGE LOG
# $Log: Makefile,v $
# Revision 1.3  2008/07/29 06:51:09  fperrad
# - add a target 'png'
#
# Revision 1.2  2008/04/24 09:29:55  fperrad
# + fix #1934494 : remove 'test' from 'all' target
#
# Revision 1.1  2008/02/04 12:48:00  fperrad
# Added Scala examples 1 - 3
#
#
