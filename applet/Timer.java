//
// The contents of this file are subject to the Mozilla Public
// License Version 1.1 (the "License"); you may not use this file
// except in compliance with the License. You may obtain a copy of
// the License at http://www.mozilla.org/MPL/
// 
// Software distributed under the License is distributed on an "AS
// IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
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
//  Timer.java
//
// Description
//  Because I am using non-Swing, pre-JDK 1.4 Java, I have to
//  use my own timer class.
//
// RCS ID
// $Id: Timer.java,v 1.3 2005/05/28 19:41:44 cwrapp Exp $
//
// CHANGE LOG
// $Log: Timer.java,v $
// Revision 1.3  2005/05/28 19:41:44  cwrapp
// Update for SMC v. 4.0.0.
//
// Revision 1.0  2003/12/14 19:04:08  charlesr
// Initial revision
//

import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Map;
import java.util.Vector;

public final class Timer
{
// Member methods.

    public static boolean timerExists(String name)
    {
        TimerThread timer;
        boolean retcode;

        if ((timer = (TimerThread) _timerMap.get(name)) == null ||
            timer.getState() == STOPPED)
        {
            retcode = false;
        }
        else
        {
            retcode = true;
        }

        return(retcode);
    }

    public static void createTimer(String name,
                                   int delay,
                                   boolean repeatFlag,
                                   TimerListener listener)
        throws IllegalArgumentException
    {
        if (name == null)
        {
            throw(new IllegalArgumentException("name is null"));
        }
        else if (name.length() == 0)
        {
            throw(new IllegalArgumentException("name is empty"));
        }
        else if (delay <= 0)
        {
            throw(new IllegalArgumentException("delay is invalid (" +
                                               Integer.toString(delay) +
                                               ")"));
        }
        else if (listener == null)
        {
            throw(new IllegalArgumentException("listener is null"));
        }
        else if (_timerMap.containsKey(name) == true)
        {
            throw(new IllegalArgumentException("name \"" +
                                               name +
                                               "\" is not unique"));
        }
        else
        {
            // Create timer and start it running.
            TimerThread timer = new TimerThread(name,
                                                delay,
                                                repeatFlag,
                                                listener);

            _timerMap.put(name, timer);
        }

        return;
    }

    public static void addTimerListener(String name,
                                        TimerListener listener)
        throws IllegalArgumentException
    {
        TimerThread timer = null;

        if (name == null)
        {
            throw(new IllegalArgumentException("name is null"));
        }
        else if (listener == null)
        {
            throw(new IllegalArgumentException("listener is null"));
        }
        else if (name.length() == 0)
        {
            throw(new IllegalArgumentException("name is empty"));
        }
        else if ((timer = (TimerThread) _timerMap.get(name)) == null)
        {
            throw(new IllegalArgumentException("timer \"" +
                                               name +
                                               "\" does not exist"));
        }
        else
        {
            timer.addListener(listener);
        }

        return;
    }

    static void removeTimerListener(String name,
                                    TimerListener listener)
        throws IllegalArgumentException
    {
        TimerThread timer = null;

        if (name == null)
        {
            throw(new IllegalArgumentException("name is null"));
        }
        else if (listener == null)
        {
            throw(new IllegalArgumentException("listener is null"));
        }
        else if (name.length() == 0)
        {
            throw(new IllegalArgumentException("name is empty"));
        }
        else if ((timer = (TimerThread) _timerMap.get(name)) == null)
        {
            throw(new IllegalArgumentException("timer \"" +
                                               name +
                                               "\" does not exist"));
        }
        else
        {
            timer.removeListener(listener);
        }

        return;
    }

    public static int getDelay(String name)
        throws IllegalArgumentException
    {
        TimerThread timer = null;
        int retval;

        if (name == null)
        {
            throw(new IllegalArgumentException("name is null"));
        }
        else if (name.length() == 0)
        {
            throw(new IllegalArgumentException("name is empty"));
        }
        else if ((timer = (TimerThread) _timerMap.get(name)) == null)
        {
            throw(new IllegalArgumentException("timer \"" +
                                               name +
                                               "\" does not exist"));
        }
        else
        {
            retval = timer.getDelay();
        }

        return(retval);
    }

    public static void setDelay(String name, int delay)
        throws IllegalArgumentException,
               IllegalStateException
    {
        TimerThread timer = null;
        int timerState;

        if (name == null)
        {
            throw(new IllegalArgumentException("name is null"));
        }
        else if (delay <= 0)
        {
            throw(new IllegalArgumentException("\"" +
                                               Integer.toString(delay) +
                                               "\" is an invalid delay"));
        }
        else if (name.length() == 0)
        {
            throw(new IllegalArgumentException("name is empty"));
        }
        else if ((timer =(TimerThread) _timerMap.get(name)) == null)
        {
            throw(new IllegalArgumentException("timer \"" +
                                               name +
                                               "\" does not exist"));
        }
        else if ((timerState = timer.getState()) != IDLE &&
                  timerState != PAUSED)
        {
            throw(new IllegalStateException("timer \"" +
                                            name +
                                            "\" not idle or paused"));
        }
        else
        {
            timer.setDelay(delay);
        }

        return;
    }

    public static boolean isRepeats(String name)
        throws IllegalArgumentException
    {
        TimerThread timer = null;
        boolean retval;

        if (name == null)
        {
            throw(new IllegalArgumentException("name is null"));
        }
        else if (name.length() == 0)
        {
            throw(new IllegalArgumentException("name is empty"));
        }
        else if ((timer = (TimerThread) _timerMap.get(name)) == null)
        {
            throw(new IllegalArgumentException("timer \"" +
                                               name +
                                               "\" does not exist"));
        }
        else
        {
            retval = timer.isRepeats();
        }

        return(retval);
    }

    public static void setRepeats(String name,
                                  boolean flag)
        throws IllegalArgumentException,
               IllegalStateException
    {
        TimerThread timer = null;
        int timerState;

        if (name == null)
        {
            throw(new IllegalArgumentException("name is null"));
        }
        else if (name.length() == 0)
        {
            throw(new IllegalArgumentException("name is empty"));
        }
        else if ((timer = (TimerThread) _timerMap.get(name)) == null)
        {
            throw(new IllegalArgumentException("timer \"" +
                                               name +
                                               "\" does not exist"));
        }
        else if ((timerState = timer.getState()) != IDLE &&
                  timerState != PAUSED)
        {
            throw(new IllegalStateException("timer \"" +
                                            name +
                                            "\" not idle or paused"));
        }
        else
        {
            timer.setRepeats(flag);
        }

        return;
    }

    public static int getState(String name)
        throws IllegalArgumentException
    {
        TimerThread timer = null;
        int retval;

        if (name == null)
        {
            throw(new IllegalArgumentException("name is null"));
        }
        else if (name.length() == 0)
        {
            throw(new IllegalArgumentException("name is empty"));
        }
        else if ((timer = (TimerThread) _timerMap.get(name)) == null)
        {
            throw(new IllegalArgumentException("timer \"" +
                                               name +
                                               "\" does not exist"));
        }
        else
        {
            retval = timer.getState();
        }

        return(retval);
    }

    public static void startTimer(String name)
        throws IllegalArgumentException,
               IllegalStateException
    {
        TimerThread timer = null;

        if (name == null)
        {
            throw(new IllegalArgumentException("name is null"));
        }
        else if (name.length() == 0)
        {
            throw(new IllegalArgumentException("name is empty"));
        }
        else if ((timer = (TimerThread) _timerMap.get(name)) == null)
        {
            throw(new IllegalArgumentException("timer \"" +
                                               name +
                                               "\" does not exist"));
        }
        else if (timer.getState() != IDLE)
        {
            throw(new IllegalStateException("timer \"" +
                                            name +
                                            "\" is not idle"));
        }
        else
        {
            // Start the timer running.
            timer.start();
        }

        return;
    }

    public static void pauseTimer(String name)
        throws IllegalArgumentException,
               IllegalStateException
    {
        TimerThread timer = null;
        int timerState;

        if (name == null)
        {
            throw(new IllegalArgumentException("name is null"));
        }
        else if (name.length() == 0)
        {
            throw(new IllegalArgumentException("name is empty"));
        }
        else if ((timer = (TimerThread) _timerMap.get(name)) == null)
        {
            throw(new IllegalArgumentException("timer \"" +
                                               name +
                                               "\" does not exist"));
        }
        else if ((timerState = timer.getState()) != RUNNING &&
                 timerState != PAUSED)
        {
            throw(new IllegalStateException("timer \"" +
                                            name +
                                            "\" is not running"));
        }
        else if (timerState != PAUSED)
        {
            timer.pause();
        }
        // Else the timer is already paused - nothing need
        // be done.

        return;
    }

    public static void continueTimer(String name)
        throws IllegalArgumentException,
               IllegalStateException
    {
        TimerThread timer = null;
        int timerState;

        if (name == null)
        {
            throw(new IllegalArgumentException("name is null"));
        }
        else if (name.length() == 0)
        {
            throw(new IllegalArgumentException("name is empty"));
        }
        else if ((timer = (TimerThread) _timerMap.get(name)) == null)
        {
            throw(new IllegalArgumentException("timer \"" +
                                               name +
                                               "\" does not exist"));
        }
        else if ((timerState = timer.getState()) == IDLE ||
                 timerState == STOPPED)
        {
            throw(new IllegalStateException("timer \"" +
                                            name +
                                            "\" is not paused"));
        }
        else if (timerState != RUNNING)
        {
            // continue is a Java keyword, so call the method
            // "unpause".
            timer.unpause();
        }
        // Else if timer is running, do nothing. That's what the
        // user wants.

        return;
    }

    public static void restartTimer(String name)
        throws IllegalArgumentException,
               IllegalStateException
    {
        TimerThread timer = null;
        int timerState;

        if (name == null)
        {
            throw(new IllegalArgumentException("name is null"));
        }
        else if (name.length() == 0)
        {
            throw(new IllegalArgumentException("name is empty"));
        }
        else if ((timer = (TimerThread) _timerMap.get(name)) == null)
        {
            throw(new IllegalArgumentException("timer \"" +
                                               name +
                                               "\" does not exist"));
        }
        else if ((timerState = timer.getState()) == IDLE ||
                 timerState == STOPPED)
        {
            throw(new IllegalStateException("timer \"" +
                                            name +
                                            "\" is stopped"));
        }
        else
        {
            timer.restart();
        }

        return;
    }

    public static void stopTimer(String name)
        throws IllegalArgumentException
    {
        TimerThread timer = null;

        if (name == null)
        {
            throw(new IllegalArgumentException("name is null"));
        }
        else if (name.length() == 0)
        {
            throw(new IllegalArgumentException("name is empty"));
        }
        else if ((timer = (TimerThread) _timerMap.get(name)) != null)
        {
            if (timer.getState() == IDLE)
            {
                // Nothing to stop. Simply delete the timer.
                deleteTimer(name);
            }
            else
            {
                timer.stopRun();
                deleteTimer(name);
            }
        }
        // Else, if the timer doesn't exist, do nothing.

        return;
    }

    public static void stopAllTimers()
    {
        Enumeration i;
        TimerThread timer;

        for (i = _timerMap.elements();
             i.hasMoreElements() == true;)
        {
            timer = (TimerThread) i.nextElement();
            timer.stopRun();
            deleteTimer(timer._name);
        }

        _timerMap.clear();

        return;
    }

    private static void deleteTimer(String name)
    {
        _timerMap.remove(name);
        return;
    }

    /**
     * Make the default constructor private so it cannot be
     * accessed.
     */
    private Timer() {}

// Member data.

    private static Hashtable _timerMap;

    /**
     * Timer state
     * <code>IDLE</code>: Timer is created but never been
     * started.
     */
    public static final int IDLE    = 0;

    /**
     * Timer state
     * <code>RUNNING</code>: Timer is running.
     */
    public static final int RUNNING = 1;

    /**
     * Timer state
     * <code>PAUSED</code>: A running timer has been
     * paused. Time spent paused is not counted against
     * the delay.
     */
    public static final int PAUSED  = 2;

    /**
     * Timer state
     * <code>STOPPED</code>: Timer is no longer running and
     * will be deleted. Cannot be used for further timing.
     */
    public static final int STOPPED = 3;

    static
    {
        _timerMap = new Hashtable();
    }

// Inner classes.

    private static final class TimerThread
        extends Thread
    {
    // Member methods.

        private TimerThread(String name,
                            int delay,
                            boolean repeatFlag,
                            TimerListener listener)
        {
            super();

            // Timer starts in the idle state. Once it leaves
            // this state, it will never return.
            _state = Timer.IDLE;

            _name = name;
            _delay = delay;
            _repeatFlag = repeatFlag;

            _listenerList = new Vector();
            _listenerList.addElement(listener);
        }

        private void addListener(TimerListener listener)
        {
            if (_listenerList.contains(listener) == false)
            {
                _listenerList.addElement(listener);
            }
            return;
        }

        private void removeListener(TimerListener listener)
        {
            int index;

            if ((index = _listenerList.indexOf(listener)) >= 0)
            {
                _listenerList.removeElementAt(index);
            }

            return;
        }

        private int getDelay()
        {
            return(_delay);
        }

        private void setDelay(int delay)
        {
            _delay = delay;
            return;
        }

        private boolean isRepeats()
        {
            return(_repeatFlag);
        }

        private void setRepeats(boolean repeatFlag)
        {
            _repeatFlag = repeatFlag;
            return;
        }

        private int getState()
        {
            return(_state);
        }

        private void pause()
        {
            _state = Timer.PAUSED;
            interrupt();

            return;
        }

        private void unpause()
        {
            _state = Timer.RUNNING;

            // Use notify to get the thread's wait() call to
            // return.
            notify();

            return;
        }

        private void restart()
        {
            _restartFlag = true;
            _state = Timer.RUNNING;
            interrupt();

            return;
        }

        private void stopRun()
        {
            _wasStopped = true;
            _state = Timer.STOPPED;

            // DON'T SET _name TO null UNTIL THE VERY
            // END. _name is needed to remove this timer
            // thread from the timer map.

            _listenerList = null;

            // Interrupt self to stop this thread.
            interrupt();

            return;
        }

        public void run()
        {
            long timeStart;
            long timeStop;
            int timeLeft;
            Enumeration i;
            TimerListener listener;
            TimerEvent timerEvent = new TimerEvent(_name);

            _state = Timer.RUNNING;

            // If this timer is explicitly killed via
            // Timer.stop(), then simply return quietly. If
            // the timer dies because a non-repeatable delay
            // expires, then tell Timer to delete this timer.
            _wasStopped = false;

            // This flag is set to true when the timer is
            // restarted.
            _restartFlag = false;

            // Keep track of time til expiration. When this value
            // reaches 0, issue callbacks.
            timeLeft = _delay;

            // Mark the timer as unstarted.
            timeStart = -1;

            while (_state != Timer.STOPPED)
            {
                try
                {
                    switch (_state)
                    {
                        case Timer.RUNNING:
                            // Sleep the remaining time.
                            // But first, remember when we
                            // started sleeping in case we are
                            // woken up early.
                            timeStart = System.currentTimeMillis();
                            sleep(timeLeft);

                            // When we reach here, then we must have
                            // slept the remaining time. Tell the
                            // listeners.
                            timeLeft = 0;

                            // If this timer is not repeated,
                            // delete it before issuing any
                            // transitions.
                            if (_repeatFlag == false)
                            {
                                _state = Timer.STOPPED;
                                Timer.deleteTimer(_name);

                                // Delete the name after calling deleteTimer.
                                _name = null;
                            }
                            
                            for (i = _listenerList.elements();
                                 i.hasMoreElements() == true;
                                )
                            {
                                listener = (TimerListener) i.nextElement();
                                listener.handleTimeout(timerEvent);
                            }

                            // If this timer is repeatable, reset
                            // the time left and go again.
                            // Otherwise, this timer is done.
                            if (_repeatFlag == true)
                            {
                                timeLeft = _delay;
                            }
                            else
                            {
                                _listenerList = null;
                            }
                            break;

                        case Timer.PAUSED:
                            // Wait to be continued or stopped.
                            timeStart = -1;
                            synchronized(this) {
                                wait();
                            }
                            break;
                    }
                    

                    // Get the current time. Use this to calculate how
                    // long the timer has been running.
                }
                catch (InterruptedException interrupt)
                {
                    // Get timestamp in case it is needed.
                    timeStop = System.currentTimeMillis();

                    // Has this timer been restarted? If yes,
                    // then reset time remaining to the full
                    // delay. Otherwise, figure out how long
                    // sleep lasted and update time left.
                    if (_restartFlag == true)
                    {
                        _restartFlag = false;
                        timeLeft = _delay;
                    }
                    else if (timeStart >= 0)
                    {
                        timeLeft -= (int) (timeStop - timeStart);
                        if (timeLeft < 0)
                        {
                            timeLeft = 0;
                        }
                    }
                }
                catch (Exception jexcept)
                {
                    // Ignore all other exceptions.
                }
            }

            return;
        }

    // Member data.

        private String _name;
        private int _delay;
        private boolean _repeatFlag;
        private Vector _listenerList;
        private int _state;
        private boolean _wasStopped;
        private boolean _restartFlag;
    }
}
