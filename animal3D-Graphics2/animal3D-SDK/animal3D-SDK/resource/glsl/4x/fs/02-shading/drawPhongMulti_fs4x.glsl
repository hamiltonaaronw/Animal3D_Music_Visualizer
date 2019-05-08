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
	
	drawPhongMulti_fs4x.glsl
	Calculate and output Phong shading model for multiple lights using data 
		from prior shader.
*/

#version 410

// ****TO-DO: 
//	1) declare varyings to read from vertex shader
//		-> *test all varyings by outputting them as color
//	2) declare uniforms for textures (diffuse, specular)
//	3) sample textures and store as temporary values
//		-> *test all textures by outputting samples
//	4) declare fixed-sized arrays for lighting values and other related values
//		-> *test lighting values by outputting them as color
//		-> one day this will be made easier... soon, soon...
//	5) implement Phong shading calculations
//		-> *save time where applicable
//		-> diffuse, specular, attenuation
//		-> remember to be modular (e.g. write a function)
//	6) calculate Phong shading model for one light
//		-> *test shading values (diffuse, specular) by outputting them as color
//	7) calculate Phong shading for all lights
//		-> *test shading values
//	8) add all light values appropriately
//	9) calculate final Phong model (with textures) and copy to output
//		-> *test the individual shading totals
//		-> use alpha channel from diffuse sample for final alpha

uniform sampler2D uTex_dm;
uniform sampler2D uTex_sm;

in vbPassDataBlock
{
	vec4 vPosition;
	vec4 vNormal;
	vec2 vTexcoord;
	vec4 vLight;
	vec4 vEyePos;
	vec4 vClipPos;
} vPassData;

layout (location = 0) out vec4 rtFragColor;

void main()
{
	vec4 texD = texture(uTex_dm, vPassData.vTexcoord);
	vec4 texS = texture(uTex_sm, vPassData.vTexcoord);

	// PHONG
	vec4 L = normalize(vPassData.vLight);
	vec4 N = normalize(vPassData.vNormal);
	float diffuse = dot(L, N);

	// specular total
	vec4 R = normalize((2*diffuse) - L);
	vec4 V = normalize(vPassData.vClipPos);
	float specular = dot(R, V);
	
	int j = 4;
	for (int i = 0; i < j; ++i)
		specular *= specular;

	vec3 Phong = texD.rgb * diffuse + texS.rgb * specular;
	rtFragColor = vec4(Phong, texD.a);
}