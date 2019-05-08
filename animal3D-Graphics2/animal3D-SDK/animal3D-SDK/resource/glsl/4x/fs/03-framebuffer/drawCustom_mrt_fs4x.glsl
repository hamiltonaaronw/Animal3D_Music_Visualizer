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
	
	drawCustom_fs4x.glsl
	Custom effects for MRT.
*/

#version 410

// ****TO-DO: 
//	0) copy entirety of other fragment shader to start, or start from scratch: 
//		-> declare varyings to read from vertex shader
//		-> *test all varyings by outputting them as color
//	1) declare at least four render targets
//	2) implement four custom effects, outputting each one to a render target

uniform sampler2D uTex_dm;
uniform sampler2D uTex_sm;
uniform vec4 uColor;

in vbPassDataBlock
{
	vec4 vPosition;
	vec4 vNormal;
	vec2 vTexcoord;
	vec4 vLight;
	vec4 vEyePos;
	vec4 vClipPos;
} vPassData;

layout (location =  0) out vec4 rtRGBtoHSL;
layout (location =  1) out vec4 rtJohnClancysRainbowSix;
layout (location =  2) out vec4 rtGratefulDead;
layout (location = 3) out vec4 rtPrisonUniform;

vec4 rgb2hsl(vec4 color)
{
	vec4 hsl;		

	float cMin = min(min(color.r, color.g), color.b);	// min value of RGB
	float cMax = max(max(color.r, color.g), color.b);	// max value of rgb
	float delta = cMax - cMin;		// delta RGB value

	hsl.a = (cMax + cMin) / 2.0;	// luminance

	if (delta == 0.0)	// this is gray, no chroma
	{
		hsl.x = 0.0;		// hue	
		hsl.y = 0.0;		// saturation
	}
	else	// chromatic data 
	{
		if (hsl.z < 0.5)
			hsl.y = delta / (cMax + cMin);	// saturation
		else
			hsl.y = delta / (2.0 - cMax - cMin);	// saturation

		float dR = (((cMax - color.r) / 6.0) + (delta / 2.0)) / delta;
		float dG = (((cMax - color.g) / 6.0) + (delta / 2.0)) / delta;
		float dB = (((cMax - color.b) / 6.0) + (delta / 2.0)) / delta;

		if (cMax == color.r)
			hsl.x = dB - dG;	// hue
		else if (cMax == color.g)
			hsl.x = (1.0 / 3.0) + dR - dB;		// hue
		else if (cMax == color.b)
			hsl.x = (2.0 / 3.0) + dG - dR;	// hue

		if (hsl.x < 0.0f)
			hsl.x += 1.0f;	// hue
		else if (hsl.x > 1.0f)
			hsl.x -= 1.0f;	// hue
	}

	return hsl;
}

vec4 johnClancysRainbowSix(vec4 color)
{
	vec4 outSin;
	float pi = 3.14159;

	float A = 0.15;
	float w = 10.0 * pi;
	float t = 30.0 * pi / 180.0;
	float y = sin(w * color.r + t) * A;

	outSin.r = sin(w * color.r + t) * A * tan(-0.5);
	outSin.g = tan(w * color.g + t) * A;
	outSin.b = cos(w * color.b + t) * A;

	return outSin;
}

vec4 theGratefulDead(vec4 color)
{
	vec4 outC;

	vec2 pos = (vPassData.vEyePos.xy / color.xy) / 4.0;

	float col = 0.0;
	col += sin(pos.x * cos(vPassData.vEyePos.x / 15.0) * 8) + cos(pos.y * cos(vPassData.vEyePos.x / 15.0) * .00001);
	col += sin(pos.y * sin(vPassData.vEyePos.y / 4.0) * 40.0) + cos(pos.x * sin(vPassData.vEyePos.y / 25.0) * .004);
	col += sin(pos.x * sin(vPassData.vEyePos.z / 1.0) * 10.0) + sin(pos.y * sin(vPassData.vEyePos.z / 35.0) * .0008);

	col *= sin(vPassData.vClipPos.x / 10.0) * 0.5;

	outC = vec4(fract(col), col * 0.5, fract(sin(col + max((color.r, color.g), color.b) * 30.0) * 0.75), 1.0); 

	return outC;
}

vec4 prisonUniform(vec4 color)
{
	float lineW = 3.0;
	float frame = vPassData.vEyePos.z * 60.0;
	float innerCircle = min((color.r, color.g), color.b) / 5.0;

	vec2 p = vPassData.vEyePos.xy - (color.rg / 2);

	float dist = (p.x + p.y) / 2.0;

	dist += mix(frame, -frame, step(innerCircle, length(p)));

	vec4 outC = mix(vec4(0), vec4(1), mod(floor(dist / lineW), 2.0));

	return outC;

}

void main()
{
	// DUMMY OUTPUT: all fragments are FADED CYAN
//	rtFragColor = vec4(0.5, 1.0, 1.0, 1.0);

	// textured vec4 to apply the other RTs on
	vec4 diffuseMap = texture(uTex_dm, vPassData.vTexcoord);

	rtRGBtoHSL = rgb2hsl(diffuseMap);
	rtJohnClancysRainbowSix = johnClancysRainbowSix(diffuseMap);
	rtGratefulDead = theGratefulDead(diffuseMap);
	rtPrisonUniform = prisonUniform(diffuseMap);
}
