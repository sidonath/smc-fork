


                          C++ Example 6


An incomplete implementation of the TCP state machine. This
implementation is based on UDP sockets and does the TCP connect
and disconnect processing. This demo does *not* implement
TCP's sophisticated transmission capability.



+ Building
----------

NOTE: Smc.jar must be built and installed.

Unix:
    $ make all

Windows Visual C++:
    1. Load ex6.dsw.
    2. Make the server project active.
    3. Rebuild all.
    4. Make the client project active.
    5. Rebuild all.



+ Executing
-----------

There are two separate applications: server and client. The
server application accepts connections on a specified port. The
client application connections to the server application and
transmits messages at random times. The accepted client
connection also sends messages.

Unix:

    1. Open a new shell window.
    2. $ cd .../src/examples/C++/EX6
    3. $ server <port #>
    4. Open a new shell window.
    5. $ cd .../src/examples/C++/EX6
    6. $ client <hostname> <port #>
       where <hostname> is the computer on which the server is
       running.

Windows:

    1. Open a new DOS command window.
    2. C:\> cd ...\src\examples\C++\EX6\Debug\server
    3. C:\...\src\examples\C++\EX6> server <port #>
    4. Open a new DOS command window.
    5. C:\> cd ...\src\examples\C++\EX6\Debug\client
    6. C:\...\src\examples\C++\EX6> client <hostname> <port #>
       where <hostname> is the computer on which the server is
       running.

For both Unix and Windows, you can stop both the server and
client programs by hitting <Cntl-c>. Note: On Windows, the
server and client programs will not receive the interrupt until
select() returns.

Have some fun! Mix and match server and clients running on
different computers of different platform types, even different
programming languages. The server and client executables built
here should run against ../../Java/EX6 server and client classes.
