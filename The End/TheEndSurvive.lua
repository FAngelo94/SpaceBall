--The End
--Go to this scene when a math is finish
local composer = require( "composer" )
local scene = composer.newScene()
local path="img/"
--Require My Class
local database=require("Database")

--public variables
--I put all grapics elements of this scene in the same group and it will be deleted when  the scene change
local groupGraphicsElements
local backgroundEnd

--At the end of the game the background change, depend of the world
function setupBackground()
	local path="img/play/surviveBackground.png"
	backgroundEnd=display.newImageRect(groupGraphicsElements, path, 1280, 720)
	backgroundEnd.x=display.contentCenterX
	backgroundEnd.y=display.contentCenterY
	backgroundEnd:toFront()
end

--Go back to main Menu
function goToAdvancedModalityMenu()
	composer.removeScene("secondaryScreen.AdvancedModalityMenu")
	composer.gotoScene("secondaryScreen.AdvancedModalityMenu")
end

--Functions to print the result (depend of the survive level finished) in the display
function printSurviveTime(timeResist)
	local firstRecord=true
	local score=timeResist
	local record=timeResist
	for row in database.readSurviveResult("timeResist") do
		firstRecord=false
		record=row.record
	end
	if firstRecord then
		--First time player did a record
		database.insertSurviveResult("timeResist", string.format("%.3f", timeResist))
	else
		if record<score then
			--player did a new record
			database.modifySurviveResult("timeResist", string.format("%.3f", score))
			record=score
		end
	end
	recordText.text="Time Resist"
	now.text="Record="..string.format("%.3f", record).."\nscore="..string.format("%.3f", score)
end
function printSurviveBalls(countBalls)
	local firstRecord=true
	local score=countBalls
	local record=countBalls
	for row in database.readSurviveResult("countBalls") do
		firstRecord=false
		record=row.record
	end
	if firstRecord then
		--First time player did a record
		database.insertSurviveResult("countBalls", countBalls)
	else
		if record<score then
			--player did a new record
			database.modifySurviveResult("countBalls", score)
			record=score
		end
	end
	recordText.text="Balls Resist"
	now.text="Record="..record.."\nscore="..score
end

--I add the event listener after a few second so the player can see well his points
--in the end of the game
function addListenerGoToLevels()
	backgroundEnd:addEventListener("tap", goToAdvancedModalityMenu)
end

-- create()
function scene:create( event )
    local sceneGroup = self.view
	local params=event.params
	local levelFinished=params.level
	groupGraphicsElements=display.newGroup()
	sceneGroup:insert(groupGraphicsElements)
	setupBackground()
	--Show text
	recordText=display.newText(groupGraphicsElements, "", display.contentCenterX, 100, native.systemFont, 100)
	now=display.newText(groupGraphicsElements, "", display.contentCenterX, 300, native.systemFont, 100)
	--Read wich type of survive game player done
	if params.level=="surviveTime" then
		printSurviveTime(params.timer)
	elseif params.level=="surviveBalls" then
		printSurviveBalls(params.balls)
	end
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