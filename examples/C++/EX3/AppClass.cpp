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
// Class
//	AppClass
//
// Member Functions
//	AppClass()				  - Default constructor.
//	CheckString(const char *) - Is this string acceptable?
//
// RCS ID
// $Id: AppClass.cpp,v 1.6 2009/12/17 19:51:42 cwrapp Exp $
//
// CHANGE LOG
// $Log: AppClass.cpp,v $
// Revision 1.6  2009/12/17 19:51:42  cwrapp
// Testing complete.
//
// Revision 1.5  2009/03/01 18:20:37  cwrapp
// Preliminary v. 6.0.0 commit.
//
// Revision 1.4  2005/05/28 13:31:18  cwrapp
// Updated C++ examples.
//
// Revision 1.0  2003/12/14 19:18:49  charlesr
// Initial revision
//

#ifdef WIN32
#pragma warning(disable: 4355)
#endif

#include "AppClass.h"

const static char _rcs_id[] = "$Id: AppClass.cpp,v 1.6 2009/12/17 19:51:42 cwrapp Exp $";

AppClass::AppClass()
: _fsm(*this),
  isAcceptable(false)
{
    // Uncomment to see debug output.
    // _fsm.setDebugFlag(true);
}

bool AppClass::CheckString(const char *theString)
{
    _fsm.enterStartState();
	while(*theString)
	{
		switch(*theString)
		{
		case '0':
			_fsm.Zero();
			break;

		case '1':
			_fsm.One();
			break;

		case 'c':
		case 'C':
// Uncomment to test serialization.
//               if (serialize("foobar.txt") < 0)
//               {
//                   std::cerr << "FSM serialization failed." << std::endl;
//               }
//               else if (deserialize("foobar.txt") < 0)
//               {
//                   std::cerr << "FSM deserialization failed." << std::endl;
//               }
//               else
//               {
//                   _fsm.C();
//               }
			_fsm.C();
			break;

		default:
			_fsm.Unknown();
			break;
		}
		++theString;
	}

	// end of string has been reached - send the EOS transition.
	_fsm.EOS();

	return(isAcceptable);
}

// Uncomment to test serialization.
// int AppClass::serialize(const std::string& filename)
// {
//     int fd(open(filename.c_str(),
//                 (O_WRONLY | O_CREAT | O_TRUNC),
//                 (S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH)));
//     int retval(-1);

//     if (fd >= 0)
//     {
//         int size(_fsm.getStateStackDepth() + 1);
//         int bufferSize(size * sizeof(int));
//         int buffer[size + 1];
//         int i;

//         buffer[0] = size;
//         buffer[size] = (_fsm.getState()).getId();
//         for (i = (size - 1); i > 0; --i)
//         {
//             _fsm.popState();
//             buffer[i] = (_fsm.getState()).getId();
//         }

//         retval = write(fd, buffer, (bufferSize + sizeof(int)));

//         (void) close(fd);
//         fd = -1;
//     }

//     return (retval);
// } // end of AppClass::serialize(const std::string&)

// Uncomment to test serialization.
// int AppClass::deserialize(const std::string& filename)
// {
//     int fd(open(filename.c_str(), O_RDONLY));
//     int size;
//     int retval(-1);

//     _fsm.clearState();

//     if (fd >= 0 && read(fd, &size, sizeof(int)) == sizeof(int))
//     {
//         int bufferSize(size * sizeof(int));
//         int buffer[size];

//         if (read(fd, buffer, bufferSize) == bufferSize)
//         {
//             int i;

//             retval = (bufferSize + sizeof(int));

//             for (i = 0; i < size; i++)
//             {
//                 _fsm.pushState(_fsm.valueOf(buffer[i]));
//             }
//         }
//     }

//     if (fd >= 0)
//     {
//         (void) close(fd);
//         fd = -1;
//     }

//     return (retval);
// } // end of AppClass::deserialize(const std::string&)
