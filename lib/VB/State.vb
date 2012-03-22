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
'  This package defines the state class which SMC-generated
'  state classes override.
'
' RCS ID
' $Id: State.vb,v 1.1 2005/05/28 18:47:13 cwrapp Exp $
'
' Change Log
' $Log: State.vb,v $
' Revision 1.1  2005/05/28 18:47:13  cwrapp
' Updated C++, Java and Tcl libraries, added CSharp, Python and VB.
'
' Revision 1.0  2004/05/31 13:46:48  charlesr
' Initial revision
'

' statemap.State --
'
' Base class for all SMC-generated state classes. Contains the
' state's name and unique identifier.
'
' @author <a href="mailto:rapp@acm.org">Charles Rapp</a>

Public MustInherit Class State

    '------------------------------------------------------------
    ' Member Data.
    '

    ' The state's unique name.
    Private _name As String

    ' The state's unique identifier.
    Private _id As Integer

    '------------------------------------------------------------
    ' Properties
    '

    Public ReadOnly Property Name As String
       Get
           Return _name
       End Get
    End Property

    Public ReadOnly Property Id As Integer
        Get
            Return _id
        End Get
    End Property

    '------------------------------------------------------------
    ' Member methods.
    '

    ' Returns the state's name.
    Public Overrides Function ToString() As String

        Return _name
    End Function

    Protected Sub New(ByVal name As String, ByVal id As Integer)

        _name = name
        _id = id
    End Sub

    ' The default and copy constructors are private to prevent
    ' their use.
    Private Sub New()
    End Sub

    Private Sub New(ByVal state As State)
    End Sub

End Class
