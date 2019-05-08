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
	
	drawBlurGaussian_fs4x.glsl
	Implements and performs Gaussian blur algorithms.
*/

#version 410

// ****TO-DO: 
//	1) declare uniforms used in this algorithm (see blur pass in render)
//	2) implement one or more 1D Gaussian blur functions
//	3) output result as blurred image

in vec2 vPassTexcoord;

uniform sampler2D uImage0;

// (1)
uniform vec2 uPixelSz;

layout (location = 0) out vec4 rtFragColor;

float gaussian(float c)//(vec4 c1, vec4 c2, vec2 center)
{
	float sigma = 0.840896421f;		// got this value from https://en.wikipedia.org/wiki/Gaussian_blur
	float pi = 3.1415926535897932384626433832795;

	float powBase = (1/sqrt(2 * pi * pow(sigma, 2)));
	float powExp = exp(pow(c, 2) / pow(2 * sigma, 2));

	float g = powBase * powExp;

	return c;
}

vec4 calcGaussianBlur1D_H(in sampler2D image, in vec2 center, in vec2 axis)	// (2)
{
	vec4 color = vec4(0.0);	

	float gauss5x1H[5] = float[5](6.0, 24.0, 36.0, 24.0, 6.0);
							//(1.0, 4.0, 6.0, 4.0, 1.0);

	//float blur = length(center / axis);
	for (int i = 1; i < 5; ++i)
		color += texture(image, vec2(center.x - gauss5x1H[i] * axis.x, center.y - gauss5x1H[i] * axis.y));
	
	color.r = gaussian(color.r);
	color.g = gaussian(color.g);
	color.b = gaussian(color.b);

	return color / 4.0;
}

vec4 calcGaussianBlur1D_V(in sampler2D image, in vec2 center, in vec2 axis) // (2)
{
	vec4 color = vec4(0.0);

	float gauss5x1V[5] = float[5](4.0, 16.0, 24.0, 16.0, 4.0);

	//float blur = length(axis / center);
	for (int i = 1; i < 5; ++i)
		color += texture(image, vec2(center.x - gauss5x1V[i] * axis.x, center.y - gauss5x1V[i] * axis.y));

	color.r = gaussian(color.r);
	color.g = gaussian(color.g);
	color.b = gaussian(color.b);

	return color / 4.0;
}

void main()
{
	vec4 image = texture(uImage0, vPassTexcoord);
	vec4 blurPass1 = calcGaussianBlur1D_H(uImage0, vPassTexcoord, uPixelSz);
	vec4 blurPass2 = calcGaussianBlur1D_V(uImage0, vPassTexcoord, uPixelSz);
	vec4 blurTotal = blurPass1 + blurPass2;

	vec4 gauss = vec4(gaussian(blurTotal.r), 
						gaussian(blurTotal.g),
						gaussian(blurTotal.b), 
						1.00);

	rtFragColor = blurTotal;
}



// ************************************************************************ cool stuff below



/*		another fun thing I stumbled across that I want written down somewhere
float convolution(vec4 c1, vec4 c2)
{
	float sigma = 0.840896421f;		// got this value from https://en.wikipedia.org/wiki/Gaussian_blur
	float pi = 3.1415926535897932384626433832795;

	float powBase = (1/(2 * pi * pow(sigma, 2)));
	float powExp = exp(-((pow(length(c1), 2) + pow(length(c2), 2)) / pow(2 * sigma, 2)));

	float g = powBase * powExp;

	return g;
}


void main()
{
	vec4 blurPass1 = calcGaussianBlur1D_H(uImage0, vPassTexcoord, uPixelSz);
	vec4 blurPass2 = calcGaussianBlur1D_V(uImage0, vPassTexcoord, uPixelSz);

//	rtFragColor = calcGaussianBlur1D_4(uImage0, vPassTexcoord, uPixelSz);
//	rtFragColor = calcGaussianBlur1D_0(blurPass1, vPassTexcoord, uPixelSz);

	float gauss = convolution(blurPass1, blurPass2);

	vec4 col = blurPass1 / blurPass2;
	rtFragColor = col;// * gauss;

	rtFragColor = (blurPass1 / gauss) + (blurPass2 / gauss);			/// also pretty cool

	// DEBUGGING
//	vec4 sample0 = texture(uImage0, vPassTexcoord);
//	rtFragColor = vec4(vPassTexcoord, 0.0, 1.0);
//	rtFragColor = 1.0 - sample0;
}

*/

/* another cool thing
float gaussian(float c)//(vec4 c1, vec4 c2, vec2 center)
{
	float sigma = 0.840896421f;		// got this value from https://en.wikipedia.org/wiki/Gaussian_blur
	float pi = 3.1415926535897932384626433832795;

	float powBase = (1/sqrt(2 * pi * pow(sigma, 2)));
	float powExp = exp(pow(c, 2) / pow(2 * sigma, 2));

	float g = powBase * powExp;

	return g;
}

// Gaussian blur with 1D kernel about given axis
//	weights are selected by rows in Pascal's triangle
//		2^0 = 1:		1
//		2^1 = 2:		1	1
//		2^2 = 4:		1	2	1
//		2^3 = 8:		1	3	3	1
//		2^4 = 16:		1	4	6	4	1
//		2^5 = 32:		1	5	10	10	5	1
//		2^6 = 64:		1	6	15	20	15	6	1
//		2^7 = 128:		1	7	21	35	35	21	7	1
vec4 calcGaussianBlur1D_H(in sampler2D image, in vec2 center, in vec2 axis)	// (2)
{
	vec4 color = vec4(0.0);	

	color += texture(image, center + axis * 2.0);
	color += texture(image, center + axis) * 4.0;
	color += texture(image, center) * 6.0;
	color += texture(image, center - axis) * 4.0;
	color += texture(image, center - axis * 2.0);

	return //texture(image, center) * (color / 16.0);
		color / 16.0;

	color.r = gaussian(color.r);
	color.g = gaussian(color.g);
	color.b = gaussian(color.b);
	color.a = 1.0;

	return color / 16.0;
}

vec4 calcGaussianBlur1D_V(in sampler2D image, in vec2 center, in vec2 axis) // (2)
{
	vec4 color = vec4(0.0);

	color += texture(image, center + axis * 16.0);
	color += texture(image, center + axis) * 8.0;
	color += texture(image, center) * 2.0;
	color += texture(image, center - axis) * 8.0;
	color += texture(image, center - axis * 16.0);

	color.r = gaussian(color.r);
	color.g = gaussian(color.g);
	color.b = gaussian(color.b);
	color.a = 1.0;

	return color / 16.0;
}

void main()
{
	vec4 image = texture(uImage0, vPassTexcoord);
	vec4 blurPass1 = calcGaussianBlur1D_H(uImage0, vPassTexcoord, uPixelSz);
	vec4 blurPass2 = calcGaussianBlur1D_V(uImage0, vPassTexcoord, uPixelSz);
	vec4 blurTotal = normalize(blurPass1 + blurPass2);
	
	rtFragColor = blurTotal;
//	rtFragColor = image * gauss;
//	rtFragColor = blurPass1 * blurPass2;

}
*/

