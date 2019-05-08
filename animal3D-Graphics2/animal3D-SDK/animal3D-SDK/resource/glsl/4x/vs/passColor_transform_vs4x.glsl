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
	
	passColor_transform_vs4x.glsl
	Transform position attribute and pass color attribute down the pipeline.
*/

#version 410

// ****TO-DO: 
//	1) declare uniform variable for MVP matrix; see demo code for hint
//	2) correctly transform input position by MVP matrix
//	3) declare attribute for vertex color input
//	4) declare varying to pass color input to fragment shader
//	5) assign vertex color input to varying

layout (location = 0) in vec4 aPosition;

// (1)
uniform mat4 uMVP;

// (3)
layout (location = 3) in vec4 aColor;

// (4)
out vec4 vPassColor;

void main()
{
	// DUMMY OUTPUT: directly assign input position to output position
	//gl_Position = aPosition;

	// (2)
	gl_Position = uMVP * aPosition;

	// (5)
	vPassColor = aColor;
}
