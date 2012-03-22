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
# Copyright (C) 2007. Charles W. Rapp.
# All Rights Reserved.
#
# Contributor(s):
#
# RCS ID
# $Id: Makefile,v 1.4 2008/07/29 06:51:10 fperrad Exp $
#
# CHANGE LOG
# (See the bottom of this file.)
#

#################################################################
# Macros.
#

SM_SOURCES=     VEHICLE.SM \
                stoplight.sm
SOURCES=        $(SM_SOURCES:%.sm=%_sm.tcl) \
                $(SM_SOURCES:%.SM=%_sm.tcl)
TARGET=         Traffic

# Uncomment to turn on debug message generation.
TRACE=          -g

# Uncomment to turn on serialization.
# SERIAL=         -serial

# Uncomment to turn on reflection.
# REFLECT=        -reflect

SMC=            java -jar ../../../bin/Smc.jar
SMC_FLAGS=      -tcl $(TRACE) $(SERIAL) $(REFLECT)

RM_F=           rm -f

#################################################################
# Rules.
#

%_sm.tcl :      %.sm
		$(SMC) $(SMC_FLAGS) $<

%_sm.tcl :      %.SM
		$(SMC) $(SMC_FLAGS) $<

%_sm.dot :      %.sm
		$(SMC) -graph -glevel 1 $<

%_sm.dot :      %.SM
		$(SMC) -graph -glevel 1 $<

%_sm.png :      %_sm.dot
		dot -T png -o $@ $<

%_sm.html :     %.sm
		$(SMC) -table $<

%_sm.html :     %.SM
		$(SMC) -table $<

all :           $(TARGET)

$(TARGET) :     $(SOURCES)

test :          $(SOURCES)
		wish TRAFFIC.TCL

graph :         $(SM_SOURCES:%.sm=%_sm.dot) $(SM_SOURCES:%.SM=%_sm.dot)

png :           $(SM_SOURCES:%.sm=%_sm.png) $(SM_SOURCES:%.SM=%_sm.png)

table :         $(SM_SOURCES:%.sm=%_sm.html) $(SM_SOURCES:%.SM=%_sm.html)

clean :
		-$(RM_F) *_sm.tcl
		-$(RM_F) *_sm.dot
		-$(RM_F) *_sm.png
		-$(RM_F) *_sm.html

#
# CHANGE LOG
# $Log: Makefile,v $
# Revision 1.4  2008/07/29 06:51:10  fperrad
# - add a target 'png'
#
# Revision 1.3  2008/04/24 09:29:55  fperrad
# + fix #1934494 : remove 'test' from 'all' target
#
# Revision 1.2  2008/02/04 11:17:29  fperrad
# + Exhibit options
# + add a target 'table'
# + add a target 'graph'
#
# Revision 1.1  2007/01/15 16:58:59  cwrapp
# Release 4.4.0 second commit.
#
