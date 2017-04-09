-- ========== Settings ================
Settings:setCompareDimension(true, 720)
Settings:setScriptDimension(true, 720)
Settings:set("MinSimilarity", 0.65)

timeout=30
-- ==========  function defs ===========
function turnBattleAnimationsOff()
	click(Location(80,1220))
	click("settingsBlue.png")
	click(Location(500,870))
	wait(2)
	click(Location(500,870))
	wait(2)
	click(Location(500,1000))
	wait(2)
	click(Location(500,1000))
	wait(2)
	click("backArrowRed.png")

end
function runInitialSetup()
	-- This starts at the language select screen, runs through the tutorial, 
	-- and ends on the fist time visiting the 'Battle' tab
	wait(3)
	usaRegion = Region(226, 336, 487, 388)
	usaRegion:click("usaSelect.png")
	waitClick("confirmDark.png",timeout)
	waitClick("acceptGreen.png",timeout)
	waitClick("linkLaterRed.png",timeout)
	wait(3)
	click(Location(0, 0))
	click(Location(0, 0))
	existsClick("startDownload.png",timeout)  --if you already have the movie downloaded this doesn't show up
	waitClick("closeGreen.png",5*60)
	wait(1)
	click(Location(0, 0))
	waitClick("skipGreen.png",timeout)
	waitClick("confirmGreen.png",timeout)
	wait(2)
	click(Location(0, 0))
	waitClick("skipRed.png",timeout)
	waitClick("skipRed.png",timeout)

	--first anna sequence
	dragDrop(Location(60,750),Location(320,750))
	waitClick("skipRed.png",timeout)
	dragDrop(Location(300,750),Location(550,620))
	waitClick("annaLevelUpText.png",timeout*3)  --wait for level up graphic
	click(Location(0,0))
	waitClick("skipRed.png",timeout)
	click(Location(0, 0))
	waitClick("skipRed.png",timeout)
	waitClick("skipRed.png",timeout)

	dragDrop(Location(50,870),Location(420,750))  -- move archer
	--turn off battle animations
	--waitClick("settingsGear.png",30)
	wait(timeout)
	turnBattleAnimationsOff()
	dragDrop(Location(60,750),Location(400,750))  -- move anna
	existsClick("annaLevelUpText.png",timeout)  --?she sometimes levels up here?--
	waitClick("skipRed.png",timeout)  -- special charged notification
	dragDrop(Location(300,750),Location(550,750))  --move anna again (kill archer)
	existsClick("annaLevelUpText.png",timeout)

	wait(2)
	click(Location(0, 0)) --dissmiss stage clear
	if not exists("skipRed.png",timeout) then
		click(Location(0, 0)) --dissmiss stage clear again must have missed it last time
	end
	waitClick("skipRed.png",timeout)  --todo: shouldn't have to search twice for skipRed

	waitClick("closeGreen.png",timeout)  --dissmiss 15 free orbs
	waitClick("startDownload.png",timeout)  --main download that takes a while

	wait("worldOfZenith.png",10*60) --wait for download to finish

end

function claimAllGifts()
	wait(2)
	click(Location(80,1220)) --switch to home screen

	while existsClick("closeGreen.png",10) do --hit close till there's no more gift notification stuff to close

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

	while exists("redeemGreen.png",2) == nil and exists("closeGreen.png") == nil do  --keep periodically clicking until summon is done
		click(Location(0,0)) 
		retrys=retrys+1
		if retrys > 20 then
			error('Error finding redeemGreen.png or closeGreen.png')
		end
	end
	

end

function doSummons(count,bannerNumber) --number of summon sessions to do and banner to do them on
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
		
		--take screenshot or something?
		waitClick("closeGreen.png",timeout)
		--existsClick()  --click no if asked to rate
	end
	



end


-- ==========  main program ===========

runInitialSetup()

claimAllGifts()

doSummons(2,2)







--print("Script done!")

