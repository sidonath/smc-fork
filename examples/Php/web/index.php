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
  Main

 Description
  This is the front controller for the php RPN calculator
  example to implement a simple stateless MVC pattern.

 RCS ID
 $Id: index.php,v 1.1 2008/04/22 15:58:41 fperrad Exp $

 CHANGE LOG
 $Log: index.php,v $
 Revision 1.1  2008/04/22 15:58:41  fperrad
 - add PHP language (patch from Toni Arnold)


*/

require_once 'Calculator.php';


// MODEL
// Instantiate the model class either new or from the postback.

// Encrypt the serialized object to ensure that it has not
// been tampered with.
require_once 'crypt.php';

if (array_key_exists('calculator', $_POST)) {
    // postback
    $calculator = unserialize(decrypt(base64_decode($_POST['calculator'])));
    // re-create the not serializable stderr stream
    $calculator->getFsm()->setDebugStream(fopen("php://stderr","w"));
} else {
    // 1st page
    $calculator = new Calculator();
}
// Assign the operand to the global variable if it was given.
// Don't validate here, as we can't react properly yet.
$operand = NULL;
if (array_key_exists('operand', $_POST)) {
    $operand = $_POST['operand'];
}


// CONTROL
$transition = NULL;
foreach ($_POST as $name => $value) {
    // Determine the transition according to the button name.
    if (substr($name, 0, 4) == 'btn_') {
        $transition = substr($name, 4);
        switch($transition) {
            case 'Enter':
                $calculator->getFsm()->Enter($operand);
                break;
            default:
                // Calculation methods are generated dynamically,
                // thus guard against code injection attacks.
                if (! preg_match('/^\w+$/', $transition) ) {
                    throw new Exception(
                        "Transition attack detected: $transition");
                } else {
                    eval("\$calculator->getFsm()" .
                         "->$transition(\$calculator->getStack());");
                }
        }
    }
}


// VIEW
// Now all program logic is finished, the target state is determined
// and we can start render the page.
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
    <head>
        <title>RPN Calculator</title>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    </head>

    <body onload="document.form.btn_Enter.focus()">
        <form action="<?php echo $_SERVER['PHP_SELF'] ?>" method="POST" name="form">
            <!-- Persist the calculator (including its fsm) across posts. -->
            <input name="calculator" type="hidden"
                value="<?php echo base64_encode(encrypt(serialize($calculator))) ?>">
<?php
// Include the parts the web application is composed of.
include 'title.php';
echo "<hr>";

// Conditionally display the page belonging to a (now read-only) state.
switch($calculator->getStateName()) {
    // separate includes per state
    case 'Map1.Splash':
        include "Splash.php";
        break;
    case 'Map1.Enter':
        include "Enter.php";
        break;
    case 'Map1.Calculate':
        include "Calculate.php";
        break;
    // one error page for all error states,
    // parametrized with $errormsg
    case 'Map1.ErrorNumeric':
        $errormsg = "The input was not numeric.";
        include "Error.php";
        break;
    case 'Map1.ErrorTuple':
        $errormsg = "Need two values on the stack to compute.";
        include "Error.php";
        break;
    case 'Map1.ErrorEmpty':
        $errormsg = "Need two values on the stack to compute.";
        include "Error.php";
        break;
    default:
        throw new Exception(
            "Cannot display state {$calculator->getStateName()}");
}

echo "<hr>";
include 'footer.php';    // contains btn_Enter for the onload event
?>
        </form>
    </body>
</html>
