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
' $Id: TransitionUndefinedException.vb,v 1.1 2005/05/28 18:47:13 cwrapp Exp $
'
' Change Log
' $Log: TransitionUndefinedException.vb,v $
' Revision 1.1  2005/05/28 18:47:13  cwrapp
' Updated C++, Java and Tcl libraries, added CSharp, Python and VB.
'
' Revision 1.0  2004/05/31 13:46:59  charlesr
' Initial revision
'

'
' A TransitionUndefinedException is thrown by an SMC-generated
' FSM whenever a transition is taken which:
' 1. Is not explicitly defined in the current state.
' 2. Is not explicitly defined in the current FSM's default
'    state.
' 3. The current state does not have a Default transition.
'

Imports System.Runtime.Serialization

Public NotInheritable Class TransitionUndefinedException
    Inherits Exception

    '------------------------------------------------------------
    ' Member methods.
    '

    Public Sub New()

        MyBase.New()
    End Sub

    Public Sub New(ByVal message As String)

        MyBase.New(message)
    End Sub

    Public Sub New(ByVal info As SerializationInfo, _
                   ByVal context As StreamingContext)

        MyBase.New(info, context)
    End Sub

End Class
