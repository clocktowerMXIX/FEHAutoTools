# FEHAutoTools
The goal of the project is to automate some tasks in FEH such as rerolling. These script(s) should work on both emulators (bluestacks, nox, etc) and real devices. 
Do note that the free version of ankulua has some timing restrictions, most scripts should still work though may cut out after some time and have cooldown restrictions.

General setup:

Install AnkuLua here: https://play.google.com/store/apps/details?id=com.appautomatic.ankulua.trial&hl=en  (more info on AnkuLua here: http://ankulua.boards.net/) 

On your device (either physical android device or android emulator like nox) download desired script(s) and image.zip 

extract the image.zip folder

open up ankulua

either confirm root access or use the daemon installation mode: http://ankulua.boards.net/thread/3/daemon-installation

select the desired script in ankulua (right now there's just FEHFullReroll)

open FEH and press the overlaid translucent white play button




~~~Current Scripts~~~

--FEHFullReroll     (old version) demo video here: https://youtu.be/kIu3qtsVivA (it's kind of boring)


	This script should run through the download, opening scenes, tutorial, and then make a couple summons (with root it can restart this untill a set number of 5 stars are rolled. See below)

	
	+Optional Setup: Open up the FEHFullReroll.lua script in a text editor and change the numberOfSummons and bannerNumber options in the first few lines as desired
		numberOfSummons is the number of full 5 orb summons to do (specific summon color choices comming soon)
		bannerNumber is the number of times to click the right arrow on the summon banner page before summoning		
		
		
	-Single Reroll (no root required)

		Start with a fresh FEH app. Either a new install, clear the app data through settings, or delete shared prefs

		Open the FEH app then start the script (via the translucent arrow button) at the first landing page. 

		

		
	-!NEW! Reroll untill X number of 5 stars (for now only works in Nox and other devices that automatically go into landscape mode when the home button is pressed)

		Download and install FEH Restart App available here: https://github.com/Neffez/FEHrestart/raw/master/apk/FEHrestart-v0.1.apk
		
		Make sure both FEH and FEH restart App are on your home screen

		Open up the FEHFullReroll.lua script in a text editor
		
		Change  autoClearAndRestart = false   to   autoClearAndRestart = true
		
		and change minWanted5Stars to whatever you want 
		
		press the ankulua play button. The script will automatically clear out your data and start up the app




Helpful links:

resolve 803-3001 errors:  https://serenesforest.net/forums/index.php?/topic/68725-fe-heroes-error-803-3001/&page=4
ankulua reference: http://ankulua.boards.net/thread/6/objects-methods-introduction-sikuli-compatible#existsClick
