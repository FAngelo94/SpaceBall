--CountStars
--In this class read and print the amount of start the player win
local countStars={}
local database=require("Database")

function countStars.create(group)
	local starsCount=database.countStars()
	local stars=display.newImageRect(group, "img/star.png",80,80)
	stars.x=50
	stars.y=230
	local starsText=display.newText( group, starsCount, 10, 230,native.systemFont, 70 )
	starsText.anchorX=1
end

return countStars