


                         Groovy Example 1


This state machine "recognizes" the string 0*1* (which includes the
empty string).


+ Building
----------

NOTE: Smc.jar must be built and installed.

Unix & Windows:
    $ make checkstring


+ Executing
-----------

Unix:

    $ groovy -classpath ${CLASSPATH}:../../../lib/Groovy/statemap.jar checkstring <string>

Windows:

    $ groovy -classpath ${CLASSPATH};../../../lib/Groovy/statemap.jar checkstring <string>

Try several different strings, such as:

    $ groovy -classpath ${CLASSPATH}:../../../lib/Groovy/statemap.jar checkstring ""
      -> acceptable
    $ groovy -classpath ${CLASSPATH}:../../../lib/Groovy/statemap.jar checkstring 000
      -> acceptable
    $ groovy -classpath ${CLASSPATH}:../../../lib/Groovy/statemap.jar checkstring 00011
      -> acceptable
    $ groovy -classpath ${CLASSPATH}:../../../lib/Groovy/statemap.jar checkstring 111
      -> acceptable
    $ groovy -classpath ${CLASSPATH}:../../../lib/Groovy/statemap.jar checkstring 000111100
      -> unacceptable
    $ groovy -classpath ${CLASSPATH}:../../../lib/Groovy/statemap.jar checkstring 00011a1b10c0
      -> unacceptable
