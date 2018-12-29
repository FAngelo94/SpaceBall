--In this class I manage the frozen power
local frozenPower={}
--REQUIRE
local pathGraphics="graphicsElement."
local graph=require(pathGraphics.."FrozenPush80x")

--Save the references to other classes
local level
local player
--Check if the energy push button is active or not
local isActive

function frozenPower.setup(sceneGroup, l)
	level=l
	graph.create(sceneGroup)
end

--By this function I setup player
function frozenPower.setupPlayer(p)
	player=p
	graph.buttonLeft:addEventListener("touch", activeFrozenPower)
	graph.buttonRight:addEventListener("touch", activeFrozenPower)
	isActive=true
end

--PLAYER FUNCTIONS
--This function active when the player press the button
local timerPushPlayer=nil
function activeFrozenPower(event)
	if isActive then
		--Stop everything in the game except the player
		level.frozenTheGame()
		--Setup the timer and listener button
		graph.disactiveButton()
		
		timerPushPlayer=timer.performWithDelay(level.rechargePower, frozenPower.rechargeFrozen, 1)
		isActive=false
	end
end
--This function reactive the energy button
function frozenPower.rechargeFrozen()
	level.stopFrozenTheGame()
	graph.activeButton()
	isActive=true
end

--Remove the timer of the player
function frozenPower.removePlayerTimer()
	timer.cancel(timerPushPlayer)
end

function frozenPower.removeIce()
	graph.removeIce()
end

return frozenPower