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
#       Port to Ruby by Francois Perrad, francois.perrad@gadz.org
#
# Function
#   Main
#
# Description
#  This routine starts the finite state machine running.
#
# RCS ID
# $Id: AppClass.rb,v 1.2 2009/04/11 14:28:40 cwrapp Exp $
#
# CHANGE LOG
# $Log: AppClass.rb,v $
# Revision 1.2  2009/04/11 14:28:40  cwrapp
# Added called to enterStartState.
#
# Revision 1.1  2005/06/16 17:52:03  fperrad
# Added Ruby examples 1 - 4 and 7.
#
#

require 'AppClass_sm'

class AppClass

	def initialize()
		@_fsm = AppClass_sm::new(self)
		@_is_acceptable = nil

		# Uncomment to see debug output.
		#@_fsm.setDebugFlag(true)
	end

	def CheckString(string)
                   @_fsm.enterStartState
		for c in string.split(//) do
			if c == '0' then
				@_fsm.Zero
			elsif c == '1' then
				@_fsm.One
			else
				@_fsm.Unknown
			end
		end
		@_fsm.EOS()
		return @_is_acceptable
	end

	def Acceptable()
		@_is_acceptable = true
	end

	def Unacceptable()
		@_is_acceptable = false
	end

end
