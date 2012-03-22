'
' The contents of this file are subject to the Mozilla Public
' License Version 1.1 (the "License"); you may not use this file
' except in compliance with the License. You may obtain a copy of
' the License at http://www.mozilla.org/MPL/
' 
' Software distributed under the License is distributed on an "AS
' IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
' implied. See the License for the specific language governing
' rights and limitations under the License.
' 
' The Original Code is State Machine Compiler (SMC).
' 
' The Initial Developer of the Original Code is Charles W. Rapp.
' Portions created by Charles W. Rapp are
' Copyright (C) 2003 Charles W. Rapp.
' All Rights Reserved.
' 
' Contributor(s): 
'
' statemap.java --
'
'  This package defines the fsmContext class which is extended
'  by SMC-generated state machines.
'
' RCS ID
' $Id: FSMContext.vb,v 1.2 2009/03/01 18:20:41 cwrapp Exp $
'
' Change Log
' $Log: FSMContext.vb,v $
' Revision 1.2  2009/03/01 18:20:41  cwrapp
' Preliminary v. 6.0.0 commit.
'
' Revision 1.1  2005/05/28 18:47:13  cwrapp
' Updated C++, Java and Tcl libraries, added CSharp, Python and VB.
'
' Revision 1.0  2004/05/31 13:46:30  charlesr
' Initial revision
'

Imports System.Collections
Imports System.IO

' statemap.FSMContext --
'
' Base class for the SMC-generated context class. The context
' stores:
'   + current state
'   + previous state (only valid while in transition)
'   + stack stack (created on first push transition)
'   + transition name (only valid while in transition)
'

Public MustInherit Class FSMContext

    '------------------------------------------------------------
    ' Member data.
    '

    ' The current state.
    Protected _state As State

    ' The current transition's name. This value is only set
    ' while in transition.
    Protected _transition As String

    ' The state the transition just left. This value is only set
    ' while in transition.
    Protected _previousState As State

    ' This stack is used when a push transition is taken.
    Protected _stateStack As Stack

    ' When this flag is set to true, this class prints out debug
    ' messages.
    Protected _debugFlag As Boolean

    ' Write output to this text stream.
    Protected _debugStream As TextWriter

    '------------------------------------------------------------
    ' Properties
    '

    Public Property DebugFlag As Boolean
        Get
            Return _debugFlag
        End Get

        Set(ByVal flag As Boolean)

            _debugFlag = flag
        End Set
    End Property

    Public Property DebugStream As TextWriter
        Get
            Return _debugStream
        End Get

        Set(ByVal stream As TextWriter)
            _debugStream = stream
        End Set
    End Property

    Public ReadOnly Property IsInTransition As Boolean
        Get
            Dim retcode As Boolean

            If _state Is Nothing _
            Then
                retcode = True
            Else
                retcode = False
            End If

            Return retcode
        End Get
    End Property

    Public ReadOnly Property PreviousState() As State
        Get
            Return _previousState
        End Get
    End Property

    Public ReadOnly Property Transition() As String
        Get
            Return _transition
        End Get
    End Property

    '------------------------------------------------------------
    ' Member methods
    '

    Public MustOverride Sub EnterStartState()
    End Sub

    Public Sub ClearState()

        _previousState = _state
        _state = Nothing
    End Sub

    Public Sub PushState(ByRef state As State)

        If _debugFlag = True _
        Then
            _debugStream.WriteLine( _
                String.Concat("PUSH TO STATE: ", state.Name))
        End If

        If Not IsNothing(_state) _
        Then
            If _stateStack Is Nothing _
            Then
                _stateStack = New Stack()
            End If

            _stateStack.Push(_state)

        End If

        _state = state

    End Sub

    Public Sub PopState()

        If _stateStack.Count = 0 _
        Then
            If _debugFlag = True _
            Then
                _debugStream.WriteLine( _
                    "POPPING ON EMPTY STATE STACK.")
            End If

            Throw New InvalidOperationException( _
                "popping an empty state stack")
        Else
            _state = _stateStack.Pop()

            If _debugFlag = True _
            Then
                _debugStream.WriteLine( _
                    String.Concat("POP TO STATE : ", _
                                  _state.Name))
            End If
        End If

    End Sub

    Public Sub EmptyStateStack()

        If Not IsNothing(_stateStack) _
        Then
            _stateStack.Clear()
        End If

    End Sub

    Protected Sub New(ByRef state As State)

        ' There is no state until the start state is explicitly
        ' set.
        _state = state
        _previousState = Nothing
        _stateStack = Nothing
        _transition = ""
        _debugFlag = False
        _debugStream = Console.Out

    End Sub

End Class
