//
// The contents of this file are subject to the Mozilla Public
// License Version 1.1 (the "License"); you may not use this file
// except in compliance with the License. You may obtain a copy
// of the License at http://www.mozilla.org/MPL/
// 
// Software distributed under the License is distributed on an
// "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
// implied. See the License for the specific language governing
// rights and limitations under the License.
// 
// The Original Code is State Machine Compiler (SMC).
// 
// The Initial Developer of the Original Code is Charles W. Rapp.
// Portions created by Charles W. Rapp are
// Copyright (C) 2000 - 2003 Charles W. Rapp.
// All Rights Reserved.
// 
// Contributor(s): 
//
// Name
//  client.java
//
// Description
//  Encapsulates "TCP" client connection.
//
// RCS ID
// $Id: client.java,v 1.2 2007/08/05 13:21:09 cwrapp Exp $
//
// CHANGE LOG
// $Log: client.java,v $
// Revision 1.2  2007/08/05 13:21:09  cwrapp
// Version 5.0.1 check-in. See net/sf/smc/CODE_README.txt for more information.
//
// Revision 1.1  2005/05/28 12:49:21  cwrapp
// Added Ant examples 1 - 7.
//
// Revision 1.0  2004/05/31 13:31:03  charlesr
// Initial revision
//

package smc_ex6;

import java.io.IOException;
import java.net.InetAddress;
import java.util.Random;

public final class client
    extends Thread
    implements TcpConnectionListener
{
    public static void main(String[] args)
    {
        int port = -1;
        String host = null;

        if (args.length != 2)
        {
            System.err.println("client: Incorrect number of arguments.");
            System.err.println("usage: client host port");
            System.exit(1);
        }
        else
        {
            host = args[0];
            try
            {
                port = Integer.parseInt(args[1]);
            }
            catch (NumberFormatException ex)
            {
                System.err.println("Invalid port number - \"" +
                                   args[1] +
                                   "\".");
                System.exit(2);
            }

            // Now try to connect to the server and start sending
            // data.
            try
            {
                InetAddress address;
                client client;

                address = InetAddress.getByName(host);
                client = new client();

                // Create client and start running.
                System.out.println("(Starting execution. Hit Enter to stop.)");
                client.run(address, port);
                System.out.println("(Stopping execution.)");

                System.exit(0);
            }
            catch (Exception ex)
            {
                ex.printStackTrace();
                System.exit(5);
            }
        }
    }

    public client()
    {
        _client_socket = null;
        _my_thread = null;
        _opened = false;
        _isRunning = false;
        _randomizer = new Random(System.currentTimeMillis());
        _owner = null;
        _errorMessage = null;

        return;
    }

    public client(TcpClient client_socket, server owner)
    {
        _client_socket = client_socket;
        _my_thread = null;
        _opened = false;
        _isRunning = false;
        _randomizer = new Random(System.currentTimeMillis());
        _owner = owner;
        _errorMessage = null;

        _client_socket.setListener(this);

        return;
    }

    public void run(InetAddress address, int port)
    {
        String port_string = Integer.toString(port);

        _my_thread = Thread.currentThread();

        // If there is no client connection, create one and open
        // it.
        _client_socket = new TcpClient(this);

        // Open the client connection.
        System.out.print("Opening connection to " +
                         address.getHostName() +
                         ":" +
                         port_string +
                         " ... ");
        _opened = false;
        _client_socket.open(address, port);

        // Wait for open to complete.
        try
        {
            _isRunning = true;
            while (_isRunning == true)
            {
                Thread.sleep(1000);
            }
        }
        catch (InterruptedException interrupt) {}

        if (_opened == false)
        {
            System.out.print("open failed");
            if (_errorMessage == null)
            {
                System.out.println(".");
            }
            else
            {
                System.out.println(" - " + _errorMessage);
                _errorMessage = null;
            }
        }
        else
        {
            System.out.println("open successful.");
            run();
        }

        return;
    }

    public void run()
    {
        long sleeptime;
        InetAddress address = _client_socket.getAddress();
        int port = _client_socket.getPort();
        String port_string = Integer.toString(port);
        StopThread thread = new StopThread(this);
        int message_count = 1;
        String message_base = "This is message #";
        String message;
        byte[] data;

        // Remember this thread for later.
        if (_my_thread == null)
        {
            _my_thread = Thread.currentThread();
        }

        // Create a thread to watch for a keystroke.
        thread.start();

        // Now sit here waiting to send and receive.
        _isRunning = true;
        while (_isRunning == true)
        {
            try
            {
                // Decide how long before the next alarm is issued.
                // Sleep time is in milliseconds but no less than 100.
                sleeptime = (_randomizer.nextLong() % MAX_SLEEP_TIME);
                if (sleeptime < MIN_SLEEP_TIME)
                {
                    sleeptime = MIN_SLEEP_TIME;
                }

                Thread.sleep(sleeptime);

                // Now send a message.
                message = message_base +
                        Integer.toString(message_count++) +
                        ".";
                data = message.getBytes();
                System.out.print("Transmitting to " +
                                 address.getHostName() +
                                 ":" +
                                 port_string +
                                 ": \"" +
                                 message +
                                 "\" ... ");
                _client_socket.transmit(data, 0, data.length);
            }
            catch (InterruptedException interrupt) {}
            catch (Exception jex)
            {
                jex.printStackTrace();
                _isRunning = false;
            }
        }

        // Now that we are no longer running, close the
        // connection.
        System.out.print("Closing connection to " +
                         address.getHostName() +
                         ":" +
                         port_string +
                         " ... ");
        _client_socket.close();
        System.out.println("closed.");

        if (_owner != null)
        {
            _owner.clientClosed(this);
        }

        return;
    }

    // Stop the app.
    public synchronized void halt()
    {
        _isRunning = false;

        // Wake me up in case I am sleeping.
        _my_thread.interrupt();

        return;
    }

    public void opened(TcpConnection client)
    {
        _opened = true;
        _my_thread.interrupt();
        return;
    }

    public void openFailed(String reason, TcpConnection client)
    {
        _opened = false;
        _errorMessage = reason;
        _my_thread.interrupt();
        return;
    }

    public void halfClosed(TcpConnection client)
    {
        InetAddress address = _client_socket.getAddress();
        String port_string = Integer.toString(_client_socket.getPort());

        System.out.print("Connection from " +
                         address.getHostName() +
                         ":" +
                         port_string +
                         " has closed its side. ");

        // The far end has closed its connection. Stop running
        // since it is no longer listening.
        _isRunning = false;
        _my_thread.interrupt();

        return;
    }

    public void closed(String reason, TcpConnection client)
    {
        _opened = false;
        _isRunning = false;
        _my_thread.interrupt();
        return;
    }

    public void transmitted(TcpConnection client)
    {
        System.out.println("transmit successful.");
        return;
    }

    public void transmitFailed(String reason, TcpConnection client)
    {
        System.out.println("transmit failed - " +
                           reason +
                           ".");
        return;
    }

    public void receive(byte[] data, TcpConnection client)
    {
        String message = new String(data);

        System.out.println("Received data from " +
                           ((TcpClient) client).getAddress() +
                           ":" +
                           Integer.toString(((TcpClient) client).getPort()) +
                           ": \"" +
                           message +
                           "\"");
        return;
    }

    public void accepted(TcpClient client, TcpServer server) {}

// Member data

    private TcpClient _client_socket;
    private boolean _isRunning;
    private boolean _opened;
    private Thread _my_thread;
    private server _owner;
    private String _errorMessage;

    // Use the following to randomly decide when to issue an
    // alarm and what type, etc.
    private Random _randomizer;

    // Constants.
    private static final long MIN_SLEEP_TIME = 100;
    private static final long MAX_SLEEP_TIME = 30000; // 30 seconds..
    private static final int          OPTION = 0;
    private static final int            PORT = 1;
    private static final int            HOST = 2;

// Inner classes.

    private final class StopThread
        extends Thread
    {
        private StopThread(client client)
        {
            _client = client;
        }

        public void run()
        {
            // As soon as any key is hit, stop.
            try
            {
                System.in.read();
            }
            catch (IOException io_exception)
            {}

            _client.halt();

            return;
        }

        private client _client;
    }
}
