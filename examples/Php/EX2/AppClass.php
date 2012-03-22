<?php
/*
 The contents of this file are subject to the Mozilla Public
 License Version 1.1 (the "License"); you may not use this file
 except in compliance with the License. You may obtain a copy of
 the License at http://www.mozilla.org/MPL/

 Software distributed under the License is distributed on an "AS
 IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 implied. See the License for the specific language governing
 rights and limitations under the License.

 The Original Code is State Machine Compiler (SMC).

 The Initial Developer of the Original Code is Charles W. Rapp.
 Portions created by Charles W. Rapp are
 Copyright (C) 2000 - 2003 Charles W. Rapp.
 All Rights Reserved.

 Contributor(s):
       Port to PHP by Toni Arnold

 Function
   Main

 Description
  This routine starts the finite state machine running.

 RCS ID
 $Id: AppClass.php,v 1.2 2009/04/22 20:26:29 fperrad Exp $

 CHANGE LOG
 $Log: AppClass.php,v $
 Revision 1.2  2009/04/22 20:26:29  fperrad
 Added enterStartState method

 Revision 1.1  2008/04/22 15:58:41  fperrad
 - add PHP language (patch from Toni Arnold)


*/

require_once 'AppClass_sm.php';

class AppClass {

    protected $_fsm;
    protected $_is_acceptable;

    public function __construct() {
        $this->_fsm = new AppClass_sm($this);
        $this->_is_acceptable = false;

        // Uncomment to see debug output.
        //$this->_fsm->setDebugFlag(true);
    }

    public function CheckString($string) {
        $this->_fsm->enterStartState();
        if ($string != "") {
            $array = str_split($string);
            foreach($array as $c) {
                if ($c == '0') {
                    $this->_fsm->Zero();
                } elseif ($c == '1') {
                    $this->_fsm->One();
                } else {
                    $this->_fsm->Unknown();
                }
            }
        }
        $this->_fsm->EOS();
        return $this->_is_acceptable;
    }

    public function Acceptable() {
        $this->_is_acceptable = true;
    }

    public function Unacceptable() {
        $this->_is_acceptable = false;
    }
}

?>
