


                         Scala Example 1


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

    $ scala -classpath ../../../lib/Scala/statemap.jar checkstring <string>

Windows:

    $ scala -classpath ../../../lib/Scala/statemap.jar checkstring <string>

Try several different strings, such as:

    $ scala -classpath ../../../lib/Scala/statemap.jar checkstring ""
      -> acceptable
    $ scala -classpath ../../../lib/Scala/statemap.jar checkstring 000
      -> acceptable
    $ scala -classpath ../../../lib/Scala/statemap.jar checkstring 00011
      -> acceptable
    $ scala -classpath ../../../lib/Scala/statemap.jar checkstring 111
      -> acceptable
    $ scala -classpath ../../../lib/Scala/statemap.jar checkstring 000111100
      -> unacceptable
    $ scala -classpath ../../../lib/Scala/statemap.jar checkstring 00011a1b10c0
      -> unacceptable
