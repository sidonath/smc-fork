#!/usr/bin/env perl

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
# $Id: checkstring.pl,v 1.2 2008/02/04 11:02:38 fperrad Exp $
#
# CHANGE LOG
# $Log: checkstring.pl,v $
# Revision 1.2  2008/02/04 11:02:38  fperrad
# + Exhibit options
#
# Revision 1.1  2005/06/16 18:04:15  fperrad
# Added Perl examples 1 - 4 and 7.
#
#

use strict;
use warnings;

use AppClass;

my $retcode = 0;
if (scalar(@ARGV) < 1) {
    warn "No string to check.\n";
    $retcode = 2;
}
elsif (scalar(@ARGV) > 1) {
    warn "Only one argument is accepted.\n";
    $retcode = 3;
}
else {
    my $appobject = new AppClass();
    my $str = $ARGV[0];
    my $result;
    unless ($appobject->CheckString($str)) {
        $result = 'not acceptable';
        $retcode = 1;
    }
    else {
        $result = 'acceptable';
    }
    print "The string \"",$str,"\" is ",$result,".\n";
}
exit($retcode);
