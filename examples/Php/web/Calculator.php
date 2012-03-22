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
       Port to Php by Toni Arnold

 Function
  Calculator class

 Description
  This is the front controller for the php RPN calculator.

 RCS ID
 $Id: Calculator.php,v 1.1 2008/04/22 15:58:41 fperrad Exp $

 CHANGE LOG
 $Log: Calculator.php,v $
 Revision 1.1  2008/04/22 15:58:41  fperrad
 - add PHP language (patch from Toni Arnold)


*/

require_once 'Calculator_sm.php';

class Calculator {

    protected $_fsm;
    protected $_stack;

    public function __construct() {
        $this->_fsm = new Calculator_sm($this);
        $this->_stack = array();

        // Uncomment to send debug output to the apache error_log.
        //$this->_fsm->setDebugFlag(true);
    }

    // Accessors
    public function getFsm() {
        return $this->_fsm;
    }
    public function getStateName() {
        return $this->_fsm->getState()->getName();
    }
    public function getStack() {
        return $this->_stack;
    }

    // Context methods
    public function Push($value) {
        array_push($this->_stack, $value);
    }
    public function Add() {
        $y = array_pop($this->_stack);
        $x = array_pop($this->_stack);
        array_push($this->_stack, $x + $y);
    }
    public function Sub() {
        $y = array_pop($this->_stack);
        $x = array_pop($this->_stack);
        array_push($this->_stack, $x - $y);
    }
    public function Mul() {
        $y = array_pop($this->_stack);
        $x = array_pop($this->_stack);
        array_push($this->_stack, $x * $y);
    }
    public function Div() {
        $y = array_pop($this->_stack);
        $x = array_pop($this->_stack);
        array_push($this->_stack, $x / $y);
    }
    public function Pow() {
        $x = array_pop($this->_stack);
        array_push($this->_stack, pow($x, 2 ) );
    }
    public function Sqrt() {
        $x = array_pop($this->_stack);
        array_push($this->_stack, sqrt($x) );
    }
    public function Clr() {
        array_pop($this->_stack);
    }
    public function ClrAll() {
        $this->_stack = array();
    }
}

?>
