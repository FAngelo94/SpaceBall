--Corner Arrow
--Draw the Arrow in the corner that indicate the gravity 
local cornerArrow={}
--Arrow Corner
local arrowBotLeft
local arrowBotRight
local arrowTopRight
local arrowTopLeft

function cornerArrow.create(group)
	local pathArrow="img/gameComponents/cornerArrow.png"
	arrowBotLeft=display.newImageRect(group, pathArrow, 100,100)
	arrowBotLeft.rotation=-45
	arrowBotLeft.x=display.contentCenterX-180
	arrowBotLeft.y=display.contentCenterY+180
	arrowBotLeft.alpha=0
	arrowBotRight=display.newImageRect(group, pathArrow, 100,100)
	arrowBotRight.rotation=-132
	arrowBotRight.x=display.contentCenterX+180
	arrowBotRight.y=display.contentCenterY+180
	arrowBotRight.alpha=0
	arrowTopRight=display.newImageRect(group, pathArrow, 100,100)
	arrowTopRight.rotation=135
	arrowTopRight.x=display.contentCenterX+180
	arrowTopRight.y=display.contentCenterY-180
	arrowTopRight.alpha=0
	arrowTopLeft=display.newImageRect(group, pathArrow, 100,100)
	arrowTopLeft.rotation=45
	arrowTopLeft.x=display.contentCenterX-180
	arrowTopLeft.y=display.contentCenterY-180
	arrowTopLeft.alpha=0
end

--Change visibility of Arrow 
function cornerArrow.show(position)
	--1=Left-Bot corner, 2=Right-Bot corner ecc..
	cornerArrow.setInvisible()
	if(position==1)then
		arrowBotLeft.alpha=1
	elseif(position==2)then
		arrowBotRight.alpha=1
	elseif(position==3)then
		arrowTopRight.alpha=1
	elseif(position==4)then
		arrowTopLeft.alpha=1
	end
end

--Set invisible corner
function cornerArrow.setInvisible()
	arrowBotLeft.alpha=0
	arrowBotRight.alpha=0
	arrowTopRight.alpha=0
	arrowTopLeft.alpha=0
end

return cornerArrow