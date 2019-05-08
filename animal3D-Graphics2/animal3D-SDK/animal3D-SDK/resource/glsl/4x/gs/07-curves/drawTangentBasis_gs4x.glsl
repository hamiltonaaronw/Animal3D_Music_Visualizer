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
	
	drawTangentBasis_gs4x.glsl
	Draw tangent basis.
*/

#version 410

// ****TO-DO: 
//	1) declare input and output varying data
//	2) draw tangent basis in place of each vertex

layout (triangles) in;
layout (line_strip, max_vertices = 18) out;

uniform mat4 uP;

// (1)
in mat4 vPassTangentBasis[];
in vec4 color[];

out vec4 vColor;

void main()
{
	for (int i = 0; i < gl_in.length(); ++i)
	{
		gl_Position = uP * vPassTangentBasis[i][3];
		vColor = vec4(0.0, 0.0, 0.0, 1.0);
		EmitVertex();

		gl_Position = uP * vPassTangentBasis[i][3] + vPassTangentBasis[i][3];
		vColor = vec4(0.0, 0.0, 1.0, 1.0);
		EmitVertex();	
		
		gl_Position = uP * vPassTangentBasis[i][3];
		vColor = vec4(0.0, 0.0, 0.0, 1.0);
		EmitVertex();

		gl_Position = uP * vPassTangentBasis[i][3] + vPassTangentBasis[i][2];
		vColor = vec4(0.0, 1.0, 0.0, 1.0);
		EmitVertex();		
		
		gl_Position = uP * vPassTangentBasis[i][3];
		vColor = vec4(0.0, 0.0, 0.0, 1.0);
		EmitVertex();

		gl_Position = uP * vPassTangentBasis[i][3] + vPassTangentBasis[i][1];
		vColor = vec4(1.0, 0.0, 0.0, 1.0);
		EmitVertex();		
		
		gl_Position = uP * vPassTangentBasis[i][3];
		vColor = vec4(0.0, 0.0, 0.0, 1.0);
		EmitVertex();

		gl_Position = uP * vPassTangentBasis[i][3] + vPassTangentBasis[i][0];
		vColor = vec4(1.0, 0.0, 0.0, 1.0);
		EmitVertex();

		EndPrimitive();
	}

	EndPrimitive();
}
