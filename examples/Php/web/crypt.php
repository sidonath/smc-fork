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
   encrypt/decrypt

 Description
   Functions to symmetrically encrypt the postback value with
   a secret key to ensure that it is not possible to
   purposefully modify it on the client side between postbacks.

 RCS ID
 $Id: crypt.php,v 1.1 2008/04/22 15:58:41 fperrad Exp $

 CHANGE LOG
 $Log: crypt.php,v $
 Revision 1.1  2008/04/22 15:58:41  fperrad
 - add PHP language (patch from Toni Arnold)


*/

$secret_key = '<change the secret if you put it online>';

// The encryption mechanism sends the IV together with the cypher
// to the client, as described in
// http://ch2.php.net/manual/en/function.mcrypt-create-iv.php#40434

function encrypt($string) {
    global $secret_key;

    srand((double)microtime()*1000000 );
    $td = mcrypt_module_open(MCRYPT_RIJNDAEL_256, '', MCRYPT_MODE_CFB, '');
    $iv_size = mcrypt_enc_get_iv_size($td);
    $iv = mcrypt_create_iv($iv_size, MCRYPT_RAND);
    $ks = mcrypt_enc_get_key_size($td);
    $key = substr(sha1($secret_key), 0, $ks);

    if (mcrypt_generic_init($td, $key, $iv) >= 0) {
        $ciphertext = mcrypt_generic($td, $string);
        mcrypt_generic_deinit($td);
        mcrypt_module_close($td);
        return $iv.$ciphertext; // prefix the ciphertext with the IV
    } else {
        throw new Exception("mcrypt_generic_init failed");
    }
}

function decrypt($string) {
    global $secret_key;

    $td = mcrypt_module_open(MCRYPT_RIJNDAEL_256, '', MCRYPT_MODE_CFB, '');
    $iv_size = mcrypt_enc_get_iv_size($td);
    $iv = substr($string, 0, $iv_size);
    $ks = mcrypt_enc_get_key_size($td);
    $key = substr(sha1($secret_key), 0, $ks);
    $ciphertext = substr($string, $iv_size);

    if (mcrypt_generic_init($td, $key, $iv) >= 0) {
        $cleartext = mdecrypt_generic($td, $ciphertext);
        mcrypt_generic_deinit($td);
        mcrypt_module_close($td);
        return $cleartext;
    } else {
        throw new Exception("mcrypt_generic_init failed");
    }
}

?>
