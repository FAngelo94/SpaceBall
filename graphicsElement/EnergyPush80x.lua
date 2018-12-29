--In this class I create the graphics need for energy push
local energyPush={}
local path="img/gameComponents/normal/"
local pathComponents="img/gameComponents/"
local sheetButton=
{
	frames=
	{
		{--Active
			x=0,
			y=0,
			width=140,
			height=140
		},
		{--Disabled
			x=140,
			y=0,
			width=140,
			height=140
		},
	}
}
local pushButton=graphics.newImageSheet(pathComponents.."energyPush.png", sheetButton)--Button
local pushGroup
--Variable for the different energy push, one for player and one for each enemy
local playerPush
local topPush
local leftPush
local rightPush

--Prepare the graphics of Energy Push
function energyPush.create(groupGraph, bounceEnergy)
	pushGroup=groupGraph
	--Prepare the image of energyPush
	width=80
	height=20
	playerPush=display.newImageRect(pushGroup, path.."energyPush.png",width,height)
	playerPush.anchorY=1
	topPush=display.newImageRect(pushGroup, path.."energyPush.png",width,height)
	topPush.rotation=180
	topPush.anchorY=1
	leftPush=display.newImageRect(pushGroup, path.."energyPush.png",width,height)
	leftPush.rotation=90
	leftPush.anchorY=1
	rightPush=display.newImageRect(pushGroup, path.."energyPush.png",width,height)
	rightPush.rotation=270
	rightPush.anchorY=1
	--Add physics characteristic
	physics.addBody(playerPush, "static", {bounce=bounceEnergy, density=10})
	physics.addBody(topPush, "static", {bounce=bounceEnergy, density=10})
	physics.addBody(leftPush, "static", {bounce=bounceEnergy, density=10})
	physics.addBody(rightPush, "static", {bounce=bounceEnergy, density=10})
	--Hide all energy push
	playerPush.x=2000
	topPush.x=2000
	leftPush.x=2000
	rightPush.x=2000
end

--Add the button that player must press to use energy push
function energyPush.addButton()
	local sequenceOption={start=1, count=2}
	local buttonEnergyPush=display.newSprite(pushGroup, pushButton, sequenceOption)
	buttonEnergyPush.x=0
	buttonEnergyPush.y=300
	energyPush.buttonLeft=buttonEnergyPush
	local buttonEnergyPush=display.newSprite(pushGroup, pushButton, sequenceOption)
	buttonEnergyPush.x=display.contentWidth
	buttonEnergyPush.y=300
	energyPush.buttonRight=buttonEnergyPush
end
--By these 2 functions I change the button color
function energyPush.activeButton()
	if energyPush.buttonLeft~=nil and energyPush.buttonRight~=nil then
		energyPush.buttonLeft:setFrame(1)
		energyPush.buttonRight:setFrame(1)
	end
end
function energyPush.disactiveButton()
	if energyPush.buttonLeft~=nil and energyPush.buttonRight~=nil then
		energyPush.buttonLeft:setFrame(2)
		energyPush.buttonRight:setFrame(2)
	end
end

--Function to move the use the energy push
function energyPush.playerUse(x, y)
	playerPush.x=x
	playerPush.y=y-40
	transition.to(playerPush,{time=800, y=(playerPush.y-160), xScale=4, yScale=2, alpha=0, onComplete=transitionListener})
end
function energyPush.topUse(x, y)
	topPush.x=x
	topPush.y=y+40
	transition.to(topPush,{time=800, y=(topPush.y+160), xScale=4, yScale=2, alpha=0, onComplete=transitionListener})
end
function energyPush.leftUse(x, y)
	leftPush.y=y
	leftPush.x=x+40
	transition.to(leftPush,{time=800, x=(leftPush.x+160), xScale=4, yScale=2, alpha=0, onComplete=transitionListener})
end
function energyPush.rightUse(x, y)
	rightPush.y=y
	rightPush.x=x-40
	transition.to(rightPush,{time=800, x=(rightPush.x-160), xScale=4, yScale=2, alpha=0, onComplete=transitionListener})
end

--I want repeat the sequence of energy push just one time
function transitionListener(object)
	object.xScale=1
	object.yScale=1
	object.alpha=1
	object.x=2000
end

return energyPush