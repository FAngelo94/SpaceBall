local player={}
--REQUIRE
local pathGraphics="graphicsElement."
local graph=require(pathGraphics.."PlayerShip100x")	--Save the graphics class player ship
local textPoints=require(pathGraphics.."SimpleText")--save the graphics class to modify the text of points

local level--save level class
local points--save player points
local ball--save ball logic class
local playerShip--Save the graphics element "player ship" content in graph
local ringClass--save the graphics class Ring
--margin in the ring
local marginRight
local marginLeft

function player.setup(groupGraph, l, b, r)
	level=l
	ringClass=r
	local ring=ringClass.getRing()
	graph.create(groupGraph, level, ring)
	textPoints.create(groupGraph, ring)
	textPoints.createPlayerPoints()
	points=level.playerPoints
	textPoints.setPlayerPointsText(points)
	ball=b
	playerShip=graph.getPlayerShip()
	marginRight=ring.x+ring.width/2-ringClass.getSpawnDimension()/2-playerShip.width/2
	marginLeft=ring.x-ring.width/2+ringClass.getSpawnDimension()/2+playerShip.width/2
end

--FUNCTIONS AND VARIABLES TO MANAGE THE PLAYER'S SHIP MOVEMENTS
--variables usefull to move the Player's ship
local loopMovePlayer
local playerTouchedX
local playerEvent
--Move the player depending WHEN the player is touching while this method 
--is called
function movePlayer()
	--move to right
	local center=display.contentCenterX
	if playerEvent.x>=center then
		if(playerTouchedX<center)then
			graph.shipDirection("right")
			playerTouchedX=playerEvent.x
			level.startMove()
		end
		if(playerShip.x+level.speed<marginRight)then
			modifyPlayerX(level.speed)
		else
			playerShip.x=marginRight
		end
		level.increment()
	--move to left
	elseif playerEvent.x<center then
		if(playerTouchedX>=center)then
			graph.shipDirection("left")
			playerTouchedX=playerEvent.x
			level.startMove()
		end
		if(playerShip.x-level.speed>marginLeft)then
			 modifyPlayerX(-level.speed)
		else
			playerShip.x=marginLeft
		end
		level.increment()
	end
end
--Modify position of the player's ship
function modifyPlayerX(move)
	transition.to(playerShip, {time=20, x=(playerShip.x+move)})
end
--Check WHEN and WHERE the player is touching the screen
function player.touchDisplay(event)
	if event.phase == "began" then
		if (loopMovePlayer ~= nil) then --Delete the timer if it was created and not ended because the player didn't release
			timer.cancel(loopMovePlayer) --the finger while he was in the display
		end
		level.startMove()
		playerTouchedX=event.x
		playerEvent=event
		if playerTouchedX >= display.contentCenterX then
			graph.shipDirection("right")
		else
			graph.shipDirection("left")
		end
		loopMovePlayer=timer.performWithDelay(20,movePlayer,0)
	elseif event.phase=="moved" then
		playerEvent=event
	elseif event.phase == "ended" or event.phase== "cancelled" then
		graph.shipDirection("stop")
		player.removeTimer()
	end
end
--Decrement the points of the player
function player.decrementPoints()
	points=points-1
end
--Return the points of the player
function player.getPoints()
	return points
end
--Set the point of player
function player.setPoints(p)
	points=p
	textPoints.setPlayerPointsText(points)
end
--Count the balls that goes inside the player's goal
function player.checkBallsOut()
	local ballsTable=ball.getTable()
	for i=#ballsTable, 1, -1 do
		local ball=ballsTable[i]
		if ball.myName=="in" then --Check only the balls that weren't go out
			if(ball.y>playerShip.y+ball.height/2)then
				ball.myName="out"
				points=points-1
				textPoints.setPlayerPointsText(points)
			end
		end
	end
end

--Delete the timer that manage the movement when the game finish
function player.removeTimer()
	if loopMovePlayer~=nil then
		timer.cancel(loopMovePlayer)
	end
end

--This function return X and Y of ship
function player.shipX()
	return playerShip.x
end
function player.shipY()
	return playerShip.y
end

return player