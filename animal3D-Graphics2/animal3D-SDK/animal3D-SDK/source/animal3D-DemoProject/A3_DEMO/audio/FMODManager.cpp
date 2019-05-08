#include "FMODManager.h"

#include <iostream>

void FMODManager::FMODErrorCheck(FMOD_RESULT res)
{
	if (res != FMOD_OK)
	{
		std::cout << "FMOD error! (" << res << ") " << FMOD_ErrorString(res) << std::endl;
		exit(-1);
	}
}

void FMODManager::initFMOD()
{
	// check version
	mResult = FMOD_System_GetVersion(mpSystem, &mVersion);		// c
			//mpSystem->getVersion(&mVersion);		c++
	FMODErrorCheck(mResult);

	// get number of sound cards 
	mResult = FMOD_System_GetNumDrivers(mpSystem, &mNumDrivers);		// c
			//mpSystem->getNumDrivers(&mNumDrivers);		// c++
	FMODErrorCheck(mResult);

	// no sound cards (disable sound)
	if (mNumDrivers == 0)
	{
		mResult = FMOD_System_SetOutput(mpSystem, FMOD_OUTPUTTYPE_NOSOUND);	// c
				//mpSystem->setOutput(FMOD_OUTPUTTYPE_NOSOUND);		c++
		FMODErrorCheck(mResult);
	}

	mResult = FMOD_System_Init(mpSystem, 32, FMOD_INIT_NORMAL, 0);		// c
		//mpSystem->init(100, FMOD_INIT_NORMAL, 0);		c++

	FMODErrorCheck(mResult);
}

void FMODManager::loadSound(const char* f)
{
	// create the sound
	mResult = FMOD_System_CreateSound(mpSystem, f, FMOD_DEFAULT, 0, &mpSound);	// c
			//mpSystem->createSound(f, FMOD_DEFAULT, 0, &mpSound);		c++
	FMODErrorCheck(mResult);

	// create the stream
	mResult = FMOD_System_CreateStream(mpSystem, f, FMOD_DEFAULT, 0, &mpStream);	// c
			//mpSystem->createStream(f, FMOD_DEFAULT, 0, &mpStream);		c++
	FMODErrorCheck(mResult);

	// create the channel
	mResult = FMOD_Channel_GetSystemObject(mpChannel, &mpSystem);	// c
			// mpSystem->getSystemObject(mpChannel, mpSystem);		// c++
	FMODErrorCheck(mResult);

	mResult = FMOD_System_CreateChannelGroup(mpSystem, "group", &mpCGroup);	// c
			//mResult = mpSystem->createChannelGroup("group", &mpCGroup);	c++
	FMODErrorCheck(mResult);
}

void FMODManager::playSound()
{
	mResult = FMOD_System_PlaySound(mpSystem, mpSound, mpCGroup, 0, &mpChannel);
		//mpSystem->playSound(mpSound, mpCGroup, false, 0);
}