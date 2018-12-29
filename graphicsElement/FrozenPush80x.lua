--In this class I create the graphics need for frozen push
local frozenPush={}
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
local ice

--Add the button to Frozen Power
function frozenPush.create(groupGraph)
	pushGroup=groupGraph
	local sequenceOption={start=1, count=2}
	local buttonEnergyPush=display.newSprite(pushGroup, pushButton, sequenceOption)
	buttonEnergyPush.x=0
	buttonEnergyPush.y=300
	frozenPush.buttonLeft=buttonEnergyPush
	local buttonEnergyPush=display.newSprite(pushGroup, pushButton, sequenceOption)
	buttonEnergyPush.x=display.contentWidth
	buttonEnergyPush.y=300
	frozenPush.buttonRight=buttonEnergyPush
	--Ice effect
	ice=display.newImageRect(groupGraph, pathComponents.."ice.png",600,600)
	ice.x=display.contentCenterX
	ice.y=display.contentCenterY
	ice.alpha=0
end

--By these 2 functions I change the button color
function frozenPush.activeButton()
	if frozenPush.buttonLeft~=nil and frozenPush.buttonRight~=nil then
		frozenPush.buttonLeft:setFrame(1)
		frozenPush.buttonRight:setFrame(1)
	end
end
function frozenPush.disactiveButton()
	if frozenPush.buttonLeft~=nil and frozenPush.buttonRight~=nil then
		frozenPush.buttonLeft:setFrame(2)
		frozenPush.buttonRight:setFrame(2)
		ice.alpha=0.5
	end
end

--Function to add some effect (maybe an ice theme around he ring)
function frozenPush.removeIce()
	ice.alpha=0
end

return frozenPush