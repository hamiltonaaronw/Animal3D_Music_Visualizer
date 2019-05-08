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
	
	drawPhong_volume_fs4x.glsl
	Perform Phong shading for a single light within a volume; output 
		components to MRT.
*/

#version 410

// ****TO-DO: 
//	0) copy entirety of Phong multi-light shader
//	1) geometric inputs from scene objects are not received from VS!
//		-> we are drawing a textured FSQ so where does the geometric 
//			input data come from? declare appropriately
//	2) declare varyings for light volume geometry
//		-> biased clip-space position, index
//	3) declare uniform blocks
//		-> implement data structure matching data in renderer
//		-> replace old lighting uniforms with new block
//	4) declare multiple render targets
//		-> diffuse lighting, specular lighting
//	5) compute screen-space coordinate for current light
//	6) retrieve new geometric inputs (no longer from varyings)
//		-> *test by outputting as color
//	7) use new inputs where appropriate in lighting
//		-> remove anything that can be deferred further


// (2)
in vec4 vPassBiasClipCoord;
in vec2 vPassTexcoord;
in vec4 vClipPos;
in vec4 vLight;
flat in int vPassInstanceID;

// (3)
#define maxLights 1024
struct sPointLight 
{
	vec4 worldPos;	
	vec4 viewPos;		
	vec4 color;		
	float radius;		
	float radiusInvSq;	
	float pad[2];
};
uniform ubPointLight {
	sPointLight uPointLight[maxLights];
};
layout (location = 0) out vec4 rtDiffuse;
layout (location = 1) out vec4 rtSpecular;

uniform vec4 uColor;

// (1)
uniform sampler2D uImage4;
uniform sampler2D uImage5;
uniform sampler2D uImage6;

uniform sampler2D uTex_atlas_dm;
uniform sampler2D uTex_atlas_sm;

uniform mat4 uP_inv;

void main()
{
	vec4	difAtlas		=		texture(uTex_atlas_dm, vPassBiasClipCoord.xy);
	vec4	specAtlas		=		texture(uTex_atlas_sm, vPassBiasClipCoord.xy);
	vec4	difOut			=		texture(uImage4, difAtlas.xy);
	vec4	specOut			=		texture(uImage5, difAtlas.xy);
	vec4	texOut			=		texture(uImage6, vPassTexcoord.xy);

	vec4 lightCol = uPointLight[vPassInstanceID].color;
	vec4 lightDir = lightCol - difOut;

	// diffuse
	vec4 L = normalize(uPointLight[vPassInstanceID].viewPos);
	vec4 N = normalize(difAtlas) * vec4(uPointLight[vPassInstanceID].radiusInvSq);
	float diffuse = dot(L, N);
	vec4 diffuseTotal = vec4(diffuse) + lightDir * difAtlas;

	// specular
	vec4 R = normalize((2 * diffuse) - L);
	vec4 V = normalize(specAtlas);
	float specular = dot(R, V);
	vec4 specularTotal = vec4(specular) + lightDir * specAtlas;

	rtDiffuse = diffuseTotal * uPointLight[vPassInstanceID].color;
	rtSpecular = specularTotal * uPointLight[vPassInstanceID].color;
}

