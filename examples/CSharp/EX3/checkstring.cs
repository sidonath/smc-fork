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
// Copyright (C) 2004. Charles W. Rapp.
// All Rights Reserved.
// 
// Contributor(s):
//   Eitan Suez contributed examples/Ant.
//   (Name withheld) contributed the C# code generation and
//   examples/C#.
//
// Function
//	Main
//
// Description
//  This routine starts the finite state machine running.
//
// RCS ID
// $Id: checkstring.cs,v 1.1 2005/05/28 13:05:18 cwrapp Exp $
//
// CHANGE LOG
// $Log: checkstring.cs,v $
// Revision 1.1  2005/05/28 13:05:18  cwrapp
// Added CSharp examples 1 - 3.
//
// Revision 1.0  2004/09/01 17:35:44  charlesr
// Initial revision
//

using System;

public class checkstring
{
    static void Main(string[] args)
    {
        AppClass appobject = new AppClass();

        if (args.Length < 1)
        {
            System.Console.WriteLine("No string to check.");
        }
        else if (args.Length > 1)
        {
            System.Console.WriteLine("Only one argument is accepted.");
        }
        else
        {
            System.Console.Write("The string \"");
            System.Console.Write(args[0]);
            System.Console.Write("\" is ");

            if (appobject.CheckString(args[0]) == false)
            {
                System.Console.WriteLine("not acceptable.");
            }
            else
            {
                System.Console.WriteLine("acceptable.");
            }
        }
    }
}
