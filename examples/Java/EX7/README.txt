


                         Java Example 7


This is a telephone finite state machine.


+ Building
----------

NOTE: Smc.jar must be built and installed.

Unix & Windows:
    $ make telephone


+ Executing
-----------

(Make sure you have sound turned on before running this
 application.)

Do what you normally do with a telephone: pick up the receiver
and start dialing.

Try some of these telephone number:

    + 555-1212
    + 555-9263
    + 1-212-555-1234
    + 879-6877
    + 1-802-521-6448
    + Dial a "#" or a "*"
    + 911

When you have completed the telephone call put down the receiver.

Note: If you don't put down the receiver after the call has
      completed, a "receiver left off hook" alarm will sound.

Unix:

    $ java -classpath ${CLASSPATH}:../../../lib/statemap.jar Telephone

Windows:

    $ java -classpath "${CLASSPATH};../../../lib/statemap.jar" Telephone
