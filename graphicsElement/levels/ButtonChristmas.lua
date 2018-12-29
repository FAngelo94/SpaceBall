--Button to go to in Christmas Event
--Create the button in the levels screen to go to the Christmas event
local buttonChristmas={}

local path="img/play/"
local dimensionArrowPage=70
local composer
local storyAndTutorial

function goToChristmasMode()
	if storyAndTutorial.readStoryOrTutorial()==false then
		composer.removeScene("secondaryScreen.ChristmasMenu")
		composer.gotoScene("secondaryScreen.ChristmasMenu")
	end
end

function buttonChristmas.create(group, comp, story)
	composer=comp
	storyAndTutorial=story
	local button=display.newImageRect(group, path.."buttonChristmas.png", dimensionArrowPage, dimensionArrowPage)
	button.x=display.contentWidth
	button.y=display.contentCenterY+150
	button:addEventListener("tap", goToChristmasMode)
end

return buttonChristmas