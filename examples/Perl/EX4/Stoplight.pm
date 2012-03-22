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
# Stoplight --
#
#  When a timer goes off, change the light's color as per the
#  state machine.
#
# RCS ID
# $Id: Stoplight.pm,v 1.3 2009/04/22 19:07:03 fperrad Exp $
#
# CHANGE LOG
# $Log: Stoplight.pm,v $
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

use Stoplight_sm;

package Stoplight;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my ($canvas) = @_;
    my $self = {
            _canvas => $canvas,
    };
    bless($self, $class);
    # Create the stop light's state machine.
    $self->{_fsm} = new smc_ex4::Stoplight_sm($self);

    $self->{_east_light} = {};
    $self->{_west_light} = {};
    $self->{_north_light} = {};
    $self->{_south_light} = {};
    $self->{_roadWidth} = 38;
    $self->{_lightDiameter} = 6;
    $self->{_lightSpace} = 2;

    # Set the light height and width.
    $self->{_lightWidth} = $self->{_lightDiameter} + $self->{_lightSpace} * 2;
    $self->{_lightHeight} = $self->{_lightDiameter} * 3 + $self->{_lightSpace} * 4;

    $self->{_northVehicleList} = [];
    $self->{_southVehicleList} = [];
    $self->{_eastVehicleList} = [];
    $self->{_westVehicleList} = [];

    # Create the stoplight GUI. Draw the roads.
    $self->DrawRoads();

    # Draw the stoplights.
    $self->DrawLights();

    # Set each light timer.
    $self->{_timeouts} = {
            NSGreenTimer => 7000,
            EWGreenTimer => 5000,
            YellowTimer => 2000,
    };

    $self->{_timerID} = -1;

    # Uncomment to see debug output.
    #$self->{_fsm}->setDebugFlag(1);

    return $self;
}

# getRoadLengthX --
#
#   Return the road's length in X direction.
#
# Arguments:
#   None.
#
# Results:
#   Pixel length of road in X direction.

sub getRoadLengthX {
    my $self = shift;
    return $self->{_canvas}->cget(-width);
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

sub getRoadLengthY {
    my $self = shift;
    return $self->{_canvas}->cget(-height);
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

sub getRoadWidth {
    my $self = shift;
    return $self->{_roadWidth};
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

sub getLight {
    my $self = shift;
    my ($direction) = @_;
    my $cv = $self->{_canvas};

    my ($RedLight, $YellowLight, $GreenLight);
    # The direction represents which way the vehicle
    # is facing. This is the opposite direction in which
    # the light is facing.
    if    ($direction eq 'north') {
        $RedLight = $cv->itemcget($self->{_south_light}->{RED}, -fill);
        $YellowLight = $cv->itemcget($self->{_south_light}->{YELLOW}, -fill);
        $GreenLight = $cv->itemcget($self->{_south_light}->{GREEN}, -fill);
    }
    elsif ($direction eq 'south') {
        $RedLight = $cv->itemcget($self->{_north_light}->{RED}, -fill);
        $YellowLight = $cv->itemcget($self->{_north_light}->{YELLOW}, -fill);
        $GreenLight = $cv->itemcget($self->{_north_light}->{GREEN}, -fill);
    }
    elsif ($direction eq 'east') {
        $RedLight = $cv->itemcget($self->{_west_light}->{RED}, -fill);
        $YellowLight = $cv->itemcget($self->{_west_light}->{YELLOW}, -fill);
        $GreenLight = $cv->itemcget($self->{_west_light}->{GREEN}, -fill);
    }
    elsif ($direction eq 'west') {
        $RedLight = $cv->itemcget($self->{_east_light}->{RED}, -fill);
        $YellowLight = $cv->itemcget($self->{_east_light}->{YELLOW}, -fill);
        $GreenLight = $cv->itemcget($self->{_east_light}->{GREEN}, -fill);
    }

    if    ($RedLight eq 'red') {
        return 'red';
    }
    elsif ($YellowLight eq 'yellow') {
        return 'yellow';
    }
    else {
        return 'green';
    }
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

sub registerVehicle {
    my $self = shift;
    my ($vehicle, $direction) = @_;
    if    ($direction eq 'north') {
        push @{$self->{_northVehicleList}}, $vehicle;
    }
    elsif ($direction eq 'south') {
        push @{$self->{_southVehicleList}}, $vehicle;
    }
    elsif ($direction eq 'east') {
        push @{$self->{_eastVehicleList}}, $vehicle;
    }
    elsif ($direction eq 'west') {
        push @{$self->{_westVehicleList}}, $vehicle;
    }
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

sub getQueueSize {
    my $self = shift;
    my ($direction) = @_;
    if    ($direction eq 'north') {
        return scalar @{$self->{_northVehicleList}};
    }
    elsif ($direction eq 'south') {
        return scalar @{$self->{_southVehicleList}};
    }
    elsif ($direction eq 'east') {
        return scalar @{$self->{_eastVehicleList}};
    }
    elsif ($direction eq 'west') {
        return scalar @{$self->{_westVehicleList}};
    }
}

# setLightTimer --
#
#   Set a particular light's timer. The value is given in
#   seconds, so convert to milliseconds.
#
# Arguments:
#   light    NSGreenTimer, EWGreenTimer or YellowTimer.
#   time     Light time in seconds.

sub setLightTimer {
    my $self = shift;
    my ($light, $time) = @_;
    $self->{_timeouts}->{$light} = $time * 1000;
}

# start --
#
#   Start the demo running.
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
#   Pause this demo.
#
# Arguments:
#   None.

sub Pause {
    my $self = shift;
    $self->{_fsm}->Pause();
}

# continue --
#
#   Continue this demo.
#
# Arguments:
#   None.

sub Continue {
    my $self = shift;
    $self->{_fsm}->Continue();
}

# stop --
#
#   Stop this demo.
#
# Arguments:
#   None.

sub Stop {
    my $self = shift;
    $self->{_fsm}->Stop();
}

# State Machine Actions.
#
# The following methods are called by the state machine..

sub TurnLight {
    my $self = shift;
    my ($direction, $color) = @_;
    my $cv = $self->{_canvas};
    if      ($direction eq 'EWLIGHT') {
        if    ($color eq 'red') {
            $cv->itemconfigure($self->{_east_light}->{YELLOW}, -fill => 'white');
            $cv->itemconfigure($self->{_west_light}->{YELLOW}, -fill => 'white');
            $cv->itemconfigure($self->{_east_light}->{RED}, -fill => 'red');
            $cv->itemconfigure($self->{_west_light}->{RED}, -fill => 'red');
        }
        elsif ($color eq 'green') {
            $cv->itemconfigure($self->{_east_light}->{RED}, -fill => 'white');
            $cv->itemconfigure($self->{_west_light}->{RED}, -fill => 'white');
            $cv->itemconfigure($self->{_east_light}->{GREEN}, -fill => 'green');
            $cv->itemconfigure($self->{_west_light}->{GREEN}, -fill => 'green');
        }
        elsif ($color  eq 'yellow') {
            $cv->itemconfigure($self->{_east_light}->{GREEN}, -fill => 'white');
            $cv->itemconfigure($self->{_west_light}->{GREEN}, -fill => 'white');
            $cv->itemconfigure($self->{_east_light}->{YELLOW}, -fill => 'yellow');
            $cv->itemconfigure($self->{_west_light}->{YELLOW}, -fill => 'yellow');
        }
    }
    elsif ($direction eq 'NSLIGHT') {
        if    ($color eq 'red') {
            $cv->itemconfigure($self->{_north_light}->{YELLOW}, -fill => 'white');
            $cv->itemconfigure($self->{_south_light}->{YELLOW}, -fill => 'white');
            $cv->itemconfigure($self->{_north_light}->{RED}, -fill => 'red');
            $cv->itemconfigure($self->{_south_light}->{RED}, -fill => 'red');
        }
        elsif ($color eq 'green') {
            $cv->itemconfigure($self->{_north_light}->{RED}, -fill => 'white');
            $cv->itemconfigure($self->{_south_light}->{RED}, -fill => 'white');
            $cv->itemconfigure($self->{_north_light}->{GREEN}, -fill => 'green');
            $cv->itemconfigure($self->{_south_light}->{GREEN}, -fill => 'green');
        }
        elsif ($color  eq 'yellow') {
            $cv->itemconfigure($self->{_north_light}->{GREEN}, -fill => 'white');
            $cv->itemconfigure($self->{_south_light}->{GREEN}, -fill => 'white');
            $cv->itemconfigure($self->{_north_light}->{YELLOW}, -fill => 'yellow');
            $cv->itemconfigure($self->{_south_light}->{YELLOW}, -fill => 'yellow');
        }
    }
}

sub SetTimer {
    my $self = shift;
    my ($timer) = @_;
    $self->{_timerID} = $self->{_canvas}->after($self->{_timeouts}->{$timer},
        sub { $self->Timeout(); }
    );
}

sub StopTimer {
    my $self = shift;
    if ($self->{_timerID} >= 0) {
        $self->{_canvas}->after('cancel', $self->{_timerID});
        $self->{_timerID} = -1;
    }
}

sub Timeout {
    my $self = shift;
    $self->{_timerID} = -1;
    $self->{_fsm}->Timeout();
}

sub ResetLights {
    my $self = shift;
    my $cv = $self->{_canvas};

    $cv->itemconfigure($self->{_east_light}->{YELLOW}, -fill => 'white');
    $cv->itemconfigure($self->{_west_light}->{YELLOW}, -fill => 'white');
    $cv->itemconfigure($self->{_east_light}->{RED}, -fill => 'white');
    $cv->itemconfigure($self->{_west_light}->{RED}, -fill => 'white');
    $cv->itemconfigure($self->{_east_light}->{GREEN}, -fill => 'white');
    $cv->itemconfigure($self->{_west_light}->{GREEN}, -fill => 'white');

    $cv->itemconfigure($self->{_north_light}->{YELLOW}, -fill => 'white');
    $cv->itemconfigure($self->{_south_light}->{YELLOW}, -fill => 'white');
    $cv->itemconfigure($self->{_north_light}->{RED}, -fill => 'white');
    $cv->itemconfigure($self->{_south_light}->{RED}, -fill => 'white');
    $cv->itemconfigure($self->{_north_light}->{GREEN}, -fill => 'white');
    $cv->itemconfigure($self->{_south_light}->{GREEN}, -fill => 'white');
}

# InformVehicles --
#
#   Tell the vehicles that were waiting on the green light
#   that they can go now.
#
# Arguments:
#   direction   Which light turned green.

sub InformVehicles {
    my $self = shift;
    my ($direction) = @_;
    if    ($direction eq 'north') {
        foreach my $vehicle (@{$self->{_northVehicleList}}) {
            $vehicle->lightGreen();
        }
        $self->{_northVehicleList} = [];
    }
    elsif ($direction eq 'south') {
        foreach my $vehicle (@{$self->{_southVehicleList}}) {
            $vehicle->lightGreen();
        }
        $self->{_southVehicleList} = [];
    }
    elsif ($direction eq 'east') {
        foreach my $vehicle (@{$self->{_eastVehicleList}}) {
            $vehicle->lightGreen();
        }
        $self->{_eastVehicleList} = [];
    }
    elsif ($direction eq 'west') {
        foreach my $vehicle (@{$self->{_westVehicleList}}) {
            $vehicle->lightGreen();
        }
        $self->{_westVehicleList} = [];
    }
}

sub DrawRoads {
    my $self = shift;
    my $cv = $self->{_canvas};
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
    my $XLength = ($self->getRoadLengthX() / 2) - $self->{_roadWidth} / 2;
    my $YLength = ($self->getRoadLengthY() / 2) - $self->{_roadWidth} / 2;

    # Calculate the major coordinates.
    my $X1 = 0;
    my $Y1 = 0;
    my $X2 = $XLength;
    my $Y2 = $YLength;
    my $X3 = $cv->cget(-width) / 2;
    my $Y3 = $cv->cget(-height) / 2;
    my $X4 = $cv->cget(-width) - $XLength;
    my $Y4 = $cv->cget(-height) - $YLength;
    my $X5 = $cv->cget(-width);
    my $Y5 = $cv->cget(-height);

    # Put green lawns around the road.
    $cv->createRectangle($X1, $Y1, $X2, $Y2,
        -outline => "",
        -fill => 'green',
    );
    $cv->createRectangle($X1, $Y4, $X2, $Y5,
        -outline => "",
        -fill => 'green',
    );
    $cv->createRectangle($X4, $Y4, $X5, $Y5,
        -outline => "",
        -fill => 'green',
    );
    $cv->createRectangle($X4, $Y1, $X5, $Y2,
        -outline => "",
        -fill => 'green',
    );

    # Draw four connected lines where each drawing uses three
    # coordinates.
    $cv->createLine($X1, $Y2, $X2, $Y2, $X2, $Y1);
    $cv->createLine($X4, $Y1, $X4, $Y2, $X5, $Y2);
    $cv->createLine($X1, $Y4, $X2, $Y4, $X2, $Y5);
    $cv->createLine($X4, $Y5, $X4, $Y4, $X5, $Y4);

    # Now draw the lane markings.
    $cv->createLine($X1, $Y3, $X2, $Y3);
    $cv->createLine($X3, $Y1, $X3, $Y2);
    $cv->createLine($X4, $Y3, $X5, $Y3);
    $cv->createLine($X3, $Y4, $X3, $Y5);
}

sub DrawLights {
    my $self = shift;
    my $cv = $self->{_canvas};
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
    my $X1 = $cv->cget(-width) / 2 - $self->{_lightWidth} / 2 - $self->{_lightHeight};
    my $Y1 = $cv->cget(-height) / 2 - $self->{_lightWidth} / 2 - $self->{_lightHeight};
    my $X2 = $X1 + $self->{_lightHeight};
    my $Y2 = $Y1 + $self->{_lightHeight};
    my $X3 = $X2 + $self->{_lightWidth};
    my $Y3 = $Y2 + $self->{_lightWidth};
    my $X4 = $X3 + $self->{_lightHeight};
    my $Y4 = $Y3 + $self->{_lightHeight};

    # Draw the four stop lights boxes.
    $cv->createRectangle($X2, $Y1, $X3, $Y2,
            -outline => 'black',
            -fill => 'black',
            -width => 1,
    );
    $cv->createRectangle($X1, $Y2, $X2, $Y3,
            -outline => 'black',
            -fill => 'black',
            -width => 1,
    );
    $cv->createRectangle($X2, $Y3, $X3, $Y4,
            -outline => 'black',
            -fill => 'black',
            -width => 1,
    );
    $cv->createRectangle($X3, $Y2, $X4, $Y3,
            -outline => 'black',
            -fill => 'black',
            -width => 1,
    );

    # Draw the lights within the stoplights. Save the
    # canvas items into an array because they will be
    # referenced later. Because there are two lights
    $self->{_north_light}->{RED} = $cv->createOval(
            $X2 + $self->{_lightSpace},
            $Y1 + $self->{_lightSpace},
            $X3 - $self->{_lightSpace},
            $Y1 + $self->{_lightSpace} + $self->{_lightDiameter},
            -outline => 'black',
            -fill => 'white'
    );
    $self->{_north_light}->{YELLOW} = $cv->createOval(
            $X2 + $self->{_lightSpace},
            $Y1 + $self->{_lightSpace} * 2 + $self->{_lightDiameter},
            $X3 - $self->{_lightSpace},
            $Y1 + $self->{_lightSpace} * 2 + $self->{_lightDiameter} * 2,
            -outline => 'black',
            -fill => 'white'
    );
    $self->{_north_light}->{GREEN} = $cv->createOval(
            $X2 + $self->{_lightSpace},
            $Y1 + $self->{_lightSpace} * 3 + $self->{_lightDiameter} * 2,
            $X3 - $self->{_lightSpace},
            $Y1 + $self->{_lightSpace} * 3 + $self->{_lightDiameter} * 3,
            -outline => 'black',
            -fill => 'white'
    );

    $self->{_west_light}->{RED} = $cv->createOval(
            $X1 + $self->{_lightSpace},
            $Y2 + $self->{_lightSpace},
            $X1 + $self->{_lightSpace} + $self->{_lightDiameter},
            $Y3 - $self->{_lightSpace},
            -outline => 'black',
            -fill => 'white'
    );
    $self->{_west_light}->{YELLOW} = $cv->createOval(
            $X1 + $self->{_lightSpace} * 2 + $self->{_lightDiameter},
            $Y2 + $self->{_lightSpace},
            $X1 + $self->{_lightSpace} * 2 + $self->{_lightDiameter} * 2,
            $Y3 - $self->{_lightSpace},
            -outline => 'black',
            -fill => 'white'
    );
    $self->{_west_light}->{GREEN} = $cv->createOval(
            $X1 + $self->{_lightSpace} * 3 + $self->{_lightDiameter} * 2,
            $Y2 + $self->{_lightSpace},
            $X1 + $self->{_lightSpace} * 3 + $self->{_lightDiameter} * 3,
            $Y3 - $self->{_lightSpace},
            -outline => 'black',
            -fill => 'white'
    );

    $self->{_south_light}->{GREEN} = $cv->createOval(
            $X2 + $self->{_lightSpace},
            $Y3 + $self->{_lightSpace},
            $X3 - $self->{_lightSpace},
            $Y3 + $self->{_lightSpace} + $self->{_lightDiameter},
            -outline => 'black',
            -fill => 'white'
    );
    $self->{_south_light}->{YELLOW} = $cv->createOval(
            $X2 + $self->{_lightSpace},
            $Y3 + $self->{_lightSpace} * 2 + $self->{_lightDiameter},
            $X3 - $self->{_lightSpace},
            $Y3 + $self->{_lightSpace} * 2 + $self->{_lightDiameter} * 2,
            -outline => 'black',
            -fill => 'white'
    );
    $self->{_south_light}->{RED} = $cv->createOval(
            $X2 + $self->{_lightSpace},
            $Y3 + $self->{_lightSpace} * 3 + $self->{_lightDiameter} * 2,
            $X3 - $self->{_lightSpace},
            $Y3 + $self->{_lightSpace} * 3 + $self->{_lightDiameter} * 3,
            -outline => 'black',
            -fill => 'white'
    );

    $self->{_east_light}->{GREEN} = $cv->createOval(
            $X3 + $self->{_lightSpace},
            $Y2 + $self->{_lightSpace},
            $X3 + $self->{_lightSpace} + $self->{_lightDiameter},
            $Y3 - $self->{_lightSpace},
            -outline => 'black',
            -fill => 'white'
    );
    $self->{_east_light}->{YELLOW} = $cv->createOval(
            $X3 + $self->{_lightSpace} * 2 + $self->{_lightDiameter},
            $Y2 + $self->{_lightSpace},
            $X3 + $self->{_lightSpace} * 2 + $self->{_lightDiameter} * 2,
            $Y3 - $self->{_lightSpace},
            -outline => 'black',
            -fill => 'white'
    );
    $self->{_east_light}->{RED} = $cv->createOval(
            $X3 + $self->{_lightSpace} * 3 + $self->{_lightDiameter} * 2,
            $Y2 + $self->{_lightSpace},
            $X3 + $self->{_lightSpace} * 3 + $self->{_lightDiameter} * 3,
            $Y3 - $self->{_lightSpace},
            -outline => 'black',
            -fill => 'white'
    );
}

1;
