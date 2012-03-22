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

 Description
  This is the title page for the php RPN calculator,
  displayed unconditionally.

 RCS ID
 $Id: title.php,v 1.1 2008/04/22 15:58:41 fperrad Exp $

 CHANGE LOG
 $Log: title.php,v $
 Revision 1.1  2008/04/22 15:58:41  fperrad
 - add PHP language (patch from Toni Arnold)


*/
?>
<h2>RPN calculator</h2>
Current calculator state: <?php echo $calculator->getStateName() ?>
