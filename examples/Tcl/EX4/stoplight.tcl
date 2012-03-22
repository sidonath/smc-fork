# 
# The contents of this file are subject to the Mozilla Public
# License Version 1.1 (the "License"); you may not use this file
# except in compliance with the License. You may obtain a copy of
# the License at http://www.mozilla.org/MPL/
# 
# Software distributed under the License is distributed on an "AS
# IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
# implied. See the License for the specific language governing
# rights and limitations under the License.
# 
# The Original Code is State Machine Compiler (SMC).
# 
# The Initial Developer of the Original Code is Charles W. Rapp.
# Portions created by Charles W. Rapp are
# Copyright (C) 2000 - 2003 Charles W. Rapp.
# All Rights Reserved.
# 
# Contributor(s):
#
# Stoplight --
#
#  When a timer goes off, change the light's color as per the
#  state machine.
#
# RCS ID
# $Id: stoplight.tcl,v 1.8 2009/11/25 22:30:18 cwrapp Exp $
#
# CHANGE LOG
# $Log: stoplight.tcl,v $
# Revision 1.8  2009/11/25 22:30:18  cwrapp
# Fixed problem between %fsmclass and sm file names.
#
# Revision 1.7  2008/02/04 12:38:37  fperrad
# fix filename case on linux
#
# Revision 1.6  2005/05/28 18:02:56  cwrapp
# Updated Tcl examples, removed EX6.
#
# Revision 1.0  2003/12/14 20:30:35  charlesr
# Initial revision
#

package require statemap;

source ./stoplight_sm.tcl;

namespace eval tcl_ex4 {
    class Stoplight {
    # Member data.
        private variable _fsm;

	# Store here how long each light is supposed to last.
	private variable _timeouts;

        # Store the Tcl timer ID here.
        private variable _timerID;

        private variable _canvas;
        private variable _east_light;
        private variable _west_light;
        private variable _north_light;
        private variable _south_light;

        private variable _roadWidth 38;
        private variable _lightDiameter 6;
        private variable _lightSpace 2;
        private variable _lightWidth;
        private variable _lightHeight;

	# List of vehicles waiting for the light to turn green
        # in a given direction.
	private variable _northVehicleList;
	private variable _southVehicleList;
	private variable _eastVehicleList;
        private variable _westVehicleList;

    # Member functions.
        constructor {canvas} {
            set _fsm [::tcl_ex4::stoplightContext #auto $this];

            set _canvas $canvas;
            
            # Set the light height and width.
            set _lightWidth \
                    [expr $_lightDiameter + [expr $_lightSpace * 2]];
            set _lightHeight \
                    [expr [expr $_lightDiameter * 3] + \
                    [expr $_lightSpace * 4]];
            
            set _northVehicleList {};
            set _southVehicleList {};
            set _eastVehicleList {};
            set _westVehicleList {};

            # Create the stoplight GUI. Draw the roads.
            DrawRoads;
            
            # Draw the stoplights.
            DrawLights;

            # Set each light timer.
            array set _timeouts \
                    [list NSGreenTimer 7000 \
                    EWGreenTimer 5000 \
                    YellowTimer 2000];

            set _timerID -1;

            # DEBUG
            # Uncomment the following line so that
            # FSM debug output may be seen.
            # $_fsm setDebugFlag 1;
        }

	# getRoadLengthX --
	#
	#   Return the road's length in Y direction.
	#
	# Arguments:
	#   None.
	#
	# Results:
	#   Pixel length of road in X direction.

	public method getRoadLengthX {} {
            return -code ok [$_canvas cget -width];
	}

	# getRoadLengthY --
	#
	#   Return the road's length in Y direction in pixels.
	#
	# Arguments:
	#   None.
	#
	# Results:
	#   Pixel length of road in Y direction.

	public method getRoadLengthY {} {
            return -code ok [$_canvas cget -height];
	}

	# getRoadWidth --
	#
	#   Return road's width in pixels.
	#
	# Arguments:
	#   None.
	#
	# Results:
	#   Road's width in pixels.

	public method getRoadWidth {} {
            return -code ok $_roadWidth;
	}

	# getLight --
	#
	#   Return a specified stop lights color.
	#
	# Arguments:
	#   direction   Must be either north, south east or west.
	#
	# Results:
	#   Returns the color for that direction.

	public method getLight {direction} {
            set Retcode ok;

            # The direction represents which way the vehicle
            # is facing. This is the opposite direction in which
            # the light is facing.
            switch -exact -- $direction {
                north {
                    set RedLight [$_canvas itemcget $_south_light(RED) -fill];
                    set YellowLight [$_canvas itemcget $_south_light(YELLOW) -fill];
                    set GreenLight [$_canvas itemcget $_south_light(GREEN) -fill];
                }
                south {
                    set RedLight [$_canvas itemcget $_north_light(RED) -fill];
                    set YellowLight [$_canvas itemcget $_north_light(YELLOW) -fill];
                    set GreenLight [$_canvas itemcget $_north_light(GREEN) -fill];
                }
                east {
                    set RedLight [$_canvas itemcget $_west_light(RED) -fill];
                    set YellowLight [$_canvas itemcget $_west_light(YELLOW) -fill];
                    set GreenLight [$_canvas itemcget $_west_light(GREEN) -fill];
                }
                west {
                    set RedLight [$_canvas itemcget $_east_light(RED) -fill];
                    set YellowLight [$_canvas itemcget $_east_light(YELLOW) -fill];
                    set GreenLight [$_canvas itemcget $_east_light(GREEN) -fill];
                }
                default {
                    set Retcode error;
                    set Retval "Stoplight::getLight: \"$direction\" is an invalid direction.";
                }
            }

            if {[string compare $Retcode "ok"] == 0} {
                if {[string compare $RedLight "red"] == 0} {
                    set Retval red;
                } elseif {[string compare $YellowLight "yellow"] == 0} {
                    set Retval yellow;
                } else {
                    set Retval green;
                }
            }

            return -code $Retcode $Retval;
	}

	# registerVehicle --
	#
	#   A vehicle is waiting for this light to turn green.
	#   Add it to the list. When the light turns green,
	#   the vehicle will be told about it.
	#
	# Arguments:
	#   vehicle    A vehicle object name.
        #   direction  The direction the vehicle is moving.
	#
	# Results:
	#   ok

	public method registerVehicle {vehicle direction} {
            switch -exact -- $direction {
                north {
                    lappend _northVehicleList $vehicle;
                }
                south {
                    lappend _southVehicleList $vehicle;
                }
                east {
                    lappend _eastVehicleList $vehicle;
                }
                west {
                    lappend _westVehicleList $vehicle;
                }
            }

            return -code ok;
	}

        # getQueueSize --
        #
        #   Return the number of vehicles waiting on a red in
        #   a particular direction.
        #
        # Arguments:
        #   direction   The direction the vehicle is moving.
        #
        # Results:
        #   The size of the red light queue for that direction.

        public method getQueueSize {direction} {
            switch -exact -- $direction {
                north {
                    set Retval [llength $_northVehicleList];
                }
                south {
                    set Retval [llength $_southVehicleList];
                }
                east {
                    set Retval [llength $_eastVehicleList];
                }
                west {
                    set Retval [llength $_westVehicleList];
                }
            }

            return -code ok $Retval;
        }

        # setLightTimer --
        #
        #   Set a particular light's timer. The value is given in
        #   seconds, so convert to milliseconds.
        #
        # Arguments:
        #   light    NSGreenTimer, EWGreenTimer or YellowTimer.
        #   time     Light time in seconds.
        #
        # Results:
        #   ok

        public method setLightTimer {light time} {
            set _timeouts($light) [expr $time * 1000];

            return -code ok;
        }

        # start --
        #
        #   Start the demo running.
        #
        # Arguments:
        #   None.
        #
        # Results:
        #   ok

        public method start {} {
            $_fsm Start;
            return -code ok;
        }

        # pause --
        #
        #   Pause this demo.
        #
        # Arguments:
        #   None.
        #
        # Results:
        #   ok

        public method pause {} {
            $_fsm Pause;
            return -code ok;
        }

        # continue --
        #
        #   Continue this demo.
        #
        # Arguments:
        #   None.
        #
        # Results:
        #   ok

        public method continue {} {
            $_fsm Continue;
            return -code ok;
        }

        # stop --
        #
        #   Stop this demo.
        #
        # Arguments:
        #   None.
        #
        # Results:
        #   ok

        public method stop {} {
            $_fsm Stop;
            return -code ok;
        }

        # State Machine Actions.
        #
        # The following methods are called by the state machine..

        public method TurnLight {direction color} {
            switch -exact -- $direction {
                EWLIGHT {
                    switch -exact -- $color {
                        RED {
                            $_canvas itemconfigure $_east_light(YELLOW) -fill white;
                            $_canvas itemconfigure $_west_light(YELLOW) -fill white;
                            $_canvas itemconfigure $_east_light(RED) -fill red;
                            $_canvas itemconfigure $_west_light(RED) -fill red;
                        }
                        GREEN {
                            $_canvas itemconfigure $_east_light(RED) -fill white;
                            $_canvas itemconfigure $_west_light(RED) -fill white;
                            $_canvas itemconfigure $_east_light(GREEN) -fill green;
                            $_canvas itemconfigure $_west_light(GREEN) -fill green;
                        }
                        YELLOW {
                            $_canvas itemconfigure $_east_light(GREEN) -fill white;
                            $_canvas itemconfigure $_west_light(GREEN) -fill white;
                            $_canvas itemconfigure $_east_light(YELLOW) -fill yellow;
                            $_canvas itemconfigure $_west_light(YELLOW) -fill yellow;
                        }
                    }
                }
                NSLIGHT {
                    switch -exact -- $color {
                        RED {
                            $_canvas itemconfigure $_north_light(YELLOW) -fill white;
                            $_canvas itemconfigure $_south_light(YELLOW) -fill white;
                            $_canvas itemconfigure $_north_light(RED) -fill red;
                            $_canvas itemconfigure $_south_light(RED) -fill red;
                        }
                        GREEN {
                            $_canvas itemconfigure $_north_light(RED) -fill white;
                            $_canvas itemconfigure $_south_light(RED) -fill white;
                            $_canvas itemconfigure $_north_light(GREEN) -fill green;
                            $_canvas itemconfigure $_south_light(GREEN) -fill green;
                        }
                        YELLOW {
                            $_canvas itemconfigure $_north_light(GREEN) -fill white;
                            $_canvas itemconfigure $_south_light(GREEN) -fill white;
                            $_canvas itemconfigure $_north_light(YELLOW) -fill yellow;
                            $_canvas itemconfigure $_south_light(YELLOW) -fill yellow;
                        }
                    }
                }
            }
        }

        public method SetTimer {timer} {
            set _timerID [after $_timeouts($timer) [list $this Timeout]];
            return -code ok;
        }

        public method StopTimer {} {
            if {$_timerID >= 0} {
                after cancel $_timerID;
                set _timerID -1;
            }

            return -code ok;
        }

        public method Timeout {} {
            set _timerID -1;
            $_fsm Timeout;

            return -code ok;
        }

        public method ResetLights {} {
            $_canvas itemconfigure $_east_light(YELLOW) -fill white;
            $_canvas itemconfigure $_west_light(YELLOW) -fill white;
            $_canvas itemconfigure $_east_light(RED) -fill white;
            $_canvas itemconfigure $_west_light(RED) -fill white;
            $_canvas itemconfigure $_east_light(GREEN) -fill white;
            $_canvas itemconfigure $_west_light(GREEN) -fill white;

            $_canvas itemconfigure $_north_light(YELLOW) -fill white;
            $_canvas itemconfigure $_south_light(YELLOW) -fill white;
            $_canvas itemconfigure $_north_light(RED) -fill white;
            $_canvas itemconfigure $_south_light(RED) -fill white;
            $_canvas itemconfigure $_north_light(GREEN) -fill white;
            $_canvas itemconfigure $_south_light(GREEN) -fill white;

            return -code ok;
        }

	# InformVehicles --
	#
	#   Tell the vehicles that were waiting on the green light
	#   that they can go now.
	#
	# Arguments:
	#   direction   Which light turned green.
	#
	# Results:
	#   ok

	public method InformVehicles {direction} {
            switch -exact -- $direction {
                north {
                    foreach Vehicle $_northVehicleList {
                        catch "$Vehicle lightGreen";
                    }
                    set _northVehicleList {};
                }
                south {
                    foreach Vehicle $_southVehicleList {
                        catch "$Vehicle lightGreen";
                    }
                    set _southVehicleList {};
                }
                east {
                    foreach Vehicle $_eastVehicleList {
                        catch "$Vehicle lightGreen";
                    }
                    set _eastVehicleList {};
                }
                west {
                    foreach Vehicle $_westVehicleList {
                        catch "$Vehicle lightGreen";
                    }
                    set _westVehicleList {};
                }
            }

            return -code ok;
	}

        private method DrawRoads {} {
            # The roads are drawn as follows:
            #
            #        (x2,y1)   (x4,y1)
            #             |  |  |
            #             |     |
            #             |  |  |
            # (x1,y2)     |     |       (x5,y2)
            # ------------+  |  +------------
            #         (x2,y2) (x4,y2)    
            # - - - - - -        - - - - - -
            #         (x2,y4) (x4,y4)   (x5,y4)
            # ------------+     +------------
            # (x1,y4)     |  |  |
            #             |     |
            #             |  |  |
            #             |     |
            #        (x2,y5) |(x4,y5)

            # Calculate the line segment's length.
            set XLength [expr [expr [getRoadLengthX] / 2] - \
                    [expr $_roadWidth / 2]];
            set YLength [expr [expr [getRoadLengthY] / 2] - \
                    [expr $_roadWidth / 2]];
            
            # Calculate the major coordinates.
            set X1 0;
            set Y1 0;
            set X2 $XLength;
            set Y2 $YLength;
            set X3 [expr [$_canvas cget -width] / 2];
            set Y3 [expr [$_canvas cget -height] / 2];
            set X4 [expr [$_canvas cget -width] - $XLength];
            set Y4 [expr [$_canvas cget -height] - $YLength];
            set X5 [$_canvas cget -width];
            set Y5 [$_canvas cget -height];
            
            # Put green lawns around the road.
            $_canvas create rect $X1 $Y1 $X2 $Y2 -outline "" -fill green;
            $_canvas create rect $X1 $Y4 $X2 $Y5 -outline "" -fill green;
            $_canvas create rect $X4 $Y4 $X5 $Y5 -outline "" -fill green;
            $_canvas create rect $X4 $Y1 $X5 $Y2 -outline "" -fill green;

            # Draw four connected lines where each drawing uses three
            # coordinates.
            $_canvas create line $X1 $Y2 $X2 $Y2 $X2 $Y1;
            $_canvas create line $X4 $Y1 $X4 $Y2 $X5 $Y2;
            $_canvas create line $X1 $Y4 $X2 $Y4 $X2 $Y5;
            $_canvas create line $X4 $Y5 $X4 $Y4 $X5 $Y4;
            
            # Now draw the lane markings.
            $_canvas create line $X1 $Y3 $X2 $Y3;
            $_canvas create line $X3 $Y1 $X3 $Y2;
            $_canvas create line $X4 $Y3 $X5 $Y3;
            $_canvas create line $X3 $Y4 $X3 $Y5;

            return -code ok;
        }

        private method DrawLights {} {
            # The lights are drawns as follows:
            #
            #  y1          +---+
            #              | o |green
            #              | o |yellow
            #              | o |red
            #  y2  +-------+---+-------+
            #      | o o o |   | o o o |
            #  y3  +-------+---+-------+
            #              | o |red
            #              | o |yellow
            #              | o |green
            #  y4          +---+
            #
            #    x1       x2   x3     x4
            # Store each light as a separate element in a table.
            
            # Figure out the coordinates for the stoplights.
            set X1 [expr [expr [$_canvas cget -width] / 2] - \
                    [expr $_lightWidth / 2] - $_lightHeight];
            set Y1 [expr [expr [$_canvas cget -height] / 2] - \
                    [expr $_lightWidth / 2] - $_lightHeight];
            set X2 [expr $X1 + $_lightHeight];
            set Y2 [expr $Y1 + $_lightHeight];
            set X3 [expr $X2 + $_lightWidth];
            set Y3 [expr $Y2 + $_lightWidth];
            set X4 [expr $X3 + $_lightHeight];
            set Y4 [expr $Y3 + $_lightHeight];
            
            # Draw the four stop lights boxes.
            $_canvas create rect $X2 $Y1 $X3 $Y2 -outline black -fill black -width 1;
            $_canvas create rect $X1 $Y2 $X2 $Y3 -outline black -fill black -width 1;
            $_canvas create rect $X2 $Y3 $X3 $Y4 -outline black -fill black -width 1;
            $_canvas create rect $X3 $Y2 $X4 $Y3 -outline black -fill black -width 1;
            
            # Draw the lights within the stoplights. Save the
            # canvas items into an array because they will be
            # referenced later. Because there are two lights
            set _north_light(RED) \
                    [$_canvas create oval [expr $X2 + $_lightSpace] \
                    [expr $Y1 + $_lightSpace] \
                    [expr $X3 - $_lightSpace] \
                    [expr $Y1 + \
                    $_lightSpace + \
                    $_lightDiameter] \
                    -outline black -fill white];
            set _north_light(YELLOW) \
                    [$_canvas create oval [expr $X2 + $_lightSpace] \
                    [expr $Y1 + \
                    [expr $_lightSpace * 2] + \
                    $_lightDiameter] \
                    [expr $X3 - $_lightSpace] \
                    [expr $Y1 + \
                    [expr $_lightSpace * 2] + \
                    [expr $_lightDiameter * 2]] \
                    -outline black -fill white];
            set _north_light(GREEN) \
                    [$_canvas create oval [expr $X2 + $_lightSpace] \
                    [expr $Y1 + \
                    [expr $_lightSpace * 3] + \
                    [expr $_lightDiameter * 2]] \
                    [expr $X3 - $_lightSpace] \
                    [expr $Y1 + \
                    [expr $_lightSpace * 3] + \
                    [expr $_lightDiameter * 3]] \
                    -outline black -fill white];
            
            set _west_light(RED) \
                    [$_canvas create oval [expr $X1 + $_lightSpace] \
                    [expr $Y2 + $_lightSpace] \
                    [expr $X1 + \
                    $_lightSpace + \
                    $_lightDiameter] \
                    [expr $Y3 - $_lightSpace] \
                    -outline black -fill white];
            set _west_light(YELLOW) \
                    [$_canvas create oval [expr $X1 + \
                    [expr $_lightSpace * 2] + \
                    $_lightDiameter] \
                    [expr $Y2 + $_lightSpace] \
                    [expr $X1 + \
                    [expr $_lightSpace * 2] + \
                    [expr $_lightDiameter * 2]] \
                    [expr $Y3 - $_lightSpace] \
                    -outline black -fill white];
            set _west_light(GREEN) \
                    [$_canvas create oval [expr $X1 + \
                    [expr $_lightSpace * 3] + \
                    [expr $_lightDiameter * 2]] \
                    [expr $Y2 + $_lightSpace] \
                    [expr $X1 + \
                    [expr $_lightSpace * 3] + \
                    [expr $_lightDiameter * 3]] \
                    [expr $Y3 - $_lightSpace] \
                    -outline black -fill white];
            
            set _south_light(GREEN) \
                    [$_canvas create oval [expr $X2 + $_lightSpace] \
                    [expr $Y3 + $_lightSpace] \
                    [expr $X3 - $_lightSpace] \
                    [expr $Y3 + \
                    $_lightSpace + \
                    $_lightDiameter] \
                    -outline black -fill white];
            set _south_light(YELLOW) \
                    [$_canvas create oval [expr $X2 + $_lightSpace] \
                    [expr $Y3 + \
                    [expr $_lightSpace * 2] + \
                    $_lightDiameter] \
                    [expr $X3 - $_lightSpace] \
                    [expr $Y3 + \
                    [expr $_lightSpace * 2] + \
                    [expr $_lightDiameter * 2]] \
                    -outline black -fill white];
            set _south_light(RED) \
                    [$_canvas create oval [expr $X2 + $_lightSpace] \
                    [expr $Y3 + \
                    [expr $_lightSpace * 3] + \
                    [expr $_lightDiameter * 2]] \
                    [expr $X3 - $_lightSpace] \
                    [expr $Y3 + \
                    [expr $_lightSpace * 3] + \
                    [expr $_lightDiameter * 3]] \
                    -outline black -fill white];
            
            set _east_light(GREEN) \
                    [$_canvas create oval [expr $X3 + $_lightSpace] \
                    [expr $Y2 + $_lightSpace] \
                    [expr $X3 + \
                    $_lightSpace + \
                    $_lightDiameter] \
                    [expr $Y3 - $_lightSpace] \
                    -outline black -fill white];
            set _east_light(YELLOW) \
                    [$_canvas create oval [expr $X3 + \
                    [expr $_lightSpace * 2] + \
                    $_lightDiameter] \
                    [expr $Y2 + $_lightSpace] \
                    [expr $X3 + \
                    [expr $_lightSpace * 2] + \
                    [expr $_lightDiameter * 2]] \
                    [expr $Y3 - $_lightSpace] \
                    -outline black -fill white];
            set _east_light(RED) \
                    [$_canvas create oval [expr $X3 + \
                    [expr $_lightSpace * 3] + \
                    [expr $_lightDiameter * 2]] \
                    [expr $Y2 + $_lightSpace] \
                    [expr $X3 + \
                    [expr $_lightSpace * 3] + \
                    [expr $_lightDiameter * 3]] \
                    [expr $Y3 - $_lightSpace] \
                    -outline black -fill white];
        }
    }
}