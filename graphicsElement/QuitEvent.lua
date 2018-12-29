--Quit from level
--This class manages the stop/resume during the game
local quitEvent={}
local path="img/gameComponents/"

--public varibles
local backButton
local composer

function quitEvent.create(group, comp)
	composer=comp
	backButton=display.newImageRect(group, path.."goBack.png",70,70)
	backButton.x=display.contentWidth
	backButton.y=50
	backButton:addEventListener("touch", quitEvent.goBack)
end

function quitEvent.goBack()
	composer.removeScene("secondaryScreen.ChristmasMenu")
	composer.gotoScene("secondaryScreen.ChristmasMenu")
end

return quitEvent