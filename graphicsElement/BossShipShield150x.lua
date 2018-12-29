--Boss Ship
--This class is like EnemyShip and manage the graphics of Boss Ship
local bossShip={}

local path="img/gameComponents/big/"
local pathComponent="img/gameComponents/"
local sheetShips=
{
	frames=
	{
		{
			x=0,
			y=0,
			width=170,
			height=163
		},
		{
			x=170,
			y=0,
			width=170,
			height=163
		},
		{
			x=340,
			y=0,
			width=170,
			height=163,
		},
	}
}
local shipObject=graphics.newImageSheet(path.."shipEnemyShield.png", sheetShips)
local enemyGroup
--bossShip's Ship
local bossEnemy
--Save the ring for manage where draw everything
local ring
local spawnDimension

function bossShip.create(groupGraph, level, r, sD)
	enemyGroup=groupGraph
	ring=r
	spawnDimension=sD
	local sequenceOption={start=1, count=3}--this is valid for enemy
	bossEnemy=display.newSprite(enemyGroup,shipObject,sequenceOption)
	bossEnemy.x=ring.x
	bossEnemy.y=ring.y-310
	bossEnemy.rotation=180
	--Add physics body
	physics.addBody(bossEnemy,"static", {bounce=2}) 
end

--Change the image of the player's ship when he is moving
function bossShip.shipDirection(ship, direction)
	if direction == "right" then
		ship:setFrame(2)
	elseif direction == "left" then
		ship:setFrame(3)
	else
		ship:setFrame(1)
	end
end

--Functions to return enemy ships
function bossShip.getBossShip()
	return bossEnemy
end

return bossShip