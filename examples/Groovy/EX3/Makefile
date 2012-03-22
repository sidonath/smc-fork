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
#       Port to Groovy by Francois Perrad, francois.perrad@gadz.org
#
# RCS ID
# $Id: Makefile,v 1.6 2008/07/29 06:50:58 fperrad Exp $
#
# CHANGE LOG
# (See the bottom of this file.)
#

#################################################################
# Macros.
#

SM_SOURCES=     AppClass.sm
SOURCES=        $(SM_SOURCES:%.sm=%Context.groovy)
CHECKSTRING=    $(GROOVY) $(GROOVY_FLAGS) checkstring

# Uncomment to turn on debug message generation.
TRACE=          -g

# Uncomment to turn on serialization.
# SERIAL=         -serial

# Uncomment to turn on synchronized.
# SYNC=           -sync

# Uncomment to turn on reflection.
# REFLECT=        -reflect

SMC=            java -jar ../../../bin/Smc.jar
SMC_FLAGS=      -groovy $(TRACE) $(SERIAL) $(SYNC) $(REFLECT)

GROOVY=         groovy
GROOVY_FLAGS=   -classpath ../../../lib/Groovy/statemap.jar

RM_F=           rm -f

#################################################################
# Rules.
#

%Context.groovy : %.sm
		$(SMC) $(SMC_FLAGS) $<

%_sm.dot :      %.sm
		$(SMC) -graph -glevel 1 $<

%_sm.png :      %_sm.dot
		dot -T png -o $@ $<

%_sm.html :     %.sm
		$(SMC) -table $<

all :           checkstring

checkstring :   $(SOURCES)

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
		-$(RM_F) *Context.groovy
		-$(RM_F) *_sm.dot
		-$(RM_F) *_sm.png
		-$(RM_F) *_sm.html

#
# CHANGE LOG
# $Log: Makefile,v $
# Revision 1.6  2008/07/29 06:50:58  fperrad
# - add a target 'png'
#
# Revision 1.5  2008/04/24 09:29:53  fperrad
# + fix #1934494 : remove 'test' from 'all' target
#
# Revision 1.4  2008/02/04 11:00:26  fperrad
# + Exhibit options
#
# Revision 1.3  2008/01/24 07:50:18  fperrad
# - add a target 'table'
#
# Revision 1.2  2008/01/22 08:45:34  fperrad
# - add a target 'graph'
#
# Revision 1.1  2007/07/16 06:31:31  fperrad
# + Added Groovy examples 1 - 3.
#
#
