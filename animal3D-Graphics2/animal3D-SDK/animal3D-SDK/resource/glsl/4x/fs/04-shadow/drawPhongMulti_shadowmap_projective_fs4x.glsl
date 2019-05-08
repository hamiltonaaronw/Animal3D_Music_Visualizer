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
	
	drawPhongMulti_shadowmap_projective_fs4x.glsl
	Phong shading with shadow mapping and projective texturing.
*/

#version 410

// ****TO-DO: 
//	0) complete and combine projective texturing and shadow mapping shaders

uniform sampler2D uTex_shadow;												
uniform sampler2D uTex_dm;
uniform sampler2D uTex_sm;
uniform sampler2D uTex_proj;

uniform vec4 uLightPos[4];
uniform vec4 uLightCol[4];
uniform float uLightSz[4];
uniform int uLightCt;

in vbPassDataBlock
{
	vec4 vPosition;
	vec4 vNormal;
	vec2 vTexcoord;
	vec4 vLight;
	vec4 vEyePos;
	vec4 vClipPos;

	vec4 vShadowCoord;
	vec4 vProjClip;
} vPassData;

layout (location = 0) out vec4 rtFragColor;

void main()
{
	vec4 texD = texture(uTex_dm, vPassData.vTexcoord);
	vec4 texS = texture(uTex_sm, vPassData.vTexcoord);

	// PHONG
	vec4 lightCols = vec4(0);
	for (int i = 0; i < uLightCt; ++i)
		lightCols += (uLightCol[i] / uLightSz[i]); 
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

	vec3 _phong = texD.rgb * diffuse + texS.rgb * specular;
	vec4 Phong = vec4(_phong, 1.0) + normalize(lightCols);

	// projective texturing
	vec4 screenProj = vPassData.vProjClip / vPassData.vProjClip.w;
	vec4 projTex = texture(uTex_proj, screenProj.xy);
	
	rtFragColor = Phong * mix(texD, projTex, vec4(0.5));

	// shadow mapping
	vec4 screen_proj = vPassData.vShadowCoord / vPassData.vShadowCoord.w;				

	vec4 sample_shadow = texture(uTex_shadow, screen_proj.xy);						

	float shadowValue = sample_shadow.x;
	float shadowTest = screen_proj.z > shadowValue + 0.0001 ? 0.2 : 1.0;

	rtFragColor.rgb *= shadowTest;
}