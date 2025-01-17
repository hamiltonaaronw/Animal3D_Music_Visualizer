// This file was modified by Aaron Hamilton with permission of the author

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
	
	a3_DemoState_unloading.c/.cpp
	Demo state function implementations.

	****************************************************
	*** THIS IS ONE OF YOUR DEMO'S MAIN SOURCE FILES ***
	*** Implement your demo logic pertaining to      ***
	***     UNLOADING in this file.                  ***
	****************************************************
*/

//-----------------------------------------------------------------------------

#include "../a3_DemoState.h"

#include <stdio.h>


//-----------------------------------------------------------------------------
// UNLOADING
// this is where the union array style comes in handy; don't need a single 
//	release statement for each and every object... just iterate and release!

// **************************
// FMOD Stuff

void unloadFMOD(a3_DemoState *demoState)
{
	FMOD_RESULT res;

	for (int i = 0; i < (int)sizeof(demoState->mpSongsList) - 1; ++i)
	{
		res = FMOD_Sound_Release(demoState->mpSongsList[i]);
		FMODErrorCheck(res);
	}

	//res = FMOD_Sound_Release(*demoState->mpSongsList);
	//FMODErrorCheck(res);

	res = FMOD_System_Close(demoState->mpSystem);
	FMODErrorCheck(res);

	res = FMOD_System_Release(demoState->mpSystem);
	FMODErrorCheck(res);

	res = FMOD_SoundGroup_Release(demoState->mpSoundGroup);
}

// **************************

// utility to unload geometry
void a3demo_unloadGeometry(a3_DemoState *demoState)
{
	a3_BufferObject *currentBuff = demoState->drawDataBuffer,
		*const endBuff = currentBuff + demoStateMaxCount_drawDataBuffer;
	a3_VertexArrayDescriptor *currentVAO = demoState->vertexArray,
		*const endVAO = currentVAO + demoStateMaxCount_vertexArray;
	a3_VertexDrawable *currentDraw = demoState->drawable,
		*const endDraw = currentDraw + demoStateMaxCount_drawable;

	while (currentBuff < endBuff)
		a3bufferRelease(currentBuff++);
	while (currentVAO < endVAO)
		a3vertexArrayReleaseDescriptor(currentVAO++);
	while (currentDraw < endDraw)
		a3vertexDrawableRelease(currentDraw++);
}

// utility to unload shaders
void a3demo_unloadShaders(a3_DemoState *demoState)
{
	a3_DemoStateShaderProgram *currentProg = demoState->shaderProgram,
		*const endProg = currentProg + demoStateMaxCount_shaderProgram;
	a3_UniformBuffer *currentUBO = demoState->uniformBuffer,
		*const endUBO = currentUBO + demoStateMaxCount_uniformBuffer;

	while (currentProg < endProg)
		a3shaderProgramRelease((currentProg++)->program);
	while (currentUBO < endUBO)
		a3bufferRelease(currentUBO++);
}


// utility to unload textures
void a3demo_unloadTextures(a3_DemoState *demoState)
{
	a3_Texture *currentTex = demoState->texture,
		*const endTex = currentTex + demoStateMaxCount_texture;

	while (currentTex < endTex)
		a3textureRelease(currentTex++);
}


// utility to unload framebuffers
void a3demo_unloadFramebuffers(a3_DemoState *demoState)
{
	a3_Framebuffer *currentFBO = demoState->framebuffer,
		*const endFBO = currentFBO + demoStateMaxCount_framebuffer;
	a3_FramebufferDouble *currentDFBO = demoState->framebuffer_double,
		*const endDFBO = currentDFBO + demoStateMaxCount_framebufferDouble;

	while (currentFBO < endFBO)
		a3framebufferRelease(currentFBO++);
	while (currentDFBO < endDFBO)
		a3framebufferDoubleRelease(currentDFBO++);
}


//-----------------------------------------------------------------------------

// confirm that all graphics objects were unloaded
void a3demo_validateUnload(const a3_DemoState *demoState)
{
	a3ui32 handle;
	const a3_BufferObject *currentBuff = demoState->drawDataBuffer,
		*const endBuff = currentBuff + demoStateMaxCount_drawDataBuffer;
	const a3_VertexArrayDescriptor *currentVAO = demoState->vertexArray,
		*const endVAO = currentVAO + demoStateMaxCount_vertexArray;
	const a3_DemoStateShaderProgram *currentProg = demoState->shaderProgram,
		*const endProg = currentProg + demoStateMaxCount_shaderProgram;
	const a3_UniformBuffer *currentUBO = demoState->uniformBuffer,
		*const endUBO = currentUBO + demoStateMaxCount_uniformBuffer;
	const a3_Texture *currentTex = demoState->texture,
		*const endTex = currentTex + demoStateMaxCount_texture;
	const a3_Framebuffer *currentFBO = demoState->framebuffer,
		*const endFBO = currentFBO + demoStateMaxCount_framebuffer;
	const a3_FramebufferDouble *currentDFBO = demoState->framebuffer_double,
		*const endDFBO = currentDFBO + demoStateMaxCount_framebufferDouble;

	handle = 0;
	while (currentBuff < endBuff)
		handle += (currentBuff++)->handle->handle;
	if (handle)
		printf("\n A3 Warning: One or more draw data buffers not released.");

	handle = 0;
	while (currentVAO < endVAO)
		handle += (currentVAO++)->handle->handle;
	if (handle)
		printf("\n A3 Warning: One or more vertex arrays not released.");

	handle = 0;
	while (currentProg < endProg)
		handle += (currentProg++)->program->handle->handle;
	if (handle)
		printf("\n A3 Warning: One or more shader programs not released.");

	handle = 0;
	while (currentUBO < endUBO)
		handle += (currentUBO++)->handle->handle;
	if (handle)
		printf("\n A3 Warning: One or more uniform buffers not released.");

	handle = 0;
	while (currentTex < endTex)
		handle += (currentTex++)->handle->handle;
	if (handle)
		printf("\n A3 Warning: One or more textures not released.");

	handle = 0;
	while (currentFBO < endFBO)
		handle += (currentFBO++)->handle->handle;
	if (handle)
		printf("\n A3 Warning: One or more framebuffers not released.");

	handle = 0;
	while (currentDFBO < endDFBO)
		handle += (currentDFBO++)->handle->handle;
	if (handle)
		printf("\n A3 Warning: One or more double framebuffers not released.");
}


//-----------------------------------------------------------------------------
