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
# Copyright (C) 2000 - 2007. Charles W. Rapp.
# All Rights Reserved.
#
# Contributor(s):
#       Port to Ruby by Francois Perrad, francois.perrad@gadz.org
#
# RCS ID
# $Id: Makefile,v 1.10 2008/07/29 06:51:09 fperrad Exp $
#
# CHANGE LOG
# (See the bottom of this file.)
#

#################################################################
# Macros.
#

SM_SOURCES=     AppClass.sm
SOURCES=        $(SM_SOURCES:%.sm=%_sm.rb)
CHECKSTRING=    ruby -I ../../../lib/Ruby checkstring.rb

# Uncomment to turn on debug message generation.
TRACE=          -g

# Uncomment to turn on reflection.
# REFLECT=        -reflect

SMC=            java -jar ../../../bin/Smc.jar
SMC_FLAGS=      -ruby $(TRACE) $(REFLECT)

RM_F=           rm -f

#################################################################
# Rules.
#

%_sm.rb :       %.sm
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
		-$(CHECKSTRING) 00
		-$(CHECKSTRING) 1c
		-$(CHECKSTRING) c0
		-$(CHECKSTRING) abcba
		-$(CHECKSTRING) 110010c010011
		-$(CHECKSTRING) 110010c110010

graph :         $(SM_SOURCES:%.sm=%_sm.dot)

png :           $(SM_SOURCES:%.sm=%_sm.png)

table :         $(SM_SOURCES:%.sm=%_sm.html)

clean :
		-$(RM_F) *_sm.rb
		-$(RM_F) *_sm.dot
		-$(RM_F) *_sm.png
		-$(RM_F) *_sm.html

#
# CHANGE LOG
# $Log: Makefile,v $
# Revision 1.10  2008/07/29 06:51:09  fperrad
# - add a target 'png'
#
# Revision 1.9  2008/04/24 09:29:55  fperrad
# + fix #1934494 : remove 'test' from 'all' target
#
# Revision 1.8  2008/02/04 11:06:36  fperrad
# + Exhibit options
#
# Revision 1.7  2008/01/24 07:50:23  fperrad
# - add a target 'table'
#
# Revision 1.6  2008/01/22 08:47:03  fperrad
# - add a target 'graph'
#
# Revision 1.5  2007/10/12 08:55:04  fperrad
# - refactor: Makefile with variables
#
# Revision 1.4  2007/01/15 16:58:58  cwrapp
# Release 4.4.0 second commit.
#
# Revision 1.3  2007/01/03 14:43:24  fperrad
# + Added -reflect option for Perl, Python and Ruby code generation
#
# Revision 1.2  2006/09/17 16:26:06  cwrapp
# Initial v. 4.3.3 check-in.
#
# Revision 1.1  2005/06/16 17:52:03  fperrad
# Added Ruby examples 1 - 4 and 7.
#