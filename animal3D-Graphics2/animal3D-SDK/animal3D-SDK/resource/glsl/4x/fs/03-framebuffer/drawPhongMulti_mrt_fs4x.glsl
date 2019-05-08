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
	
	drawPhongMulti_mrt_fs4x.glsl
	Phong shading model with splitting to multiple render targets (MRT).
*/

#version 410

// ****TO-DO: 
//	0) copy entirety of Phong fragment shader
//	1) declare eight render targets
//	2) output appropriate data to render targets

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

// (1)
layout (location = 0) out vec4 rtPosition;
layout (location = 1) out vec4 rtNormal;
layout (location = 2) out vec4 rtTexcoord;
layout (location = 3) out vec4 rtDiffuseMap;
layout (location = 4) out vec4 rtSpecularMap;
layout (location = 5) out vec4 rtDiffuseTotal;
layout (location = 6) out vec4 rtSpecularTotal;
layout (location = 7) out vec4 rtPhongTotal;

uniform vec4 uLightPos[4];
uniform vec4 uLightCol[4];
uniform float uLightSz[4];
uniform int uLightCt;

float calculateDiffuse()
{
	float diff = 0;
	for (int i = 0; i < uLightCt; ++i)
	{
		vec4 L = normalize(uLightPos[i] - vPassData.vEyePos);
		vec4 N = normalize(vPassData.vNormal);
		diff += max(0, dot(L, N));
	}
	
	return diff;
}

void main()
{
// (2)
	rtPosition = vPassData.vPosition;
	rtNormal = normalize(vPassData.vNormal);
	rtTexcoord = vec4(vPassData.vTexcoord, 0, 0);
	rtDiffuseMap = texture(uTex_dm, vPassData.vTexcoord);
	rtSpecularMap = texture(uTex_sm, vPassData.vTexcoord);

	vec4 lightCols = vec4(0);
	for (int i = 0; i < uLightCt; ++i)
		lightCols += (uLightCol[i] / uLightSz[i]); 
	
	// diffuse total
	vec4 L = normalize(vPassData.vLight);
	vec4 N = normalize(vPassData.vNormal);
	float diffuse = dot(L, N);
	rtDiffuseTotal =  vec4(diffuse) + normalize(lightCols) * rtDiffuseMap;

	// specular total
	vec4 R = normalize((2*diffuse) - L);
	vec4 V = normalize(vPassData.vClipPos);
	float specular = dot(R, V);
	rtSpecularTotal =vec4(specular) + normalize(lightCols) * rtSpecularMap;

	// phong total
	int j = 4;
	for (int i = 0; i < j; ++i)
		specular *= specular;
	vec3 Phong = rtDiffuseMap.rgb * diffuse + rtSpecularMap.rgb * specular;
	rtPhongTotal = vec4(Phong, rtDiffuseMap.a) + normalize(lightCols);
}
