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

	drawNonPhotoMulti_fs4x.glsl
	Calculate and output non-photorealistic shading model for multiple lights 
		using data from prior shader.
*/

#version 410

// ****TO-DO: 
//	1) start with completed Phong fragment shader
//	2) implement cel shading (ramps) or Gooch shading (cool/warm gradient)
//		-> declare new samplers or colors
//		-> *test values as output color

out vec4 rtFragColor;

in vbPassDataBlock
{
	vec4 vPosition;
	vec4 vNormal;
	vec2 vTexcoord;
	vec4 vLight;
	vec4 vEyePos;
	vec4 vClipPos;
} vPassData;

void main()
{
	// DUMMY OUTPUT: all fragments are FADED MAGENTA
	rtFragColor = vec4(1.0, 0.5, 1.0, 1.0);
}
