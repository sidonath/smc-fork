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
#       Port to Perl by Francois Perrad, francois.perrad@gadz.org
#
# RCS ID
# $Id: Makefile,v 1.7 2008/07/29 06:51:04 fperrad Exp $
#
# CHANGE LOG
# $Log: Makefile,v $
# Revision 1.7  2008/07/29 06:51:04  fperrad
# - add a target 'png'
#
# Revision 1.6  2008/02/04 11:03:06  fperrad
# + Exhibit options
#
# Revision 1.5  2008/01/24 07:50:19  fperrad
# - add a target 'table'
#
# Revision 1.4  2008/01/22 08:46:22  fperrad
# - add a target 'graph'
#
# Revision 1.3  2007/10/12 08:54:03  fperrad
# - refactor: Makefile with variables
#
# Revision 1.2  2007/01/03 14:37:39  fperrad
# + Added -reflect option for Perl, Python and Ruby code generation
#
# Revision 1.1  2005/06/16 18:04:15  fperrad
# Added Perl examples 1 - 4 and 7.
#
#

#################################################################
# Macros.
#

SM_SOURCES=     Vehicle.sm \
                Stoplight.sm
SOURCES=        $(SM_SOURCES:%.sm=%_sm.pm)
TARGET=         Traffic

# Uncomment to turn on debug message generation.
TRACE=          -g

# Uncomment to turn on reflection.
# REFLECT=        -reflect

SMC=            java -jar ../../../bin/Smc.jar
SMC_FLAGS=      -perl $(TRACE) $(REFLECT)

RM_F=           rm -f

#################################################################
# Rules.
#

%_sm.pm :       %.sm
		$(SMC) $(SMC_FLAGS) $<

%_sm.dot :      %.sm
		$(SMC) -graph -glevel 1 $<

%_sm.png :      %_sm.dot
		dot -T png -o $@ $<

%_sm.html :     %.sm
		$(SMC) -table $<

all :           $(TARGET)

$(TARGET) :     $(SOURCES)

graph :         $(SM_SOURCES:%.sm=%_sm.dot)

png :           $(SM_SOURCES:%.sm=%_sm.png)

table :         $(SM_SOURCES:%.sm=%_sm.html)

clean :
		-$(RM_F) *_sm.pm
		-$(RM_F) *_sm.dot
		-$(RM_F) *_sm.png
		-$(RM_F) *_sm.html
