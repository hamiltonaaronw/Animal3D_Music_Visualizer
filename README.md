# Animal3D_Music_Visualizer
*** DISCLAIMER *** 
Animal3D is a graphics framework written by Daniel Buckstein.
I have modified it and integreated FMOD with permissions from the author

Notable features:
- Ability to toggle songs
- The list of songs is dynamically allocated
- Rather than hardcoding the paths to each song, 
	the program goes directly into the ../../music
	directory and adds anything with .mp3 in the name
	to the dynamic list of songs (as soon in the
	loadSongs() function in a3_DemoState_loading.c)

Relevant files:
a3_DemoState.h

a3_demo_callbacks.c
a3_DemoState_initialize.c
a3_DemoState_loading.c
a3_DemoState_idle-render.c
a3_DemoState_idle-update.c
a3_DemoState_unloading.c
main_dll.c

passMusicVisualization_vs4x.glsl
drawMusicVisualization_vs4x.glsl

Music:
*** DISCLAIMER: I do not own the rights to any of these songs nor am I
	attempting to gain any sort of profit from them ***
At the beginning of the project I was hardcoding the paths to the songs
So I made the name of each song in the folder as short as possible 
while still being able to distinguish them
In order of appearence in the /music/ directory:

baby:		Be My Baby - Major and the Monbacks
back: 		Right Back - Khalid
begood: 	Be Good Until Then - Butch Walker
beth:		bethamphetamine - Butch Walker
bigworm:	Big Worm - Maxo Kream
blackfriday:	Black Friday - Kendrick Lamar & J. Cole
brazil:		Brazil - Declan McKenna
coin:		Insert Coin - Broncho
cuckoos:	We Can Take a Trip to Another Day - The Cuckoos
daisies:	Daisies - White Reaper
die:		Die Tonight - Goldyard
dimension:	Dimenson - Wolfmother
dirty:		Dirty - Made Violent
domination:	Domination - Pantera
fc4:		Free Crack 4 Intro - Lil Bibby
fury:		Song and Fury - Mt Eddy
gone:		Since You Been Gone - Head East
grind:		Grind You Down - Machine Head
guilty:		Guilty Pleasure - Bryce Vine
hacked:		Hacked My Instagram - Pierre Bourne
illusion:	A Life of Illusion - Joe Walsh
kids:		The Kids Aren't Alright - The Offspring
latin:		Boys Latin - Panda Bear
lit:		Kid Singing in Walmart (Lowercase EDM Remix) - Lowercase
mallrats:	Mallrats (La La La) - The Orwells
map:		Map Change - Every Time I Die
mooncalf:	Mooncalf - Active Bird Community 
needs:		Who Needs You - The Orwells
ponce:		Ponce De Leon Ave - Butch Walker
redwood:	redwood - UltraQ
road:		Old Town Road - Lil Nas X feat. Billy Ray Cyrus
roundabout:	Roundabout - Yes
shoelaces:	Pink Shoe Laces - Dodie Stevens
sosa:		Love Sosa (Nairobi Remix) - artist unknown
speaking:	Universally Speaking - Red Hot Chili Peppers
storm:		Storm Charmer - The Damned Things
tricky:		It's Tricky - RunDMC
uni:		You & I - Samson
weather:	Curse the Weather - Mo Lowda & The Humble
wolf:		Wolf Trap Hotel - White Reaper
