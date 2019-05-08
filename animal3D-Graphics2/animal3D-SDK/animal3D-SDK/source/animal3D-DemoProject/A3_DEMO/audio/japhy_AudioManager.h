#ifndef JAPHY_AUDIO_MANAGER_H
#define JAPHY_AUDIO_MANAGER_H


typedef struct FMODManager f_Man;

/*
#ifdef __cplusplus
extern "C" 
{
#endif
#else	// ! __cplusplus

*/
#include "FMODManager.h"

struct japhy_Audio
{
	struct f_Man *j_FMODMan;

	char* songFile;

	void (*func)();
};
typedef struct japhy_Audio j_Audio;

/*
#ifdef __cplusplus
}
#endif
*/
#endif // JAPHY_AUDIO_MANAGER_H