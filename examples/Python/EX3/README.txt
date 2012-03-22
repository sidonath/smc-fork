


                         Python Example 3


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

    $ python checkstring.py <string>

Try several different strings, such as:

    $ python checkstring.py ""
      -> unacceptable
    $ python checkstring.py 00
      -> unacceptable
    $ python checkstring.py 1c
      -> unacceptable
    $ python checkstring.py c0
      -> unacceptable
    $ python checkstring.py abcba
      -> unacceptable
    $ python checkstring.py 110010c010011
      -> acceptable
    $ python checkstring.py 110010c110010
      -> unacceptable
