


                         PHP Example 3


This state machine "recognizes" the palindromes (words that read the
same backwards as forwards). The words consist of the alphabet
{0, 1, c} where the letter 'c' may appear only once and marks the
words center.


+ Building
----------

NOTE: Smc.jar must be built and installed.

Unix & Windows:
    $ make checkstring


+ Executing
-----------

Unix & Windows:

    $ php -q checkstring.php <string>

Try several different strings, such as:

    $ php -q checkstring.php ""
      -> unacceptable
    $ php -q checkstring.php 00
      -> unacceptable
    $ php -q checkstring.php 1c
      -> unacceptable
    $ php -q checkstring.php c0
      -> unacceptable
    $ php -q checkstring.php abcba
      -> unacceptable
    $ php -q checkstring.php 110010c010011
      -> acceptable
    $ php -q checkstring.php 110010c110010
      -> unacceptable
