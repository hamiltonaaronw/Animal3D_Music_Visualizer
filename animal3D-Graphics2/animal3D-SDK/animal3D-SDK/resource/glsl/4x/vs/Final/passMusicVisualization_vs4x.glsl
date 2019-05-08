/*
	Author: Aaron William Hamilton
	
	passMusicVisualization_vs4x.glsl
	Outputs data from audio
*/

#version 410

layout (location = 0) in vec4 aPosition;
layout (location = 2) in vec3 aNormal;
layout (location = 8) in vec2 aTexcoord;

out vec2 vPassTexcoord;
out vec3 vPassNormal;


void main()
{
	gl_Position = vec4(aTexcoord.xy - 0.5, 0.0, 0.5);

	vPassTexcoord = aTexcoord;
	vPassNormal = aNormal;
}
