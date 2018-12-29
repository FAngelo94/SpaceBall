--physics
physics.start()
physics.setGravity(0,0)

local composer = require( "composer" )
local scene = composer.newScene()

--Require My Class
local database=require("Database")

--level
local level
--Components of the game
local path="logicElement."

--Save which level the player is playing
local selectedLevel

function readLevel(params)
	selectedLevel=params.level
	local options =
	{
		params = {
			level = selectedLevel
		}
	}
	composer.removeScene("levels.Level 1")
	composer.removeScene("levels.Level 16")
	composer.removeScene("levels.Level 31")
	composer.removeScene("levels.Level 46")
	composer.removeScene("levels.Level 61")
	composer.removeScene("levels.Level 76")
	composer.removeScene("levels.Level 91")
	composer.removeScene("levels.SurviveTime")
	composer.removeScene("levels.SurviveBalls")
	if selectedLevel>=1 and selectedLevel<=15 then
		composer.gotoScene("levels.Level 1", options)
	elseif selectedLevel>=16 and selectedLevel<=30 then
		composer.gotoScene("levels.Level 16", options)
	elseif selectedLevel>=31 and selectedLevel<=45 then
		composer.gotoScene("levels.Level 31", options)
	elseif selectedLevel>=46 and selectedLevel<=60 then
		composer.gotoScene("levels.Level 46", options)
	elseif selectedLevel>=61 and selectedLevel<=75 then
		composer.gotoScene("levels.Level 61", options)
	elseif selectedLevel>=76 and selectedLevel<=90 then
		composer.gotoScene("levels.Level 76", options)
	elseif selectedLevel>=91 and selectedLevel<=105 then
		composer.gotoScene("levels.Level 91", options)
	elseif selectedLevel==-1 then
		composer.gotoScene("levels.SurviveTime")
	elseif selectedLevel==-2 then
		composer.gotoScene("levels.SurviveBalls")
	end
end

-- create()
--I put a big background that catch touch of player everywhere
local background
function scene:create( event )
    local sceneGroup = self.view
	local params = event.params
	physics.pause()
	readLevel(params)
end

function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
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