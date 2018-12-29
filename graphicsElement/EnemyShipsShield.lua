--In this class will be created and destroyed enemy ships and implement
--all functions to modify the enemy ships
local enemies={}
local path="img/gameComponents/normal/"
local pathComponent="img/gameComponents/"
local sheetShips=
{
	frames=
	{
		{
			x=0,
			y=0,
			width=118,
			height=113
		},
		{
			x=118,
			y=0,
			width=118,
			height=113
		},
		{
			x=236,
			y=0,
			width=118,
			height=113,
		},
	}
}
local shipObject=graphics.newImageSheet(path.."shipEnemyShield.png", sheetShips)
local enemyGroup
--enemies's Ship
local topEnemy
local rightEnemy
local leftEnemy
--Save the ring for manage where draw everything
local ring
local spawnDimension

function enemies.create(groupGraph, level, r, sD)
	enemyGroup=groupGraph
	ring=r
	spawnDimension=sD
	local sequenceOption={start=1, count=3}--this is valid for enemy
	topEnemy=display.newSprite(enemyGroup,shipObject,sequenceOption)
	topEnemy.x=ring.x
	topEnemy.y=ring.y-320
	topEnemy.rotation=180
	rightEnemy=display.newSprite(enemyGroup,shipObject,sequenceOption)
	rightEnemy.x=ring.x+320
	rightEnemy.y=ring.y
	rightEnemy.rotation=270
	leftEnemy=display.newSprite(enemyGroup,shipObject,sequenceOption)
	leftEnemy.x=ring.x-320
	leftEnemy.y=ring.y
	leftEnemy.rotation=90
	--Add physics body
	physics.addBody(topEnemy,"static", {bounce=2.3})
	physics.addBody(rightEnemy,"static", {bounce=2.3})
	physics.addBody(leftEnemy,"static",  {bounce=2.3})
end

--Change the image of the player's ship when he is moving
function enemies.shipDirection(ship, direction)
	if direction == "right" then
		ship:setFrame(2)
	elseif direction == "left" then
		ship:setFrame(3)
	else
		ship:setFrame(1)
	end
end

--Functions below change enemies with 0 points with a wall
function enemies.deleteEnemy(enemy)
	if enemy == "top" then
		local y=topEnemy.y
		display.remove(topEnemy)
		local block=display.newImageRect(enemyGroup, pathComponent.."diedEnemy.png", ring.width-spawnDimension, 40)
		block.x=display.contentCenterX
		block.y=y+15
		physics.addBody(block, "static" )
		topEnemy=nil
	elseif enemy== "left" then
		local x=leftEnemy.x
		display.remove(leftEnemy)
		local block=display.newImageRect(enemyGroup, pathComponent.."diedEnemy.png", 40, ring.height-spawnDimension)
		block.y=display.contentCenterY
		block.x=x+15
		physics.addBody(block, "static")
		leftEnemy=nil
	elseif enemy== "right" then 
		local x=rightEnemy.x
		display.remove(rightEnemy)
		local block=display.newImageRect(enemyGroup, pathComponent.."diedEnemy.png", 40, ring.height-spawnDimension)
		block.y=display.contentCenterY
		block.x=x-15
		physics.addBody(block, "static")
		rightEnemy=nil
	end
end

--Functions to return enemy ships
function enemies.getTopShip()
	return topEnemy
end
function enemies.getLeftShip()
	return leftEnemy
end
function enemies.getRightShip()
	return rightEnemy
end

return enemies