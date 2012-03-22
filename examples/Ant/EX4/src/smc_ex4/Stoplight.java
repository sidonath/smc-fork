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
//  Stoplight.java
//
// Description
//  This class paints the stoplights on the canvas and changes
//  the lights' color.
//
// RCS ID
// $Id: Stoplight.java,v 1.2 2007/08/05 13:10:03 cwrapp Exp $
//
// CHANGE LOG
// $Log: Stoplight.java,v $
// Revision 1.2  2007/08/05 13:10:03  cwrapp
// Version 5.0.1 check-in. See net/sf/smc/CODE_README.txt for more information.
//
// Revision 1.1  2005/05/28 12:49:21  cwrapp
// Added Ant examples 1 - 7.
//
// Revision 1.0  2004/05/31 13:10:14  charlesr
// Initial revision
//

package smc_ex4;

import java.awt.*;
import java.awt.event.*;
import java.awt.geom.*;
import javax.swing.*;

public final class Stoplight
{
// Member methods.

    public Stoplight(int canvasWidth,
                     int canvasHeight,
                     TrafficCanvas owner)
    {
        // Remember on which canvas this stop light is being
        // drawn.
        _owner = owner;

        // Calculate the stop light's width and height.
        // The width is equal to the individual lamp's diameter
        // plus space on either side.
        // The height is equal to three lamps plus four spaces.
        _size = new Dimension((LAMP_DIAMETER + (LAMP_SPACE * 2)),
                              ((LAMP_DIAMETER * 3) + (LAMP_SPACE * 4)));

        // Now calculate the stop light's coordinates based on
        // the following diagram:
        //
        // y[0]         +---+
        //              | o | g
        //              | o | y
        //              | o | r y g
        // y[1] +-------+---+-------+
        //      | o o o | c | o o o |
        // y[2] +-------+---+-------+
        //        g y r | o |
        //            y | o |
        //            g | o |
        // y[3]         +---+
        //     x[0]   x[1] x[2]    x[3]
        //
        _positions = new Point[4];
        _positions[0] = new Point((((int) (canvasWidth / 2)) -
                                   ((int) (_size.width / 2)) - _size.height),
                                  (((int) (canvasHeight / 2)) -
                                   ((int) (_size.width / 2)) - _size.height));
        _positions[1] = new Point((_positions[0].x + _size.height),
                                  (_positions[0].y + _size.height));
        _positions[2] = new Point((_positions[1].x + _size.width),
                                  (_positions[1].y + _size.width));
        _positions[3] = new Point((_positions[2].x + _size.height),
                                  (_positions[2].y + _size.height));

        // There are four lights: north, east, south and west.
        // Each light has four bulbs: green, yellow and red.
        _lights = new Color[4][3];
        InitLights();

        // Set the initial light durations.
        _nsLightDuration = 8000;
        _ewLightDuration = 10000;
        _yellowDuration = 4000;

        // Create the stop light's state machine.
        _fsm = new StoplightContext(this);

        // Uncomment to see debug output.
        // _fsm.setDebugFlag(true);
    }

    public Color getLightsColor(int direction)
    {
        boolean found;
        int i;
        Color retval = Color.white;

        // Go through the light's bulbs looking for
        // one that is *not* black.
        for (i = 0, found = false;
             found == false && i < 3;
             ++i)
        {
            if (_lights[direction][i].getRGB() != Color.black.getRGB())
            {
                retval = _lights[direction][i];
                found = true;
            }
        }

        return(retval);
    }

    public void getLightDimensions(Point direction,
                                   Point lightLocation,
                                   Dimension lightSize)
    {
        // If the vehicle is heading north, it will pass under
        // the east light.
        if (direction.x == _owner.NORTH.x &&
            direction.y == _owner.NORTH.y)
        {            lightLocation.x = _positions[2].x;
            lightLocation.y = _positions[1].y;
            lightSize.width = _size.height;
            lightSize.height = _size.width;
        }
        // If the vehicle is heading east, it will pass under the
        // south light.
        else if (direction.x == _owner.EAST.x &&
                 direction.y == _owner.EAST.y)
        {
            lightLocation.x = _positions[1].x;
            lightLocation.y = _positions[2].y;
            lightSize.width = _size.width;
            lightSize.height = _size.height;
        }
        // If the vehicle is heading south, it will pass under
        // the west light.
        else if (direction.x == _owner.SOUTH.x &&
                 direction.y == _owner.SOUTH.y)
        {
            lightLocation.x = _positions[0].x;
            lightLocation.y = _positions[1].y;
            lightSize.width = _size.height;
            lightSize.height = _size.width;
        }
        // If the vehicle is heading west, it will pass under the
        // north light.
        else if (direction.x == _owner.WEST.x &&
                 direction.y == _owner.WEST.y)
        {
            lightLocation.x = _positions[1].x;
            lightLocation.y = _positions[0].y;
            lightSize.width = _size.width;
            lightSize.height = _size.height;
        }

        return;
    }

    public int getLightDuration(int light)
    {
        int duration;

        switch (light)
        {
            case TrafficCanvas.NS_LIGHT:
                duration = _nsLightDuration;
                break;

            case TrafficCanvas.EW_LIGHT:
                duration = _ewLightDuration;
                break;

            case TrafficCanvas.YELLOW_LIGHT:
            default:
                duration = _yellowDuration;
                break;
        }

        return(duration);
    }

    public void setLightDuration(int light, int duration)
    {
        switch (light)
        {
            case TrafficCanvas.NS_LIGHT:
                _nsLightDuration = duration;
                break;

            case TrafficCanvas.EW_LIGHT:
                _ewLightDuration = duration;
                break;

            case TrafficCanvas.YELLOW_LIGHT:
                _yellowDuration = duration;
                break;
        }

        return;
    }

    public void startDemo()
    {
        _fsm.Start();
        return;
    }

    public void pauseDemo()
    {
        _fsm.Pause();
        return;
    }

    public void continueDemo()
    {
        _fsm.Continue();
        return;
    }

    public void stopDemo()
    {
        _fsm.Stop();
        return;
    }

    public void paint(Graphics g)
    {
        Graphics2D g2 = (Graphics2D) g;

        // Draw the four stop light boxes. Start with the
        // northern light and go clockwise.
        g2.setPaint(Color.black);
        g2.fill(new Rectangle2D.Double(_positions[1].x,
                                       _positions[0].y,
                                       _size.width,
                                       _size.height));
        g2.fill(new Rectangle2D.Double(_positions[2].x,
                                       _positions[1].y,
                                       _size.height,
                                       _size.width));
        g2.fill(new Rectangle2D.Double(_positions[1].x,
                                       _positions[2].y,
                                       _size.width,
                                       _size.height));
        g2.fill(new Rectangle2D.Double(_positions[0].x,
                                       _positions[1].y,
                                       _size.height,
                                       _size.width));

        // Now draw the lamps within the stop lights.
        // Again, start with the northern light.
        g2.setPaint(_lights[NORTH][GREEN]);
        g2.fill(new Ellipse2D.Double((_positions[1].x + LAMP_SPACE),
                                     (_positions[0].y + LAMP_SPACE),
                                     LAMP_DIAMETER,
                                     LAMP_DIAMETER));
        g2.setPaint(_lights[NORTH][YELLOW]);
        g2.fill(new Ellipse2D.Double((_positions[1].x + LAMP_SPACE),
                                     (_positions[0].y + (LAMP_SPACE * 2) + LAMP_DIAMETER),
                                     LAMP_DIAMETER,
                                     LAMP_DIAMETER));
        g2.setPaint(_lights[NORTH][RED]);
        g2.fill(new Ellipse2D.Double((_positions[1].x + LAMP_SPACE),
                                     (_positions[0].y + (LAMP_SPACE * 3) + (LAMP_DIAMETER * 2)),
                                     LAMP_DIAMETER,
                                     LAMP_DIAMETER));

        // Eastern light.
        g2.setPaint(_lights[EAST][RED]);
        g2.fill(new Ellipse2D.Double((_positions[2].x + LAMP_SPACE),
                                     (_positions[1].y + LAMP_SPACE),
                                     LAMP_DIAMETER,
                                     LAMP_DIAMETER));
        g2.setPaint(_lights[EAST][YELLOW]);
        g2.fill(new Ellipse2D.Double((_positions[2].x + (LAMP_SPACE * 2) + LAMP_DIAMETER),
                                     (_positions[1].y + LAMP_SPACE),
                                     LAMP_DIAMETER,
                                     LAMP_DIAMETER));
        g2.setPaint(_lights[EAST][GREEN]);
        g2.fill(new Ellipse2D.Double((_positions[2].x + (LAMP_SPACE * 3) + (LAMP_DIAMETER * 2)),
                                     (_positions[1].y + LAMP_SPACE),
                                     LAMP_DIAMETER,
                                     LAMP_DIAMETER));

        // Southern light.
        g2.setPaint(_lights[SOUTH][RED]);
        g2.fill(new Ellipse2D.Double((_positions[1].x + LAMP_SPACE),
                                     (_positions[2].y + LAMP_SPACE),
                                     LAMP_DIAMETER,
                                     LAMP_DIAMETER));
        g2.setPaint(_lights[SOUTH][YELLOW]);
        g2.fill(new Ellipse2D.Double((_positions[1].x + LAMP_SPACE),
                                     (_positions[2].y + (LAMP_SPACE * 2) + LAMP_DIAMETER),
                                     LAMP_DIAMETER,
                                     LAMP_DIAMETER));
        g2.setPaint(_lights[SOUTH][GREEN]);
        g2.fill(new Ellipse2D.Double((_positions[1].x + LAMP_SPACE),
                                     (_positions[2].y + (LAMP_SPACE * 3) + (LAMP_DIAMETER * 2)),
                                     LAMP_DIAMETER,
                                     LAMP_DIAMETER));

        // Western light.
        g2.setPaint(_lights[WEST][GREEN]);
        g2.fill(new Ellipse2D.Double((_positions[0].x + LAMP_SPACE),
                                     (_positions[1].y + LAMP_SPACE),
                                     LAMP_DIAMETER,
                                     LAMP_DIAMETER));
        g2.setPaint(_lights[WEST][YELLOW]);
        g2.fill(new Ellipse2D.Double((_positions[0].x + (LAMP_SPACE * 2) + LAMP_DIAMETER),
                                     (_positions[1].y + LAMP_SPACE),
                                     LAMP_DIAMETER,
                                     LAMP_DIAMETER));
        g2.setPaint(_lights[WEST][RED]);
        g2.fill(new Ellipse2D.Double((_positions[0].x + (LAMP_SPACE * 3) + (LAMP_DIAMETER * 2)),
                                     (_positions[1].y + LAMP_SPACE),
                                     LAMP_DIAMETER,
                                     LAMP_DIAMETER));
    }

    public void handleTimeout()
    {
        // Get rid of the current timer.
        _stoplightTimer = null;

        _fsm.Timeout();
        return;
    }

    //----------------------------------------
    // State Machine Actions
    //
    public void InitLights()
    {
        // The lights are initially all black.
        int i;
        int j;
        for (i = 0; i < 4; ++i)
        {
            for (j = 0; j < 3; ++j)
            {
                _lights[i][j] = Color.black;
            }
        }

        return;
    }

    public void TurnLight(String light, String color)
    {
        if (light.compareTo("EWLIGHT") == 0)
        {
            if (color.compareTo("RED") == 0)
            {
                _lights[EAST][GREEN] = Color.black;
                _lights[EAST][YELLOW] = Color.black;
                _lights[EAST][RED] = Color.red;
                _lights[WEST][GREEN] = Color.black;
                _lights[WEST][YELLOW] = Color.black;
                _lights[WEST][RED] = Color.red;
            }
            else if (color.compareTo("GREEN") == 0)
            {
                _lights[EAST][GREEN] = Color.green;
                _lights[EAST][YELLOW] = Color.black;
                _lights[EAST][RED] = Color.black;
                _lights[WEST][GREEN] = Color.green;
                _lights[WEST][YELLOW] = Color.black;
                _lights[WEST][RED] = Color.black;
            }
            else if (color.compareTo("YELLOW") == 0)
            {
                _lights[EAST][GREEN] = Color.black;
                _lights[EAST][YELLOW] = Color.yellow;
                _lights[EAST][RED] = Color.black;
                _lights[WEST][GREEN] = Color.black;
                _lights[WEST][YELLOW] = Color.yellow;
                _lights[WEST][RED] = Color.black;
            }
        }
        else if (light.compareTo("NSLIGHT") == 0)
        {
            if (color.compareTo("RED") == 0)
            {
                _lights[NORTH][GREEN] = Color.black;
                _lights[NORTH][YELLOW] = Color.black;
                _lights[NORTH][RED] = Color.red;
                _lights[SOUTH][GREEN] = Color.black;
                _lights[SOUTH][YELLOW] = Color.black;
                _lights[SOUTH][RED] = Color.red;
            }
            else if (color.compareTo("GREEN") == 0)
            {
                _lights[NORTH][GREEN] = Color.green;
                _lights[NORTH][YELLOW] = Color.black;
                _lights[NORTH][RED] = Color.black;
                _lights[SOUTH][GREEN] = Color.green;
                _lights[SOUTH][YELLOW] = Color.black;
                _lights[SOUTH][RED] = Color.black;
            }
            else if (color.compareTo("YELLOW") == 0)
            {
                _lights[NORTH][GREEN] = Color.black;
                _lights[NORTH][YELLOW] = Color.yellow;
                _lights[NORTH][RED] = Color.black;
                _lights[SOUTH][GREEN] = Color.black;
                _lights[SOUTH][YELLOW] = Color.yellow;
                _lights[SOUTH][RED] = Color.black;
            }
        }
        return;
    }

    public void InformCanvas(String greenlight)
    {
        // Tell the owning canvas that the light has changed.
        // Also tell the canvas if a light is now green.
        if (greenlight.compareTo("YELLOW") == 0)
        {
            _owner.lightChanged(TrafficCanvas.YELLOW_LIGHT);
        }
        else if (greenlight.compareTo("EastWest") == 0)
        {
            _owner.lightChanged(TrafficCanvas.EW_LIGHT);
        }
        else
        {
            _owner.lightChanged(TrafficCanvas.NS_LIGHT);
        }

        return;
    }

    public void SetTimer(String direction)
    {
        int duration;

        if (direction.compareTo("NorthSouth") == 0)
        {
            duration = _nsLightDuration;
        }
        else if (direction.compareTo("EastWest") == 0)
        {
            duration = _ewLightDuration;
        }
        else
        {
            duration = _yellowDuration;
        }

        SetTimer(duration);

        return;
    }

    public void SetTimer(int duration)
    {
        // Remember when this timer was set and how long it
        // lasts. This information is needed for pausing and
        // continuing.
        _timerStart = new java.util.Date();
        _timerDuration = duration;

        // If the timer already exists, then get rid of it.
        if (_stoplightTimer != null)
        {
            // If the timer is running, then stop it, reset
            // its timeout value and run it again.
            if (_stoplightTimer.isRunning() == true)
            {
                _stoplightTimer.stop();
            }

            _stoplightTimer = null;
        }

        _stoplightTimer = new Timer(_timerDuration,
                                    new StoplightTimeoutListener(this));
        _stoplightTimer.setRepeats(false);
        _stoplightTimer.start();

        return;
    }

    public void PauseTimer()
    {
        // Figure out how much time is left on the timer and
        // use that value when continuing the timer.
        java.util.Date currTime = new java.util.Date();

        // Stop the timer now and do the calculations after.
        if (_stoplightTimer != null &&
            _stoplightTimer.isRunning() == true)
        {
            _stoplightTimer.stop();
        }

        _timerDuration = _timerDuration -
                (int) (currTime.getTime() - _timerStart.getTime());
        if (_timerDuration < 0)
        {
            _timerDuration = 0;
        }
        _timerStart = null;

        return;
    }

    public void ContinueTimer()
    {
        // Pick up where we left off by restarting the timer.
        SetTimer(_timerDuration);

        return;
    }

    public void StopTimer()
    {
        // Stop the timer and clear the timer data.
        if (_stoplightTimer != null &&
            _stoplightTimer.isRunning() == true)
        {
            _stoplightTimer.stop();
        }
        _stoplightTimer = null;
        _timerDuration = 0;
        _timerStart = null;

        return;
    }

// Member data.

    //----------------------------------------
    // Dynamic data.
    //
    // private StoplightContext _fsm;
    private Point[] _positions;
    private Dimension _size;
    private TrafficCanvas _owner;
    private StoplightContext _fsm;

    // Keep track of each light's current color.
    private Color[][] _lights;

    // Remember when the timer was started and how long the
    // timer is running.
    private java.util.Date _timerStart;
    private int _timerDuration;
    private Timer _stoplightTimer;

    // Stop light timing.
    private int _nsLightDuration;
    private int _ewLightDuration;
    private int _yellowDuration;

    //----------------------------------------
    // Static data.
    //
    public static final int NORTH = 0;
    public static final int EAST = 1;
    public static final int SOUTH = 2;
    public static final int WEST = 3;

    private static final int LAMP_DIAMETER = 6;
    private static final int LAMP_SPACE = 3;
    private static final int GREEN = 0;
    private static final int YELLOW = 1;
    private static final int RED = 2;


    //----------------------------------------
    // Nested classes.
    //
    private final class StoplightTimeoutListener
        implements ActionListener
    {
        public StoplightTimeoutListener(Stoplight owner)
        {
            _owner = owner;
        }

        public void actionPerformed(ActionEvent e)
        {
            _owner.handleTimeout();
            return;
        }

        private Stoplight _owner;
    }
}
