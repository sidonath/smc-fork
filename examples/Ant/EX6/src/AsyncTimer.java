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
//  AsyncTimer.java
//
// Description
//  Non-swing based timing. Not needed for Java 1.3.
//
// RCS ID
// $Id: AsyncTimer.java,v 1.2 2007/08/05 13:21:09 cwrapp Exp $
//
// CHANGE LOG
// $Log: AsyncTimer.java,v $
// Revision 1.2  2007/08/05 13:21:09  cwrapp
// Version 5.0.1 check-in. See net/sf/smc/CODE_README.txt for more information.
//
// Revision 1.1  2005/05/28 12:49:21  cwrapp
// Added Ant examples 1 - 7.
//
// Revision 1.0  2004/05/31 13:26:07  charlesr
// Initial revision
//

package smc_ex6;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public final class AsyncTimer
{
    // This is a singleton object.
    public AsyncTimer()
    {}

    // Create a new timer. Let the caller know when it expires.
    public static boolean startTimer(String name,
                                     long millisecs,
                                     TimerListener listener)
    {
        boolean Retcode;

        // Fail if there already exists a timer by this name.
        if (_timerMap.containsKey(name) == true)
        {
            Retcode = false;
        }
        else
        {
            // Create a new thread and pass in the necessary info.
            TimerThread NewTimer = new TimerThread(name, millisecs, listener);
            _timerMap.put(name, NewTimer);

            // Start the timer.
            NewTimer.start();

            Retcode = true;
        }

        return(Retcode);
    }

    // Reset a timer, reusing its current duration.
    public static boolean resetTimer(String name)
    {
        boolean Retcode;
        TimerThread Timer;

        // If there is no such timer, fail this request.
        if ((Timer = (TimerThread) _timerMap.get(name)) == null)
        {
            Retcode = false;
        }
        else
        {
            Retcode = true;

            Timer.resetTimer();
            Timer.interrupt();
        }

        return(Retcode);
    }

    // Reset a timer to the new timeout.
    public static boolean resetTimer(String name, long millisecs)
    {
        boolean Retcode;
        TimerThread Timer;

        // If there is no such timer, fail this request.
        if ((Timer = (TimerThread) _timerMap.get(name)) == null)
        {
            Retcode = false;
        }
        else
        {
            Retcode = true;

            Timer.resetTimer(millisecs);
            Timer.interrupt();
        }

        return(Retcode);
    }

    // Stop a running timer.
    public static boolean stopTimer(String name)
    {
        TimerThread Timer;

        // First, tell the timer to stop. Then remove
        // the timer from the map.
        if ((Timer = (TimerThread) _timerMap.get(name)) != null)
        {
            Timer.stopTimer();
            _timerMap.remove(name);
            Timer.interrupt();
        }

        // This method always succeeds because even if the timer
        // doesn't exist, it was successfully "stopped".
        return(true);
    }

    // Stop all running timers.
    public static void stopAllTimers()
    {
        Iterator i = _timerMap.keySet().iterator();

        while (i.hasNext())
        {
            TimerThread Timer = (TimerThread) i.next();
            Timer.stopTimer();
            Timer.interrupt();
        }

        // Remove all the timer threads from the map.
        _timerMap.clear();

        return;
    }

    private static synchronized void timerDone(String name)
    {
        // Remove the timer from the list and delete it.
        _timerMap.remove(name);
        return;
    }

    // Keep track of all the currently running timers.
    private static Map _timerMap;

    static {
        _timerMap = new HashMap();
    }

    // The timer thread class.
    private static final class TimerThread extends Thread
    {
        public TimerThread(String name,
                           long millisecs,
                           TimerListener listener)
        {
            _name = name;
            _duration = millisecs;
            _listener = listener;
            _wasStopped = false;
            _wasReset = false;
            _isDone = false;
        }

        public String getTimerName()
        {
            return(_name);
        }

        public long getTimerDuration()
        {
            return(_duration);
        }

        public String toString()
        {
            return(_name);
        }

        public void run()
        {
            // Keep doing this until the timer has either
            // successfully completed a sleep or it is
            // stopped.
            while (_isDone == false && _wasStopped == false)
            {
                // Go to sleep. When the timer has expired, first
                // tell the listener and then the alarm clock.
                try
                {
                    sleep(_duration);

                    // Only issue this timeout if the timer
                    // was not stopped.
                    if (_wasStopped == false && _wasReset == false)
                    {
                        // The timer has successfully done
                        // its task.
                        _isDone = true;

                        // Tell the alarm clock to delete this
                        // timer. Do this before issuing the
                        // callback in case the callback tries
                        // to create this timer again.
                        AsyncTimer.timerDone(_name);

                        // Issue the callback to the interested
                        // party.
                        _listener.handleTimeout(_name);
                    }
                }
                catch (InterruptedException e)
                {
                    // If this timer has been reset, then
                    // reset the flag to false and go to sleep
                    // again.
                    _wasReset = false;
                }
            }

            return;
        }

        private void resetTimer()
        {
            _wasReset = true;
            return;
        }

        private void resetTimer(long millisecs)
        {
            _wasReset = true;
            _duration = millisecs;
            return;
        }

        private void stopTimer()
        {
            _wasStopped = true;
            return;
        }

        // Each timer has a name, a duration and a listener
        // who is informed when the timer has expired.
        private String _name;
        private long _duration;
        private TimerListener _listener;

        // When the AsyncTimer stops this timer, this
        // boolean is set to true.
        private boolean _wasStopped;

        // When this timer is reset, this boolean is
        // set to true.
        private boolean _wasReset;

        // When the timer has successfully done its
        // task, this boolean is set to true.
        private boolean _isDone;
    }
}
