//#include "fmod/fmod.hpp"
#ifndef FMOD_MANAGER_H
#define FMOD_MANAGER_H

#include "fmod/fmod.h"
#include "fmod/fmod_errors.h"

#ifdef __cplusplus

class FMODManager {
private:
	FMOD_SYSTEM *mpSystem;
	FMOD_CHANNELGROUP *mpCGroup;
	FMOD_CHANNEL *mpChannel;
	FMOD_SOUND *mpSound;
	FMOD_SOUND *mpStream;

	FMOD_RESULT mResult;
	FMOD_SPEAKERMODE mSpeakerMode;

	unsigned int mVersion;
	int mNumDrivers;

	char mDriverName[256];

public:
	void FMODErrorCheck(FMOD_RESULT res);
	void initFMOD();
	void loadSound(const char* name);

	void playSound();
};

#endif		// __cplusplus
#endif		// FMOD_MANAGER_H