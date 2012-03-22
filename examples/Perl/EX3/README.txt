


                         Perl Example 3


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

    $ perl checkstring.pl <string>

Try several different strings, such as:

    $ perl checkstring.pl ""
      -> unacceptable
    $ perl checkstring.pl 00
      -> unacceptable
    $ perl checkstring.pl 1c
      -> unacceptable
    $ perl checkstring.pl c0
      -> unacceptable
    $ perl checkstring.pl abcba
      -> unacceptable
    $ perl checkstring.pl 110010c010011
      -> acceptable
    $ perl checkstring.pl 110010c110010
      -> unacceptable
