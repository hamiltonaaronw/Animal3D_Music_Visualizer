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
	
	manipTriangle_gs4x.glsl
	Manipulate a single input triangle.
*/

#version 410

// ****TO-DO: 
//	1) declare input and output varying data
//	2) either copy input directly to output for each vertex, or 
//		do something with the vertices first (e.g. explode, invert)

layout (triangles) in;
layout (triangle_strip, max_vertices = 3) out;

uniform mat4 uP;

// recieved from FMOD DSP
uniform float uFreq;
uniform double uTime;

// (1)
// received from "passPhongAttribs_transform_vs"
in vbPassDataBlock
{
	vec4 vPosition;
	vec4 vNormal;
	vec2 vTexcoord;
} vPassDataIn[];

// sending to "drawPhongMulti_fs"
out vbPassDataBlock
{
	vec4 vPosition;
	vec4 vNormal;
	vec2 vTexcoord;
} vPassDataOut;

float sinc(float x)
{
	return sin(x)/x;
}

void main()
{
	// (2)
	float freq;
	if (uFreq >= 0)
		freq = uFreq;
	else
		freq = 0.1;

	//const float explodeSz = 0.5;
	for (int i = 0; i < 3; ++i)
	//for (int i = 2; i >= 0; --i)
	{
		vPassDataOut.vPosition		=	vPassDataIn[i].vPosition + normalize(vPassDataIn[0].vNormal) * -freq;
		vPassDataOut.vNormal		=	vPassDataIn[i].vNormal;
		vPassDataOut.vTexcoord		=	vPassDataIn[i].vTexcoord;

		gl_Position = uP * vPassDataOut.vPosition;
		EmitVertex();
	}

	EndPrimitive();
}
