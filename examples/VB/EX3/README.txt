


                          VB.net Example 3


This state machine "recognizes" palindromes (words that read the
same backwards as forwards). The words consist of the alphabet
{0, 1, c} where the letter 'c' may appear only once and marks the
words center.


+ Building
----------

NOTE: Smc.jar must be built and installed.

Windows:
    $ java -jar ../../../bin/Smc.jar -vb AppClass.sm

Load EX1.sln into Microsoft Visual Studio.Net. You will
have to add the fully qualified path to smc/lib/statemap.dll
before building.


+ Executing
-----------

    $ checkstring.exe <string>

Try several different strings, such as:

    $ checkstring.exe ""
      -> unacceptable
      
    $ checkstring.exe 00
      -> unacceptable
      
    $ checkstring.exe 1c
      -> unacceptable
      
    $ checkstring.exe c0
      -> unacceptable
      
    $ checkstring.exe 110010c010011
      -> acceptable
      
    $ checkstring.exe 110010c110010
      -> unacceptable
