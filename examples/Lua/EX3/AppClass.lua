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
-- $Id: AppClass.lua,v 1.3 2010/11/21 18:49:39 fperrad Exp $
--
-- CHANGE LOG
-- $Log: AppClass.lua,v $
-- Revision 1.3  2010/11/21 18:49:39  fperrad
-- refactor Lua generation (compat 5.2)
--
-- Revision 1.2  2009/04/22 19:40:07  fperrad
-- Added enterStartState method
--
-- Revision 1.1  2007/01/03 15:42:33  fperrad
-- + Added Lua examples 1 - 3.
--
--
--

local m = {}

function m:new ()
    local o = {}
    o.fsm = require 'AppClass_sm':new({owner = o})
    -- Uncomment to see debug output.
    -- o.fsm.debugFlag = true
    return setmetatable(o, {__index = m})
end

function m:CheckString (str)
    self.fsm:enterStartState()
    for c in string.gmatch(str, '.') do
        if c == '0' then
            self.fsm:Zero()
        elseif c == '1' then
            self.fsm:One()
        elseif c == 'c' or c == 'C' then
            self.fsm:C()
        else
            self.fsm:Unknown()
        end
    end
    self.fsm:EOS()
    return self._is_acceptable
end

function m:Acceptable ()
    self._is_acceptable = true
end

function m:Unacceptable ()
    self._is_acceptable = false
end

return m
