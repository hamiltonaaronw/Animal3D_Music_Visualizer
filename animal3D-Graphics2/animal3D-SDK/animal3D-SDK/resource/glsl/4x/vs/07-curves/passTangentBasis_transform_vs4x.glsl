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
	
	passTangentBasis_transform_vs4x.glsl
	Transform and pass complete tangent basis.
*/

#version 410

// ****TO-DO: 
//	1) declare remaining tangent basis attributes
//	2) declare transformation matrix uniforms
//	3) declare tangent basis to pass along
//	4) define local tangent basis
//	5) transform and pass tangent basis
//	6) set final clip-space position

// what are tangent basis???
// M = [ T B N P ]
//		tangent, bitangent, normal, position

// (1)
layout (location = 10)	in vec4 aTangent;
layout (location = 11)	in vec4 aBitangent;
layout (location = 2)	in vec4 aNormal;
layout (location = 0)	in vec4 aPosition;

// (2)
uniform mat4 uMV, uP;

// (3)
out mat4 vPassTangentBasis;
out vec4 color;

void main()
{
	// (4)
	mat4 tangentBasis = mat4(
		aTangent,		 0.0,
		aBitangent,		 0.0,
		aNormal,		 0.0,
		aPosition);

	// (5)
	vPassTangentBasis = uMV * tangentBasis;

	// (6)
	for (int i = 0; i < 4; ++i)
		gl_Position = uP * vPassTangentBasis[i];
	color = vec4(1.0, 1.0, 0.0, 1.0);
}
