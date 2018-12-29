--Advanced Modality
--Manage all Advanced Menu
local composer = require( "composer" )
local scene = composer.newScene()

--Require My Class
local menuButton=require("graphicsElement.MenuButton")
local surviveBackground=require("graphicsElement.surviveMode.SurviveBackground")

local imageGroup

--Functions to go to other screen
function goToSurviveTime()
	local options =
	{
		params = {
			level = -1
		}
	}
	composer.removeScene("Game")
	composer.gotoScene("Game", options)
end
function goToSurviveBalls()
	local options =
	{
		params = {
			level = -2
		}
	}
	composer.removeScene("Game")
	composer.gotoScene("Game", options)
end
function goToLevels()
	composer.removeScene("Play")
	composer.gotoScene("Play")
end

--By this function setup the graphics
function setupButton()
	local path="img/play/"
	--Put background
	surviveBackground.create(imageGroup)
	--Put button
	local survive=display.newImageRect(imageGroup, path.."survive.png", 500, 150)
	survive.x=display.contentCenterX
	survive.y=85
	local times=display.newImageRect(imageGroup, path.."time.png", 300, 70)
	times.x=display.contentCenterX
	times.y=250
	times:addEventListener("tap", goToSurviveTime)
	local balls=display.newImageRect(imageGroup, path.."balls.png", 300, 70)
	balls.x=display.contentCenterX
	balls.y=370
	balls:addEventListener("tap", goToSurviveBalls)
	--put the button to go to menu
	menuButton.create(composer, imageGroup)
	--put the button to go back
	local levelsPage=display.newImageRect(imageGroup, path.."previousPage.png", 70, 70)
	levelsPage.x=0
	levelsPage.y=display.contentCenterY
	levelsPage:addEventListener("tap", goToLevels)
end

 -- create()
function scene:create( event )
    local sceneGroup = self.view
	imageGroup=display.newGroup()
	sceneGroup:insert(imageGroup)
end


function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
	
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
		setupButton()
    end
end


function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
		
    end
end


function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
	
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene