/**
 * The contents of this file are subject to the Mozilla Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of
 * the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS
 * IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 *
 * The Original Code is State Machine Compiler (SMC).
 *
 * The Initial Developer of the Original Code is Charles W. Rapp.
 *
 * Port to JavaScript by Nitin Nizhawan, nitin.nizhawan@gmail.com
 * Copyright 2011, Nitin Nizhawan.
 * All Rights Reserved.
 *
 * Contributor(s):
 *
 * RCS ID
 * $Id: statemap.js,v 1.2 2011/04/23 13:14:54 fperrad Exp $
 *
 *
 * This module contains two class  :
 * * State
 *    the base State class
 * * FSMContext
 *    the Finite State Machine Context class
 *
 * See: http://smc.sourceforge.net/
 *

 */

// base State class

function State(name,id){
    this._name = name;
    this._id = id;
}
State.mixin = function(a,b){
    for(var x in b){
	a[x] = b[x];
    }
    return a;
}

State.prototype=State.mixin(State.prototype,{
    getName:function(){
        // Returns the state''s printable name.
        return this._name
    },
    getId:function(){
	return this._id;
    }
});



/*
 The user can derive FSM contexts from this class and interface
 to them with the methods of this class.

 The finite state machine needs to be initialized to the starting
 state of the FSM.  This must be done manually in the constructor
 of the derived class.
*/

function FSMContext(init_state){

    this._state = init_state;
    this._previous_state=null;
    this._state_stack=[];
    this._transition=null;
    this._debug_flag=false;
    this.debug_stream={};
}

FSMContext.prototype = State.mixin(FSMContext.prototype,{
    // Returns the debug flag's current setting.
    getDebugFlag:function() {
        return this._debug_flag;
    },

    // Sets the debug flag.
    // A true value means debugging is on and false means off.
    setDebugFlag:function(flag) {
        this._debug_flag = flag;
    },

    // Returns the stream to which debug output is written.
    getDebugStream:function() {
        return this._debug_stream;
    },

    // Sets the debug output stream.
    setDebugStream:function(stream) {
        this._debug_stream = stream;
    },

    // Is this state machine already inside a transition?
    // True if state is undefined.
    isInTransition:function() {
        if (this._state){
            return false;
	}
        else {
            return true;
	}
    },

    // Returns the current transition's name.
    // Used only for debugging purposes.
    getTransition:function() {
        return this._transition;
    },

    // Clears the current state.
    clearState:function() {
        this._previous_state = this._state;
        this._state = null;
    },

    // Returns the state which a transition left.
    // May be Null
    getPreviousState:function() {
        return this._previous_state;
    },

    // Sets the current state to the specified state.
    setState:function(state) {
        if (!(state instanceof State)){
            throw {err:state+' should be of class State'};
	}
        this._state = state;
    },

    // Returns True if the state stack is empty and False otherwise.
    isStateStackEmpty:function() {
        return this._state_stack.length == 0;
    },

    // Returns the state stack's depth.
    getStateStackDepth:function() {
        return this._state_stack.length;
    },

    // Push the current state on top of the state stack
    // and make the specified state the current state.
    pushState:function(state) {
        if (! (state instanceof State)){
            throw {err:state+' should be of class State'};
	}
        if (this._state){
            this._state_stack.push(this._state);
	}
        this._state = state;
    },

    // Make the state on top of the state stack the current state.
    popState:function() {
            this._state = this._state_stack.pop();
    },

    // Remove all states from the state stack.
    emptyStateStack:function() {
        this._state_stack = [];
    }
});

