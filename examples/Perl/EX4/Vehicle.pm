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
#       Port to Perl by Francois Perrad, francois.perrad@gadz.org
#
# Vehicle --
#
#  Draws a generic vehicle on the map (a black square) which
#  moves in straight lines along the road and obeys the stop light.
#
# RCS ID
# $Id: Vehicle.pm,v 1.3 2009/04/22 19:07:03 fperrad Exp $
#
# CHANGE LOG
# $Log: Vehicle.pm,v $
# Revision 1.3  2009/04/22 19:07:03  fperrad
# Added enterStartState method
#
# Revision 1.2  2008/02/04 12:40:28  fperrad
# some Perl Best Practices
#
# Revision 1.1  2005/06/16 18:04:15  fperrad
# Added Perl examples 1 - 4 and 7.
#
#

use strict;
use warnings;

use Vehicle_sm;

package Vehicle;

our $_speed;

sub BEGIN {
    $_speed = 2;
}

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my ($stoplight, $direction, $canvas) = @_;
    my $self = {};
    bless($self, $class);
    $self->{_fsm} = new smc_ex4::Vehicle_sm($self);

    # The canvas to draw on and the direction this vehicle is
    # moving.
    $self->{_canvas} = $canvas;
    $self->{_direction} = $direction;

    # The stoplight object is responsible knowing the road
    # layout. Ask it for all relevant information.
    $self->{_stoplight} = $stoplight;

    # This vehicle is initially at the road's outside edge.
    # Figure out the road's length.
    my $XLength = $stoplight->getRoadLengthX();
    my $YLength = $stoplight->getRoadLengthY();
    my $LaneWidth = $stoplight->getRoadWidth() / 2;

    # The vehicle is 12 pixels x 12 pixels.
    $self->{_vehicleSize} = 6;

    # A 3 pixel separation is to be maintained between vehicles.
    $self->{_vehicleSeparation} = 3;

    # How far away the vehicle is from the curb.
    my $CurbOffset = ($LaneWidth - $self->{_vehicleSize}) / 2;

    # The vehicle's current canvas location. This is the
    # square's upper left hand corner.
    if      ($direction eq 'north') {
        $self->{_xpos} = ($XLength / 2) + $CurbOffset;
        $self->{_ypos} = $YLength - $self->{_vehicleSize};
    }
    elsif ($direction eq 'south') {
        $self->{_xpos} = ($XLength / 2) - $LaneWidth + $CurbOffset;
        $self->{_ypos} = 0;
    }
    elsif ($direction eq 'east') {
        $self->{_xpos} = 0;
        $self->{_ypos} = ($YLength / 2) + $CurbOffset;
    }
    elsif ($direction eq 'west') {
        $self->{_xpos} = $XLength - $self->{_vehicleSize};
        $self->{_ypos} = ($YLength / 2) - $LaneWidth + $CurbOffset;
    }

    # Put the vehicle on display.
    $self->{_canvasID} = $canvas->createRectangle(
            $self->{_xpos},
            $self->{_ypos},
            $self->{_xpos} + $self->{_vehicleSize},
            $self->{_ypos} + $self->{_vehicleSize},
            -fill => 'black',
            -outline => 'white',
    );

    # Move this vehicle along at near movie-refresh rate.
    $self->{_redrawRate} = 1000 / 60;

    # Store the after's timer ID here.
    $self->{_timerID} = -1;

    # Set this flag to true when the vehicle has
    # completed its trip.
    $self->{_isDoneFlag} = undef;

    # Uncomment to see debug output.
    #$self->{_fsm}->setDebugFlag(1);

    return $self;
}

sub Delete {
    my $self = shift;
    if ($self->{_timerID} >= 0) {
        $self->{_canvas}->after('cancel', $self->{_timerID});
        $self->{_timerID} = -1;
    }
    $self->{_canvas}->delete($self->{_canvasID});
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

sub timeout {
    my $self = shift;
    $self->{_timerID} = -1;
    if ($self->OffCanvas()) {
        $self->{_fsm}->TripDone();
    }
    elsif ($self->AtIntersection() and $self->getLight() ne 'green') {
        $self->{_fsm}->LightRed();
    }
    else {
        $self->{_fsm}->KeepGoing();
    }
}

sub getLight {
    my $self = shift;
    return $self->{_stoplight}->getLight($self->{_direction});
}

# lightGreen --
#
#   The light has turned green. Time to get moving again.
#
# Arguments:
#   None

sub lightGreen {
    my $self = shift;
    $self->{_fsm}->LightGreen();
}

# setSpeed --
#
#   Set speed for all vehicles.
#
# Arguments:
#   speed   In pixels.

sub setSpeed {
    my ($speed) = @_;
    if ($speed < 1 || $speed > 10) {
        warn "Invalid speed ($speed).\n";
    }
    else {
        $_speed = $speed;
    }
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

sub isDone {
    my $self = shift;
    return $self->{_isDoneFlag};
}

# start --
#
#   Start this vehicle running.
#
# Arguments:
#   None.

sub Start {
    my $self = shift;
    $self->{_fsm}->enterStartState();
    $self->{_fsm}->Start();
}

# pause --
#
#   Pause this vehicles' running.
#
# Arguments:
#   None.

sub Pause {
    my $self = shift;
    $self->{_fsm}->Pause();
}

# continue --
#
#   Continue this vehicles' running.
#
# Arguments:
#   None.

sub Continue {
    my $self = shift;
    $self->{_fsm}->Continue();
}

# stop --
#
#   Stop this vehicles' running.
#
# Arguments:
#   None.
#

sub Stop {
    my $self = shift;
    $self->{_fsm}->Stop();
    $self->Delete();
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

sub SetTimer {
    my $self = shift;
    $self->{_timerID} = $self->{_canvas}->after($self->{_redrawRate},
        sub { $self->timeout(); }
    );
}

# StopTimer --
#
#   Stop the vehicle's timer.
#
# Arguments:
#   None.

sub StopTimer {
    my $self = shift;
    if ($self->{_timerID} >= 0) {
        $self->{_canvas}->after('cancel', $self->{_timerID});
        $self->{_timerID} = -1;
    }
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

sub Move {
    my $self = shift;

    my ($Xmove, $Ymove);
    if    ($self->{_direction} eq 'north') {
        $Xmove = 0;
        $Ymove = - $_speed;
    }
    elsif ($self->{_direction} eq 'south') {
        $Xmove = 0;
        $Ymove = $_speed;
    }
    elsif ($self->{_direction} eq 'east') {
        $Xmove = $_speed;
        $Ymove = 0;
    }
    elsif ($self->{_direction} eq 'west') {
        $Xmove = - $_speed;
        $Ymove = 0;
    }

    $self->{_canvas}->move($self->{_canvasID}, $Xmove, $Ymove);

    $self->{_xpos} += $Xmove;
    $self->{_ypos} += $Ymove;
}

# RegisterWithLight --
#
#   When the light turns green, it will inform us.
#
# Arguments:
#   None.

sub RegisterWithLight {
    my $self = shift;
    $self->{_stoplight}->registerVehicle($self, $self->{_direction});
}

# SelfDestruct --
#
#   Remove the vehicle from the canvas.
#
# Arguments:
#   None.

sub SelfDestruct {
    my $self = shift;
    $self->{_canvas}->delete($self->{_canvasID});
    $self->{_canvasID} = -1;
    $self->{_isDoneFlag} = 1;
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

sub OffCanvas {
    my $self = shift;

    if    ($self->{_direction} eq 'north') {
        return ($self->{_ypos} - $_speed) <= 0;
    }
    elsif ($self->{_direction} eq 'south') {
        my $YLength = $self->{_stoplight}->getRoadLengthY();
        return ($self->{_ypos} + $_speed) >= $YLength;
    }
    elsif ($self->{_direction} eq 'east') {
        my $XLength = $self->{_stoplight}->getRoadLengthX();
        return ($self->{_xpos} + $_speed) >= $XLength;
    }
    elsif ($self->{_direction} eq 'west') {
        return ($self->{_xpos} - $_speed) <= 0;
    }
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

sub AtIntersection {
    my $self = shift;
    # The vehicle is not at the intersection until proven
    # otherwise.
    my $Retval = undef;

    my $XLength = $self->{_stoplight}->getRoadLengthX();
    my $YLength = $self->{_stoplight}->getRoadLengthY();
    my $LaneWidth = $self->{_stoplight}->getRoadWidth() / 2;

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
    my $NumVehicles = $self->{_stoplight}->getQueueSize($self->{_direction});
    my $LenVehicles = ($self->{_vehicleSize} + $self->{_vehicleSeparation}) * $NumVehicles;
    if    ($self->{_direction} eq 'north') {
        my $YIntersection = ($YLength / 2) + $LaneWidth
         + ($self->{_vehicleSize} / 2) + $LenVehicles;
        $Retval = ($self->{_ypos} > $YIntersection)
         && ($self->{_ypos} - $_speed <= $YIntersection);
    }
    elsif ($self->{_direction} eq 'south') {
        my $YIntersection = ($YLength / 2) - $LaneWidth
         - ($self->{_vehicleSize} / 2) - $LenVehicles;
        $Retval = ($self->{_ypos} < $YIntersection)
         && ($self->{_ypos} + $_speed >= $YIntersection);
    }
    elsif ($self->{_direction} eq 'east') {
        my $XIntersection = ($XLength / 2) - $LaneWidth
         - ($self->{_vehicleSize} / 2) - $LenVehicles;
        $Retval = ($self->{_xpos} < $XIntersection)
         && ($self->{_xpos} + $_speed >= $XIntersection);
    }
    elsif ($self->{_direction} eq 'west') {
        my $XIntersection = ($XLength / 2) + $LaneWidth
         + ($self->{_vehicleSize} / 2) + $LenVehicles;
        $Retval = ($self->{_xpos} > $XIntersection)
         && ($self->{_xpos} - $_speed <= $XIntersection);
    }
    return $Retval;
}

1;
