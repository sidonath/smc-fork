#!/usr/bin/env python

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
# Copyright (C) 2000 - 2005 Charles W. Rapp.
# All Rights Reserved.
# 
# Contributor(s): 
#       Port to Python by Francois Perrad, francois.perrad@gadz.org
#
# Function
#   Main
#
# Description
#  This routine starts the finite state machine running.
#
# RCS ID
# $Id: checkstring.py,v 1.2 2005/06/03 19:58:28 cwrapp Exp $
#
# CHANGE LOG
# $Log: checkstring.py,v $
# Revision 1.2  2005/06/03 19:58:28  cwrapp
# Further updates for release 4.0.0
#
# Revision 1.1  2005/05/28 17:48:29  cwrapp
# Added Python examples 1 - 4 and 7.
#
# 

import sys

import AppClass

retcode = 0
if len(sys.argv) < 2:
	print "No string to check.\n"
	retcode = 2
elif len(sys.argv) > 2:
	print "Only one argument is accepted.\n"
	retcode = 3
else:
	appobject = AppClass.AppClass()
	str = sys.argv[1]
	if appobject.CheckString(str) == False:
		result = "not acceptable"
		retcode = 1
	else:
		result = "acceptable"
	print 'The string "%s" is %s.\n' % (str, result)
sys.exit(retcode)
