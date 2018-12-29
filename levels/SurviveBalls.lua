local composer = require( "composer" )
local scene = composer.newScene()
--setup All require variables
local pathGraphics="graphicsElement."
local myMath=require("myLibrary.myMath")
local ringG=require(pathGraphics.."Ring")
local pathLogic="logicElement."
local player=require(pathLogic.."Player")
local ball=require(pathLogic.."Ball")
local invincibleEnemy=require(pathLogic.."InvincibleEnemy")
--Require My Class for pause
local pause=require(pathGraphics.."Pause")
--Require My Class for Count Balls
local textMessage=require(pathGraphics.."surviveMode.TextMessage")

--The speed of the player
local speedStart=30
local increment=10
local maxSpeed=50
--Background to manage touch events
local background
--Count the balls in the ring
local countBalls

--Combine graphics and logic elements to create the game
function createGraphicsAndLogic(groupGraph)
	--create big background to touch event for player
	background=display.newRect(display.contentCenterX, display.contentCenterY, 2000, display.contentHeight)
	background:setFillColor( 000000 )
	background:toBack()
	ringG.create(groupGraph, scene)
	--Setup Game Logic
	ball.setup(scene, ringG.getRing())
	player.setup(groupGraph, scene, ball, ringG)
	invincibleEnemy.setup(groupGraph, scene, ball, ringG, 100)
	textMessage.create(groupGraph)
end
	
function setup(groupGraph, comp)
	scene.world=1
	composer=comp
	countBalls=0
	--GAME PROPRIETIES
	scene.speed=0
	--The speed of the Ball
	scene.maxBallVelocity=300
	scene.minBallVelocity=150
	--Bounce of ball, how modify the speed of ball when the they hit something
	scene.bounceBall=1
	--Bounce of ships
	scene.bounceShip=1.3
	--Bounce of the spawnballs
	scene.bounceSpawn=1
	--How often the balls spawn
	scene.ballTimeMin=1000
	scene.ballTimeMax=1000
	scene.maxBalls=1000
	--Start points
	scene.playerPoints=1
	scene.enemyPoints=0
	--Create graphics, logic and timer
	createGraphicsAndLogic(groupGraph)
	timer.performWithDelay(1000,createTimers,1)
end

--Two functions to manage eventListener
function setupListener()
	--addEventListener
	background:addEventListener("touch", player.touchDisplay)
	Runtime:addEventListener( "collision", onCollision )
end
function removeListener()
	background:removeEventListener("touch", player.touchDisplay)
	Runtime:removeEventListener( "collision", onCollision )
end

--This function check if the game is end
function isGameEnd()
	local playerPoints=player.getPoints()
	if playerPoints==0 then
		local options =
		{
			params = {
				level = "surviveBalls",
				balls=countBalls,
			}
		}
		composer.removeScene("The End.TheEndSurvive")
		composer.gotoScene("The End.TheEndSurvive", options)
	end
end

--With this function I create all timers need in the game
--Save all timer will be created
local timersTable={}
function createTimers()
	local t1=timer.performWithDelay(100, spawnBall, 0)
	table.insert(timersTable,t1)
	t1=timer.performWithDelay(1000, ball.deleteOutBalls, 0)
	table.insert(timersTable,t1)
	t1=timer.performWithDelay(20,player.checkBallsOut,0)
	table.insert(timersTable,t1)
	t1=timer.performWithDelay(20,invincibleEnemy.managePoints,0)
	table.insert(timersTable,t1)
	t1=timer.performWithDelay(50,isGameEnd,0)
	table.insert(timersTable, t1)
	timer.performWithDelay(2000, pause.create(scene), 1)
end

--Create one ball and increment the points
function spawnBall()
	if ball.spawnBall() then
		countBalls=countBalls+1
		textMessage.write(countBalls)
	end
end

--The speed of player's ship start with a low value and then it increases
function scene.startMove()
	scene.speed=speedStart
end

--increment the instant speed of the player
function scene.increment()
	if scene.speed<maxSpeed then
		scene.speed=scene.speed+increment
	end
end

--Functions to Stop and Resume the level
function scene.pause()
	physics.pause()
	cancelTimers()
	removeListener()
end
function scene.resume()
	physics.start()
	createTimers()
	setupListener()
end

--return player Points
function scene.getPlayerPoints()
	return player.getPoints()
end

function scene.goBackToPlay()
	composer.removeScene("Play")
	composer.gotoScene( "Play")
end

--Delete and Clear everything
function cancelTimers()
	for i=#timersTable, 1, -1 do
		timer.cancel(timersTable[i])
	end
	player.removeTimer()
end

function removeGraphics()
	ball.removeAllBalls()
	pause.destroy()
end

--MANAGE SOUND
local database=require("Database")
--Variables and functions to manage the music and sound
local soundBall
local soundIsActive --read database and save here what player chose
function setupSound()
	soundBall=audio.loadSound("sound/3.wav")
	for s in database.readSound() do
		if s.sound==1 then
			soundIsActive=true
		else
			soundIsActive=false
		end
	end
end
--Play sound of kick when the ball hit something
function onCollision(event)
	if event.phase=="began" and soundIsActive then
		audio.play(soundBall)
	end
end

function scene:create( event )
    local sceneGroup = self.view
	groupGraph=display.newGroup()
	sceneGroup:insert(groupGraph)
	physics.pause()
	setupSound()
	setup(groupGraph, composer)
	setupListener()
end

--MANAGE SCREEN
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
		physics.start()
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
    end
end


function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
		--I delete all timer
		physics.pause()
		removeListener()
		display.remove(background)
		cancelTimers()
		removeGraphics()
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
		display.remove(groupGraph)
    end
end


function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
	audio.dispose(sound)
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