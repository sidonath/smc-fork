//
// The contents of this file are subject to the Mozilla Public
// License Version 1.1 (the "License"); you may not use this file
// except in compliance with the License. You may obtain a copy of
// the License at http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS
// IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
// implied. See the License for the specific language governing
// rights and limitations under the License.
//
// The Original Code is State Machine Compiler (SMC).
//
// The Initial Developer of the Original Code is Charles W. Rapp.
// Portions created by Charles W. Rapp are
// Copyright (C) 2000 - 2005 Charles W. Rapp.
// All Rights Reserved.
//
// Port to Groovy by Francois Perrad, francois.perrad@gadz.org
// Copyright 2007, Francois Perrad.
// All Rights Reserved.
//
// Contributor(s):
//
// RCS ID
// $Id: statemap.groovy,v 1.7 2010/03/17 13:13:29 fperrad Exp $
//
// CHANGE LOG
// (See the bottom of this file.)
//

package statemap

import java.beans.PropertyChangeListener
import java.beans.PropertyChangeSupport

abstract class State implements Serializable {
    String name
    int id

    def String toString () {
        return name
    }
}

class StateUndefinedException extends RuntimeException {
}

class TransitionUndefinedException extends RuntimeException {
    def msg

    def TransitionUndefinedException (msg) {
        super()
        this.msg = msg
    }

    String toString () {
        return 'statemap.TransitionUndefinedException: ' + msg
    }
}

abstract class FSMContext implements Serializable {
    private _state = null
    private _stateStack = []
    def previousState = null
    String transition = ''
    boolean debugFlag = false
    def debugStream = System.err
    private _listeners = new PropertyChangeSupport(this)

    // Creates a finite state machine context with the given
    // initial state.
    FSMContext(State initState) {
        _state = initState;
    }

    abstract enterStartState()

    // Is this state machine in a transition? If state is null,
    // then true; otherwise, false.
    boolean isInTransition () {
        return (_state == null) ? true : false
    }

    def setState (state) {
        def previousState = _state
        if (! (state instanceof State))
            throw new IllegalArgumentException('state should be a statemap.State')
        if (debugFlag)
            debugStream.println('ENTER STATE     : ' + state.name)
        _state = state
        // Inform all listeners about this state change
        _listeners.firePropertyChange('State', previousState, _state)
    }

    def getState () {
        if (_state == null)
            throw new StateUndefinedException()
        return _state
    }

    def clearState () {
        previousState = _state
        _state = null
    }

    def pushState (state) {
        def previousState = _state
        if (! (state instanceof State))
            throw new IllegalArgumentException('state should be a statemap.State')
        if (_state == null)
            throw new NullPointerException('uninitialized state')
        if (debugFlag)
            debugStream.println('PUSH TO STATE   : ' + state.name)
        _stateStack << _state   // push
        _state = state
        // Inform all listeners about this state change
        _listeners.firePropertyChange('State', previousState, _state)
    }

    def popState () {
        if (!_stateStack) {
            if (debugFlag)
                debugStream.println('POPPING ON EMPTY STATE STACK.')
            throw new EmptyStackException('empty state stack')
        }
        else {
            def previousState = _state
            _state = _stateStack.pop()
            if (debugFlag)
                debugStream.println('POP TO STATE    : ' + _state.name)
            // Inform all listeners about this state change
            _listeners.firePropertyChange('State', previousState, _state)
        }
    }

    def emptyStateStack () {
        _stateStack = []
    }

    def addStateChangeListener(listener) {
        _listeners.addPropertyChangeListener('State', listener)
    }

    def removeStateChangeListener(listener) {
        _listeners.removePropertyChangeListener('State', listener)
    }

}

//
// CHANGE LOG
// $Log: statemap.groovy,v $
// Revision 1.7  2010/03/17 13:13:29  fperrad
// add TransitionUndefinedException toString
//
// Revision 1.6  2010/03/16 16:43:58  fperrad
// add TransitionUndefinedException constructor
//
// Revision 1.5  2009/11/24 20:42:39  cwrapp
// v. 6.0.1 update
//
// Revision 1.4  2009/04/11 13:07:23  cwrapp
// Added FSMContext initial state constructor.
//
// Revision 1.3  2008/02/04 10:54:01  fperrad
// + Added Event Notification
//
// Revision 1.2  2008/01/14 19:59:23  cwrapp
// Release 5.0.2 check-in.
//
// Revision 1.1  2007/07/16 06:29:37  fperrad
// + Added Groovy.
//
//
