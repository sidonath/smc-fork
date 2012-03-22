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
// Copyright (C) 2000 - 2003 Charles W. Rapp.
// All Rights Reserved.
// 
// Contributor(s): 
//
// Name
//  TimerListener.java
//
// Description
//  Because I am using non-Swing, pre-JDK 1.4 Java, I have to
//  use my own timer class.
//
// RCS ID
// $Id: TimerListener.java,v 1.3 2005/05/28 19:41:44 cwrapp Exp $
//
// CHANGE LOG
// $Log: TimerListener.java,v $
// Revision 1.3  2005/05/28 19:41:44  cwrapp
// Update for SMC v. 4.0.0.
//
// Revision 1.0  2003/12/14 19:04:42  charlesr
// Initial revision
//

import java.util.EventListener;

public interface TimerListener
    extends EventListener
{
    public void handleTimeout(TimerEvent event);
}
