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
# Name
#  telephone.pl
#
# Description
#  A simulation of an old fashioned touch-tone telephone.
#
# RCS ID
# $Id: telephone.pl,v 1.3 2009/04/22 19:07:03 fperrad Exp $
#
# CHANGE LOG
# $Log: telephone.pl,v $
# Revision 1.3  2009/04/22 19:07:03  fperrad
# Added enterStartState method
#
# Revision 1.2  2008/02/04 12:40:11  fperrad
# some Perl Best Practices
#
# Revision 1.1  2005/06/16 18:04:15  fperrad
# Added Perl examples 1 - 4 and 7.
#
#

use strict;
use warnings;

use Tk;

package Telephone;

use POSIX qw(strftime);
use Telephone_sm;

use constant LONG_DISTANCE => 1;
use constant LOCAL => 2;
use constant EMERGENCY => 3;

use constant NYC_TEMP => 4;
use constant TIME => 5;
use constant DEPOSIT_MONEY => 6;
use constant LINE_BUSY => 7;
use constant INVALID_NUMBER => 8;

use constant SEC_PER_MINUTE => 60;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = {
            _areaCode => q{},
            _exchange => q{},
            _local => q{},
            _display => q{},
            _receiverButton => undef,
            _timerMap => {
                ClockTimer => -1,
                OffHookTimer => -1,
                LoopTimer => -1,
                RingTimer => -1,
            },
            _timerAudioID => -1,
    };
    bless($self, $class);

    $self->_loadUI();

    # Create the state machine to drive this object.
    $self->{_fsm} = new smc_ex7::Telephone_sm($self);

    # DEBUG
    #$self->{_fsm}->setDebugFlag(1);

    return $self;
}

# Create the user interface but don't display it yet.
sub _loadUI {
    my $self = shift;
    my $mw = new MainWindow();
    $self->{_mw} = $mw;
    $mw->title('Telephone demo');

    my $frameDisplay = $mw->Frame()->pack(
            -side => 'top',
            -fill => 'both',
    );
    # Create the read-only phone number display.
    $self->{_numberDisplay} = $frameDisplay->Label(
            -width => 30,
            -bg => 'white',
            -relief => 'sunken',
            -padx => 5,
            -pady => 5,
    )->pack(
            -side => 'top',
            -padx => 5,
            -pady => 5,
    );

    my $frameHook = $mw->Frame()->pack(
            -side => 'top',
            -expand => 1,
    );
    # Create the off-hook/on-hook button.
    $self->{_receiverButton} = $frameHook->Button(
            -text => 'Pick up receiver',
            -state => 'normal',
            -command => sub {
                my $text = $self->{_receiverButton}->cget(-text);
                if ($text eq 'Pick up receiver') {
                    $self->{_fsm}->OffHook();
                }
                elsif ($text eq 'Put down receiver') {
                    $self->{_fsm}->OnHook();
                }
                else {
                    warn "Unknown receiver ($text).\n";
                }
            },
            -padx => 10,
            -pady => 5,
            -bd => 3,
    )->pack(
            -side => 'top',
            -padx => 5,
            -pady => 5,
    );

    my $frameDial = $mw->Frame()->pack(
            -side => 'top',
            -fill => 'both',
            -padx => 5,
            -pady => 5,
    );
    # Create the dialing buttons.
    my @w;
    foreach my $digit (1..9, '*', 0, '#') {
        push @w, $frameDial->Button(
                    -text => $digit,
                    -height => 2,
                    -width => 3,
                    -command => sub {
                        $self->{_fsm}->Digit($digit);
                    },
            );
    }
    $w[0]->grid($w[1], $w[2],
            -padx => 1,
            -pady => 1,
    );
    $w[3]->grid($w[4], $w[5],
            -padx => 1,
            -pady => 1,
    );
    $w[6]->grid($w[7], $w[8],
            -padx => 1,
            -pady => 1,
    );
    $w[9]->grid($w[10], $w[11],
            -padx => 1,
            -pady => 1,
    );

    my $frameStatus = $mw->Frame()->pack(
            -side => 'top',
            -fill => 'both',
    );
    $self->{_soundDisplay} = $frameStatus->Label(
            -relief => 'groove',
    )->pack(
            -side => 'top',
            -fill => 'x',
            -expand => 1,
            -anchor => 's',
    );

    # Cntl-C stops the demo as well.
    $mw->bind('<Control-c>',
        [sub { exit(0); }]
    );
}

sub Start {
    my $self = shift;
    $self->{_fsm}->enterStartState();
}

#-----------------------------------------------------------
# State Machine Actions.
#

# Return the current area code.
sub getAreaCode {
    my $self = shift;
    return $self->{_areaCode};
}

# Return the exchange.
sub getExchange {
    my $self = shift;
    return $self->{_exchange};
}

# Return the local number.
sub getLocal {
    my $self = shift;
    return $self->{_local};
}

sub routeCall {
    my $self = shift;
    my ($callType, $areaCode, $exchange, $local) = @_;
    my $route;

    if ($callType == EMERGENCY) {
        $route = EMERGENCY;
    }
    elsif ($callType == LONG_DISTANCE
        && $areaCode eq '1212'
        && $exchange eq '555'
        && $local eq '1234') {
        $route = NYC_TEMP;
    }
    elsif ($exchange eq '555') {
        if ($local eq '1212') {
            $route = TIME;
        }
        else {
            $route = LINE_BUSY;
        }
    }
    elsif ($callType == LOCAL) {
        $route = DEPOSIT_MONEY;
    }
    else {
        $route = INVALID_NUMBER;
    }

    # Call routing needs to be done asynchronouzly in order to
    # avoid issuing a transition within a transition.
    $self->{_mw}->after(50, sub { $self->_callRoute($route); });
}

sub startTimer {
    my $self = shift;
    my ($name, $delay) = @_;
    if ($name eq 'ClockTimer') {
        $self->{_timerMap}->{$name} =
            $self->{_mw}->after($delay, sub { $self->{_fsm}->ClockTimer(); });
    }
    elsif ($name eq 'OffHookTimer') {
        $self->{_timerMap}->{$name} =
            $self->{_mw}->after($delay, sub { $self->{_fsm}->OffHookTimer(); });
    }
    elsif ($name eq 'LoopTimer') {
        $self->{_timerMap}->{$name} =
            $self->{_mw}->after($delay, sub { $self->{_fsm}->LoopTimer(); });
    }
    elsif ($name eq 'RingTimer') {
        $self->{_timerMap}->{$name} =
            $self->{_mw}->after($delay, sub { $self->{_fsm}->RingTimer(); });
    }
}

sub resetTimer {
    my $self = shift;
    my ($name, $delay) = @_;
    if ($self->{_timerMap}->{$name} >= 0) {
        $self->{_mw}->afterCancel($self->{_timerMap}->{$name});
        $self->{_timerMap}->{$name} = -1;
        $self->startTimer($name, $delay);
    }
}

sub stopTimer {
    my $self = shift;
    my ($name) = @_;
    if ($self->{_timerMap}->{$name} >= 0) {
        $self->{_mw}->afterCancel($self->{_timerMap}->{$name});
        $self->{_timerMap}->{$name} = -1;
    }
}

sub play {
    my $self = shift;
    my ($name, $delay) = @_;
    if ($self->{_timerAudioID} >= 0) {
        $self->{_mw}->afterCancel($self->{_timerAudioID});
        $self->{_timerAudioID} = -1;
    }
    $self->{_soundDisplay}->configure(-text => $name);
    $self->{_timerAudioID} = $self->{_mw}->after($delay, sub {
        $self->{_soundDisplay}->configure(-text => q{});
        $self->{_timerAudioID} = -1;
    });
}

sub playTT {
    my $self = shift;
    my ($name) = @_;
    $self->play($name, 400);
}

sub loop {
    my $self = shift;
    my ($name) = @_;
    if ($self->{_timerAudioID} >= 0) {
        $self->{_mw}->afterCancel($self->{_timerAudioID});
        $self->{_timerAudioID} = -1;
    }
    $self->{_soundDisplay}->configure(-text => $name . ' ...');
}

sub stopLoop {
    my $self = shift;
    $self->{_soundDisplay}->configure(-text => q{});
}

sub stopPlayback {
    my $self = shift;
    if ($self->{_timerAudioID} >= 0) {
        $self->{_mw}->afterCancel($self->{_timerAudioID});
        $self->{_timerAudioID} = -1;
    }
    $self->{_soundDisplay}->configure(-text => q{});
}

sub playEmergency {
    my $self = shift;
    $self->play('911', 5000);
}

sub playNYCTemp {
    my $self = shift;
    $self->play('NYC_temp', 2000);
}

sub playDepositMoney {
    my $self = shift;
    $self->play('50_cents_please', 2000);
}

sub playTime {
    my $self = shift;
    $self->play('the_time_is ???', 2000);
}

sub playInvalidNumber {
    my $self = shift;
    $self->play('you_dialed ### could_not_be_completed', 2000);
}

sub getType {
    my $self = shift;
    return $self->{_callType};
}

sub setType {
    my $self = shift;
    my ($type) = @_;
    $self->{_callType} = $type;
}

sub saveAreaCode {
    my $self = shift;
    my ($n) = @_;
    $self->{_areaCode} .= $n;
    $self->addDisplay($n);
}

sub saveExchange {
    my $self = shift;
    my ($n) = @_;
    $self->{_exchange} .= $n;
    $self->addDisplay($n);
}

sub saveLocal {
    my $self = shift;
    my ($n) = @_;
    $self->{_local} .= $n;
    $self->addDisplay($n);
}

sub addDisplay {
    my $self = shift;
    my ($character) = @_;
    $self->{_display} .= $character;
    $self->{_numberDisplay}->configure(-text => $self->{_display});
}

sub clearDisplay {
    my $self = shift;

    #Clear the internal data store.
    $self->{_display} = q{};
    $self->{_areaCode} = q{};
    $self->{_local} = q{};
    $self->{_exchange} = q{};

    # Put up the current time and date on the display.
    $self->{_numberDisplay}->configure(-text => q{});
}

sub startClockTimer {
    my $self = shift;
    my $currentTime = time();
    my $timeRemaining = SEC_PER_MINUTE - ($currentTime % SEC_PER_MINUTE);

    # Figure out how long until the top of the minute
    # and set the timer for that amount.
    $self->startTimer('ClockTimer', $timeRemaining * 1000);
}

sub updateClock {
    my $self = shift;
    my $text = strftime('%H:%M  %b %d, %Y', localtime(time()));
    $self->{_numberDisplay}->configure(-text => $text);
}

sub setReceiver {
    my $self = shift;
    my ($text) = @_;
        if (defined $self->{_receiverButton}) {
        $self->{_receiverButton}->configure(-text => $text);
    }
}

sub _callRoute {
    my $self = shift;
    my ($route) = @_;
    if ($route == EMERGENCY) {
        $self->{_fsm}->Emergency();
    }
    elsif ($route == NYC_TEMP) {
        $self->{_fsm}->NYCTemp();
    }
    elsif ($route == TIME) {
        $self->{_fsm}->Time();
    }
    elsif ($route == DEPOSIT_MONEY) {
        $self->{_fsm}->DepositMoney();
    }
    elsif ($route == LINE_BUSY) {
        $self->{_fsm}->LineBusy();
    }
    elsif ($route == INVALID_NUMBER) {
        $self->{_fsm}->InvalidNumber();
    }
}

package main;

# Display the "telephone" user interface and run until
# the user quits the window.
my $tel = new Telephone();
$tel->Start();
MainLoop();
