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
	
	drawTexture_fs4x.glsl
	Draw texture sample using texture coordinate from prior shader.
*/

#version 410

// ****TO-DO: 
//	1) declare image handles (see blend pass in render)
//	2) sample and *test images
//	3) implement some multi-image blending algorithms
//	4) output result as blend between multiple images

in vec2 vPassTexcoord;

uniform sampler2D uImage0;

layout (location = 0) out vec4 rtFragColor;

// (1)
uniform sampler2D uImage1;
uniform sampler2D uImage2;
uniform sampler2D uImage3;

// (3)
vec4 blend(vec4 a, vec4 b, vec4 c, vec4 d)
{
	return vec4(1 - (1 - a) * (1 - b) * (1 - c) * (1 - d));
}

void main()
{
	vec4 samp0 = texture(uImage0, vPassTexcoord);
	vec4 samp1 = texture(uImage1, vPassTexcoord);
	vec4 samp2 = texture(uImage2, vPassTexcoord);
	vec4 samp3 = texture(uImage3, vPassTexcoord);


	//(2)
//	rtFragColor = samp0;
//	rtFragColor = samp1;
//	rtFragColor = samp2;
//	rtFragColor = samp3;

	// (4)
	vec4 bloom = blend(samp0, samp1, samp2, samp3);
	rtFragColor = bloom;
}
