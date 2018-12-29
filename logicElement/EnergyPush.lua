--In this class I manage the energy push
local energyPush={}
--REQUIRE
local pathGraphics="graphicsElement."
local graph=require(pathGraphics.."EnergyPush80x")

--Save the references to other classes
local level
local player
local enemy
local ball
--Check if the energy push button is active or not
local isActive
--By these variables check if the enemy can use energy push or not
local isActiveTop
local isActiveLeft
local isActiveRight

function energyPush.setup(sceneGroup, l, b)
	level=l
	ball=b
	graph.create(sceneGroup, level.bounceEnergy)
end

--By these 2 functions I setup player and enemy differently so if I want I can give
--the energy push only to the enemy or only to the enemy, it will be decided in the level Class
function energyPush.setupPlayer(p)
	player=p
	graph.addButton()
	graph.buttonLeft:addEventListener("touch", activeEnergyPlayer)
	graph.buttonRight:addEventListener("touch", activeEnergyPlayer)
	isActive=true
end
function energyPush.setupEnemy(e)
	enemy=e
	isActiveTop=true
	isActiveLeft=true
	isActiveRight=true
end

--ENEMY FUNCTIONS
--This functions decide when the enemy can use the energy and active it
function energyPush.activeEnemyEnergy()
	topEnergyPush(enemy.getTopEnemy(), ball)
	leftEnergyPush(enemy.getLeftEnemy(), ball)
	rightEnergyPush(enemy.getRightEnemy(), ball)
end
function topEnergyPush(ship, ball)
	if isActiveTop==true and ship~=nil then
		local ballTable=ball.getTable()
		local needEnergy=false
		for i=#ballTable, 1, -1 do
			if (ballTable[i].y<ship.y+150 and
			ballTable[i].x>ship.x-150 and ballTable[i].x<ship.x+150) then
				needEnergy=true
			end
		end
		if(needEnergy)then
			graph.topUse(ship.x, ship.y)
		end
		isActiveTop=false
		local t=math.random(level.rechargeEnemyEnergyMin, level.rechargeEnemyEnergyMax)
		timerPushTop=timer.performWithDelay(t, useAgainEnergyTop, 1)
	end
end
function leftEnergyPush(ship, ball)
	if isActiveLeft==true and ship~=nil then
		local ballTable=ball.getTable()
		local needEnergy=false
		for i=#ballTable, 1, -1 do
			if (ballTable[i].x<ship.x+150 and
			ballTable[i].y>ship.y-150 and ballTable[i].y<ship.y+150) then
				needEnergy=true
			end
		end
		if(needEnergy)then
			graph.leftUse(ship.x, ship.y)
		end
		isActiveLeft=false
		local t=math.random(level.rechargeEnemyEnergyMin, level.rechargeEnemyEnergyMax)
		timerPushLeft=timer.performWithDelay(t, useAgainEnergyLeft, 1)
	end
end
function rightEnergyPush(ship, ball)
	if isActiveRight==true and ship~=nil then
		local ballTable=ball.getTable()
		local needEnergy=false
		for i=#ballTable, 1, -1 do
			if (ballTable[i].x<ship.x-150 and
			ballTable[i].y>ship.y-150 and ballTable[i].y<ship.y+150) then
				needEnergy=true
			end
		end
		if(needEnergy)then
			graph.rightUse(ship.x, ship.y)
		end
		isActiveRight=false
		local t=math.random(level.rechargeEnemyEnergyMin, level.rechargeEnemyEnergyMax)
		timerPushRight=timer.performWithDelay(t, useAgainEnergyRight, 1)
	end
end
--Active energy push for enemy
function useAgainEnergyTop()
	isActiveTop=true
end
function useAgainEnergyLeft()
	isActiveLeft=true
end
function useAgainEnergyRight()
	isActiveRight=true
end

--PLAYER FUNCTIONS
--This function active when the player press the button
local timerPushPlayer=nil
function activeEnergyPlayer(event)
	if isActive then
		--Play animation
		x=player.shipX()
		y=player.shipY()
		graph.playerUse(x, y)
		--Setup the timer and listener button
		graph.disactiveButton()
		timerPushPlayer=timer.performWithDelay(level.rechargeEnergy, energyPush.rechargeEnergy, 1)
		isActive=false
	end
end
--This function reactive the energy button
function energyPush.rechargeEnergy()
	graph.activeButton()
	isActive=true
end
function energyPush.disableEnergy()
	graph.disactiveButton()
	isActive=false
end
--This functions manage the pause and start of the timers
function energyPush.pause()
	if timerPushTop~=nil then
		timer.pause(timerPushTop)
	end
	if timerPushRight~=nil then
		timer.pause(timerPushRight)
	end
	if timerPushLeft~=nil then
		timer.pause(timerPushLeft)
	end
	if timerPushPlayer~=nil then
		timer.pause(timerPushPlayer)
	end
	isActive=false
end
function energyPush.resume()
	if timerPushTop~=nil then
		timer.resume(timerPushTop)
	end
	if timerPushRight~=nil then
		timer.resume(timerPushRight)
	end
	if timerPushLeft~=nil then
		timer.resume(timerPushLeft)
	end
	if timerPushPlayer~=nil then
		timer.resume(timerPushPlayer)
	end
	isActive=true
end

--Remove the timer of the player
function energyPush.removePlayerTimer()
	timer.cancel(timerPushPlayer)
end

return energyPush