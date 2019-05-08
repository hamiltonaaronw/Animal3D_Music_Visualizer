// This file was modified by Aaron William Hamilton with permission from the author
/*

Aaron William Hamilton		1000338
EGP 300 01
“We certify that this work is entirely our own. The assessor of this project
may reproduce this project and provide copies to other academic staff,
and/or communicate a copy of this project to a plagiarism-checking service,
which may retain a copy of the project on its database.”
*/


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
	
	drawColorAttrib_fs4x.glsl
	Draw color attribute passed from prior stage as varying.
*/

#version 410

// ****TO-DO: 
//	1) declare varying to receive input vertex color from vertex shader
//	2) assign vertex color to output color

// (1)
in vec4 vColor;

out vec4 rtFragColor;

void main()
{
	// DUMMY OUTPUT: all fragments are OPAQUE RED
	//rtFragColor = vec4(1.0, 0.0, 0.0, 1.0);

	// (2)
	rtFragColor = vColor;
}
