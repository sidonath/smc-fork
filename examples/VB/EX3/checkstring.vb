'
' The contents of this file are subject to the Mozilla Public
' License Version 1.1 (the "License"); you may not use this file
' except in compliance with the License. You may obtain a copy
' of the License at http://www.mozilla.org/MPL/
' 
' Software distributed under the License is distributed on an
' "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
' implied. See the License for the specific language governing
' rights and limitations under the License.
' 
' The Original Code is State Machine Compiler (SMC).
' 
' The Initial Developer of the Original Code is Charles W. Rapp.
' Portions created by Charles W. Rapp are
' Copyright (C) 2003. Charles W. Rapp.
' All Rights Reserved.
' 
' Contributor(s): 
'
' Function
'   Main
'
' Description
'  This routine starts the finite state machine running.
'
' RCS ID
' $Id: checkstring.vb,v 1.2 2009/03/01 18:20:40 cwrapp Exp $
'
' CHANGE LOG
' $Log: checkstring.vb,v $
' Revision 1.2  2009/03/01 18:20:40  cwrapp
' Preliminary v. 6.0.0 commit.
'
' Revision 1.1  2005/05/28 18:15:26  cwrapp
' Added VB.net examples 1 - 4.
'
' Revision 1.0  2004/05/30 21:36:04  charlesr
' Initial revision
'

Module checkstring

    Sub Main(ByVal args As String())

        If args.Length < 1 _
        Then
            Console.WriteLine("No string to check.")
        ElseIf args.Length > 1 _
        Then
            Console.WriteLine("Only one argument is accepted.")
        Else
            Dim appobject As AppClass = New AppClass()

            Console.Write("The string '")
            Console.Write(args(0))
            Console.Write("' is ")

            If appobject.CheckString(args(0)) = False _
            Then
                Console.WriteLine("not acceptable.")
            Else
                Console.WriteLine("acceptable.")
            End If
        End If
    End Sub

End Module
