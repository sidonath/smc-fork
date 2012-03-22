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
#
# RCS ID
# $Id: Makefile,v 1.5 2005/05/28 18:52:09 cwrapp Exp $
#
# CHANGE LOG
# $Log: Makefile,v $
# Revision 1.5  2005/05/28 18:52:09  cwrapp
# Updated Makefile.
#
# Revision 1.0  2003/12/14 20:44:57  charlesr
# Initial revision
#

STAGING_DIR =	../../staging/smc/misc

# Copy all products to the staging directory.
install : $(STAGING_DIR)
		cp -f ./smc.ico $(STAGING_DIR)

$(STAGING_DIR) :
		mkdir $(STAGING_DIR)

uninstall : 
		-rm -f $(STAGING_DIR)/smc.ico

clean :

realclean :
