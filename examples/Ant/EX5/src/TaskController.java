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
//  TaskController.java
//
// Description
//  A singleton responsible for routing messages between objects.
//
// RCS ID
// $Id: TaskController.java,v 1.2 2007/08/05 13:14:57 cwrapp Exp $
//
// CHANGE LOG
// $Log: TaskController.java,v $
// Revision 1.2  2007/08/05 13:14:57  cwrapp
// Version 5.0.1 check-in. See net/sf/smc/CODE_README.txt for more information.
//
// Revision 1.1  2005/05/28 12:49:21  cwrapp
// Added Ant examples 1 - 7.
//
// Revision 1.0  2004/05/31 13:18:55  charlesr
// Initial revision
//

package smc_ex5;

import javax.swing.Timer;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.ListIterator;
import java.util.Map;

public final class TaskController
{
// Member Methods.

    public TaskController()
    {}

    public void register(String name, Object obj)
    {
        // Has an object already registered under this name?
        if (_objectMap.containsKey(name) == false)
        {
            _objectMap.put(name, obj);
        }

        return;
    }

    public void deregister(String name)
    {
        ListIterator messIt;
        Message message;

        _objectMap.remove(name);

        // Remove all messages queued for this object.
        for (messIt = _messageQueue.listIterator(0);
             messIt.hasNext() == true;
             )
        {
            message = (Message) messIt.next();
            if (message._recepient.compareTo(name) == 0)
            {
                messIt.remove();
            }
        }

        return;
    }

    public void postMessage(String recepient,
                            String event)
    {
        Map args = new HashMap();

        postMessage(recepient, event, args);

        return;
    }

    public void postMessage(String recepient,
                            String event,
                            Map args)
    {
        // Is there a known recepient?
        if (_objectMap.containsKey(recepient) == true)
        {
            // Yes, enqueue the message for later delivery.
            Message message =
                    new Message(recepient, event, args);
            _messageQueue.add(message);

            // Asynchronously send the message.
            if (_sendTimer == null)
            {
                _sendTimer =
                        new Timer(1,
                                  new SendTimerListener(this));
                _sendTimer.start();
            }
            else if (_sendTimer.isRunning() == false)
            {
                _sendTimer.restart();
            }
        }

        return;
    }

    private void sendMessage()
    {
        boolean notSent = true;
        Message message;
        TaskEventListener listener;

        // Send a message only if there is a message to send.
        while (notSent == true && _messageQueue.size() > 0)
        {
            message = (Message) _messageQueue.remove(0);
            listener =
                    (TaskEventListener) _objectMap.get(message._recepient);
            if (listener != null)
            {
                notSent = false;
                listener.handleEvent(message._event,
                                     message._args);
            }
        }

        // If there are no more messages, stop the timer.
        if (_messageQueue.size() == 0)
        {
            _sendTimer.stop();
        }

        return;
    }

// Member Data.

    // Each object has a unique name. Map each name to an object.
    private static Map _objectMap;

    // Messages yet to be sent.
    private static LinkedList _messageQueue;

    // When this timer expires, it is time to send another
    // message.
    private static Timer _sendTimer;

    static
    {
        _objectMap = new HashMap();
        _messageQueue = new LinkedList();
        _sendTimer = null;
    }

// Inner Classes.

    private final class Message
    {
        private Message(String recepient,
                        String event,
                        Map args)
        {
            super();

            _recepient = recepient;
            _event = event;
            _args = args;
        }

        private String _recepient;
        private String _event;
        private Map _args;
    }

    private final class SendTimerListener
        implements ActionListener
    {
        private SendTimerListener(TaskController owner)
        {
            super();

            _owner = owner;
        }

        public void actionPerformed(ActionEvent e)
        {
            _owner.sendMessage();
        }

        TaskController _owner;
    }
}
