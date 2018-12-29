--In this class will be created and destroyed player ship and implement
--all functions to modify the player ship
local player={}
local path="img/gameComponents/normal/playerShip/"
local database=require("Database")
local sheetShips=
{
	frames=
	{
		{
			x=0,
			y=0,
			width=100,
			height=100
		},
		{
			x=100,
			y=0,
			width=100,
			height=100
		},
		{
			x=200,
			y=0,
			width=100,
			height=100,
		},
	}
}
local numberShip=database.getShipSelected()
local shipObject=graphics.newImageSheet(path..numberShip..".png", sheetShips)
local playersGroup
local playerShip

function player.create(groupGraph, level, ring)
	playersGroup=groupGraph
	local sequenceOption={start=1, count=3}--this is valid for player 
	playerShip=display.newSprite(playersGroup,shipObject,sequenceOption)
	playerShip.x=ring.x
	playerShip.y=ring.y+320
	physics.addBody(playerShip,"static", {bounce=level.bounceShip})
end

--Functions to get Player ship
function player.getPlayerShip()
	return playerShip
end

--Change the image of the player's ship when he is moving
function player.shipDirection(direction)
	if direction == "right" then
		playerShip:setFrame(2)
	elseif direction == "left" then
		playerShip:setFrame(3)
	else
		playerShip:setFrame(1)
	end
end

function player.destroy()
	display.remove(playersGroup)
end

return player