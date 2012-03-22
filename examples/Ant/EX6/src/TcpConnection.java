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
//  TcpConnection.java
//
// Description
//  Both TCP client and server sockets are TCP connections.
//
// RCS ID
// $Id: TcpConnection.java,v 1.2 2007/08/05 13:21:09 cwrapp Exp $
//
// CHANGE LOG
// $Log: TcpConnection.java,v $
// Revision 1.2  2007/08/05 13:21:09  cwrapp
// Version 5.0.1 check-in. See net/sf/smc/CODE_README.txt for more information.
//
// Revision 1.1  2005/05/28 12:49:21  cwrapp
// Added Ant examples 1 - 7.
//
// Revision 1.0  2004/05/31 13:27:57  charlesr
// Initial revision
//

package smc_ex6;

import java.io.IOException;
import java.lang.reflect.Method;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;

public abstract class TcpConnection
    implements DatagramSocketListener,
               TimerListener
{
// Member methods.

    public final synchronized void close()
    {
        _fsm.Close();
        return;
    }

    public final synchronized void handleReceive(DatagramPacket packet,
                                                 AsyncDatagramSocket dgram_socket)
    {
        TcpSegment segment = new TcpSegment(packet);
        Object[] args = new Object[1];

        // Generate the appropriate transition based on the
        // header flags.
        args[0] = segment;

        // DEBUG
//          System.out.println("Receive event from " +
//                             packet.getAddress() +
//                             ":" +
//                             Integer.toString(packet.getPort()) +
//                             ":\n" +
//                             segment);

        try
        {
            _transition_table[segment.getFlags()].invoke(_fsm, args);
        }
        catch (Exception jex)
        {
            System.err.println(jex);
            jex.printStackTrace();
        }

        return;
    }

    public final void handleError(Exception e,
                                  AsyncDatagramSocket dgram_socket)
    {
        // TODO
        // Generate the appropriate transition.
    }

    public final synchronized void handleTimeout(String name)
    {
        if (name.compareTo("CONN_ACK_TIMER") == 0)
        {
            _fsm.ConnAckTimeout();
        }
        else if (name.compareTo("TRANS_ACK_TIMER") == 0)
        {
            _fsm.TransAckTimeout();
        }
        else if (name.compareTo("CLOSE_ACK_TIMER") == 0)
        {
            _fsm.CloseAckTimeout();
        }
        else if (name.compareTo("CLOSE_TIMER") == 0)
        {
            _fsm.CloseTimeout();
        }
        else if (name.compareTo("SERVER_OPENED") == 0)
        {
            _fsm.Opened();
        }
        else if (name.compareTo("CLIENT_OPENED") == 0)
        {
            _fsm.Opened(_address, _port);
        }
        else if (name.compareTo("OPEN_FAILED") == 0)
        {
            _fsm.OpenFailed(_errorMessage);
            _errorMessage = null;
        }

        return;
    }

    // Server socket constructor.
    protected TcpConnection(TcpConnectionListener listener)
    {
        _listener = listener;
        _fsm = new TcpConnectionContext(this);
        _sequence_number = 0;
        _async_socket = null;
        _address = null;
        _port = -1;
        _server = null;
        _errorMessage = null;

        // Turn on FSM debugging.
        // _fsm.setDebugFlag(true);

        return;
    }

    // "Accepted" socket constructor.
    protected TcpConnection(InetAddress address,
                            int port,
                            DatagramSocket socket,
                            int sequence_number,
                            TcpServer server,
                            TcpConnectionListener listener)
    {
        _async_socket = new AsyncDatagramSocket(socket, this);
        _address = address;
        _port = port;
        _sequence_number = sequence_number;
        _server = server;
        _errorMessage = null;
        _listener = listener;
        _fsm = new TcpConnectionContext(this);

        // Turn on FSM debugging.
        // _fsm.setDebugFlag(true);

        _async_socket.start();

        return;
    }

    protected final synchronized void passiveOpen(int port)
    {
        _fsm.PassiveOpen(port);
        return;
    }

    protected final synchronized void activeOpen(InetAddress address, int port)
    {
        _fsm.ActiveOpen(address, port);
        return;
    }

    protected final synchronized void acceptOpen(TcpSegment segment)
    {
        _fsm.AcceptOpen(segment);
        return;
    }

    protected final void setListener(TcpConnectionListener listener)
        throws IllegalStateException
    {
        if (_listener != null)
        {
            throw(new IllegalStateException("Socket listener already set"));
        }
        else
        {
            _listener = listener;
        }

        return;
    }

    protected synchronized void transmit(byte[] data, int offset, int length)
    {
        _fsm.Transmit(data, offset, length);
        return;
    }

    //-----------------------------------------------------------
    // State Map Actions.
    //
    /* package */ InetAddress getFarAddress()
    {
        return (_address);
    }

    /* package */ int getFarPort()
    {
        return (_port);
    }

    /* package */ int getSequenceNumber()
    {
        return (_sequence_number);
    }

    /* package */ void openServerSocket(int port)
    {
        DatagramSocket socket;

        try
        {
            // Create the asynchronous datagram socket listener and
            // start it running.
            socket = new DatagramSocket(port);
            _async_socket = new AsyncDatagramSocket(socket, this);
            _async_socket.start();

            // Set the sequence number.
            _sequence_number = ISN;

            startTimer("SERVER_OPENED", MIN_TIMEOUT);
            
        }
        catch (Exception jex)
        {
            _errorMessage = jex.getMessage();
            startTimer("OPEN_FAILED", MIN_TIMEOUT);
        }

        return;
    }

    /* package */ void openClientSocket(InetAddress address,
                                        int port)
    {
        DatagramSocket socket;

        try
        {
            socket = new DatagramSocket();

            _address = address;
            _port = port;
            _async_socket =
                    new AsyncDatagramSocket(socket, this);
            _async_socket.start();

            // Set the sequence number.
            _sequence_number = ISN;

            startTimer("CLIENT_OPENED", MIN_TIMEOUT);
        }
        catch (Exception jex)
        {
            // Do not issue a transition now since we are already
            // in a transition. Set a 1 millisecond timer and
            // issue transition when timer expires.
            _errorMessage = jex.toString();
            startTimer("OPEN_FAILED", MIN_TIMEOUT);
        }

        return;
    }

    /* package */ void openSuccess()
    {
        _listener.opened(this);
        return;
    }

    /* package */ void openFailed(String reason)
    {
        _listener.openFailed(reason, this);
        return;
    }

    /* package */ void closeSocket()
    {
        _async_socket.closeDatagramSocket();
        _async_socket = null;
        _address = null;
        _port = -1;
        return;
    }

    /* package */ void halfClosed()
    {
        if (_listener != null)
        {
            _listener.halfClosed(this);
        }

        return;
    }

    /* package */ void closed(String reason)
    {
        if (_listener != null)
        {
            _listener.closed(reason, this);
            _listener = null;
        }

        return;
    }

    /* package */ void clearListener()
    {
        _listener = null;
        return;
    }

    /* package */ void transmitted()
    {
        if (_listener != null)
        {
            _listener.transmitted(this);
        }

        return;
    }

    /* package */ void transmitFailed(String reason)
    {
        if (_listener != null)
        {
            _listener.transmitFailed(reason, this);
        }

        return;
    }

    /* package */ void receive(TcpSegment segment)
    {
        // Send the TCP segment's data to the socket listener.
        if (_listener != null)
        {
            _listener.receive(segment.getData(), this);
        }

        return;
    }

    // Create a client socket to handle a new connection.
    /* package */ void accept(TcpSegment segment)
    {
        TcpClient accept_client;
        DatagramSocket dgram_socket;

        try
        {
            _address = segment.getSourceAddress();
            _port = segment.getSourcePort();

            // Create a new client socket to handle this side of
            // the socket pair.
            dgram_socket = new DatagramSocket();
            accept_client = new TcpClient(_address,
                                          _port,
                                          dgram_socket,
                                          _sequence_number,
                                          (TcpServer) this,
                                          _listener);


            ((TcpConnection) accept_client).acceptOpen(segment);
        }
        catch (Exception jex)
        {
            // If the open fails, send a reset to the peer.
            send(TcpSegment.RST,
                 null,
                 0,
                 0,
                 segment);
        }

        return;
    }

    /* package */ void accepted()
    {
        TcpServer server = _server;
        TcpConnectionListener listener = _listener;

        // Tell the server listener that a new connection has
        // been accepted. Then clear the server listener because
        // this socket is now truly a client socket. Clear the
        // listener member data now because the callback method
        // will be resetting it and the reset will fail if we
        // don't do it.
        _server = null;
        _listener = null;
        listener.accepted((TcpClient) this, server);

        return;
    }

    // Send the SYN/ACK reply to the client's SYN.
    /* package */ void sendAcceptSynAck(TcpSegment segment)
    {
        int client_port;
        byte[] port_bytes = new byte[2];

        // Tell the far-side client with what port it should now
        // communicate.
        client_port =
            _async_socket.getDatagramSocket().getLocalPort();

        port_bytes[0] = (byte) ((client_port & 0x0000ff00) >> 8);
        port_bytes[1] = (byte)  (client_port & 0x000000ff);
        send(TcpSegment.SYN_ACK,
             port_bytes,
             0,
             2,
             null,
             -1,
             segment);

        return;
    }

    /* package */ void send(int flags,
                            byte[] data,
                            int offset,
                            int size,
                            TcpSegment recv_segment)
    {
        send(flags,
             data,
             offset,
             size,
             recv_segment.getSourceAddress(),
             recv_segment.getSourcePort(),
             recv_segment);
        return;
    }

    /* package */ void send(int flags,
                            byte[] data,
                            int offset,
                            int size,
                            InetAddress address,
                            int port,
                            TcpSegment recv_segment)
    {
        int local_port;
        int ack_number;
        TcpSegment send_segment;
        DatagramSocket socket;

        // Quietly quit if there is not socket.
        if (_async_socket == null ||
            (socket = _async_socket.getDatagramSocket()) == null)
        {
            return;
        }

        // If the address and port were not specified, then send
        // this segment to whatever client socket we are
        // currently speaking.
        if (address == null)
        {
            address = _address;
            port = _port;
        }

        // If there is a recv_segment, then use its destination
        // port as the local port. Otherwise, use the local
        // datagram socket's local port.
        if (recv_segment != null)
        {
            local_port = recv_segment.getDestinationPort();
        }
        else
        {
            local_port =
                _async_socket.getDatagramSocket().getLocalPort();
        }

        // Send the ack number only if the ack flag is set.
        if ((flags & TcpSegment.ACK) == 0)
        {
            ack_number = 0;
        }
        else
        {
            // Figure out the ack number based on the received
            // segment's sequence number and data size.
            ack_number = getAck(recv_segment);
        }

        send_segment =
            new TcpSegment(local_port,
                           address,
                           port,
                           _sequence_number,
                           ack_number,
                           flags,
                           data,
                           offset,
                           size);

        // Advance the sequence number depending on the message
        // sent. Don't do this if message came from an
        // interloper.
        if (address.equals(_address) && port == _port)
        {
            _sequence_number = getAck(send_segment);
        }

        // Now send the data.
        try
        {
            DatagramPacket packet;

            packet = send_segment.packetize();

            // DEBUG
//                System.out.println("Sending packet to " +
//                                   packet.getAddress() +
//                                   ":" +
//                                   Integer.toString(packet.getPort()) +
//                                   ":\n" +
//                                   send_segment);

            _async_socket.getDatagramSocket().send(packet);
            // _fsm.Transmitted();
        }
        catch (IOException io_exception)
        {
            // _fsm.TransmitFailed(io_exception.getMessage());
        }

        return;
    }

    /* package */ void startTimer(String name, long time)
    {
        AsyncTimer.startTimer(name, time, this);
        return;
    }

    /* package */ void stopTimer(String name)
    {
        AsyncTimer.stopTimer(name);
        return;
    }

    /* package */ void setDestinationPort(TcpSegment segment)
    {
        byte[] data;

        // The server socket is telling us the accepted client's
        // port number. Reset the destination port to that.
        data = segment.getData();
        _port = ((((int) data[0]) & 0x000000ff) << 8) |
                 (((int) data[1]) & 0x000000ff);

        // Modify the segment's source port so that the ack will
        // go to the correct destination.
        segment.setSourcePort(_port);

        return;
    }

    private int getAck(TcpSegment segment)
    {
        int retval;

        // The ack # depends on the segment's flags.
        switch (segment.getFlags())
        {
            case TcpSegment.FIN:
            case TcpSegment.SYN:
            case TcpSegment.FIN_ACK:
            case TcpSegment.SYN_ACK:
                retval = segment.getSequenceNumber() + 1;
                break;

            case TcpSegment.PSH:
            case TcpSegment.PSH_ACK:
                retval = segment.getSequenceNumber() +
                         segment.getDataSize();
                break;

            case TcpSegment.ACK:
            default:
                retval = segment.getSequenceNumber();
                break;
        }

        return(retval);
    }

// Member data.

    protected TcpConnectionListener _listener;
    private TcpConnectionContext  _fsm;
    protected AsyncDatagramSocket   _async_socket;
    private int                   _sequence_number;

    // The port to which a client socket is connected.
    protected InetAddress _address;
    protected int         _port;

    // The server which accepted this connection.
    protected TcpServer _server;

    private String _errorMessage;

    // The Initial Sequence Number.
    private static final int ISN = 1415531521;

    // Wait only so long for an ACK (in milliseconds).
    /* package */ static final long ACK_TIMEOUT = 2000;

    // Wait a while before reusing this port (in milliseconds).
    /* package */ static final long CLOSE_TIMEOUT = 10000;

    /* package */ static final long MIN_TIMEOUT = 1;

    // Use this table to translate received segment flags into
    // state map transitions.
    private static Method[] _transition_table;

    static
    {
        try
        {
            Class context = TcpConnectionContext.class;
            Class[] parameters = new Class[1];
            Method undefined;
            int i;

            // All "TCP flag" transitions take a DatagramPacket as
            // a parameter.
            parameters[0] = TcpSegment.class;

            _transition_table = new Method[TcpSegment.FLAG_MASK + 1];

            // First, set all transitions to undefined.
            undefined = context.getDeclaredMethod("UNDEF",
                                                  parameters);
            for (i = 0; i < _transition_table.length; ++i)
            {
                _transition_table[i] = undefined;                    
            }

            // Now go back and set the known transitions.
            _transition_table[TcpSegment.FIN] =
                context.getDeclaredMethod("FIN", parameters);
            _transition_table[TcpSegment.SYN] =
                context.getDeclaredMethod("SYN", parameters);
            _transition_table[TcpSegment.RST] =
                context.getDeclaredMethod("RST", parameters);
            _transition_table[TcpSegment.PSH] =
                context.getDeclaredMethod("PSH", parameters);
            _transition_table[TcpSegment.ACK] =
                context.getDeclaredMethod("ACK", parameters);
            _transition_table[TcpSegment.URG] =
                context.getDeclaredMethod("URG", parameters);
            _transition_table[TcpSegment.FIN_ACK] =
                context.getDeclaredMethod("FIN_ACK", parameters);
            _transition_table[TcpSegment.SYN_ACK] =
                context.getDeclaredMethod("SYN_ACK", parameters);
            _transition_table[TcpSegment.PSH_ACK] =
                context.getDeclaredMethod("PSH_ACK", parameters);
        }
        catch (Exception jex) {}
    }
}
