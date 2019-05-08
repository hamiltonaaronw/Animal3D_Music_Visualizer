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
	
	drawPhongMulti_deferred_fs4x.glsl
	Perform Phong shading on multiple lights, deferred.
*/

#version 410

// ****TO-DO: 
//	0) copy entirety of Phong multi-light shader
//	1) geometric inputs from scene objects are not received from VS!
//		-> we are drawing a textured FSQ so where does the geometric 
//			input data come from? declare appropriately
//	2) retrieve new geometric inputs (no longer from varyings)
//		-> *test by outputting as color
//	3) use new inputs where appropriate in lighting

// (0)
uniform sampler2D uTex_atlas_dm;
uniform sampler2D uTex_atlas_sm;

uniform vec4 uLightPos[4];
uniform vec4 uLightCol[4];
uniform float uLightSz[4];
uniform int uLightCt;

in vec2 vPassTexcoord;

// (1)
uniform sampler2D uImage4;
uniform sampler2D uImage5;
uniform sampler2D uImage6;
uniform sampler2D uImage7;

layout (location = 0) out vec4 rtFragColor;

void main()
{
	// (2)
	vec4	gPosition	=		texture(uImage4, vPassTexcoord);
	vec4	gNormal		=		texture(uImage5, vPassTexcoord);
	vec2	gTexcoord	=		texture(uImage6, vPassTexcoord).xy;
	float	gDepth		=		texture(uImage7, vPassTexcoord).x;

	// (0)
	vec4 texD = texture(uTex_atlas_dm, gTexcoord);
	vec4 texS = texture(uTex_atlas_sm, gTexcoord);

	// PHONG
	vec4 lightCols = vec4(0);
	for (int i = 0; i < uLightCt; ++i)
		lightCols += (uLightCol[i] / uLightSz[i]);
	vec4 lightDir = lightCols - gPosition;

	// diffuse
	vec4 L = normalize(lightDir);
	vec4 N = normalize(gNormal);
	float diffuse = dot(L, N);

	// specular
	vec4 R = normalize((2*diffuse) - L);
	vec4 V = normalize(gPosition);
	float specular = dot(R, V);
	
	int j = 4;
	for (int i = 0; i < j; ++i)
		specular *= specular;

	vec4 phongV4 = vec4((texD * diffuse) + (texS * specular));
	rtFragColor =  vec4(phongV4.xyz, phongV4.z + gDepth);

	// (2*)
//	rtFragColor = gPosition;
//	rtFragColor = vec4(gNormal.xyz * 0.5 + 0.5, 1.0);
//	rtFragColor = vec4(gTexcoord, 0.0, 1.0);
//	rtFragColor = vec4(gDepth, gDepth, gDepth, 1.0);
}

/* ********** cool stuff below

	vec4 lighting = vec4(gTexcoord * 2, 0.0, 1.0);		// also pretty cool
	vec4 lighting;
	for (int i = 0; i < uLightCt; ++i)
	{
		vec4 lightDir = normalize(uLightPos[i] - gPosition);
		vec4 diffuse = max(dot(gNormal, lightDir), 0.0) * uLightCol[i];
		lighting += diffuse;
	}

	vec3 phongV3 = (texD.rgb * diffuse + texS.rgb * gDepth);
	vec4 phongV4 = vec4(phongV3, 1.0) + normalize(lightCols);

	rtFragColor = vec4(lighting.xyz, 1.0);

*/
