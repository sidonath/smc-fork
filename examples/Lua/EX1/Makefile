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
# Copyright (C) 2000 Charles W. Rapp.
# All Rights Reserved.
#
# Contributor(s):
#       Port to Lua by Francois Perrad, francois.perrad@gadz.org
#
# RCS ID
# $Id: Makefile,v 1.7 2008/07/29 06:50:59 fperrad Exp $
#
# CHANGE LOG
# $Log: Makefile,v $
# Revision 1.7  2008/07/29 06:50:59  fperrad
# - add a target 'png'
#
# Revision 1.6  2008/04/24 09:29:53  fperrad
# + fix #1934494 : remove 'test' from 'all' target
#
# Revision 1.5  2008/02/04 11:00:48  fperrad
# + Exhibit options
#
# Revision 1.4  2008/01/24 07:50:18  fperrad
# - add a target 'table'
#
# Revision 1.3  2008/01/22 08:46:03  fperrad
# - add a target 'graph'
#
# Revision 1.2  2007/10/12 08:55:00  fperrad
# - refactor: Makefile with variables
#
# Revision 1.1  2007/01/03 15:40:45  fperrad
# + Added Lua examples 1 - 3.
#
#
#

#################################################################
# Macros.
#

SM_SOURCES=     AppClass.sm
SOURCES=        $(SM_SOURCES:%.sm=%_sm.lua)
CHECKSTRING=    lua checkstring.lua

export LUA_PATH=./?.lua;../../../lib/Lua/?.lua

# Uncomment to turn on debug message generation.
TRACE=          -g

# Uncomment to turn on reflection.
# REFLECT=        -reflect

SMC=            java -jar ../../../bin/Smc.jar
SMC_FLAGS=      -lua $(TRACE) $(REFLECT)

RM_F=           rm -f

#################################################################
# Rules.
#

%_sm.lua :      %.sm
		$(SMC) $(SMC_FLAGS) $<

%_sm.dot :      %.sm
		$(SMC) -graph -glevel 1 $<

%_sm.png :      %_sm.dot
		dot -T png -o $@ $<

%_sm.html :     %.sm
		$(SMC) -table $<

all :           checkstring

checkstring :   $(SOURCES)

test:
		-$(CHECKSTRING) ""
		-$(CHECKSTRING) 000
		-$(CHECKSTRING) 00011
		-$(CHECKSTRING) 111
		-$(CHECKSTRING) 000111100
		-$(CHECKSTRING) 00011a1b10c0

graph :         $(SM_SOURCES:%.sm=%_sm.dot)

png :           $(SM_SOURCES:%.sm=%_sm.png)

table :         $(SM_SOURCES:%.sm=%_sm.html)

clean :
		-$(RM_F) *_sm.lua
		-$(RM_F) *_sm.dot
		-$(RM_F) *_sm.png
		-$(RM_F) *_sm.html
