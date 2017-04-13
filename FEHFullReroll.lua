-- ========== Configuration options ================ (TODO move this to config file or something)
numberOfSummons = 2
bannerNumber = 1  --how many times to click the right arrow when before summoning

-- ROOT options below. Only change these if you have root access on your device
autoClearAndRestart = false  --use FEHRestartApp to automatically clear out FEH data (requires root) then restart the whole process TODO: add a non-root way to do this
-- FEHRestartApp available here: https://github.com/Neffez/FEHrestart/raw/master/apk/FEHrestart-v0.1.apk
minWanted5Stars = 3  --for now only used if autoClearAndRestart is true


-- ========== AnkuLua Settings ================
Settings:setCompareDimension(true, 720)
Settings:setScriptDimension(true, 720)
Settings:set("MinSimilarity", 0.75)


-- ========== "globals" ==========  --TODO: make all caps I guess?
timeout=10  --attempt to set a global timeout that can (in theory) adjusted for slow devices. 10 should be more than enough though
skipRegion = Region(475,0,720,80)  --where the red skip is

-- ==========  function defs ===========
function turnBattleAnimationsOff()
	waitClick("settingsGear.png",timeout)
	waitClick("settingsBlue.png",timeout)
	
	combatAnimationsRegion = Region(46,945,674,1053)
	combatAnimationsRegion:existsClick("onBlue.png",2)
	combatAnimationsRegion:existsClick("ownTurnOnlyBlue.png",2)
	
	
	supportAnimationsRegion = Region(97,1113,637,1165)
	supportAnimationsRegion:existsClick("onBlue.png",2)
	supportAnimationsRegion:existsClick("ownTurnOnlyBlue.png",2)
	
	click("backArrowRed.png")

end
function runInitialSetup()
	-- This starts at the language select screen, runs through the tutorial, 
	-- and ends on the fist time visiting the 'Battle' tab
	wait(3)
	--usaRegion = Region(226, 336, 487, 388)
	--usaRegion:click("usaSelect.png")
	--waitClick("confirmDark.png",timeout)
	waitClick("acceptGreen.png",timeout)
	waitClick("linkLaterRed.png",timeout)
	wait(3)
	click(Location(0, 0))
	click(Location(0, 0))
	existsClick("startDownload.png")  --if you already have the movie downloaded this doesn't show up
	waitClick("closeGreen.png",5*60)
	wait(1)
	click(Location(0, 0))
	waitClick("skipGreen.png",timeout)
	waitClick("confirmGreen.png",timeout)
	wait(2)
	click(Location(0, 0))
	skipRegion:waitClick("skipRed.png",timeout)
	skipRegion:waitClick("skipRed.png",timeout)

	--first anna sequence
	dragDrop(Location(60,750),Location(320,750))  --move 
	skipRegion:waitClick("skipRed.png",timeout)  
	dragDrop(Location(300,750),Location(550,620))  --attack
	
	--keep clicking until next skip comes up (dismiss level up and stage clear)
	while skipRegion:existsClick("skipRed.png",1) == false do
		click(Location(0, 0))
	end
	--waitClick("annaLevelUpText.png",timeout*3)  --wait for level up graphic
	--click(Location(0,0))
	--skipRegion:waitClick("skipRed.png",timeout)
	click(Location(0, 0))
	skipRegion:waitClick("skipRed.png",timeout)
	skipRegion:waitClick("skipRed.png",timeout)

	--second anna sequence (now with archer)
	dragDrop(Location(50,870),Location(420,750))  -- move archer
	--turn off battle animations
	--waitClick("settingsGear.png",30)
	wait(timeout/2)
	turnBattleAnimationsOff()
	dragDrop(Location(60,750),Location(400,750))  -- move anna
	existsClick("annaLevelUpText.png",timeout*3)  --?she sometimes levels up here?--
	skipRegion:waitClick("skipRed.png",timeout)  -- special charged notification
	dragDrop(Location(300,750),Location(550,750))  --move anna again (kill archer)
	existsClick("annaLevelUpText.png",timeout*3)

	wait(2)
	click(Location(0, 0)) --dissmiss stage clear
	if not skipRegion:exists("skipRed.png",timeout) then
		click(Location(0, 0)) --dissmiss stage clear again must have missed it last time  TODO: this better
	end
	skipRegion:waitClick("skipRed.png",timeout)  --todo: shouldn't have to search twice for skipRed

	waitClick("closeGreen.png",timeout)  --dissmiss 15 free orbs
	waitClick("startDownload.png",timeout)  --main download that takes a while

	wait("worldOfZenith.png",10*60) --wait for download to finish

end

function claimAllGifts()
	wait(2)
	click(Location(80,1220)) --switch to home screen
	wait(2)
	while existsClick("closeGreen.png") do --hit close till there's no more gift notification stuff to close

	end
	waitClick("letterOwl.png",timeout) --click owl
	waitClick("acceptAllGreen.png",timeout) --accept all

	acceptAllConfirmRegion = Region(100, 550, 600, 700)
	acceptAllConfirmRegion:waitClick("acceptGreen.png",timeout) --confirm accept
	waitClick("closeGreen.png",timeout)

end

function redeemAndPickSummonOrb(orbSpotX,orbSpotY)
	existsClick("redeemGreen.png")  --click redeem for next orb
	exists("confirmDark.png",timeout)
	click(Location(orbSpotX,orbSpotY))  --click the orb spot
	waitClick("confirmGreen.png",timeout)
	
	retrys=0

	while exists("redeemGreen.png") == nil and exists("closeGreen.png") == nil do  --keep periodically clicking until summon is done
		click(Location(0,0)) 
		retrys=retrys+1
		if retrys > 200 then
			error('Error finding redeemGreen.png or closeGreen.png')
		end
	end
	

end

function count5Stars()

	found5Star,val=pcall(findAll,"5Stars.png")
	--print(found5Star)

	if found5Star then
		return #val
	else
		return 0
	end

end 

function doSummons(count,bannerNumber) --number of summon sessions to do and banner to do them on
	fiveStarCount = 0
	click(Location(420,1220))  --click summon tab
	wait(2)
	existsClick("closeGreen.png")  --click close for first time info popup

	-- Change banner?
	-- dragDrop(Location(500,600),Location(200,600)) --doesnt seem to work
	while bannerNumber-1 > 0 do
		click(Location(700,620))  --switch to one banner to the right
		bannerNumber = bannerNumber-1
	end
	
	while count > 0 do
		waitClick("summonGreen.png",timeout) -- on the banner page click summon
		waitClick("redeemGreen.png",timeout) -- still on the banner page click redeem

		-- orbs at 500,720  570,480  360,360  140,480  230,720
		redeemAndPickSummonOrb(500,720)
		redeemAndPickSummonOrb(570,480)
		redeemAndPickSummonOrb(360,360)
		redeemAndPickSummonOrb(140,480)
		redeemAndPickSummonOrb(230,720)
		count = count - 1
		
		fiveStarCount = fiveStarCount + count5Stars()
		
		
		--take screenshot or something?
		waitClick("closeGreen.png",timeout)
		--existsClick()  --click no if asked to rate
	end
	
	return fiveStarCount
	
end

function clearDataRestart()
    keyevent(187)  --press app switch  (nox sometimes black screens and it seems like hitting app switch first helps?)
	keyevent(3)  --press home
	Settings:setCompareDimension(true, 1280)
	Settings:setScriptDimension(true, 1280)
	waitClick("FEHRestartApp.png",timeout)
	Settings:setCompareDimension(true, 720)
	Settings:setScriptDimension(true, 720)

end



-- ==========  main ===========
num5Stars = 0
while(num5Stars < minWanted5Stars) do
	
	if autoClearAndRestart == true then
		clearDataRestart()
	end
	
	runInitialSetup()

	claimAllGifts()

	num5Stars=doSummons(numberOfSummons,bannerNumber)
	
	if autoClearAndRestart == false then  --can't repeat if no way to clear out previous data
		return
	end
	
	
end
	


print("Script done!")

