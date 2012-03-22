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
# Vehicle --
#
#  Draws a generic vehicle on the map (a black square) which
#  moves in straight lines along the road and obeys the stop light.
#
# RCS ID
# $Id: VEHICLE.TCL,v 1.7 2009/11/25 22:30:18 cwrapp Exp $
#
# CHANGE LOG
# $Log: VEHICLE.TCL,v $
# Revision 1.7  2009/11/25 22:30:18  cwrapp
# Fixed problem between %fsmclass and sm file names.
#
# Revision 1.6  2008/02/04 12:38:37  fperrad
# fix filename case on linux
#
# Revision 1.5  2005/05/28 18:02:55  cwrapp
# Updated Tcl examples, removed EX6.
#
# Revision 1.0  2003/12/14 20:30:06  charlesr
# Initial revision
#

package require statemap;

source ./VEHICLE_sm.tcl;

namespace eval ::tcl_ex4 {
    class Vehicle {
    # Member data.
        private variable _fsm;

        # The canvas to draw on and the direction this vehicle is
        # moving.
        private variable _canvas;
        private variable _direction;

        # The stoplight object is responsible knowing the road
        # layout. Ask it for all relevant information.
        private variable _stoplight;

        # The canvas' identifier for this square.
        private variable _canvasID -1;

        # The vehicle is 12 pixels x 12 pixels.
        private variable _vehicleSize 6;

        # A 3 pixel separation is to be maintained between vehicles.
        private variable _vehicleSeparation 3;

        # The vehicle's current canvas location. This is the
        # square's upper left hand corner.
        private variable _xpos;
        private variable _ypos;

        # How far this vehicle moves each timeout in pixels.
        private common _speed 2;

        # Move this vehicle along at near movie-refresh rate.
        private variable _redrawRate [expr 1000 / 60];

        # Store the after's timer ID here.
        private variable _timerID -1;

        # Set this flag to true when the vehicle has
        # completed its trip.
        private variable _isDoneFlag;

    # Member functions.
        constructor {stoplight direction canvas} {
            set _fsm [::tcl_ex4::VEHICLEContext #auto $this];

            set _canvas $canvas;
            set _direction $direction;
            set _stoplight $stoplight

            # This vehicle is initially at the road's outside edge.
            # Figure out the road's length.
            set XLength [$_stoplight getRoadLengthX];
            set YLength [$_stoplight getRoadLengthY];
            set LaneWidth [expr [$_stoplight getRoadWidth] / 2];

            set _isDoneFlag false;

            # How far away the vehicle is from the curb.
            set CurbOffset [expr [expr $LaneWidth - $_vehicleSize] / 2];

            switch -exact -- $direction {
                north {
                    set _xpos [expr [expr $XLength / 2] + $CurbOffset];
                    set _ypos [expr $YLength - $_vehicleSize];
                }
                south {
                    set _xpos \
                            [expr [expr $XLength / 2] - \
                            $LaneWidth + $CurbOffset];
                    set _ypos 0;
                }
                east {
                    set _xpos 0;
                    set _ypos [expr [expr $YLength / 2] + $CurbOffset];
                }
                west {
                    set _xpos [expr $XLength - $_vehicleSize];
                    set _ypos [expr [expr $YLength / 2]  - \
                            $LaneWidth + $CurbOffset];
                }
            }

            # Put the vehicle on display.
            set _canvasID \
                    [$_canvas create rect $_xpos \
                    $_ypos \
                    [expr $_xpos + $_vehicleSize] \
                    [expr $_ypos + $_vehicleSize] \
                    -fill black \
                    -outline white];

            # DEBUG
            # Uncomment the following line so that
            # FSM debug output may be seen.
            # $_fsm setDebugFlag 1;
        }

        destructor {
            if {$_timerID >= 0} {
                after cancel $_timerID;
                set _timerID -1;
            }

            $_canvas delete $_canvasID;
        }

        # timeout --
        #
        #   If the vehicle has driven off the canvas, then
        #   delete the vehicle.
        #   Check if the vehicle is at the intersection and the
        #   light is either yellow or red. If yes, then issue a
        #   "LightRed" transition. If all is go, then keep on
        #   truckin.
        #
        # Arugments:
        #   None.
        #
        # Results:
        #   None.

        public method timeout {} {
            set _timerID -1;

            if [OffCanvas] {
                $_fsm TripDone;
            } elseif {[AtIntersection] && \
                    [string compare [$_stoplight getLight $_direction] "green"] != 0} {
                $_fsm LightRed;
            } else {
                $_fsm KeepGoing;
            }

            return -code ok;
        }

        # lightGreen --
        #
        #   The light has turned green. Time to get moving again.
        #
        # Arguments:
        #   None
        #
        # Results:
        #   ok

        public method lightGreen {} {
            $_fsm LightGreen;

            return -code ok;
        }

        # setSpeed --
        #
        #   Set speed for all vehicles.
        #
        # Arguments:
        #   speed   In pixels.
        #
        # Results:
        #   ok if the set was successful; error otherwise.

        public proc setSpeed {speed} {
            if {$speed < 1 || $speed > 10} {
                set Retcode error;
                set Retval "Invalid speed ($speed).";
            } else {
                set _speed $speed;

                set Retcode ok;
                set Retval "";
            }

            return -code $Retcode $Retval;
        }

        # isDone --
        #
        #   Has this vehicle completed its trip?
        #
        # Arguments:
        #   None.
        #
        # Results:
        #   Returns true if the trip is done and false
        #   otherwise.

        public method isDone {} {
            return -code ok $_isDoneFlag;
        }

        # start --
        #
        #   Start this vehicle running.
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
        #   Pause this vehicles' running.
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
        #   Continue this vehicles' running.
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
        #   Stop this vehicles' running.
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

        # State Machine Actions
        #
        # The following methods are called by the state machine.

        # SetTimer --
        #
        #   Set the timer for the next move.
        #
        # Arguments:
        #   None.
        #
        # Results:
        #   ok

        public method SetTimer {} {
            set _timerID [after $_redrawRate [list $this timeout]];

            return -code ok;
        }

        # StopTimer --
        #
        #   Stop the vehicle's timer.
        #
        # Arguments:
        #   None.
        #
        # Results:
        #   ok

        public method StopTimer {} {
            if {$_timerID >= 0} {
                after cancel $_timerID;
                set _timerID -1;
            }

            return -code ok;
        }

        # Move --
        #
        #   1. Calculate the vehicle's new position.
        #   2. Remove the vehicle from the canvas.
        #   3. Draw the vehicles new position.
        #
        # Arguments:
        #   None.
        #
        # Results:
        #   None returned. Side affect of redrawing vehicle.
        
        public method Move {} {
            switch -exact -- $_direction {
                north {
                    set Xmove 0;
                    set Ymove -$_speed;
                }
                south {
                    set Xmove 0;
                    set Ymove $_speed;
                }
                east {
                    set Xmove $_speed;
                    set Ymove 0;
                }
                west {
                    set Xmove -$_speed;
                    set Ymove 0;
                }
            }

            # Erase the vehicle's current position by drawing it white.
            $_canvas move $_canvasID $Xmove $Ymove;

            incr _xpos $Xmove;
            incr _ypos $Ymove;

            return -code ok;
        }

        # RegisterWithLight --
        #
        #   When the light turns green, it will inform us.
        #
        # Arguments:
        #   None.
        #
        # Results:
        #   ok

        public method RegisterWithLight {} {
            $_stoplight registerVehicle $this $_direction;

            return -code ok;
        }

	# SelfDestruct --
	#
	#   Remove the vehicle from the canvas.
	#
	# Arguments:
	#   None.
	#
	# Results:
	#   ok

	public method SelfDestruct {} {
            $_canvas delete $_canvasID;
            set $_canvasID -1;
            set $_isDoneFlag true;

            return -code ok;
	}

        # OffCanvas --
        #
        #   Figure out if the vehicle has driven off the map.
        #
        # Arguments:
        #   None.
        #
        # Results:
        #   Returns true if the vehicle is off the map; otherwise
        #   false.

        private method OffCanvas {} {
            set Retval 0;

            set XLength [$_stoplight getRoadLengthX];
            set YLength [$_stoplight getRoadLengthY];

            switch -exact -- $_direction {
                north {
                    if {[expr $_ypos - $_speed] <= 0} {
                        set Retval 1;
                    }
                }
                south {
                    if {[expr $_ypos + $_speed] >= $YLength} {
                        set Retval 1;
                    }
                }
                east {
                    if {[expr $_xpos + $_speed] >= $XLength} {
                        set Retval 1;
                    }
                }
                west {
                    if {[expr $_xpos - $_speed] <= 0} {
                        set Retval 1;
                    }
                }
            }

            return -code ok $Retval;
        }

        # AtIntersection --
        #
        #   Figure out whether this vehicile is at the intersection
        #   or not.
        #
        # Arguments:
        #   None.
        #
        # Results:
        #   Returns true if the vehicle is at the intersection;
        #   otherwise, false.

        private method AtIntersection {} {	
	    # The vehicle is not at the intersection until proven
	    # otherwise.
	    set Retval 0;

            set XLength [$_stoplight getRoadLengthX];
            set YLength [$_stoplight getRoadLengthY];
            set LaneWidth [expr [$_stoplight getRoadWidth] / 2];

            # Calculate the intersections coordinates based on
            # the vehicle's direction. Then calculate where the
            # vehicle will end up this move. If the vehicle will
            # move beyond the intersection stop line, then the
            # vehicle is at the intersection.
            #
            # Also take into account the vehicles already waiting
            # at the intersection.
            #
            # By the way, once the vehicle moves past the intersection,
            # ignore the light.
            set NumVehicles [$_stoplight getQueueSize $_direction];
            switch -exact -- $_direction {
                north {
                    set YIntersection \
                            [expr [expr $YLength / 2] + \
                            $LaneWidth + \
                            [expr $_vehicleSize / 2] + \
                            [expr $NumVehicles * $_vehicleSize] + \
                            [expr $NumVehicles * $_vehicleSeparation]];
                    if {$_ypos > $YIntersection && \
                            [expr $_ypos - $_speed] <= $YIntersection} {
                        set Retval 1;
                    }
                }
                south {
                    set YIntersection \
                            [expr [expr $YLength / 2] - \
                            $LaneWidth - \
                            [expr $_vehicleSize / 2] - \
                            [expr $NumVehicles * $_vehicleSize] - \
                            [expr $NumVehicles * $_vehicleSeparation]];
                    if {$_ypos < $YIntersection && \
                            [expr $_ypos + $_speed] >= $YIntersection} {
                        set Retval 1;
                    }
                }
                east {
                    set XIntersection \
                            [expr [expr $XLength / 2] - \
                            $LaneWidth - \
                            [expr $_vehicleSize / 2] - \
                            [expr $NumVehicles * $_vehicleSize] - \
                            [expr $NumVehicles * $_vehicleSeparation]];
                    if {$_xpos < $XIntersection && \
                            [expr $_xpos + $_speed] >= $XIntersection} {
                        set Retval 1;
                    }
                }
                west {
                    set XIntersection \
                            [expr [expr $XLength / 2] + \
                            $LaneWidth + \
                            [expr $_vehicleSize / 2] + \
                            [expr $NumVehicles * $_vehicleSize] + \
                            [expr $NumVehicles * $_vehicleSeparation]];
                    if {$_xpos > $XIntersection && \
                            [expr $_xpos - $_speed] <= $XIntersection} {
                        set Retval 1;
                    }
                }
            }

            return -code ok $Retval;
        }
    }
}