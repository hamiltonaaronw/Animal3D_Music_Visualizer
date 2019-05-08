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
	
	a3_RenderPipeline.h
	Interface for render pipeline utilities.
*/

#ifndef __ANIMAL3D_RENDERPIPELINE_H
#define __ANIMAL3D_RENDERPIPELINE_H


//-----------------------------------------------------------------------------
// animal3D framework includes

#include "animal3D/animal3D.h"
#include "animal3D-A3DG/animal3D-A3DG.h"


//-----------------------------------------------------------------------------

#ifdef __cplusplus
extern "C"
{
#else	// !__cplusplus
	typedef struct a3_RenderPipeline	a3_RenderPipeline;
	typedef struct a3_RenderPass		a3_RenderPass;
#endif	// __cplusplus


//-----------------------------------------------------------------------------

	struct a3_RenderPass;

	// function pointer type for render pass callback: returns general ret 
	//	type, requires const render pass pointer and any other pointer
	typedef a3ret(*a3_RenderPassCallback)(const a3_RenderPass *pass, void *);


//-----------------------------------------------------------------------------

	// render pipeline
	struct a3_RenderPipeline
	{
		a3i32 dummy;
	};

	// render pass
	struct a3_RenderPass
	{
		a3i32 dummy;
	};


//-----------------------------------------------------------------------------


#ifdef __cplusplus
}
#endif	// __cplusplus


#endif	// !__ANIMAL3D_RENDERPIPELINE_H