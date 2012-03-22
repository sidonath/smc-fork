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
//  TcpServer.java
//
// Description
//  TCP server connection.
//
// RCS ID
// $Id: TcpServer.java,v 1.2 2007/08/05 13:21:09 cwrapp Exp $
//
// CHANGE LOG
// $Log: TcpServer.java,v $
// Revision 1.2  2007/08/05 13:21:09  cwrapp
// Version 5.0.1 check-in. See net/sf/smc/CODE_README.txt for more information.
//
// Revision 1.1  2005/05/28 12:49:21  cwrapp
// Added Ant examples 1 - 7.
//
// Revision 1.0  2004/05/31 13:29:53  charlesr
// Initial revision
//

package smc_ex6;

public final class TcpServer
    extends TcpConnection
{
// Member methods.

    public TcpServer(TcpConnectionListener listener)
    {
        super(listener);
    }

    public int getPort()
    {
        int retval;

        if (_async_socket == null ||
            _async_socket.getDatagramSocket() == null)
        {
            retval = -1;
        }
        else
        {
            retval = _async_socket.getDatagramSocket().getLocalPort();
        }

        return(retval);
    }

    public void open(int port)
    {
        passiveOpen(port);
        return;
    }

// Member data.
}
