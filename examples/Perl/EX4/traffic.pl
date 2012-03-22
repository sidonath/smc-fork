#!/usr/bin/env perl
# -*- tab-width: 4; -*-

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
# traffic --
#
#  Use state machines to do a very simple simulation of stoplights.
#
# RCS ID
# $Id: traffic.pl,v 1.2 2008/02/04 12:40:28 fperrad Exp $
#
# CHANGE LOG
# $Log: traffic.pl,v $
# Revision 1.2  2008/02/04 12:40:28  fperrad
# some Perl Best Practices
#
# Revision 1.1  2005/06/16 18:04:15  fperrad
# Added Perl examples 1 - 4 and 7.
#
#

use strict;
use warnings;

use Tk;

# Load in the stoplight and vehicles classes.
use Stoplight;
use Vehicle;

package Top;

# DisplaySliders --
#
#   Display the window which contains the sliders for dynamically
#   configuring the traffic demo.
#
# Arguments:
#   None.

sub DisplaySliders {
    my $self = shift;

    # Immediatly disable the window to prevent it from being
    # selected again.
    $self->{_ConfigButton}->configure(-state => 'disabled');

    # Put the sliders in a separate window. Create three frames,
    # one for each kind of slider.
    my $SliderFrame = $self->{_mw}->Toplevel();
    $SliderFrame->title('Traffic Configuration');

    # Put in the slider controls for setting the traffic light times
    # (how long each light stays green or yellow), how often new
    # vehicles appear and how fast vehicles move.
    my $NSGreenSlider = $SliderFrame->Scale(
            -from => 5,
            -to => 20,
            -variable => \$self->{_NSGreenTime},
            -label => 'North/South green light timer (in seconds)',
            -orient => 'horizontal',
            -tickinterval => 5,
            -showvalue => undef,
            -sliderrelief => 'sunken',
            -length => 250,
            -command => sub {
                $self->{_Stoplight}->setLightTimer('NSGreenTimer', $self->{_NSGreenTime});
            },
    )->pack(
            -side => 'top',
    );
    my $EWGreenSlider = $SliderFrame->Scale(
            -from => 5,
            -to => 20,
            -variable => \$self->{_EWGreenTime},
            -label => 'East/West green light timer (in seconds)',
            -orient => 'horizontal',
            -tickinterval => 5,
            -showvalue => undef,
            -sliderrelief => 'sunken',
            -length => 250,
            -command => sub {
                $self->{_Stoplight}->setLightTimer('EWGreenTimer', $self->{_EWGreenTime});
            },
    )->pack(
            -side => 'top',
    );
    my $YellowSlider = $SliderFrame->Scale(
            -from => 2,
            -to => 8,
            -variable => \$self->{_YellowTime},
            -label => 'Yellow light timer (in seconds)',
            -orient => 'horizontal',
            -tickinterval => 2,
            -showvalue => undef,
            -sliderrelief => 'sunken',
            -length => 250,
            -command => sub {
                $self->{_Stoplight}->setLightTimer('YellowTimer', $self->{_YellowTime});
            },
    )->pack(
            -side => 'top',
    );
    my $AppearanceSlider = $SliderFrame->Scale(
            -from => 5,
            -to => 15,
            -variable => \$self->{_AppearanceRate},
            -label => 'Vehicle appearance rate (in seconds)',
            -orient => 'horizontal',
            -tickinterval => 2,
            -showvalue => undef,
            -sliderrelief => 'sunken',
            -length => 250,
             -command => sub {
                $self->setAppearanceRate($self->{_AppearanceRate});
            },
    )->pack(
            -side => 'top',
    );
    my $SpeedSlider = $SliderFrame->Scale(
            -from => 1,
            -to => 5,
            -variable => \$self->{_VehicleSpeed},
            -label => 'Vehicle speed (in seconds)',
            -orient => 'horizontal',
            -tickinterval => 1,
            -showvalue => undef,
            -sliderrelief => 'sunken',
            -length => 250,
             -command => sub {
                Vehicle::setSpeed($self->{_VehicleSpeed});
            },
    )->pack(
            -side => 'top',
    );

    # When the slider window is destroyed, re-enable the
    # configure button.
    $SliderFrame->bind('<Destroy>',
        [ sub{$_[1]->{_ConfigButton}->configure(-state => 'normal'); }, $self ]
    );

    $SliderFrame->focus();
}

# StartDemo --
#
#   Start the traffic flowing. Do this by having the
#   stoplight and vehicle objects start their timers.
#   Also start the "make vehicles" timer.
#
# Arguments:
#   None.

sub StartDemo {
    my $self = shift;

    $self->{_Stoplight}->Start();

    # Create four vehicles, one for each direction.
    $self->makeVehicles();

    # Every minute, go through the vehicle list and
    # delete those vehicles that have completed their
    # trip.
    $self->{_CollectTimerID} = $self->{_mw}->after(60000,
        sub { $self->garbageCollect(); }
    );

    # Disable the start button and enable the pause and stop button.
    $self->{_StartButton}->configure(-state => 'disabled');
    $self->{_PauseButton}->configure(-state => 'normal');
    $self->{_StopButton}->configure(-state => 'normal');
}

# PauseDemo --
#
#   Temporarily pause this demo.
#
# Arguments:
#   None.

sub PauseDemo {
    my $self = shift;

    $self->{_PauseFlag} = 1;

    # Tell the stop light and vehicles to temporarily
    # stop their timers.
    $self->{_Stoplight}->Pause();

    foreach my $vehicle (@{$self->{_VehicleList}}) {
        $vehicle->Pause();
    }

    # Stop the vehicle deletion timer.
    if ($self->{_CollectTimerID} >= 0) {
        $self->{_mw}->afterCancel($self->{_CollectTimerID});
        $self->{_CollectTimerID} = -1;
    }

    # Disable the pause button and enable the continue button.
    $self->{_PauseButton}->configure(-state => 'disabled');
    $self->{_ContinueButton}->configure(-state => 'normal');
}

# ContinueDemo --
#
#   Pick up the demo where you left off.
#
# Arguments:
#   None.

sub ContinueDemo {
    my $self = shift;

    $self->{_PauseFlag} = undef;

    # If the vehicle appearance timer expired during the pause,
    # then make some vehicles now.
    if ($self->{_AppearanceTimerID} == -2) {
        $self->makeVehicles();
    }

    # Tell the stop light and vehicles to temporarily
    # stop their timers.
    $self->{_Stoplight}->Continue();

    foreach my $vehicle (@{$self->{_VehicleList}}) {
        $vehicle->Continue();
    }

    # Enable the pause button and disable the continue button.
    $self->{_PauseButton}->configure(-state => 'normal');
    $self->{_ContinueButton}->configure(-state => 'disabled');
}

# StopDemo --
#
#   Stop the demo and delete all vehicles.
#
# Arguments:
#   None.

sub StopDemo {
    my $self = shift;

    $self->{_Stoplight}->Stop();

    foreach my $vehicle (@{$self->{_VehicleList}}) {
        $vehicle->Stop();
    }
    $self->{_VehicleList} = [];

    if ($self->{_AppearanceTimerID} >= 0) {
        $self->{_mw}->afterCancel($self->{_AppearanceTimerID});
        $self->{_AppearanceTimerID} = -1;
    }

    if ($self->{_CollectTimerID} >= 0) {
        $self->{_mw}->afterCancel($self->{_CollectTimerID});
        $self->{_CollectTimerID} = -1;
    }

    # Enable the start button and disable all others.
    $self->{_StartButton}->configure(-state => 'normal');
    $self->{_PauseButton}->configure(-state => 'disabled');
    $self->{_ContinueButton}->configure(-state => 'disabled');
    $self->{_StopButton}->configure(-state => 'disabled');
}

# makeVehicles --
#
#   Create four new vehicles to move on the map. When
#   done, set a timer to make even more later.
#
# Arguments:
#   None.

sub makeVehicles {
    my $self = shift;

    $self->{_AppearanceTimerID} = -1;

    # Don't make vehicles if we are paused. Just remember that
    # the timer expired and call this routine when the demo is
    # continued.
    if ($self->{_PauseFlag}) {
        $self->{_AppearanceTimerID} = -2;
    } 
    else {
        foreach ('north', 'south', 'east', 'west') {
            push @{$self->{_VehicleList}},
                    new Vehicle($self->{_Stoplight}, $_, $self->{_Canvas});
        }

        # Gentlemen, start your engines.
        foreach my $vehicle (@{$self->{_VehicleList}}) {
            $vehicle->Start();
        }

        $self->{_AppearanceTimerID} = $self->{_mw}->after($self->{_AppearanceTimeout},
            sub { $self->makeVehicles(); }
        );
    }
}

# setAppearanceRate --
#
#   Set the rate at which vehicles appear.
#
# Arguments:
#   rate    In seconds. Convert to milliseconds.

sub setAppearanceRate {
    my $self = shift;
    my ($rate) = @_;
    $self->{_AppearanceTimeout} = $rate * 1000;
}

# garbageCollect --
#
#   Delete those vehicles that have completed their trip.
#
# Arguments:
#   None.
#

sub garbageCollect {
    my $self = shift;

    $self->{_CollectTimerID} = -1;

    my @NewVehicleList = ();
    foreach my $vehicle (@{$self->{_VehicleList}}) {
        if ($vehicle->isDone()) {
            $vehicle->Delete();
        }
        else {
            push @NewVehicleList, $vehicle;
        }
    }
    $self->{_VehicleList} = \@NewVehicleList;

    # Reset this timer.
    $self->{_CollectTimerID} = $self->{_mw}->after(60000,
        sub { $self->garbageCollect(); }
    );
}

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = {
            # Default settings.
            _VehicleList => [],
            _AppearanceTimerID => -1,
            _AppearanceTimeout => 8000,
            _CollectTimerID => -1,
            _NSGreenTime => 7,
            _EWGreenTime => 5,
            _YellowTime => 2,
            _AppearanceRate => 8,
            _VehicleSpeed => 2,
            _PauseFlag => undef,
    };
    bless($self, $class);

    # Set up the window in which the stop light demo will appear.
    # Also create two other frames. One will hold the sliders for
    # dynamically configuring the demo and the other buttons to
    # start, pause, continue and quit the demo.
    my $mw = new MainWindow();
    $self->{_mw} = $mw;
    $mw->title('Stoplight demo');

    my $ConfigFrame = $mw->Frame(
            -borderwidth => 4,
            -relief => 'flat',
            -height => 15,
            -width => 250,
    )->pack(
            -side => 'top',
            -fill => 'both',
    );
    my $MainFrame = $mw->Frame(
            -borderwidth => 4,
            -relief => 'flat',
            -height => 250,
            -width => 250,
    )->pack(
            -side => 'top',
            -fill => 'both',
    );
    my $ButtonFrame = $mw->Frame(
            -borderwidth => 4,
            -relief => 'flat',
            -height => 15,
            -width => 250,
    )->pack(
            -side => 'top',
            -fill => 'both',
    );

    # Put a single button in the configure frame which causes the
    # slider window to pop up.
    $self->{_ConfigButton} = $ConfigFrame->Button(
            -text => 'Configure...',
            -command => sub { $self->DisplaySliders(); },
    )->pack(
            -side => 'right',
    );

    # Create a canvas in which the stop light graphics will appear.
    $self->{_Canvas} = $MainFrame->Canvas(
            -borderwidth => 2,
            -background => 'white',
            -relief => 'raised',
            -height => 250,
            -width => 250,
    )->pack(
            -side => 'top',
            -fill => 'both',
    );

    # Create the stoplight and specify which direction initially has
    # the green light.
    $self->{_Stoplight} = new Stoplight($self->{_Canvas});

    # Add a button which allows the demo to be started, paused, continued
    # and stopped.
    $self->{_StartButton} = $ButtonFrame->Button(
            -text => 'Start',
            -command => sub { $self->StartDemo(); },
    )->pack(
            -side => 'left',
    );
    $self->{_PauseButton} = $ButtonFrame->Button(
            -text => 'Pause',
            -state => 'disabled',
            -command => sub { $self->PauseDemo(); },
    )->pack(
            -side => 'left',
    );
    $self->{_ContinueButton} = $ButtonFrame->Button(
            -text => 'Continue',
            -state => 'disabled',
            -command => sub { $self->ContinueDemo(); },
    )->pack(
            -side => 'left',
    );
    $self->{_StopButton} = $ButtonFrame->Button(
            -text => 'Stop',
            -state => 'disabled',
            -command => sub { $self->StopDemo(); },
    )->pack(
            -side => 'left',
    );

    # Cntl-C stops the demo.
    $mw->bind('<Control-c>',
        [sub { exit(0); }]
    );

    $MainFrame->focus();
}

package main;

my $top = new Top();
MainLoop();
