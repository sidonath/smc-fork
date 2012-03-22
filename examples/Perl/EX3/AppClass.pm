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
# Function
#   Main
#
# Description
#  This routine starts the finite state machine running.
#
# RCS ID
# $Id: AppClass.pm,v 1.3 2009/04/22 19:07:03 fperrad Exp $
#
# CHANGE LOG
# $Log: AppClass.pm,v $
# Revision 1.3  2009/04/22 19:07:03  fperrad
# Added enterStartState method
#
# Revision 1.2  2008/02/04 11:02:38  fperrad
# + Exhibit options
#
# Revision 1.1  2005/06/16 18:04:15  fperrad
# Added Perl examples 1 - 4 and 7.
#
#

use strict;
use warnings;

use AppClass_sm;

package AppClass;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = {};
    bless($self, $class);
    $self->{_fsm} = new AppClass_sm($self);
    $self->{_is_acceptable} = undef;

    # Uncomment to see debug output.
    #$self->{_fsm}->setDebugFlag(1);

    return $self;
}

sub CheckString {
    my $self = shift;
    my ($string) = @_;
    $self->{_fsm}->enterStartState();
    foreach (split //, $string) {
        if (/0/) {
            $self->{_fsm}->Zero();
        }
        elsif (/1/) {
            $self->{_fsm}->One();
        }
        elsif (/[Cc]/) {
            $self->{_fsm}->C();
        }
        else {
            $self->{_fsm}->Unknown();
        }
    }
    $self->{_fsm}->EOS();
    return $self->{_is_acceptable};
}

sub Acceptable {
    my $self = shift;
    $self->{_is_acceptable} = 1;
}

sub Unacceptable {
    my $self = shift;
    $self->{_is_acceptable} = undef;
}

1;
