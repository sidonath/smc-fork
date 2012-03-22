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
# Copyright (C) 2005. Charles W. Rapp.
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
#   Francois Perrad contributed the Python code generator and
#   examples/Python.
#   Toni Arnold contributed the PHP code generation and
#   examples/PHP.
#
# RCS ID
# $Id: Makefile,v 1.3 2009/03/01 18:20:41 cwrapp Exp $
#
# CHANGE LOG
# (See the bottom of this file.)
#

#################################################################
# Macros.
#

# Include the official macros.
include ../../smc.mk

SOURCES	= package.xml statemap.php

LIB_STAGING_DIR=../../$(SMC_STAGING_DIR)/lib/Php

#################################################################
# Rules.
#

$(LIB_STAGING_DIR) :
		$(MKDIR) $@

install :       $(LIB_STAGING_DIR) $(SOURCES)
		$(CP_F) README.txt $(LIB_STAGING_DIR)/README.txt
		$(CP_F) statemap.php $(LIB_STAGING_DIR)/statemap.php
		$(CP_F) package.xml $(LIB_STAGING_DIR)/package.xml

uninstall :
		-$(RM_F) $(LIB_STAGING_DIR)/*.php

clean :

realclean :	clean

#
# CHANGE LOG
# $Log: Makefile,v $
# Revision 1.3  2009/03/01 18:20:41  cwrapp
# Preliminary v. 6.0.0 commit.
#
# Revision 1.2  2008/04/23 07:14:53  fperrad
# + use common variables
#
# Revision 1.1  2008/04/22 16:00:39  fperrad
# - add PHP language (patch from Toni Arnold)
#
#
