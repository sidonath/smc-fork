


                         Java Example 6


The TCP/IP protocol state diagram based on UDP. It follows the
TCP/IP connect and disconnect protocol but not the sophisticated
transmission scheme.


+ Building
----------

NOTE: Smc.jar must be built and installed.

Unix & Windows:
    $ make tcpdemo


+ Executing
-----------

There are two separate applications: server and client. The
server application accepts connections on a specified port. The
client application connections to the server application and
transmits messages at random times. The accepted client
connection also sends messages.

Unix & Windows:

    $ java -jar server.jar <port>
    where <port> is a valid *UDP* port number.

    Hit return to terminate the application. This will close all
    client connections and all clients will terminate.

    $ java -jar client.ajr [-h <host>] -p <port>
    where <host> is the host machine running the server
                 application (may be omitted if client is running
                 on the same machine).
          <port> is the same port number used in starting the
                 server application.

    Hit return to terminate the application. This will close this
    client's connection to the server. The server will *not*
    terminate.
