--Ranking
--This class manage the internet ranking
local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()
local sceneGroup

--Require My Class
local database=require("Database")
local menuButton=require("graphicsElement.MenuButton")
local levelsBackground=require("graphicsElement.levels.LevelsBackground")
local networkRanking=require("network.RankingNetwork")

--Global variables
local variableGroup
local setName
local textName

--This function draw all common graphics
function drawGraphics()
	setName=display.newImageRect(rankingGroup, "img/ranking/setName.png", 300,80)
	setName.x=display.contentWidth-100
	setName.y=40
	textName=native.newTextField(display.contentWidth-100, 110, 280, 50 )
	--Scroll for world and surviver select
	scrollMode = widget.newScrollView(
		{
			top = 150,
			left = display.contentWidth-250,
			width = 300,
			height = 480,
			scrollHeight = 800,
			hideBackground=true,
			horizontalScrollDisabled=true
		}
	)
	--Add voices in the ScrollView
	local mode=display.newImageRect(rankingGroup, "img/ranking/starWriter.png", 300, 80)
	mode.x=0
	mode.y=0
	mode.anchorX=0
	mode.anchorY=0
	mode:addEventListener("tap", readRankingStars)
	scrollMode:insert(mode)
	local mode=display.newImageRect(rankingGroup, "img/play/time.png", 300, 80)
	mode.x=0
	mode.y=80
	mode.anchorX=0
	mode.anchorY=0
	mode:addEventListener("tap", readRankingSurviveTime)
	scrollMode:insert(mode)
	local mode=display.newImageRect(rankingGroup, "img/play/balls.png", 300, 80)
	mode.x=0
	mode.y=160
	mode.anchorX=0
	mode.anchorY=0
	mode:addEventListener("tap", readRankingSurviveBalls)
	scrollMode:insert(mode)
	--question point
	local questionPoint=display.newImageRect(rankingGroup, "img/ranking/questionPoint.png", 100,100)
	questionPoint.x=-40
	questionPoint.y=50
	questionPoint:addEventListener("tap", showHelp)
	--Draw Left and Right Scroll
	--Scroll for Left Column
	scrollLeft = widget.newScrollView(
		{
			top = 200,
			left = -50,
			width = 350,
			height = 500,
			scrollHeight = 800,
			hideBackground=true,
			horizontalScrollDisabled=true
		}
	)
	--Scroll for Right Column
	scrollRight = widget.newScrollView(
		{
			top = 200,
			left = 400,
			width = 350,
			height = 500,
			scrollHeight = 800,
			hideBackground=true,
			horizontalScrollDisabled=true
		}
	)
end

--This function show a short information about online ranking work
function showHelp()
	local help="To see online ranking you must insert an username and press Set Name.\n"
	help=help.."Then you can choose which ranking you want to see, Stars, Time or Balls."
	native.showAlert("Info", help, {"Ok"})
end

--Check if the player chose or not a username
function checkUser()
	local name=database.readUser()
	if name=="" then
		setName:addEventListener("tap", insertUser)
	else
		textName.text=name
		setName:addEventListener("tap", modifyUser)
	end
end

--FUNTIONS TO MANAGE INSERTION USERNAME FOR FIRST TIME
function insertUser()
	username=textName.text
	networkRanking.insertUsername(username, scene)
end
function scene.insertUserResponse(networkEvent)
	response=networkEvent.response
	local title
	if(response=="ok")then
		database.writeUser(username)
		response="Name Confirmed!"
		title="Ok"
		checkUser()
	elseif networkEvent.isError then
		response="No Internet! Check you connection"
		title="error"
	end
	native.showAlert(title, response, {"Ok"})
end

--FUNCTIONS TO MANAGE MODIFICATION USERNAME
function modifyUser()
	username=textName.text
	oldUser=database.readUser()
	if username~=oldUser then
		networkRanking.modifyUsername(oldUser, username, scene)
	else
		native.showAlert("Error", "You can't insert the same Username", {"Ok"})
	end
end
function scene.modifyUserResponse(networkEvent)
	response=networkEvent.response
	if(response=="ok")then
		database.writeUser(username)
		response="Name Changed!"
	elseif networkEvent.isError then
		response="No Internet! Check you connection"
	end
	native.showAlert("Error", response, {"Ok"})
end

--FUNCTIONS TO MANAGE READING RANKING ONLINE
--With this functions I send the player statistics and then I read the online ranking
function scene.rankingResponse(networkEvent)
	display.remove(scrollLeft)
	display.remove(scrollRight)
	display.remove(variableGroup)
	variableGroup=display.newGroup()
	sceneGroup:insert(variableGroup)
	local response=networkEvent.response
	local first=display.newImageRect(variableGroup, "img/ranking/first.png", 100, 100)
	first.x=400
	first.y=60
	local indexFirst=string.find(response, "£", 1)
	local optionText= {
		parent=variableGroup,
		text = string.sub(response,0,indexFirst-1),
		x = 400,
		y = 120,
		font=native.systemFont,
		fontSize = 35,
		align = "center"
	}
	local firstText=display.newText(optionText)
	local second=display.newImageRect(variableGroup, "img/ranking/second.png", 100, 100)
	second.x=150
	second.y=100
	local indexSecond=string.find(response, "£", indexFirst+1)
	local optionText= {
		parent=variableGroup,
		text = string.sub(response,indexFirst+2,indexSecond-1),
		x = 150,
		y = 160,
		font=native.systemFont,
		fontSize = 35,
		align = "center"
	}
	local secondText=display.newText(optionText)
	local third=display.newImageRect(variableGroup, "img/ranking/third.png", 100, 100)
	third.x=650
	third.y=100
	local indexThird=string.find(response, "£", indexSecond+1)
	local optionText= {
		parent=variableGroup,
		text = string.sub(response,indexSecond+2,indexThird-1),
		x = 650,
		y = 160,
		font=native.systemFont,
		fontSize = 35,
		align = "center"
	}
	local thirdText=display.newText(optionText)
	--Now I create 2 column with first 15-3 in the left and player position in the right
	--Scroll for Left Column
	scrollLeft = widget.newScrollView(
		{
			top = 200,
			left = -50,
			width = 350,
			height = 500,
			scrollHeight = 800,
			hideBackground=true
		}
	)
	local indexLeftColumn=string.find(response, "£", indexThird+1)
	local leftColumn=display.newText(variableGroup, string.sub(response,indexThird+2,indexLeftColumn-1), 0, 0, native.systemFont, 35)
	leftColumn.anchorX=0
	leftColumn.anchorY=0
	scrollLeft:insert(leftColumn)
	--Scroll for Right Column
	scrollRight = widget.newScrollView(
		{
			top = 200,
			left = 400,
			width = 350,
			height = 500,
			scrollHeight = 800,
			hideBackground=true
		}
	)
	local rightColumn=display.newText(variableGroup, string.sub(response,indexLeftColumn+2), 0, 0, native.systemFont, 35)
	rightColumn.anchorX=0
	rightColumn.anchorY=0
	scrollRight:insert(rightColumn)
end
function readRankingStars()
	local user=database.readUser()
	local score=database.countStars()
	if user~="" then
		networkRanking.readStarsRanking(user, score, scene)
	else
		native.showAlert("Error", "You must chose the username before see online ranking", {"Ok"})
	end
end
function readRankingSurviveTime()
	local user=database.readUser()
	local hasScore=false
	for row in database.readSurviveResult("timeResist") do
		hasScore=true
		local score=row.record
		if user~="" then
			networkRanking.readSuriveTimeRanking(user, score, scene)
		else
			native.showAlert("Error", "You must chose the username before see online ranking", {"Ok"})
		end
	end
	if hasScore==false then
		native.showAlert("Error", "You must play this mode before see online ranking", {"Ok"})
	end
end
function readRankingSurviveBalls()
	local user=database.readUser()
	local hasScore=false
	for row in database.readSurviveResult("countBalls") do
		hasScore=true
		local score=row.record
		if user~="" then
			networkRanking.readSuriviveBallsRanking(user, score, scene)
		else
			native.showAlert("Error", "You must chose the username before see online ranking", {"Ok"})
		end
	end
	if hasScore==false then
		native.showAlert("Error", "You must play this mode before see online ranking", {"Ok"})
	end
end

-- create()
function scene:create( event )

    sceneGroup = self.view
	rankingGroup=display.newGroup()
	sceneGroup:insert(rankingGroup)
	variableGroup=display.newGroup()
	sceneGroup:insert(variableGroup)
	levelsBackground.create(rankingGroup)
end


function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
		drawGraphics()
		menuButton.create(composer, rankingGroup)
		checkUser()
    end
end


function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
		
		
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
		display.remove(rankingGroup)
		display.remove(variableGroup)
		display.remove(textName)
		display.remove(scrollMode)
		display.remove(scrollLeft)
		display.remove(scrollRight)
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