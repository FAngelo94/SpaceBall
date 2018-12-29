--Setting
--In this class player can modify some options in the game
local composer = require( "composer" )
local scene = composer.newScene()
local settingGroup

--Require My Class
local database=require("Database")
local menuButton=require("graphicsElement.MenuButton")
local levelsBackground=require("graphicsElement.levels.LevelsBackground")
local selectShip=require("graphicsElement.settings.SelectShip")

local path="img/settingComponents/"

--Buttons, their position give me the chosen of the player
local musicButton
local soundButton

function setupSettings()
	for m in database.readMusic() do
		if m.music==1 then
			setupMusic("on")
		else
			setupMusic("off")
		end
	end
	for m in database.readSound() do
		if m.sound==1 then
			setupSound("on")
		else
			setupSound("off")
		end
	end
end
--Functions to setup music and sound buttons
function setupMusic(state)
	music=display.newText(settingGroup, "Music", 0, 50,native.systemFont, 70 )
	music.anchorX=0
	musicOnOff=display.newImageRect(settingGroup, path.."on-off.png", 200, 50)
	musicOnOff.x=400
	musicOnOff.y=50
	musicButton=display.newImageRect(settingGroup, path.."on-off-button.png", 100, 50)
	musicButton.y=50
	if state=="on" then
		musicButton.x=450
	else
		musicButton.x=350
	end
	musicButton:addEventListener("tap", changeMusic)
end
function setupSound(state)
	sound=display.newText(settingGroup, "Sound", 0, 150,native.systemFont, 70 )
	sound.anchorX=0
	soundOnOff=display.newImageRect(settingGroup, path.."on-off.png", 200, 50)
	soundOnOff.x=400
	soundOnOff.y=150
	soundButton=display.newImageRect(settingGroup, path.."on-off-button.png", 100, 50)
	soundButton.y=150
	if state=="on" then
		soundButton.x=450
	else
		soundButton.x=350
	end
	soundButton:addEventListener("tap", changeSound)
end
--Functions to active or disable music and sound
function changeMusic()
	if musicButton.x==450 then
		transition.to(musicButton,{x=350, time=500})
	else
		transition.to(musicButton,{x=450, time=500})
	end
end
function changeSound()
	if soundButton.x==450 then
		transition.to(soundButton,{x=350, time=500})
	else
		transition.to(soundButton,{x=450, time=500})
	end
end

function goToMenu()
	--Before to go in menu I modify the database
	if musicButton.x==450 then
		database.musicOn()
	else
		database.musicOff()
	end
	if soundButton.x==450 then
		database.soundOn()
	else
		database.soundOff()
	end
	--Now I can change view
	composer.removeScene("Menu")
	composer.gotoScene("Menu")
end

-- create()
function scene:create( event )
    local sceneGroup = self.view
	settingGroup=display.newGroup()
	sceneGroup:insert(settingGroup)
	--Add background
	levelsBackground.create(settingGroup)
	--Setup other information
	menuButton.create(composer, settingGroup)
	setupSettings()
	selectShip.setup(settingGroup)
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
		display.remove(settingGroup)
		selectShip.destroyScroll()
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