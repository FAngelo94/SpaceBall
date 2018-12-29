--Button to go to Advanced Modality
--Create the button in the levels screen to go to the advanced mode
local buttonAdvance={}
local database=require("Database")

local path="img/play/"
local dimensionArrowPage=70
local composer
local storyAndTutorial

function goToAdvancedMenu()
	if storyAndTutorial.readStoryOrTutorial()==false then
		composer.removeScene("secondaryScreen.AdvancedModalityMenu")
		composer.gotoScene("secondaryScreen.AdvancedModalityMenu")
	end
end

function gameNotFinished()
	native.showAlert("Warning!", "You must complete the game and beat the last champion to unlock Advanced Mode", {"ok"})
end

function buttonAdvance.create(group, comp, story)
	composer=comp
	storyAndTutorial=story
	local button=display.newImageRect(group, path.."buttonAdvancedModality.png", dimensionArrowPage, dimensionArrowPage)
	button.x=display.contentWidth
	button.y=display.contentCenterY
	if database.finishGame() then
		button:addEventListener("tap", goToAdvancedMenu)
	else
		button:addEventListener("tap", gameNotFinished)
	end
end

return buttonAdvance