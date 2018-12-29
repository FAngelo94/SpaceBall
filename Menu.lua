--Main Menu 
--this class implements the main menu with 2 option: play and option
local composer = require( "composer" )
local scene = composer.newScene()

--Require My Class
local database=require("Database")
local backbutton=require("navigationKeys.Backbutton")
local quitButton=require("graphicsElement.menu.QuitButton")

function goToPlay()
	composer.removeScene("Play")
	composer.gotoScene( "Play", { time=800, effect="crossFade" })
end

function goToSettings()
	composer.removeScene("Settings")
	composer.gotoScene( "Settings", { time=800, effect="crossFade" })
end

function goToRanking()
	composer.removeScene("Ranking")
	composer.gotoScene( "Ranking", { time=800, effect="crossFade" })
end

--function and variable for music
local music
function playMusic()
	database.tableDBSetup()
	for m in database.readMusic() do
		if(m.music==1)then
			audio.play(music, {channel=1, loops=-1}) 
		else
			audio.stop()
		end
	end
end

function showCredit()
	native.showAlert("Credits", "Developed by\nFalci Angelo and Grasso Luca", {"Ok"})
end

local play
local settings
-- create()
function scene:create( event )

    local sceneGroup = self.view
	menuGroup=display.newGroup()
	sceneGroup:insert(menuGroup)
	music=audio.loadStream("music/1.wav")
	
	--disable backbutton
	backbutton.disable()
	
	local path="img/menu/"
	background=display.newImageRect(menuGroup, path.."title.png",1280,720)
	background.x=display.contentCenterX
	background.y=display.contentCenterY
	quitButton.create(menuGroup)
	play=display.newImageRect(menuGroup, path.."play.png",280,90)
	play.x=display.contentCenterX
	play.y=display.contentCenterY+10
	play:addEventListener( "tap", goToPlay)
	settings=display.newImageRect(menuGroup, path.."settings.png",300,60)
	settings.x=display.contentCenterX
	settings.y=display.contentCenterY+120
	settings:addEventListener( "tap", goToSettings)
	ranking=display.newImageRect(menuGroup, path.."ranking.png",300,60)
	ranking.x=display.contentCenterX
	ranking.y=settings.y+100
	ranking:addEventListener("tap", goToRanking)
	--Credits
	credits=display.newImageRect(menuGroup, path.."credits.png",250,50)
	credits.x=display.contentWidth-20
	credits.y=display.contentHeight-40
	credits:addEventListener("tap", showCredit)
end


function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
		playMusic()
    end
end


function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
		display.remove(menuGroup)
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