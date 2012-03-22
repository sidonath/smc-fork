#!/usr/bin/env lua

--
-- The contents of this file are subject to the Mozilla Public
-- License Version 1.1 (the "License"); you may not use this file
-- except in compliance with the License. You may obtain a copy of
-- the License at http://www.mozilla.org/MPL/
--
-- Software distributed under the License is distributed on an "AS
-- IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
-- implied. See the License for the specific language governing
-- rights and limitations under the License.
--
-- The Original Code is State Machine Compiler (SMC).
--
-- The Initial Developer of the Original Code is Charles W. Rapp.
-- Portions created by Charles W. Rapp are
-- Copyright (C) 2000 - 2003 Charles W. Rapp.
-- All Rights Reserved.
--
-- Contributor(s):
--       Port to Lua by Francois Perrad, francois.perrad@gadz.org
--
-- Function
--   Main
--
-- Description
--  This routine starts the finite state machine running.
--
-- RCS ID
-- $Id: checkstring.lua,v 1.2 2010/11/21 18:49:24 fperrad Exp $
--
-- CHANGE LOG
-- $Log: checkstring.lua,v $
-- Revision 1.2  2010/11/21 18:49:24  fperrad
-- refactor Lua generation (compat 5.2)
--
-- Revision 1.1  2007/01/03 15:42:20  fperrad
-- + Added Lua examples 1 - 3.
--
--
--

local AppClass = require 'AppClass'

local arg = {...}
local retcode = 0
if #arg < 1 then
    io.stderr:write "No string to check.\n"
    retcode = 2
elseif #arg > 1 then
    io.stderr:write "Only one argument is accepted.\n"
    retcode = 3
else
    local appobject = AppClass.new()
    local str = arg[1]
    local result
    if appobject:CheckString(str) then
        result = 'acceptable'
    else
        result = 'not acceptable'
        retcode = 1
    end
    print(string.format('The string "%s" is %s.', str, result))
end
os.exit(retcode)

