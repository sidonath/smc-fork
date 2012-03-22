


                          C++ Example 3


This state machine "recognizes" the palindromes (words that
read the same backwards as forwards). The words consist of the
alphabet {0, 1, c} where the letter 'c' may appear only once and
marks the words center.


+ Building
----------

NOTE: Smc.jar must be built and installed.

Unix:
    $ make checkstring

Windows Visual C++:
    1. Load ex1.dsw.
    2. Rebuild all.


+ Executing
-----------

Unix & Windows:

    $ checkstring <string>

Try several different strings, such as:

    $ checkstring "" -> unacceptable
    $ checkstring 00 -> unacceptable
    $ checkstring 1c -> unacceptable
    $ checkstring c0 -> unacceptable
    $ checkstring abcba -> unacceptable
    $ checkstring 110010c010011 -> acceptable
    $ checkstring 110010c110010 -> unacceptable
