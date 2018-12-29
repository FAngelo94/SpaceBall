--LevelsBackground
--In this class setup backgrund of levels
local levelsBackground={}

function levelsBackground.create(group)
	background=display.newImageRect(group, "img/play/surviveBackground.png",1280,720)
	background.x=display.contentCenterX
	background.y=display.contentCenterY
end

return levelsBackground