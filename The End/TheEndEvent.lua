--The End
--Go to this scene when a math in some Event (like Christmas) is finished
--The page when then return the player is always the first page on the Player
local composer = require( "composer")
local database=require("Database")
local scene = composer.newScene()
local path="img/"

--I put all grapics elements of this scene in the same group and it will be deleted when  the scene change
local groupGraphicsElements
local backgroundEnd
local levelFinished

--Functions to print the right number of star
function printOneStar()
	local star=display.newImageRect(groupGraphicsElements, path.."star.png", 150, 150)
	star.x=display.contentCenterX
	star.y=500
end
function printTwoStars()
	local star=display.newImageRect(groupGraphicsElements, path.."star.png", 150, 150)
	star.anchorX=1
	star.x=display.contentCenterX
	star.y=500
	star=display.newImageRect(groupGraphicsElements, path.."star.png", 150, 150)
	star.anchorX=0
	star.x=display.contentCenterX
	star.y=500
end
function printThreeStars()
	local star=display.newImageRect(groupGraphicsElements, path.."star.png", 150, 150)
	star.x=display.contentCenterX
	star.y=500
	star=display.newImageRect(groupGraphicsElements, path.."star.png", 150, 150)
	star.x=display.contentCenterX+150
	star.y=500
	star=display.newImageRect(groupGraphicsElements, path.."star.png", 150, 150)
	star.x=display.contentCenterX-150
	star.y=500
end

--At the end of the game the background change, depend of the world
function setupBackground()
	local path="img/gameComponents/background christmas.png"
	backgroundEnd=display.newImageRect(groupGraphicsElements, path, 1280, 720)
	backgroundEnd.x=display.contentCenterX
	backgroundEnd.y=display.contentCenterY
	backgroundEnd:toFront()
end

--Go back to main Menu
function goToLevels()	
		composer.removeScene("secondaryScreen.ChristmasMenu")
		composer.gotoScene("secondaryScreen.ChristmasMenu")
end

--I add the event listener after a few second so the player can see well his points
--in the end of the game
function addListenerGoToLevels()
	backgroundEnd:addEventListener("tap", goToLevels)
end

--Check if the player has enought star to unlock a new ship
function checkNewShipAvailable(nameEvent)
	if database.countStarsEvent(nameEvent)>20 then
		database.addNewShipAvailable(2);
		native.showAlert("New Ship!!!", "You unlock a new ship, ho to the option to change the ship", {"Ok"})
	end
end

-- create()
function scene:create( event )
    local sceneGroup = self.view
	local params=event.params
	levelFinished=params.level
	nameEvent=params.nameEvent
	print(levelFinished)
	local goal=params.goal
	groupGraphicsElements=display.newGroup()
	sceneGroup:insert(groupGraphicsElements)
	setupBackground()
	display.newText(groupGraphicsElements, "Level "..levelFinished, display.contentCenterX, 100, native.systemFont, 100)
	display.newText(groupGraphicsElements, "Your points: "..goal, display.contentCenterX, 300, native.systemFont, 100)
	if goal>=8 then
		printThreeStars()
		database.insertEventResult(levelFinished, 3, nameEvent)
	elseif goal<=7 and goal>4 then
		printTwoStars()
		database.insertEventResult(levelFinished, 2, nameEvent)
	elseif goal>0 then
		printOneStar()
		database.insertEventResult(levelFinished, 1, nameEvent)
	else
		display.newText(groupGraphicsElements, "Fail!", display.contentCenterX, 500, native.systemFont, 100)
	end
	checkNewShipAvailable(nameEvent)
end


function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
		timer.performWithDelay(2000, addListenerGoToLevels, 1)
    end
end


function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
		display.remove(groupGraphicsElements)
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