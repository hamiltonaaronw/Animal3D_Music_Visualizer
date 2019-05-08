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
	
	a3_DemoState.h
	Demo state interface and programmer function declarations.

	********************************************
	*** THIS IS YOUR DEMO'S MAIN HEADER FILE ***
	********************************************
*/

#ifndef __ANIMAL3D_DEMOSTATE_H
#define __ANIMAL3D_DEMOSTATE_H


//-----------------------------------------------------------------------------
// animal3D framework includes

#include "animal3D/animal3D.h"
#include "animal3D-A3DG/animal3D-A3DG.h"

// Japhy include
#include "fmod/fmod.h"
#include "fmod/fmod_errors.h"
#include <stdio.h>
#include <stdlib.h>
#include "animal3D-A3DG/a3graphics/dirent.h"
#include <math.h>


//-----------------------------------------------------------------------------
// other demo includes

#include "_utilities/a3_DemoSceneObject.h"
#include "_utilities/a3_DemoShaderProgram.h"


//-----------------------------------------------------------------------------

#ifdef __cplusplus
extern "C"
{
#else	// !__cplusplus
typedef struct a3_DemoState					a3_DemoState;

#endif	// __cplusplus

//-----------------------------------------------------------------------------

	// object maximum counts for easy array storage
	// good idea to make these numbers greater than what you actually need 
	//	and if you end up needing more just increase the count... there's 
	//	more than enough memory to hold extra objects
	enum a3_DemoStateObjectMaxCounts
	{
		demoStateMaxCount_sceneObject = 8,
		demoStateMaxCount_cameraObject = 2,
		demoStateMaxCount_lightObject = 4,
		demoStateMaxCount_projector = 3,

		demoStateMaxCount_lightVolumeBlock = 4,
		demoStateMaxCount_lightVolumePerBlock = a3index_countMaxShort / sizeof(a3_DemoPointLight),
		demoStateMaxCount_lightVolume = demoStateMaxCount_lightVolumeBlock * demoStateMaxCount_lightVolumePerBlock,

		demoStateMaxCount_timer = 1,
		demoStateMaxCount_drawDataBuffer = 1,
		demoStateMaxCount_vertexArray = 8,
		demoStateMaxCount_drawable = 16,
		demoStateMaxCount_shaderProgram = 33,

		demoStateMaxCount_texture = 16,
		demoStateMaxCount_framebuffer = 4,
		demoStateMaxCount_framebufferDouble = 8,

		demoStateMaxCount_uniformBuffer = 2 + 3 * demoStateMaxCount_lightVolumeBlock,

		demoStateMaxCount_curveWaypoint = 32,
	};

	// additional counters for demo modes
	enum a3_DemoStateModeCounts
	{
		demoStateMaxModes = 2,
		demoStateMaxSubModes = 14,
		demoStateMaxOutputModes = 5,
	};

	
//-----------------------------------------------------------------------------

	// render pass names for this demo's render pipelines
	enum a3_DemoStateRenderPassNames
	{
		// general
		demoStateRenderPass_scene,

		// deferred
		demoStateRenderPass_deferred_volumes,

		// compositing
		demoStateRenderPass_composite,

		// bloom
		demoStateRenderPass_bloom_bright_2,
		demoStateRenderPass_bloom_blurH_2,
		demoStateRenderPass_bloom_blurV_2,
		demoStateRenderPass_bloom_bright_4,
		demoStateRenderPass_bloom_blurH_4,
		demoStateRenderPass_bloom_blurV_4,
		demoStateRenderPass_bloom_bright_8,
		demoStateRenderPass_bloom_blurH_8,
		demoStateRenderPass_bloom_blurV_8,
		demoStateRenderPass_bloom_blend,

		// supplementary
		demoStateRenderPass_shadow = demoStateMaxSubModes - 1,
	};

	// pipeline modes
	enum a3_DemoStatePipelineModeNames
	{
		demoStatePipelineMode_forward,
		demoStatePipelineMode_deferredShading,
		demoStatePipelineMode_deferredLighting,
	};

	// forward pipeline modes
	enum a3_DemoStateForwardPipelineModeNames
	{
		demoStateForwardPipelineMode_Phong,
		demoStateForwardPipelineMode_Phong_projective,
		demoStateForwardPipelineMode_Phong_shadowmap,
		demoStateForwardPipelineMode_Phong_shadowmap_projective,
		demoStateForwardPipelineMode_Phong_manip,
		demoStateForwardPipelineMode_nonphoto,
	};


//-----------------------------------------------------------------------------

	// persistent demo state data structure
	struct a3_DemoState
	{
		//---------------------------------------------------------------------
		// general variables pertinent to the state

		// terminate key pressed
		a3i32 exitFlag;

		// global vertical axis: Z = 0, Y = 1
		a3i32 verticalAxis;

		// asset streaming between loads enabled (careful!)
		a3i32 streaming;

		// window and full-frame dimensions
		a3ui32 windowWidth, windowHeight;
		a3real windowWidthInv, windowHeightInv, windowAspect;
		a3ui32 frameWidth, frameHeight;
		a3real frameWidthInv, frameHeightInv, frameAspect;
		a3i32 frameBorder;


		//---------------------------------------------------------------------
		// objects that have known or fixed instance count in the whole demo

		// text renderer
		a3i32 textInit, textMode, textModeCount;
		a3_TextRenderer text[1];

		// input
		a3_MouseInput mouse[1];
		a3_KeyboardInput keyboard[1];
		a3_XboxControllerInput xcontrol[4];

		// pointer to fast trig table
		a3f32 trigTable[4096 * 4];


		//---------------------------------------------------------------------
		// scene variables and objects

		// demo mode array: 
		//	- mode: which mode/pipeline is being viewed
		//	- sub-mode: which sub-mode/pass in the pipeline is being viewed
		//	- output: which output from the sub-mode/pass is being viewed
		a3ui32 demoMode, demoSubMode[demoStateMaxModes], demoOutputMode[demoStateMaxModes][demoStateMaxSubModes];
		a3ui32 demoModeCount, demoSubModeCount[demoStateMaxModes], demoOutputCount[demoStateMaxModes][demoStateMaxSubModes];

		// toggle grid in scene and axes superimposed, as well as other mods
		a3boolean displayGrid, displayWorldAxes, displayObjectAxes, displayTangentBases;
		a3boolean displaySkybox, displayHiddenVolumes, displayPipeline;
		a3boolean additionalPostProcessing, previewIntermediatePostProcessing;
		a3boolean stencilTest, singleForwardLight;
		a3boolean lightingPipelineMode;
		a3boolean updateAnimation;

		// lighting modes
		a3ui32 forwardShadingMode;

		// grid properties
		a3mat4 gridTransform;
		a3vec4 gridColor;

		// cameras
		a3ui32 activeCamera;

		// lights
		a3_DemoPointLight forwardPointLight[demoStateMaxCount_lightObject];
		a3_DemoPointLight deferredPointLight[demoStateMaxCount_lightVolume];
		a3mat4 deferredLightMVP[demoStateMaxCount_lightVolume];
		a3mat4 deferredLightMVPB[demoStateMaxCount_lightVolume];
		a3ui32 forwardLightCount;
		a3ui32 deferredLightCount, deferredLightBlockCount, deferredLightCountPerBlock[demoStateMaxCount_lightVolumeBlock];

		// texture atlas transforms
		union {
			a3mat4 atlasTransform[4];
			struct {
				a3mat4 atlas_stone[1], atlas_earth[1], atlas_mars[1], atlas_checker[1];
			};
		};


		// animation stuff
		a3vec4 curveWaypoint[demoStateMaxCount_curveWaypoint], curveHandle[demoStateMaxCount_curveWaypoint];
		a3ui32 curveWaypointCount;
		a3ui32 curveSegmentIndex;
		a3real curveSegmentDuration, curveSegmentDurationInv;
		a3real curveSegmentTime, curveSegmentParam;


		//---------------------------------------------------------------------
		// object arrays: organized as anonymous unions for two reasons: 
		//	1. easy to manage entire sets of the same type of object using the 
		//		array component
		//	2. at the same time, variables are named pointers

		// scene objects
		union {
			a3_DemoSceneObject sceneObject[demoStateMaxCount_sceneObject];
			struct {
				// main scene objects
				a3_DemoSceneObject
					skyboxObject[1],
					planeObject[1],
					sphereObject[1],
					cylinderObject[1],
					torusObject[1],
					teapotObject[1];

				// curve-drawing objects
				a3_DemoSceneObject
					curveFollowObject[1];
			};
		};
		union {
			a3_DemoSceneObject cameraObject[demoStateMaxCount_cameraObject];
			struct {
				a3_DemoSceneObject
					mainCameraObject[1];
				a3_DemoSceneObject
					topDownCameraObject[1];
			};
		};
		union {
			a3_DemoSceneObject lightObject[demoStateMaxCount_lightObject];
			struct {
				a3_DemoSceneObject
					mainLightObject[1];
			};
		};

		// cameras
		//	- any object can have a camera "component"
		union {
			a3_DemoCamera camera[demoStateMaxCount_projector];
			struct {
				a3_DemoCamera
					sceneCamera[1];						// scene viewing cameras
				a3_DemoCamera
					curveCamera[1];						// top-down drawing camera
				a3_DemoCamera
					projectorLight[1];					// other projectors
			};
		};


		// timers
		union {
			a3_Timer timer[demoStateMaxCount_timer];
			struct {
				a3_Timer
					renderTimer[1];						// render FPS timer
			};
		};


		// draw data buffers
		union {
			a3_VertexBuffer drawDataBuffer[demoStateMaxCount_drawDataBuffer];
			struct {
				a3_VertexBuffer
					vbo_staticSceneObjectDrawBuffer[1];			// buffer to hold all data for static scene objects (e.g. grid)
			};
		};

		// vertex array objects
		union {
			a3_VertexArrayDescriptor vertexArray[demoStateMaxCount_vertexArray];
			struct {
				a3_VertexArrayDescriptor
					vao_position[1],							// VAO for vertex format with only position
					vao_position_color[1],						// VAO for vertex format with position and color
					vao_position_texcoord[1],					// VAO for vertex format with position and UVs
					vao_position_texcoord_normal[1],			// VAO for vertex format with position, UVs and normal
					vao_tangentBasis[1];						// VAO for vertex format with full tangent basis
			};
		};

		// drawables
		union {
			a3_VertexDrawable drawable[demoStateMaxCount_drawable];
			struct {
				a3_VertexDrawable
					draw_grid[1],								// wireframe ground plane to emphasize scaling
					draw_axes[1],								// coordinate axes at the center of the world
					draw_skybox[1],								// skybox cube mesh
					draw_unitquad[1];							// unit quad (used for fsq)
				a3_VertexDrawable
					draw_pointlight[1];							// volume for point light (low-res sphere)
				a3_VertexDrawable
					draw_plane[1],								// procedural plane
					draw_sphere[1],								// procedural sphere
					draw_cylinder[1],							// procedural cylinder
					draw_torus[1],								// procedural torus
					draw_teapot[1];								// can't not have a Utah teapot
			};
		};


		// shader programs and uniforms
		union {
			a3_DemoStateShaderProgram shaderProgram[demoStateMaxCount_shaderProgram];
			struct {
				a3_DemoStateShaderProgram
					prog_drawColorUnif[1],						// draw uniform color
					prog_drawColorAttrib[1],					// draw color attribute
					prog_drawColorUnif_instanced[1],			// draw uniform color with instancing
					prog_drawColorAttrib_instanced[1];			// draw color attribute with instancing
				a3_DemoStateShaderProgram
					prog_drawTexture[1],						// draw texture
					prog_drawPhongMulti[1],						// draw Phong shading model (multiple lights)
					prog_drawNonPhotoMulti[1];					// draw non-photorealistic shading model
				a3_DemoStateShaderProgram
					prog_drawPhongMulti_mrt[1],					// draw Phong to MRT
					prog_drawCustom_mrt[1];						// draw custom effects to MRT
				a3_DemoStateShaderProgram
					prog_transform[1],							// transform vertex only; no fragment shader
					prog_drawPhongMulti_projtex[1],				// projective texturing
					prog_drawPhongMulti_shadowmap[1],			// shadow mapping
					prog_drawPhongMulti_shadowmap_projtex[1],	// shadow mapping and projective texturing
					prog_drawCustom_post[1];					// custom post-processing
				a3_DemoStateShaderProgram
					prog_drawBrightPass[1],						// post-process bright pass
					prog_drawBlurGaussian[1],					// post-process blurring (Gaussian)
					prog_drawBlendComposite[1];					// post-process blending & composite
				a3_DemoStateShaderProgram
					prog_drawGBuffers[1],						// output geometry buffers ("g-buffers")
					prog_drawPhongMulti_deferred[1],			// perform deferred Phong shading
					prog_drawPhong_volume[1],					// render one light volume with Phong
					prog_drawDeferredLightingComposite[1];		// composite deferred lighting
				a3_DemoStateShaderProgram
					prog_drawPhongMulti_manip[1],				// manipulate triangle before shading
					prog_drawTangentBasis[1],					// render complete tangent basis as lines
					prog_drawCurveSegment[1],					// draw a curve segment between waypoints
					prog_drawCurveHandles[1];					// draw curve waypoints/handles
				a3_DemoStateShaderProgram
					prog_drawMusicVisualizer[1];

			};
		};


		// textures
		union {
			a3_Texture texture[demoStateMaxCount_texture];
			struct {
				a3_Texture
					tex_skybox_clouds[1],
					tex_skybox_water[1],
					tex_atlas_dm[1],
					tex_atlas_sm[1],
					tex_stone_dm[1],
					tex_earth_dm[1],
					tex_earth_sm[1],
					tex_mars_dm[1],
					tex_mars_sm[1],
					tex_ramp_dm[1],
					tex_ramp_sm[1],
					tex_checker[1];
			};
		};


		// framebuffers
		union {
			a3_Framebuffer framebuffer[demoStateMaxCount_framebuffer];
			struct {
				a3_Framebuffer
					fbo_scene[1];					// fbo with color and depth
				a3_Framebuffer
					fbo_shadowmap[1];				// fbo for shadow map with depth only
			};
		};
		union {
			a3_FramebufferDouble framebuffer_double[demoStateMaxCount_framebufferDouble];
			struct {
				a3_FramebufferDouble
					fbo_dbl_nodepth[2],				// full frame dfbo (w or w/o border), no depth
					fbo_dbl_nodepth_2[2],			// half-frame, ditto
					fbo_dbl_nodepth_4[2],			// quarter-frame, ditto
					fbo_dbl_nodepth_8[2];			// eighth-frame, ditto
			};
		};


		// uniform buffer objects
		union {
			a3_UniformBuffer uniformBuffer[demoStateMaxCount_uniformBuffer];
			struct {
				// lighting uniform buffers
				a3_UniformBuffer
					ubo_transformMVP[demoStateMaxCount_lightVolumeBlock],
					ubo_transformMVPB[demoStateMaxCount_lightVolumeBlock],
					ubo_pointLight[demoStateMaxCount_lightVolumeBlock];

				// curve uniform buffers
				a3_UniformBuffer
					ubo_curveWaypoint[1],
					ubo_curveHandle[1];
			};
		};


		// managed objects, no touchie
		a3_VertexDrawable dummyDrawable[1];



		// ********************************************
		// FMOD stuff
		FMOD_SYSTEM			*mpSystem;
		FMOD_CHANNELGROUP	*mpCGroup;
		FMOD_CHANNEL		*mpChannel;
		FMOD_SOUND			**mpSongsList;
		FMOD_SPEAKERMODE	mSpeakerMode;
		FMOD_DSP			*mpDSP;

		FMOD_SOUNDGROUP		*mpSoundGroup;

		unsigned int mVersion;
		int mNumDrivers;
		char mDriverName;

		float mFreq;
		float mSpectrum[512];

		float mIter;

		int mCurSong,
			mSongCount;


		// ********************************************


		//---------------------------------------------------------------------
	};

	
//-----------------------------------------------------------------------------


	// FMOD Stuff
	void FMODErrorCheck(FMOD_RESULT res);
	void initFMOD(a3_DemoState *demoState);
	void loadSongs(a3_DemoState *demoState);
	void playSound(a3_DemoState *demoState, int i);

	// prevNext should be either demoState->mSongsCount - 1 (previous song) or 1 (next song)
	void toggleSong(a3_DemoState *demoState, int prevNext);
	void unloadFMOD(a3_DemoState *demoState);
	float fmodDSP(a3_DemoState *demoState);

	// demo-related functions

	// idle loop
	void a3demo_input(a3_DemoState *demoState, a3f64 dt);
	void a3demo_update(a3_DemoState *demoState, a3f64 dt);
	void a3demo_render(const a3_DemoState *demoState);

	// loading
	void a3demo_loadGeometry(a3_DemoState *demoState);
	void a3demo_loadShaders(a3_DemoState *demoState);
	void a3demo_loadTextures(a3_DemoState *demoState);
	void a3demo_loadFramebuffers(a3_DemoState *demoState);
	void a3demo_refresh(a3_DemoState *demoState);

	// unloading
	void a3demo_unloadGeometry(a3_DemoState *demoState);
	void a3demo_unloadShaders(a3_DemoState *demoState);
	void a3demo_unloadTextures(a3_DemoState *demoState);
	void a3demo_unloadFramebuffers(a3_DemoState *demoState);
	void a3demo_validateUnload(const a3_DemoState *demoState);

	// other utils & setup
	void a3demo_setDefaultGraphicsState();
	void a3demo_initScene(a3_DemoState *demoState);


//-----------------------------------------------------------------------------


#ifdef __cplusplus
}
#endif	// __cplusplus


#endif	// !__ANIMAL3D_DEMOSTATE_H