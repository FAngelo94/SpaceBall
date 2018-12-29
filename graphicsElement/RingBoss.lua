--Ring for boss
--Build a special ring with margin when the player face the boss
--This class use Ring class and apply some modify
local ringBoss={}
local pathGraphics="graphicsElement."
local ringClass=require(pathGraphics.."Ring")

function ringBoss.create(group, level)
	--Create default ring
	ringClass.create(group, level)
	--Now put left and right margin block
	local pathComponent="img/gameComponents/"
	local spawnDimension=ringClass.getSpawnDimension()
	local ring=ringClass.getRing()
	--left
	local block=display.newImageRect(group, pathComponent.."diedEnemy.png", 40, ring.height-spawnDimension)
	block.y=display.contentCenterY
	block.x=ring.x-300
	physics.addBody(block, "static")
	--right
	local block=display.newImageRect(group, pathComponent.."diedEnemy.png", 40, ring.height-spawnDimension)
	block.y=display.contentCenterY
	block.x=ring.x+300
	physics.addBody(block, "static")
end

function ringBoss.getSpawnDimension()
	return ringClass.getSpawnDimension()
end

function ringBoss.getRing()
	return ringClass.getRing()
end

--Two functions to manage the physics of the margin in the ring
--Add one margin like a body
function ringBoss.marginBecomeBody(marginSelected)
	ringClass.marginRemoveBody()
	ringClass.marginBecomeBody(marginSelected)
end

return ringBoss