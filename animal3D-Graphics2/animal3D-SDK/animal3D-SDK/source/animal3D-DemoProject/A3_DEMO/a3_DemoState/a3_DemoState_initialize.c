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
	
	a3_DemoState_initialize.c/.cpp
	Demo state function implementations.

	****************************************************
	*** THIS IS ONE OF YOUR DEMO'S MAIN SOURCE FILES ***
	*** Implement your demo logic pertaining to      ***
	***     INITIALIZATION in this file.             ***
	****************************************************
*/

//-----------------------------------------------------------------------------

#include "../a3_DemoState.h"



//-----------------------------------------------------------------------------
// INITIALIZE

// **************************
// FMOD Stuff

// Aaron
// check if any errors in FMOD have occurred
void FMODErrorCheck(FMOD_RESULT res)
{
	if (res != FMOD_OK)
	{
		printf("FMOD Error! (%s)\n", FMOD_ErrorString(res));
	}
}

// Aaron
// initialize relevant FMOD components
void initFMOD(a3_DemoState *demoState)
{
	FMOD_RESULT res;
	// create system
	res = FMOD_System_Create(&demoState->mpSystem);
	FMODErrorCheck(res);

	// initialize the system
	res = FMOD_System_Init(demoState->mpSystem, 2, FMOD_INIT_NORMAL, 0);
	FMODErrorCheck(res);

	// check version
	res = FMOD_System_GetVersion(demoState->mpSystem, &demoState->mVersion);		// c
			//mpSystem->getVersion(&mVersion);		c++
	FMODErrorCheck(res);

	// get number of sound cards 
	res = FMOD_System_GetNumDrivers(demoState->mpSystem, &demoState->mNumDrivers);		// c
			//mpSystem->getNumDrivers(&mNumDrivers);		// c++
	FMODErrorCheck(res);

	// no sound cards (disable sound)
	if (demoState->mNumDrivers == 0)
	{
		res = FMOD_System_SetOutput(demoState->mpSystem, FMOD_OUTPUTTYPE_NOSOUND);	// c
				//mpSystem->setOutput(FMOD_OUTPUTTYPE_NOSOUND);		c++
		FMODErrorCheck(res);
	}

	// init dsp
	res = FMOD_System_CreateDSPByType(demoState->mpSystem, FMOD_DSP_TYPE_FFT, &demoState->mpDSP);
	FMODErrorCheck(res);

	// init soundgroup
	res = FMOD_System_CreateSoundGroup(demoState->mpSystem, "sound group", &demoState->mpSoundGroup);
	FMODErrorCheck(res);

	// create channel group
	res = FMOD_System_CreateChannelGroup(demoState->mpSystem, "channel group", &demoState->mpCGroup);	// c
			//mResult = mpSystem->createChannelGroup("group", &mpCGroup);	c++
	FMODErrorCheck(res);

	// add DSP to channel group
	res = FMOD_ChannelGroup_AddDSP(demoState->mpCGroup, FMOD_CHANNELCONTROL_DSP_TAIL, demoState->mpDSP);
	FMODErrorCheck(res);

	demoState->mFreq = 0.0f;
}

// **************************

// initialize non-asset objects
void a3demo_initScene(a3_DemoState *demoState)
{
	a3ui32 i;
	a3_DemoCamera *camera;
	a3_DemoPointLight *pointLight;

	demoState->mIter = 1.75;

	// camera's starting orientation depends on "vertical" axis
	// we want the exact same view in either case
	const a3real sceneCameraAxisPos = 20.0f;
	const a3vec3 sceneCameraStartPos = {
		demoState->verticalAxis ? +sceneCameraAxisPos : +sceneCameraAxisPos,
		demoState->verticalAxis ? +sceneCameraAxisPos : -sceneCameraAxisPos,
		demoState->verticalAxis ? +sceneCameraAxisPos : +sceneCameraAxisPos,
	};
	const a3vec3 sceneCameraStartEuler = {
		demoState->verticalAxis ? -35.0f : +55.0f,
		demoState->verticalAxis ? +45.0f : + 0.0f,
		demoState->verticalAxis ? + 0.0f : +45.0f,
	};


	// all objects
	for (i = 0; i < demoStateMaxCount_sceneObject; ++i)
		a3demo_initSceneObject(demoState->sceneObject + i);
	for (i = 0; i < demoStateMaxCount_cameraObject; ++i)
		a3demo_initSceneObject(demoState->cameraObject + i);
	for (i = 0; i < demoStateMaxCount_lightObject; ++i)
		a3demo_initSceneObject(demoState->lightObject + i);

	// cameras
	a3demo_setCameraSceneObject(demoState->sceneCamera, demoState->mainCameraObject);
	a3demo_setCameraSceneObject(demoState->curveCamera, demoState->topDownCameraObject);
	a3demo_setCameraSceneObject(demoState->projectorLight, demoState->mainLightObject);
	a3demo_initCamera(demoState->sceneCamera);
	a3demo_initCamera(demoState->curveCamera);
	a3demo_initCamera(demoState->projectorLight);

	// camera params
	demoState->activeCamera = 0;

	// scene cameras
	camera = demoState->sceneCamera + 0;
	camera->perspective = a3true;
	camera->fovy = a3realFortyFive;
	camera->znear = 1.0f;
	camera->zfar = 1000.0f;
	camera->ctrlMoveSpeed = 10.0f;
	camera->ctrlRotateSpeed = 5.0f;
	camera->ctrlZoomSpeed = 5.0f;
	camera->sceneObject->position = sceneCameraStartPos;
	camera->sceneObject->euler = sceneCameraStartEuler;

	// top-down scene camera
	camera = demoState->curveCamera + 0;
	camera->fovy = 20.0f;

	// other projectors
	camera = demoState->projectorLight + 0;
	camera->perspective = a3true;
	camera->fovy = a3realSixty; // a3realNinety;
	camera->znear = 10.0f;
	camera->zfar = 100.0f;
	camera->sceneObject->position = sceneCameraStartPos;
	camera->sceneObject->euler = sceneCameraStartEuler;


	// set projection matrix for non window-dependent projectors
	//	(resize callback handles window-dependents)
	a3demo_updateCameraProjection(demoState->projectorLight);


	// init transforms
	if (demoState->verticalAxis)
	{
		// vertical axis is Y
	}
	else
	{
		// vertical axis is Z
	}


	// demo modes
	demoState->demoModeCount = 1;
	demoState->demoMode = 0;

	// demo mode A: deferred + bloom
	//	 1) scene
	//		a) color buffer 0 (shading/position)
	//		b) color buffer 1 (normal)
	//		c) color buffer 2 (texcoord)
	//		d) depth buffer
	//	 2) light volumes (deferred lighting only)
	//		a) color buffer 0 (diffuse)
	//		b) color buffer 1 (specular)
	//	 3) full composite (skybox, lighting, UI)
	//	 4) bright 1/2
	//	 5) blur H 1/2
	//	 6) blur V 1/2
	//	 7) bright 1/4
	//	 8) blur H 1/4
	//	 9) blur V 1/4
	//	10) bright 1/8
	//	11) blur H 1/8
	//	12) blur V 1/8
	//	13) bloom composite
	//	14) shadow map (supplementary)
	//		a) depth buffer
	for (i = 0; i < demoStateMaxSubModes; ++i)
		demoState->demoOutputCount[0][i] = 1;
	demoState->demoSubModeCount[0] = demoStateMaxSubModes;
	demoState->demoOutputCount[0][0] = 5;
	demoState->demoOutputCount[0][1] = 2;

	// demo mode B: curve drawing
	demoState->demoSubMode[1] = 1;
	demoState->demoOutputMode[1][0] = 2;

	// demo mode C: music visualization
	demoState->demoSubModeCount[2] = 0;


	// initialize other objects and settings
	demoState->displayGrid = 1;
	demoState->displayWorldAxes = 1;
	demoState->displayObjectAxes = 1;
	demoState->displaySkybox = 1;
	demoState->displayHiddenVolumes = 1;
	demoState->displayPipeline = 0;
	demoState->updateAnimation = 1;
	demoState->additionalPostProcessing = 0;
	demoState->previewIntermediatePostProcessing = 0;
	demoState->stencilTest = 0;
	demoState->singleForwardLight = 0;
	demoState->displayTangentBases = 0;
	demoState->lightingPipelineMode = demoStatePipelineMode_forward;
	demoState->forwardShadingMode = demoStateForwardPipelineMode_Phong_manip;


	// lights
	demoState->forwardLightCount = demoState->singleForwardLight ? 1 : demoStateMaxCount_lightObject;
	demoState->deferredLightCount = demoStateMaxCount_lightVolumePerBlock / 32;

	// first light is hard-coded (starts at camera)
	pointLight = demoState->forwardPointLight;
	pointLight->worldPos = a3wVec4;
	pointLight->worldPos.xyz = demoState->mainLightObject->position;
//	if (demoState->verticalAxis)
//		pointLight->worldPos.y = 10.0f;
//	else
//		pointLight->worldPos.z = 10.0f;
	pointLight->radius = 100.0f;
	pointLight->radiusInvSq = a3recip(pointLight->radius * pointLight->radius);
	pointLight->color = a3oneVec4;

	// all other lights are random
	a3randomSetSeed(0);
	for (i = 1, pointLight = demoState->forwardPointLight + i;
		i < demoStateMaxCount_lightObject;
		++i, ++pointLight)
	{
		// set to zero vector
		pointLight->worldPos = a3wVec4;

		// random positions
		pointLight->worldPos.x = a3randomRange(-10.0f, +10.0f);
		if (demoState->verticalAxis)
		{
			pointLight->worldPos.z = -a3randomRange(-10.0f, +10.0f);
			pointLight->worldPos.y = -a3randomRange(-2.0f, +8.0f);
		}
		else
		{
			pointLight->worldPos.y = a3randomRange(-10.0f, +10.0f);
			pointLight->worldPos.z = a3randomRange(-2.0f, +8.0f);
		}

		// random colors
		pointLight->color.r = a3randomNormalized();
		pointLight->color.g = a3randomNormalized();
		pointLight->color.b = a3randomNormalized();
		pointLight->color.a = a3realOne;

		// random radius
		pointLight->radius = a3randomRange(10.0f, 50.0f);
		pointLight->radiusInvSq = a3recip(pointLight->radius * pointLight->radius);
	}

	// deferred lights
	for (i = 0, pointLight = demoState->deferredPointLight + i;
		i < demoStateMaxCount_lightVolume;
		++i, ++pointLight)
	{
		// set to zero vector
		pointLight->worldPos = a3wVec4;

		// random positions
		pointLight->worldPos.x = a3randomRange(-6.0f, +6.0f);
		if (demoState->verticalAxis)
		{
			pointLight->worldPos.z = -a3randomRange(-6.0f, +6.0f);
			pointLight->worldPos.y = -a3randomRange(-2.0f, +4.0f);
		}
		else
		{
			pointLight->worldPos.y = a3randomRange(-6.0f, +6.0f);
			pointLight->worldPos.z = a3randomRange(-2.0f, +4.0f);
		}

		// random colors
		pointLight->color.r = a3randomNormalized();
		pointLight->color.g = a3randomNormalized();
		pointLight->color.b = a3randomNormalized();
		pointLight->color.a = a3realOne;

		// random radius: they should be small!
		pointLight->radius = a3randomRange(0.25f, 0.50f);
		pointLight->radiusInvSq = a3recip(pointLight->radius * pointLight->radius);
	}


	// position scene objects
	demoState->sphereObject->scale.x = 2.0f;
	demoState->cylinderObject->scale.x = 4.0f;
	demoState->cylinderObject->scale.y = demoState->cylinderObject->scale.z = 2.0f;
	demoState->torusObject->scale.x = 2.0f;
	demoState->sphereObject->scaleMode = 1;		// uniform
	demoState->cylinderObject->scaleMode = 2;	// non-uniform
	demoState->torusObject->scaleMode = 1;		// uniform

	demoState->sphereObject->position.x = +6.0f;
	demoState->torusObject->position.x = -6.0f;
	if (demoState->verticalAxis)
	{
		demoState->planeObject->position.y = -2.0f;
		demoState->sphereObject->position.y = +1.0f;
		demoState->cylinderObject->position.y = +1.0f;
		demoState->torusObject->position.y = +1.0f;
		demoState->cylinderObject->position.z = -6.0f;
		demoState->teapotObject->position.z = +6.0f;
	}
	else
	{
		demoState->planeObject->position.z = -2.0f;
		demoState->sphereObject->position.z = +1.0f;
		demoState->cylinderObject->position.z = +1.0f;
		demoState->torusObject->position.z = +1.0f;
		demoState->cylinderObject->position.y = +6.0f;
		demoState->teapotObject->position.y = -6.0f;
	}


	// animation stuff
	demoState->curveSegmentDuration = a3realTwo;
	demoState->curveSegmentDurationInv = a3recip(demoState->curveSegmentDuration);
	demoState->curveSegmentTime = demoState->curveSegmentParam = a3realZero;
	demoState->curveSegmentIndex = 0;
}


//-----------------------------------------------------------------------------
