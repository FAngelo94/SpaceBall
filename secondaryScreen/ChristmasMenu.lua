--Play
--When player click play in main menu this class implements every levels present in the game
local composer = require( "composer" )
local scene = composer.newScene()
local sceneGroup
--Require My Class
local database=require("Database")
local myMath=require("myLibrary.myMath")
local menuButton=require("graphicsElement.MenuButton")
local levelsBackground=require("graphicsElement.levels.LevelsBackground")
local storyAndTutorial=require("graphicsElement.levels.StoryAndTutorial")
local energyLabel=require("graphicsElement.levels.EnergyLabel")

local path="img/play/"

local page --Save the page where is the player (15 levels for page)
local maxPage=7 --How many page there are in the game
local dimensionArrowPage=70 --save the dimension of arrow to change page

--Put all levels in this group so I remove only this group to clean the display when player select level
local levelsGroup 	--put only the levels select
local otherGroup	--put all other things

--Levels Image
local sheetLevel=
{
	frames=
	{
		{
			x=0,
			y=0,
			width=120,
			height=150
		},
		{
			x=120,
			y=0,
			width=120,
			height=150
		},
		{
			x=240,
			y=0,
			width=120,
			height=150,
		},
		{
			x=360,
			y=0,
			width=120,
			height=150,
		},
		{
			x=480,
			y=0,
			width=120,
			height=150,
		},
	}
}
local levelImage=graphics.newImageSheet(path.."level.png", sheetLevel)
local levelsTable={}

local energyAvailable
 
--Print the title of the world
function printTitle()
	local path="img/play/christmas.png"
	local title=display.newImageRect(sceneGroup, path, 300,80)
	title.x=display.contentCenterX
	title.y=0
	title.anchorY=0
end

--Print story and tutorial buttons
function printStoryAndTutorial()
	storyAndTutorial.create(levelsGroup, "christmas")
end

--Functions to manage the energy
function setupEnergy()
	database.setEnergyToPlay()
	energyAvailable=database.getEnergyAvailable()
	energyLabel.setEnergy(energyAvailable)
	if energyAvailable<10 then
		local timeEnergy=database.getTimeRemainForNextEnergy()
		if(timeEnergy>60)then
			if(myMath.restOfDivision(timeEnergy, 60)>=10)then
				timeEnergy=string.format("%.0i",(timeEnergy/60))..":"..myMath.restOfDivision(timeEnergy, 60)
			else
				timeEnergy=string.format("%.0i",(timeEnergy/60))..":0"..myMath.restOfDivision(timeEnergy, 60)
			end
		else
			timeEnergy="0:"..timeEnergy
		end
		energyLabel.setTimer(timeEnergy)
	else
		energyLabel.setTimer("")
	end
end

--Every levels implements this function to go to the some specific level
function goToGame(event)
	if storyAndTutorial.readStoryOrTutorial()==false  and energyAvailable>0 then
		database.decrementEnergyToPlay()
		local x=event.x
		local y=event.y
		local level
		local i=1
		while i<=15 do
			local levelX=124+120*myMath.restOfDivision(i-1,5)+50*myMath.restOfDivision(i-1,5)
			local levelY=80+(myMath.integerDivision(i-1,5))*200
			if x>=levelX and x<=levelX+120 and y>=levelY and y<=levelY+150 then
				level=i
				local options =
				{
					params = {
						level = i
					}
				}
				composer.removeScene("levels.Christmas")
				composer.gotoScene("levels.Christmas", options)
			end
			i=i+1
		end
	elseif energyAvailable==0 then
		native.showAlert("Error", "You don't have energy!", {"Ok"})
	end
end

--Print all levels avaiable in one page
function printLevels()
	database.tableDBSetup()
	local i=1
	local sequenceOption={start=1, count=5}
	for a in database.readLevelResultsInEvent("christmas") do
		local newLevel=display.newSprite(levelsGroup, levelImage,sequenceOption)
		newLevel.anchorX=0
		newLevel.anchorY=0
		newLevel.y=80+(myMath.integerDivision(i-1,5))*200
		newLevel.x=124+120*myMath.restOfDivision(i-1,5)+50*myMath.restOfDivision(i-1,5)
		newLevel:setFrame(1+a.stars)
		local number=display.newText(levelsGroup, i, newLevel.x+newLevel.width/2, newLevel.y+50,native.systemFont, 70 )
		number:setFillColor(0.3, 0.3, 0.3)
		newLevel:addEventListener("tap",goToGame)
		i=i+1
	end
	local justOne=true --the player can play to one level if he has at least 1 stars in the previous levels
	while (i<=15) do
		local newLevel=display.newSprite(levelsGroup, levelImage,sequenceOption)
		newLevel.anchorX=0
		newLevel.anchorY=0
		newLevel.y=80+(myMath.integerDivision(i-1,5))*200
		newLevel.x=124+120*myMath.restOfDivision(i-1,5)+50*myMath.restOfDivision(i-1,5)
		newLevel:setFrame(5)
		if justOne==true then
			local number=display.newText(levelsGroup, i, newLevel.x+newLevel.width/2, newLevel.y+50,native.systemFont, 70 )
			number:setFillColor(0.3, 0.3, 0.3)
			newLevel:addEventListener("tap",goToGame)
			justOne=false
			newLevel:setFrame(1)
		end
		i=i+1
	end
end

--Function to go back to menu
function goToMenu()
	composer.removeScene("Menu")
	composer.gotoScene("Menu")
end

--Function to go back to play menu
function goToLevels()
	composer.removeScene("Play")
	composer.gotoScene("Play")
end

-- create()
function scene:create( event )
    sceneGroup = self.view
	otherGroup=display.newGroup()
	sceneGroup:insert(otherGroup)
	levelsGroup=display.newGroup()
	sceneGroup:insert(levelsGroup)
	--Setup background
	levelsBackground.create(otherGroup)
	--Setup other graphics elements
	printLevels()
	printTitle()
	printStoryAndTutorial()
	menuButton.create(composer, otherGroup)
	energyLabel.create(otherGroup)
	setupEnergy()
	
	--put the button to go back
	local levelsPage=display.newImageRect(sceneGroup, path.."previousPage.png", 70, 70)
	levelsPage.x=0
	levelsPage.y=display.contentCenterY
	levelsPage:addEventListener("tap", goToLevels)
end


function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
		timerEnergy=timer.performWithDelay(1000,setupEnergy, 0)
    end
end


function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel(timerEnergy)
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
		display.remove(levelsGroup)
		display.remove(otherGroup)
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