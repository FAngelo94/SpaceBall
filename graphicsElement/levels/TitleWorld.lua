--Title World
--Create the title of the world in every levels page
local titleWorld={}

function titleWorld.create(group, world)
	local path="img/play/world "..world..".png"
	local title=display.newImageRect(group, path, 300,80)
	title.x=display.contentCenterX
	title.y=0
	title.anchorY=0
end

return titleWorld