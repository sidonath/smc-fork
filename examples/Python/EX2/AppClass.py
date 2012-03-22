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
# Copyright (C) 2000 - 2003 Charles W. Rapp.
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
# $Id: AppClass.py,v 1.2 2009/04/19 14:39:48 cwrapp Exp $
#
# CHANGE LOG
# $Log: AppClass.py,v $
# Revision 1.2  2009/04/19 14:39:48  cwrapp
# Added call to enterStartState before issuing first FSM transition.
#
# Revision 1.1  2005/05/28 17:48:29  cwrapp
# Added Python examples 1 - 4 and 7.
#
#

import AppClass_sm

class AppClass:

	def __init__(self):
		self._fsm = AppClass_sm.AppClass_sm(self)
		self._is_acceptable = False

		# Uncomment to see debug output.
		#self._fsm.setDebugFlag(True)

	def CheckString(self, string):
		self._fsm.enterStartState()
		for c in string:
			if c == '0':
				self._fsm.Zero()
			elif c == '1':
				self._fsm.One()
			else:
				self._fsm.Unknown()
		self._fsm.EOS()
		return self._is_acceptable

	def Acceptable(self):
		self._is_acceptable = True

	def Unacceptable(self):
		self._is_acceptable = False
