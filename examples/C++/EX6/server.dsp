# Microsoft Developer Studio Project File - Name="server" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

CFG=server - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "server.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "server.mak" CFG="server - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "server - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "server - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "server - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release\server"
# PROP Intermediate_Dir "Release\server"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /W3 /GR /GX /O2 /I "..\..\..\lib" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /D "_SERVER_APP_" /YX /FD /c
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib ws2_32.lib /nologo /subsystem:console /machine:I386

!ELSEIF  "$(CFG)" == "server - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug\server"
# PROP Intermediate_Dir "Debug\server"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /W3 /Gm /GR /GX /ZI /Od /I "..\..\..\lib" /D "WIN32" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib ws2_32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept

!ENDIF 

# Begin Target

# Name "server - Win32 Release"
# Name "server - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\AppClient.cpp
# End Source File
# Begin Source File

SOURCE=.\AppServer.cpp
# End Source File
# Begin Source File

SOURCE=.\Eventloop.cpp
# End Source File
# Begin Source File

SOURCE=.\server.cpp
# End Source File
# Begin Source File

SOURCE=.\TcpClient.cpp
# End Source File
# Begin Source File

SOURCE=.\TcpConnection.cpp
# End Source File
# Begin Source File

SOURCE=.\TcpConnection.sm

!IF  "$(CFG)" == "server - Win32 Release"

# Begin Custom Build
TargetName=server
InputPath=.\TcpConnection.sm

"$(TargetName)_sm.h $(TargetName)_sm.cpp" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	java -jar ..\..\..\bin\Smc.jar -c++ $(InputPath)

# End Custom Build

!ELSEIF  "$(CFG)" == "server - Win32 Debug"

# Begin Custom Build
TargetName=server
InputPath=.\TcpConnection.sm

"$(TargetName)_sm.h $(TargetName)_sm.cpp" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	java -jar ..\..\..\bin\Smc.jar -c++ -g $(InputPath)

# End Custom Build

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\TcpConnection_sm.cpp
# End Source File
# Begin Source File

SOURCE=.\TcpSegment.cpp
# End Source File
# Begin Source File

SOURCE=.\TcpServer.cpp
# End Source File
# Begin Source File

SOURCE=.\winsock_strerror.cpp
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\AppClient.h
# End Source File
# Begin Source File

SOURCE=.\AppServer.h
# End Source File
# Begin Source File

SOURCE=.\Eventloop.h
# End Source File
# Begin Source File

SOURCE=.\FDHandler.h
# End Source File
# Begin Source File

SOURCE=.\InputListener.h
# End Source File
# Begin Source File

SOURCE=.\TcpClient.h
# End Source File
# Begin Source File

SOURCE=.\TcpConnection.h
# End Source File
# Begin Source File

SOURCE=.\TcpConnection_sm.h
# End Source File
# Begin Source File

SOURCE=.\TcpConnectionListener.h
# End Source File
# Begin Source File

SOURCE=.\TcpSegment.h
# End Source File
# Begin Source File

SOURCE=.\TcpServer.h
# End Source File
# Begin Source File

SOURCE=.\TimerListener.h
# End Source File
# End Group
# End Target
# End Project
