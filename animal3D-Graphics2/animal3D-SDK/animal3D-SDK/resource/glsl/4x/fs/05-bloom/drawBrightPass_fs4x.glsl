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
	
	drawBrightPass_fs4x.glsl
	Perform bright pass filter: bright stays bright, dark gets darker.
*/

#version 410

// ****TO-DO: 
//	1) implement a function to calculate the relative luminance of a color
//	2) implement a general tone-mapping or bright-pass filter
//	3) sample the input texture
//	4) filter bright areas, output result

in vec2 vPassTexcoord;

uniform sampler2D uImage0;

layout (location = 0) out vec4 rtFragColor;

// (1)
float luminance(vec4 color)
{
	float lum;

	lum = (0.2126 * color.r) + (0.7152 * color.g) + (0.722 * color.b);// + (color.a);

	return lum;
}

// (2)
vec4 toneMapping(vec4 col)
{
	return (col / vec4(col + 1));
}

// (4)
vec4 brightPass(vec4 col)
{
	vec4 ret;
	float brightness = dot(col, col * luminance(col));
	if (brightness > 1.0)
		ret = vec4(col.rgb, 1.0);
	else
		ret = vec4(0.0, 0.0, 0.0, 1.0);

	return ret;
}

void main()
{
	vec4 sample0 = texture(uImage0, vPassTexcoord);
	
	// luminance
	float lum = luminance(sample0);
	vec4 luminance = sample0 * lum;

	// tone mapping
	luminance *= toneMapping(sample0);

	// bright pass filtering
//	vec4 bright = brightPass(luminance);

	// output
	rtFragColor = luminance;// bright;
}

/* something I stumbled upon, looks pretty cool, just wanna have it written down somewhere
vec4 brightPass(vec4 col)
{
	vec4 ret;
	float brightness = dot(col, col * luminance(col));
	if (brightness > 1.0)
		ret = vec4(col.rgb, 1.0);
	else
		ret = vec4(0.0, 0.0, 0.0, 1.0);

	return ret;
}

void main()
{
	vec4 sample0 = texture(uImage0, vPassTexcoord);
	
	// luminance
	float lum = luminance(sample0);
	vec4 luminance = sample0 * lum;

	// tone mapping
	luminance *= toneMapping(luminance);

	// bright pass filtering
	vec4 bright = brightPass(sample0);

	// output
	rtFragColor = bright;
}

*/
