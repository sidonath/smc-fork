


                          VB.net Example 1


This state machine "recognizes" the string 0*1* (which includes the
empty string).


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
      -> acceptable
      
    $ checkstring.exe 000
      -> acceptable
      
    $ checkstring.exe 00011
      -> acceptable
      
    $ checkstring.exe 111
      -> acceptable
      
    $ checkstring.exe 000111100
      -> unacceptable
      
    $ checkstring.exe 00011a1b10c0
      -> unacceptable
