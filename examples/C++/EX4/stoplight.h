#ifndef _H_STOPLIGHT
#define _H_STOPLIGHT

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
// Copyright (C) 2000 - 2009. Charles W. Rapp.
// All Rights Reserved.
// 
// Contributor(s): 
//
// Name
//	TheContext
//
// Description
//	When a state map executes an action, it is really calling a
//	member function in the context class.
//
// RCS ID
// $Id: stoplight.h,v 1.8 2009/11/25 22:30:18 cwrapp Exp $
//
// CHANGE LOG
// $Log: stoplight.h,v $
// Revision 1.8  2009/11/25 22:30:18  cwrapp
// Fixed problem between %fsmclass and sm file names.
//
// Revision 1.7  2009/03/27 09:41:45  cwrapp
// Added F. Perrad changes back in.
//
// Revision 1.6  2009/03/01 18:20:37  cwrapp
// Preliminary v. 6.0.0 commit.
//
// Revision 1.5  2005/05/28 13:31:18  cwrapp
// Updated C++ examples.
//
// Revision 1.0  2003/12/14 19:26:30  charlesr
// Initial revision
//

#include "stoplightdefs.h"
#include "stoplight_sm.h"

namespace cpp_ex4
{
    class Stoplight
    {
    // Member data.
    public:
    protected:
    private:
        stoplightContext _fsm;

    // Member functions.
    public:

        // Destructor.
        virtual ~Stoplight()
        {};

        void start();

        // Change a stoplight's color.
        void TurnLight(StopLights light, LightColors color);

        // Set a timer for the specified number of seconds.
        void SetTimer(int time);

        // This routine is called by SigalmHandler()
        // when a timer expires.
        inline void Timeout()
            { _fsm.Timeout(); };

        // Sets the initial state of the state map and the
        // initial timer.
        static Stoplight* Initialize(Directions direction);

    private:

        // Specify the initial direction with
        // the green light.
        Stoplight(const statemap::State& state);

    }; // end of class Stoplight
}; // end of namespace cpp_ex4

#endif
