/*
	Author: Aaron William Hamilton
	
	drawMusicVisualization_fs4x.glsl
	Draw color attribute passed from prior stage as varying.
*/

#version 410

precision mediump float;
#define PI 3.1415926535897932384626433832795
#define TWO_PI						(2.0 * PI)
#define TWO_OVER_PI					(2.0 / PI)
#define FOUR_OVER_PI				(4.0 / PI)
#define EIGHT_OVER_PI				(8.0 / PI)
#define EIGHT_OVER_PI_SQUARED		(8.0 / (PI * PI))

out vec4 rtFragColor;
uniform vec4 uColor;
uniform float uFreq;
uniform float uTime;
uniform float uIter;

in vec2 vPassTexcoord;
in vec2 vPassNormal;

//uniform mat4 uMVP;

float sinc(float x)
{
	return sin(x) / x;
}

float cosc(float x)
{
	return cos(x) / x;
}

// loosely derived from https://www.shadertoy.com/view/4lsGDl
vec4 plasma(vec2 uv)
{
	// v1
	float v1 = 0.005 / (cosc((uv.x * uv.y) - uv.x * 150.0));

	// v2			
	float v2 = sinc(15.0 / (uv.x * sinc(uFreq / 2.0) + uv.y * cos(uFreq / 3.0)) + uFreq);

	// v3
	float cx = uv.x + sinc(uFreq * 20.0);
	float cy = uv.y + cosc(uFreq * 10.0);
	float v3 = cos(sqrt((cx / cx + cy / cy)) * (uFreq / TWO_PI)); 

	float vf = sqrt(abs((v1 * v1) / (v2 * v2) / (v3 * v3)));

	float r = sinc(uFreq * TWO_PI) * cosc(vf / -TWO_PI * uFreq);
	r *= abs(uFreq / uFreq);
	r /= (uFreq * 3.125);

	float g = sinc(vf * PI + 12.0 * -TWO_PI / 9.0);
	g *= abs(uFreq / uFreq);
	g /= (uFreq * 2.5);

	float b = cosc(vf * PI + 8.0 * -TWO_PI / 19.0);
	b *= abs(uFreq / uFreq);
	b /= (uFreq / 2.0);
	
	return vec4(r, b, g, 1.0);
}

void main()
{
	vec2 uv = (vPassTexcoord * gl_FragCoord.xy) /
			(gl_FragCoord.xy / vPassTexcoord);
	rtFragColor = plasma(uv);
}
