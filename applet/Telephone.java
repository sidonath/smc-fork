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
//  Telephone.java
//
// Description
//  A simulation of an old fashioned touch-tone telephone.
//
// RCS ID
// $Id: Telephone.java,v 1.4 2005/06/05 18:51:07 cwrapp Exp $
//
// CHANGE LOG
// $Log: Telephone.java,v $
// Revision 1.4  2005/06/05 18:51:07  cwrapp
// Added output actions back into FSM.
//
// Revision 1.3  2005/05/28 19:41:44  cwrapp
// Update for SMC v. 4.0.0.
//
// Revision 1.2  2004/10/30 15:43:25  charlesr
// Correct time format.
//
// Revision 1.1  2004/10/08 18:40:42  charlesr
// Replaced CallbackThread with a timer.
//
// Revision 1.0  2003/12/14 19:02:45  charlesr
// Initial revision
//

import java.applet.Applet;
import java.applet.AudioClip;
import java.awt.Button;
import java.awt.Color;
import java.awt.Container;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.Label;
import java.awt.Panel;
import java.awt.TextArea;
import java.awt.TextField;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.GregorianCalendar;
import java.util.Hashtable;
import java.util.Vector;

public final class Telephone
    extends Applet
    implements TimerListener
{
// Member methods.

    public Telephone()
    {
        _areaCode = null;
        _exchange = null;
        _local = null;
        _display = "";
        _route = 0;

        _receiverButton = null;
        _dialButtons = null;

        _playbackThread = null;
        _fsm = null;
    }

    // Get this applet ready for running.
    public void init()
    {
        // Store dialed numbers here.
        _areaCode = new String();
        _exchange = new String();
        _local = new String();

        _clockFormatter =
            new SimpleDateFormat("    hh:mm a    MMMM dd, yyyyy");

        // Load sounds.
        _loadSounds();

        // Load user interface.
        _loadUI();

        // Create the state machine to drive this object.
        _fsm = new TelephoneContext(this);

        return;
    }

    // Start the telephone running.
    public void start()
    {
        showStatus("Running.");

        _fsm.Start();
        return;
    }

    // Stop the telephone but don't remove the display.
    public void stop()
    {
        showStatus("Stopping.");

        _fsm.Stop();
        return;
    }

    // Tear down this applet.
    public void destroy()
    {
        _areaCode = null;
        _exchange = null;
        _local = null;

        _unloadSounds();
        _unloadUI();

        _fsm = null;

        return;
    }

    //-----------------------------------------------------------
    // TimerListener Interface Implementation.
    //

    public void handleTimeout(TimerEvent event)
    {
        if (_fsm != null)
        {
            String name = event.getTimerName();

            if (name.equals("RingTimer") == true)
            {
                _fsm.RingTimer();
            }
            else if (name.equals("OffHookTimer") == true)
            {
                _fsm.OffHookTimer();
            }
            else if (name.equals("LoopTimer") == true)
            {
                _fsm.LoopTimer();
            }
            else if (name.equals("ClockTimer") == true)
            {
                _fsm.ClockTimer();
            }
            else if (name.equals("RouteTimer") == true)
            {
                _callRoute();
            }
        }

        return;
    }

    //
    // end of TimerListener Interface Implementation.
    //-----------------------------------------------------------

    //-----------------------------------------------------------
    // State Machine Conditions.
    //

    public boolean isDigitValid(String n)
    {
        boolean retcode;

        try
        {
            int digit = Integer.parseInt(n);

            retcode =
                (digit >= 0 && digit < 10 ? true : false);
        }
        catch (NumberFormatException formex)
        {
            retcode = false;
        }

        return (retcode);
    }

    public boolean equal(String n, int value)
    {
        boolean retcode;

        try
        {
            int digit;

            digit = Integer.parseInt(n);
            retcode = (digit == value ? true : false);
        }
        catch (NumberFormatException formex)
        {
            retcode = false;
        }

        return (retcode);
    }

    // The area code is complete when four digits have been
    // collected. Since we will be adding one more in a moment,
    // the area code need have only three digits.
    public boolean isCodeComplete()
    {
        return (_areaCode.length() == 3);
    }

    // The exchange has three digits.
    public boolean isExchangeComplete()
    {
        return (_exchange.length() == 2);
    }

    // The local number has four digits.
    public boolean isLocalComplete()
    {
        return (_local.length() == 3);
    }

    //-----------------------------------------------------------
    // State Machine Actions.
    //

    // Use a separate thread to route the call asynchronously.
    public void routeCall()
    {
        if (_callType == EMERGENCY)
        {
            _route = EMERGENCY;
        }
        else if (_callType == LONG_DISTANCE &&
                 _areaCode.equals("1212") == true &&
                 _exchange.equals("555") == true &&
                 _local.equals("1234") == true)
        {
            _route = NYC_TEMP;
        }
        else if (_exchange.equals("555") == true)
        {
            if (_local.equals("1212") == true)
            {
                _route = TIME;
            }
            else
            {
                _route = LINE_BUSY;
            }
        }
        else if (_callType == LOCAL)
        {
            _route = DEPOSIT_MONEY;
        }
        else
        {
            _route = INVALID_NUMBER;
        }

        // Issue the appropriate transition when this timer
        // expires.
        startTimer("RouteTimer", 1);

        return;
    }

    public void startTimer(String name, int delay)
    {
        // Is there a timer with this name already?
        if (Timer.timerExists(name) == true)
        {
            // Yes. Stop the timer.
            Timer.stopTimer(name);
        }

        Timer.createTimer(name, delay, false, this);
        Timer.startTimer(name);

        return;
    }

    public void resetTimer(String name)
    {
        if (Timer.timerExists(name) == true)
        {
            Timer.restartTimer(name);
        }

        return;
    }

    public void stopTimer(String name)
    {
        if (Timer.timerExists(name) == true)
        {
            Timer.stopTimer(name);
        }

        return;
    }

    public void play(String name)
    {
        AudioData audioData = (AudioData) _audioMap.get(name);

        if (audioData != null)
        {
            try
            {
                audioData.play();
            }
            catch (InterruptedException interrupt)
            {}
        }
        else
        {
            System.err.println("There is no audio clip named \"" +
                               name +
                               "\".");
        }

        return;
    }

    public void playTT(String name)
    {
        int n;

        try
        {
            n = Integer.parseInt(name);
            if (_dtmf[n] != null)
            {
                _dtmf[n].play();
            }
            else
            {
                System.err.println("There is no audio clip named \"dtmf_" +
                                   name +
                                   "\".");
            }
        }
        catch (NumberFormatException formex)
        {}

        return;
    }

    public void loop(String name)
    {
        AudioData audioData = (AudioData) _audioMap.get(name);

        if (audioData != null)
        {
            audioData.loop();
        }
        else
        {
            System.err.println("There is no audio clip named \"" +
                               name +
                               "\".");
        }

        return;
    }

    public void stopLoop(String name)
    {
        AudioData audioData = (AudioData) _audioMap.get(name);

        if (audioData != null)
        {
            audioData.stop();
        }
        else
        {
            System.err.println("There is no audio clip named \"" +
                               name +
                               "\".");
        }

        return;
    }

    public void stopPlayback()
    {
        if (_playbackThread != null)
        {
            _playbackThread.halt();
            _playbackThread = null;
        }

        return;
    }

    public void playEmergency()
    {
        AudioData audioData;
        Vector audioList = new Vector(1);

        audioData =
            (AudioData) _audioMap.get("911");
        audioList.addElement(audioData);

        _playbackThread = new PlaybackThread(audioList, this);
        _playbackThread.setDaemon(true);
        _playbackThread.start();

        return;
    }

    public void playNYCTemp()
    {
        AudioData audioData;
        Vector audioList = new Vector(1);

        audioData =
            (AudioData) _audioMap.get("NYC_temp");
        audioList.addElement(audioData);

        _playbackThread = new PlaybackThread(audioList, this);
        _playbackThread.setDaemon(true);
        _playbackThread.start();

        return;
    }


    public void playDepositMoney()
    {
        AudioData audioData;
        Vector audioList = new Vector(2);

        audioData =
            (AudioData) _audioMap.get("error_signal");
        audioList.addElement(audioData);

        audioData =
            (AudioData) _audioMap.get("50_cents_please");
        audioList.addElement(audioData);

        _playbackThread = new PlaybackThread(audioList, this);
        _playbackThread.setDaemon(true);
        _playbackThread.start();

        return;
    }

    public void playTime()
    {
        GregorianCalendar calendar =
            new GregorianCalendar();
        int hour = calendar.get(Calendar.HOUR);
        int minute = calendar.get(Calendar.MINUTE);
        int seconds = calendar.get(Calendar.SECOND);
        int am_pm = calendar.get(Calendar.AM_PM);
        AudioData clip;
        Vector clipList = new Vector(10);

        clip = (AudioData) _audioMap.get("the_time_is");
        clipList.addElement(clip);

        // 1. Read the hour.
        clip = (AudioData) _audioMap.get(Integer.toString(hour));
        clipList.addElement(clip);

        // Is this on the hour exactly?
        if (minute == 0 && seconds == 0)
        {
            clip = (AudioData) _audioMap.get("oclock");
            clipList.addElement(clip);

            _soundMeridian(am_pm, clipList);

            clip = (AudioData) _audioMap.get("exactly");
            clipList.addElement(clip);
        }
        else
        {
            // 2. Read the minute.
            _soundNumber(minute, true, clipList);

            _soundMeridian(am_pm, clipList);

            // 3. Read the seconds.
            if (seconds == 0)
            {
                clip = (AudioData) _audioMap.get("exactly");
                clipList.addElement(clip);
            }
            else
            {
                clip = (AudioData) _audioMap.get("and");
                clipList.addElement(clip);

                _soundNumber(seconds, false, clipList);

                if (seconds == 1)
                {
                    clip = (AudioData) _audioMap.get("second");
                }
                else
                {
                    clip = (AudioData) _audioMap.get("seconds");
                }
                clipList.addElement(clip);
            }
        }

        _playbackThread = new PlaybackThread(clipList, this);
        _playbackThread.setDaemon(true);
        _playbackThread.start();

        return;
    }

    public void playInvalidNumber()
    {
        AudioData audioData;
        Vector audioList = new Vector(13);

        audioData =
            (AudioData) _audioMap.get("error_signal");
        audioList.addElement(audioData);
        audioData =
            (AudioData) _audioMap.get("you_dialed");
        audioList.addElement(audioData);

        _soundPhoneNumber(audioList);

        audioData =
            (AudioData) _audioMap.get("could_not_be_completed");
        audioList.addElement(audioData);

        // Play the message in a separate thread.
        _playbackThread = new PlaybackThread(audioList, this);
        _playbackThread.setDaemon(true);
        _playbackThread.start();

        return;
    }

    public void setType(int type)
    {
        _callType = type;
        return;
    }

    public void saveAreaCode(String n)
    {
        _areaCode += n;
        addDisplay(n);

        return;
    }

    public void saveExchange(String n)
    {
        _exchange += n;
        addDisplay(n);

        return;
    }

    public void saveLocal(String n)
    {
        _local += n;
        addDisplay(n);

        return;
    }

    public void addDisplay(String character)
    {
        if (character.length() == 1)
        {
            _display += character;
        }
        else if (character.equals("10") == true)
        {
            _display += "*";
        }
        else
        {
            _display += "#";
        }

        _numberDisplay.setText(_display);

        return;
    }

    public void clearDisplay()
    {
        // Clear the internal data store.
        _display = "";
        _areaCode = "";
        _local = "";
        _exchange = "";

        // Then clear the GUI.
        _numberDisplay.setText("");

        return;
    }

    public void startClockTimer()
    {
        long currentTime = System.currentTimeMillis();
        int timeRemaining =
            (int) (MILLIS_PER_MINUTE -
                   (currentTime % MILLIS_PER_MINUTE));

        // Figure out how long until the top of the minute
        // and set the timer for that amount.
        startTimer("ClockTimer", timeRemaining);

        return;
    }

    public void updateClock()
    {
        _numberDisplay.setText(_clockFormatter.format(new Date()));
        return;
    }

    public void setReceiver(String command, String text)
    {
        if (_receiverButton != null)
        {
            _receiverButton.setActionCommand(command);
            _receiverButton.setLabel(text);
        }

        return;
    }

    //-----------------------------------------------------------
    // The following methods write state machine events to
    // the text area.

    public void writeState(String name)
    {
        _textArea.append(name + "\n");
        return;
    }

    public void writeStateAction(String type, String action)
    {
        _textArea.append(_stateActPad +
                         type +
                         ": " +
                         action +
                         "\n");
        return;
    }

    public void writeTransition(String name)
    {
        _textArea.append(_transPad + name + "\n");
        return;
    }

    public void writeTransAction(String action)
    {
        _textArea.append(_actPad + action + "\n");
        return;
    }

    //-----------------------------------------------------------
    // Initialization
    //

    private void _loadSounds()
    {
        String directory = getCodeBase() + "sounds/";
        String urlString = "";
        URL soundURL;
        AudioClip audioClip;
        AudioData audioData;
        int i;

        showStatus("Loading sounds.");

        // Load in the touch tone clips.
        _dtmf = new AudioClip[12];
        for (i = 0; i < 12; ++i)
        {
            try
            {
                urlString = directory +
                            "touch_tone_" +
                            Integer.toString(i) +
                            ".au";
                soundURL = new URL(urlString);
                _dtmf[i] = getAudioClip(soundURL);
            }
            catch (MalformedURLException urlex)
            {
                System.err.println("Telephone: \"" +
                                   urlString +
                                   "\" is a bad URL.");
            }
        }

        // Create sound URLs. The audio clips will be loaded in
        // only when they are needed.
        try
        {
            _audioMap = new Hashtable();

            urlString = directory + "ring.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 4000);
            _audioMap.put("ringing", audioData);

            urlString = directory + "dialtone.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1000);
            _audioMap.put("dialtone", audioData);

            urlString = directory + "busy_signal.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1000);
            _audioMap.put("busy", audioData);

            urlString = directory + "fast_busy_signal.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1000);
            _audioMap.put("fast_busy", audioData);

            urlString = directory + "error_signal.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1130);
            _audioMap.put("error_signal", audioData);

            urlString = directory + "phone_off_hook.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 500);
            _audioMap.put("phone_off_hook", audioData);

            urlString = directory + "911.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 13000);
            _audioMap.put("911", audioData);

            urlString = directory + "and.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 750);
            _audioMap.put("and", audioData);

            urlString = directory + "50_cents_please.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 6000);
            _audioMap.put("50_cents_please", audioData);

            urlString = directory + "could_not_be_completed.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 4000);
            _audioMap.put("could_not_be_completed", audioData);

            urlString = directory + "exactly.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1000);
            _audioMap.put("exactly", audioData);

            urlString = directory + "oclock.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1000);
            _audioMap.put("oclock", audioData);

            urlString = directory + "oh.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1000);
            _audioMap.put("oh", audioData);

            urlString = directory + "second.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1200);
            _audioMap.put("second", audioData);

            urlString = directory + "seconds.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1400);
            _audioMap.put("seconds", audioData);

            urlString = directory + "the_number_you_have_dialed.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1800);
            _audioMap.put("you_dialed", audioData);

            urlString = directory + "the_time_is.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1100);
            _audioMap.put("the_time_is", audioData);

            urlString = directory + "nyctemp.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 18500);
            _audioMap.put("NYC_temp", audioData);

            urlString = directory + "AM.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1250);
            _audioMap.put("AM", audioData);

            urlString = directory + "PM.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1000);
            _audioMap.put("PM", audioData);

            urlString = directory + "0.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1000);
            _audioMap.put("0", audioData);

            urlString = directory + "1.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 900);
            _audioMap.put("1", audioData);

            urlString = directory + "2.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 900);
            _audioMap.put("2", audioData);

            urlString = directory + "3.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1000);
            _audioMap.put("3", audioData);

            urlString = directory + "4.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 900);
            _audioMap.put("4", audioData);

            urlString = directory + "5.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 900);
            _audioMap.put("5", audioData);

            urlString = directory + "6.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 850);
            _audioMap.put("6", audioData);

            urlString = directory + "7.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1250);
            _audioMap.put("7", audioData);

            urlString = directory + "8.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1000);
            _audioMap.put("8", audioData);

            urlString = directory + "9.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 900);
            _audioMap.put("9", audioData);

            urlString = directory + "10.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 750);
            _audioMap.put("10", audioData);

            urlString = directory + "11.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1000);
            _audioMap.put("11", audioData);

            urlString = directory + "12.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1250);
            _audioMap.put("12", audioData);

            urlString = directory + "13.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1250);
            _audioMap.put("13", audioData);

            urlString = directory + "14.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1250);
            _audioMap.put("14", audioData);

            urlString = directory + "15.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1250);
            _audioMap.put("15", audioData);

            urlString = directory + "16.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1250);
            _audioMap.put("16", audioData);

            urlString = directory + "17.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1500);
            _audioMap.put("17", audioData);

            urlString = directory + "18.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1250);
            _audioMap.put("18", audioData);

            urlString = directory + "19.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1250);
            _audioMap.put("19", audioData);

            urlString = directory + "20.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1250);
            _audioMap.put("20", audioData);

            urlString = directory + "30.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1000);
            _audioMap.put("30", audioData);

            urlString = directory + "40.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1000);
            _audioMap.put("40", audioData);

            urlString = directory + "50.au";
            soundURL = new URL(urlString);
            audioData = new AudioData(this, soundURL, 1000);
            _audioMap.put("50", audioData);
        }
        catch (MalformedURLException malex)
        {
            System.err.println("Unknown URL: " +
                               urlString);
        }

        return;
    }

    private void _unloadSounds()
    {
        int i;
        Enumeration it;
        AudioData data;

        for (i = 0; i < 12; ++i)
        {
            _dtmf[i] = null;
        }
        _dtmf = null;

        for (it = _audioMap.elements();
             it.hasMoreElements() == true;
            )
        {
            data = (AudioData) it.nextElement();
            data.clear();
        }

        _audioMap.clear();
        _audioMap = null;

        return;
    }

    private void _loadUI()
    {
        String buttonText;
        String buttonCommand;
        int i;

        showStatus("Loading user interface.");

        // Create the read-only phone number display.
        _numberDisplay = new TextField("", 30);
        _numberDisplay.setEditable(false);

        // Create the off-hook/on-hook button.
        _receiverButton = new Button("Pick up receiver ");
        _receiverButton.setActionCommand("off hook");
        _receiverButton.addActionListener(
            new ActionListener() 
                {
                    public void actionPerformed(ActionEvent e)
                    {
                        Button button = (Button) e.getSource();
                        String command = e.getActionCommand();

                        if (command.equals("off hook") == true)
                        {
                            _fsm.OffHook();
                        }
                        else if (command.equals("on hook")
                                     == true)
                        {
                            _fsm.OnHook();
                        }
                        else
                        {
                            System.out.println(
                                "Unknown receiver command: \"" +
                                command +
                                "\".");
                        }

                        return;
                    }
                }
            );
        _receiverButton.setEnabled(true);

        // Create the dialing buttons.
        _dialButtons = new Button[12];
        for (i = 0; i < 12; ++i)
        {
            buttonCommand = Integer.toString(i);

            if (i < 10)
            {
                buttonText = buttonCommand;
            }
            else if (i == 10)
            {
                buttonText = "*";
            }
            else
            {
                buttonText = "#";
            }

            _dialButtons[i] = new Button(buttonText);
            _dialButtons[i].setActionCommand(buttonCommand);
            _dialButtons[i].addActionListener(
                new ActionListener() {
                    public void actionPerformed(ActionEvent e) 
                    {
                        _fsm.Digit(e.getActionCommand());
                    }
                }
            );
            _dialButtons[i].setEnabled(true);
        }

        // Create FSM output text area and its label.
        _stateActPad = "    ";
        _transPad = "                           ";
        _actPad = "                                                              ";

        Panel labelPanel = new Panel();
        String labelText =
            "State               Transition                Action                                                           ";
        Label label = new Label(labelText, Label.LEFT);
        Font labelFont = new Font("Arial", Font.BOLD, 12);
        label.setFont(labelFont);

        labelPanel.setLayout(
            new FlowLayout(FlowLayout.LEFT, 0, 0));
        labelPanel.add(label);

        _textArea = new TextArea("",
                                 25,
                                 65,
                                 TextArea.SCROLLBARS_BOTH);
        _textArea.setFont(new Font("Arial", Font.PLAIN, 9));
        _textArea.setEditable(false);
        _textArea.setBackground(Color.white);

        Panel fsmPanel = new Panel();
        fsmPanel.setLayout(new GridLayout(2, 1));
        fsmPanel.add(labelPanel);
        fsmPanel.add(_textArea);

        // Layout the components.
        GridBagLayout gridbag = new GridBagLayout();
        GridBagConstraints gridConstraints =
            new GridBagConstraints();
        setLayout(gridbag);

        gridConstraints.anchor = GridBagConstraints.CENTER;
        gridConstraints.gridx = 0;
        gridConstraints.gridy = 0;
        gridConstraints.gridwidth = 1;
        gridConstraints.gridheight = 1;
        gridConstraints.weighty = 0.0;
        gridbag.setConstraints(_numberDisplay, gridConstraints);
        add(_numberDisplay);

        // The pick up/put down receiver button spans all columns
        // and one row.
        gridConstraints.anchor = GridBagConstraints.CENTER;
        gridConstraints.gridx = 0;
        gridConstraints.gridy = 1;
        gridConstraints.gridwidth = 1;
        gridConstraints.gridheight = 1;
        gridConstraints.weighty = 0.0;
        gridbag.setConstraints(_receiverButton, gridConstraints);
        add(_receiverButton);

        // Now put the dial buttons in place.
        Panel dialPanel = new Panel();
        GridLayout dialGrid = new GridLayout(4, 3);

        dialGrid.setHgap(4);
        dialGrid.setVgap(4);
        dialPanel.setLayout(dialGrid);

        // Place dial buttons into the grid.
        for (i = 1; i < 11; ++i)
        {
            dialPanel.add(_dialButtons[i]);
        }

        // The last row is "* 0 #".
        dialPanel.add(_dialButtons[0]);
        dialPanel.add(_dialButtons[11]);

        // Put the dial in the middle of the overall layout.
        gridConstraints.anchor = GridBagConstraints.CENTER;
        gridConstraints.gridx = 0;
        gridConstraints.gridy = 2;
        gridConstraints.gridwidth = 1;
        gridConstraints.gridheight = 1;
        gridConstraints.weightx = 0.0;
        gridConstraints.weighty = 0.0;
        add(dialPanel, gridConstraints);

        // Put the label above text area.
        gridConstraints.anchor = GridBagConstraints.CENTER;
        gridConstraints.gridx = 0;
        gridConstraints.gridy = 3;
        gridConstraints.gridwidth = 1;
        gridConstraints.gridheight = 1;
        gridConstraints.weightx = 0.0;
        gridConstraints.weighty = 0.0;
        add(labelPanel, gridConstraints);

        // Put the FSM output text area on the bottom.
        // It also sucks up all new verticle space.
        gridConstraints.anchor = GridBagConstraints.CENTER;
        gridConstraints.gridx = 0;
        gridConstraints.gridy = 4;
        gridConstraints.gridwidth = 1;
        gridConstraints.gridheight = 1;
        gridConstraints.weightx = 0.0;
        gridConstraints.weighty = 1.0;
        add(_textArea, gridConstraints);

        return;
    }

    private void _unloadUI()
    {
        int i;

        _numberDisplay = null;
        _receiverButton = null;

        for (i = 0; i < 12; ++i)
        {
            _dialButtons[i] = null;
        }
        _dialButtons = null;

        return;
    }

    private void _soundPhoneNumber(Vector audioList)
    {
        int i;
        String digit;
        AudioData data;

        // If this is a long distance number, sound out the
        // area code first.
        if (_callType == LONG_DISTANCE)
        {
            for (i = 0; i < _areaCode.length(); ++i)
            {
                digit = _areaCode.substring(i, (i + 1));
                data = (AudioData) _audioMap.get(digit);
                audioList.addElement(data);
            }
        }

        // All types have an exchange.
        for (i = 0; i < _exchange.length(); ++i)
        {
            digit = _exchange.substring(i, (i + 1));
            data = (AudioData) _audioMap.get(digit);
            audioList.addElement(data);
        }

        // Only long distance and local numbers have a local
        // portion.
        if (_callType == LONG_DISTANCE || _callType == LOCAL)
        {
            for (i = 0; i < _local.length(); ++i)
            {
                digit = _local.substring(i, (i + 1));
                data = (AudioData) _audioMap.get(digit);
                audioList.addElement(data);
            }
        }

        return;
    }

    private void _soundMeridian(int am_pm, Vector audioList)
    {
        AudioData clip;

        if (am_pm == Calendar.AM)
        {
            clip = (AudioData) _audioMap.get("AM");
        }
        else
        {
            clip = (AudioData) _audioMap.get("PM");
        }
        audioList.addElement(clip);

        return;
    }

    private void _soundNumber(int number,
                              boolean zeroFlag,
                              Vector audioList)
    {
        AudioData clip;

        if (number < 10 && zeroFlag == true)
        {
            clip = (AudioData) _audioMap.get("oh");
            audioList.addElement(clip);
            clip =
                (AudioData) _audioMap.get(Integer.toString(number));
            audioList.addElement(clip);
        }
        else if (number < 20)
        {
            clip =
                (AudioData) _audioMap.get(Integer.toString(number));
            audioList.addElement(clip);
        }
        else
        {
            int onesDigit = number % 10;
            int tensDigit = number - onesDigit;

            // Read the ten's digit first and then the
            // remainder - if not zero.
            clip =
                (AudioData) _audioMap.get(Integer.toString(tensDigit));
            audioList.addElement(clip);

            if (onesDigit != 0)
            {
                clip =
                    (AudioData) _audioMap.get(Integer.toString(onesDigit));
                audioList.addElement(clip);
            }
        }

        return;
    }

    private void _playbackDone(PlaybackThread thread)
    {
        _playbackThread = null;
        _fsm.PlaybackDone();
    }

    private void _callRoute()
    {
        int route = _route;

        _route = 0;

        switch (route)
        {
            case EMERGENCY:
                _fsm.Emergency();
                break;

            case NYC_TEMP:
                _fsm.NYCTemp();
                break;

            case TIME:
                _fsm.Time();
                break;

            case DEPOSIT_MONEY:
                _fsm.DepositMoney();
                break;

            case LINE_BUSY:
                _fsm.LineBusy();
                break;

            case INVALID_NUMBER:
                _fsm.InvalidNumber();
                break;
        }

        return;
    }

// Member data.

    // The telphone state machine.
    private TelephoneContext _fsm;

    // The type of call being dialed.
    private int _callType;

    // Store dialed numbers here.
    private String _areaCode;
    private String _exchange;
    private String _local;
    private String _display;
    private int _route;

    // Display the dialed digits here.
    private TextField _numberDisplay;

    // This button is used to pick-up/put-down the receiver.
    private Button _receiverButton;

    // Dialing buttons.
    private Button[] _dialButtons;

    // Zounds! It's sounds!
    private AudioClip[] _dtmf;
    private Hashtable _audioMap;
    private PlaybackThread _playbackThread;

    // Data used for displaying FSM info.
    private String _stateActPad;
    private String _transPad;
    private String _actPad;
    private TextArea _textArea;

    // The telephone's time display.
    private SimpleDateFormat _clockFormatter;

    //-----------------------------------------------------------
    // Constants.
    public static final int LONG_DISTANCE = 1;
    public static final int LOCAL = 2;
    public static final int EMERGENCY = 3;

    private static final int NYC_TEMP = 4;
    private static final int TIME = 5;
    private static final int DEPOSIT_MONEY = 6;
    private static final int LINE_BUSY = 7;
    private static final int INVALID_NUMBER = 8;

    private static final long MILLIS_PER_MINUTE = 60000;

// Inner classes.

    // When playing a series of audio clips, it is neccessary
    // to wait for one clip to finish before starting the next.
    // Since Java audio clips don't know how long they are, it
    // is necessary to store with each sound clip its duration.
    private final class AudioData
    {
    // Member methods.

        public void play()
            throws InterruptedException
        {
            if (_clip != null ||
                (_clip = _owner.getAudioClip(_url)) != null)
            {
                _clip.play();

                try
                {
                    Thread.sleep(_duration);
                }
                catch (InterruptedException interrupt)
                {
                    // Stop the audio clip before rethrowing the
                    // intettupt.
                    _clip.stop();
                    _clip = null;

                    throw (interrupt);
                }
            }

            return;
        }

        public void loop()
        {
            if (_clip != null ||
                (_clip = _owner.getAudioClip(_url)) != null)
            {
                _clip.loop();
            }

            return;
        }

        public void stop()
        {
            if (_clip != null)
            {
                _clip.stop();
                _clip = null;
            }

            return;
        }

        private AudioData(Telephone owner,
                          URL url,
                          long duration)
        {
            _owner = owner;
            _url = url;
            _clip = null;
            _duration = duration;
        }

        private URL getURL()
        {
            return (_url);
        }

        private long getDuration()
        {
            return (_duration);
        }

        private void clear()
        {
            _owner = null;
            _url = null;

            if (_clip != null)
            {
                _clip.stop();
                _clip = null;
            }

            return;
        }

    // Member data.

        private Telephone _owner;
        private URL _url;
        private AudioClip _clip;
        private long _duration;
    }

    // Play several audio clips, one after another in a
    // separate thread.
    private final class PlaybackThread
        extends Thread
    {
    // Member methods.

        public void run()
        {
            Enumeration it;
            AudioData clip = null;

            _thread = Thread.currentThread();
            
            for (it = _audioList.elements(),
                     _continueFlag = true;
                 it.hasMoreElements() == true &&
                     _continueFlag == true;
                )
            {
                clip = (AudioData) it.nextElement();

                try
                {
                    clip.play();
                    clip = null;
                }
                catch (InterruptedException interrupt)
                {
                    _continueFlag = false;
                }
            }

            // Stop the currently playing sound.
            if (clip != null)
            {
                clip.stop();
            }

            _audioList.removeAllElements();

            if (_owner != null)
            {
                _owner._playbackDone(this);
            }

            return;
        }

        public void halt()
        {
            // Since the telephone object is telling us to
            // stop, don't tell the telephone that we are
            // stopped.
            _owner = null;

            _continueFlag = false;
            _thread.interrupt();

            return;
        }

        private PlaybackThread(Vector audioList,
                               Telephone owner)
        {
            _audioList = audioList;
            _owner = owner;
            _thread = null;
            _continueFlag = false;
        }

    // Member data.

        private Vector _audioList;
        private Telephone _owner;
        private boolean _continueFlag;
        private Thread _thread;
    }
}
