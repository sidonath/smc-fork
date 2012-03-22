#!/usr/bin/env ruby

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
# $Id: checkstring.rb,v 1.2 2008/04/23 12:53:28 fperrad Exp $
#
# CHANGE LOG
# $Log: checkstring.rb,v $
# Revision 1.2  2008/04/23 12:53:28  fperrad
# + fix #1934497 : remove -w in shebang
#
# Revision 1.1  2005/06/16 17:52:03  fperrad
# Added Ruby examples 1 - 4 and 7.
#
#

require 'AppClass'

retcode = 0
if ARGV.size < 1 then
	STDERR.print "No string to check.\n"
	retcode = 2
elsif ARGV.size > 1 then
	STDERR.print "Only one argument is accepted.\n"
	retcode = 3
else
	appobject = AppClass::new
	str = ARGV[0]
	unless appobject.CheckString(str) then
		result = "not acceptable"
		retcode = 1
	else
		result = "acceptable"
	end
	printf "The string \"%s\" is %s.\n", str, result
end
exit retcode
