--Dynamic Ring
--This class manage a dynamic ring, it's mean that some part of the ring
--(like the margins) can became physics body
local dynamicRing={}
local path="img/gameComponents/"
--Dinamic Margin
local sheetMargin=
{
	frames=
	{
		{
			x=0,
			y=0,
			width=600,
			height=20
		},
		{
			x=0,
			y=20,
			width=600,
			height=20
		},
	}
}

--Variables
local ring
local spawnDimension
--Margin
local marginBot
local marginRight
local marginTop
local marginLeft

--In this function setup different graphics style for the different world
--where the player is
function dynamicRing.graphicsWord(world)
	backgroundName="background "..world..".png"
	ringName="ring "..world..".png"
	marginName="margin "..world..".png"
	marginObject=graphics.newImageSheet(path..marginName, sheetMargin)

end

function dynamicRing.create(groupGraph, level)
	dynamicRing.graphicsWord(level.world)
	--load background
	local background=display.newImageRect(groupGraph, path..backgroundName,1280,720)
	background.x=display.contentCenterX
	background.y=display.contentCenterY
	--load groupGraph (ring and border)
	ring=display.newImageRect(groupGraph, path..ringName,600,600)
	ring.x=display.contentCenterX
	ring.y=display.contentCenterY
	local sequenceOption={start=1, count=2, time=300}
	marginBot=display.newSprite(groupGraph, marginObject, sequenceOption)
	marginBot.x=background.x
	marginBot.y=background.y+295
	marginRight=display.newSprite(groupGraph, marginObject, sequenceOption)
	marginRight.x=background.x+295
	marginRight.y=background.y
	marginRight.rotation=90
	marginTop=display.newSprite(groupGraph, marginObject, sequenceOption)
	marginTop.x=background.x
	marginTop.y=background.y-295
	marginLeft=display.newSprite(groupGraph, marginObject, sequenceOption)
	marginLeft.x=background.x-295
	marginLeft.y=background.y
	marginLeft.rotation=90
	--load spawnball 
	spawnDimension=114
	local topLeftSpawn=display.newImageRect(groupGraph,path.."spawnball.png",spawnDimension,spawnDimension)
	topLeftSpawn.x=ring.x-300
	topLeftSpawn.y=ring.y-300
	local topRightSpawn=display.newImageRect(groupGraph,path.."spawnball.png",spawnDimension,spawnDimension)
	topRightSpawn.x=ring.x+300
	topRightSpawn.y=ring.y-300
	topRightSpawn.rotation=90
	local botRightSpawn=display.newImageRect(groupGraph,path.."spawnball.png",spawnDimension,spawnDimension)
	botRightSpawn.x=ring.x+300
	botRightSpawn.y=ring.y+300
	botRightSpawn.rotation=180
	local botLeftSpawn=display.newImageRect(groupGraph,path.."spawnball.png",spawnDimension,spawnDimension)
	botLeftSpawn.x=ring.x-300
	botLeftSpawn.y=ring.y+300
	botLeftSpawn.rotation=270
	--Add physics body
	physics.addBody(botLeftSpawn,"static", {bounce=level.bounceSpawn})
	physics.addBody(botRightSpawn,"static", {bounce=level.bounceSpawn})
	physics.addBody(topLeftSpawn,"static", {bounce=level.bounceSpawn})
	physics.addBody(topRightSpawn,"static", {bounce=level.bounceSpawn})
end

function dynamicRing.getSpawnDimension()
	return spawnDimension
end

function dynamicRing.getRing()
	return ring
end

--Two functions to manage the physics of the margin in the ring
--Add one margin like a body
function dynamicRing.marginBecomeBody(marginSelected)
	dynamicRing.marginRemoveBody()
	if marginSelected=="bot" then
		physics.addBody(marginBot,"static", {bounce=1})
		marginBot:play()
	elseif marginSelected=="right" then
		physics.addBody(marginRight,"static", {bounce=1})
		marginRight:play()
	elseif marginSelected=="top" then
		physics.addBody(marginTop,"static", {bounce=1})
		marginTop:play()
	elseif marginSelected=="left" then
		physics.addBody(marginLeft,"static", {bounce=1})
		marginLeft:play()
	end
end
--Stop all sprite and Remove all physics body
function dynamicRing.marginRemoveBody()
	marginBot:pause()
	marginRight:pause()
	marginTop:pause()
	marginLeft:pause()
	physics.removeBody(marginBot)
	physics.removeBody(marginRight)
	physics.removeBody(marginTop)
	physics.removeBody(marginLeft)
end

return dynamicRing 