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
# The %.png target requries graphviz installed.
#
# Contributor(s):
#       Port to Php by Toni Arnold
#
# RCS ID
# $Id: Makefile,v 1.3 2008/07/29 06:51:05 fperrad Exp $
#
# CHANGE LOG
# $Log: Makefile,v $
# Revision 1.3  2008/07/29 06:51:05  fperrad
# - add a target 'png'
#
# Revision 1.2  2008/04/23 07:10:09  fperrad
# + exhibit options
# + add a target 'table'
# + add a target 'graph'
#
# Revision 1.1  2008/04/22 15:58:41  fperrad
# - add PHP language (patch from Toni Arnold)
#
#

#################################################################
# Macros.
#

SM_SOURCES=     Calculator.sm
SOURCES=        $(SM_SOURCES:%.sm=%_sm.php)

# Uncomment to turn on debug message generation.
TRACE=          -g

# Uncomment to turn on reflection.
# REFLECT=        -reflect

SMC=            java -jar ../../../bin/Smc.jar
SMC_FLAGS=      -php $(TRACE) $(REFLECT)
RM_F=           rm -f

#################################################################
# Rules.
#

%_sm.php : %.sm
		$(SMC) $(SMC_FLAGS) $<

%_sm.dot :      %.sm
		$(SMC) -graph -glevel 1 $<

%_sm.png :      %_sm.dot
		dot -T png -o $@ $<

%_sm.html :     %.sm
		$(SMC) -table $<

all :           calculator png

calculator :    $(SOURCES)

graph :         $(SM_SOURCES:%.sm=%_sm.dot)

png :           $(SM_SOURCES:%.sm=%_sm.png)

table :         $(SM_SOURCES:%.sm=%_sm.html)

clean :
		-$(RM_F) *_sm.php
		-$(RM_F) *_sm.dot
		-$(RM_F) *_sm.png
		-$(RM_F) *_sm.html
