// This file was modified by Aaron Hamilton with permission of the author

/*
	Copyright 2011-2019 Daniel S. Buckstein

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/

/*
	animal3D SDK: Minimal 3D Animation Framework
	By Daniel S. Buckstein
	
	main_dll.c
	Win32 DLL entry point.

	**DO NOT MODIFY THIS FILE**
*/


#if (defined _WINDOWS || defined _WIN32)


#include <Windows.h>


//-----------------------------------------------------------------------------
// link renderer lib and respective dependencies
#pragma comment(lib, "animal3D-A3DG-OpenGL.lib")
#pragma comment(lib, "opengl32.lib")
#pragma comment(lib, "glew32.lib")

// FMOD stuff
#pragma comment(lib, "fmod_vc.lib")


//-----------------------------------------------------------------------------
// optional DLL entry point

int APIENTRY DllMain(
	HMODULE hModule,
	DWORD  ul_reason_for_call,
	LPVOID lpReserved
)
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
		break;
	case DLL_THREAD_ATTACH:
		break;
	case DLL_THREAD_DETACH:
		break;
	case DLL_PROCESS_DETACH:
		break;
	}
	return TRUE;
}


#endif	// (defined _WINDOWS || defined _WIN32)