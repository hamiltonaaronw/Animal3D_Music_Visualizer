#ifndef DSP_H
#define DSP_H

#include "FMODManager.h"

#ifdef __cplusplus
extern "C"
{
#else	// !__cplusplus
	typedef struct j_Audio		j_AudioState;
#endif	// __cplusplus
}


struct j_Audio
{
	FMODManager* j_fmodMan;
};

#endif