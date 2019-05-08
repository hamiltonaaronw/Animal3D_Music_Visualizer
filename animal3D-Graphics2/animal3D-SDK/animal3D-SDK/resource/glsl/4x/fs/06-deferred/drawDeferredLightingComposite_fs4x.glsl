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
	
	drawDeferredLightingComposite_fs4x.glsl
	Composite deferred lighting.
*/

#version 410

// ****TO-DO: 
//	1) declare images with results of lighting pass
//	2) declare remaining geometry inputs (atlas coordinates) and atlas textures
//	3) declare any other shading variables not involved in lighting pass
//	4) sample inputs to get components of Phong shading model
//		-> surface colors, lighting results
//		-> *test by outputting as color
//	5) compute final Phong shading model (i.e. the final sum)

in vec2 vPassTexcoord;

layout (location = 0) out vec4 rtFragColor;

uniform sampler2D uTex_atlas_dm;
uniform sampler2D uTex_atlas_sm;

uniform float uPixelSz;

uniform sampler2D uImage0;
uniform sampler2D uImage1;
uniform sampler2D uImage5;
uniform sampler2D uImage6;
uniform sampler2D uImage7;

void main()
{
	// DUMMY OUTPUT: all fragments are FADED CYAN
//	rtFragColor = vec4(0.5, 1.0, 1.0, 1.0);

//	rtFragColor = vec4(vPassTexcoord, 0.0, 1.0);

	vec4 atlas = texture(uImage6, vPassTexcoord);

	vec4 texD = texture(uTex_atlas_dm, atlas.xy);
	vec4 texS = texture(uTex_atlas_sm, atlas.xy);

	rtFragColor = texS;//texture(uTex_atlas_dm, vPassTexcoord);
}
