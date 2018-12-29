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
--Require My Class for Time
local textMessage=require(pathGraphics.."surviveMode.TextMessage")

--The speed of the player
local speedStart=30
local increment=10
local maxSpeed=50
--the speed of the enemies
local speedStartEnemy
local incrementEnemy
local maxEnemySpeed
--Background to manage touch events
local background
--Save how much time the player resist
local timeResist
local timeStart

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
	composer=comp
	firstIncrementTimer=true
	scene.world=1
	--Time variables
	timeResist=0
	--GAME PROPRIETIES
	speedStartEnemy=50
	incrementEnemy=50
	maxEnemySpeed=500
	scene.speed=0
	--The speed of the Ball
	scene.maxBallVelocity=500
	scene.minBallVelocity=300
	--Bounce of ball, how modify the speed of ball when the they hit something
	scene.bounceBall=1
	--Bounce of ships
	scene.bounceShip=1.3
	--Bounce of the spawnballs
	scene.bounceSpawn=1
	--How often the balls spawn
	scene.ballTimeMin=2000
	scene.ballTimeMax=3000
	scene.maxBalls=1
	--Enemy speed
	scene.topSpeed=speedStartEnemy
	scene.leftSpeed=speedStartEnemy
	scene.rightSpeed=speedStartEnemy
	--How far the ball is when enemy follow it
	scene.distanceBallAction=600
	--Start points
	scene.playerPoints=1
	scene.enemyPoints=999
	--How give the star
	scene.limitOneStar=10
	scene.limitTwoStars=19
	scene.limitThreeStars=20
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
	if playerPoints==0 or invincibleEnemy.finishGame() or ball.countBall()<=0 then
		local options =
		{
			params = {
				level = "surviveTime",
				timer= timeResist,
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
	ball.spawnBall()
	t1=timer.performWithDelay(100, ball.deleteOutBalls, 0)
	table.insert(timersTable,t1)
	t1=timer.performWithDelay(1, invincibleEnemy.manageEnemies, 0)
	table.insert(timersTable,t1)
	t1=timer.performWithDelay(20,player.checkBallsOut,0)
	table.insert(timersTable,t1)
	t1=timer.performWithDelay(20,invincibleEnemy.managePoints,0)
	table.insert(timersTable,t1)
	t1=timer.performWithDelay(20,isGameEnd,0)
	table.insert(timersTable, t1)
	timeStart=0
	t1=timer.performWithDelay(20,incrementTimeResist,0)
	table.insert(timersTable, t1)
end

--Increment Time Variable
function incrementTimeResist(event)
	--event.time give me the time since the app start to run (I don't know why)
	if timeStart==0 then
		timeStart=event.time
	end
	timeResist=(event.time-timeStart)/1000
	textMessage.write(string.format("%.3f", timeResist))
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

--The speed of enemies's ship start with a low value and then it increases
function scene.startMoveEnemy(enemy)
	if enemy=="top" then
		scene.topSpeed=speedStartEnemy
	elseif enemy=="left" then
		scene.leftSpeed=speedStartEnemy
	elseif enemy=="right" then
		scene.rightSpeed=speedStartEnemy
	end
end

--increment the instant speed of some enemy
function scene.incrementEnemy(enemy)
	if enemy=="top" then
		if scene.topSpeed<maxEnemySpeed then
			scene.topSpeed=scene.topSpeed+incrementEnemy
		end
	elseif enemy=="left" then 
		if scene.leftSpeed<maxEnemySpeed then
			scene.leftSpeed=scene.leftSpeed+incrementEnemy
		end
	elseif enemy=="right" then
		if scene.rightSpeed<maxEnemySpeed then
			scene.rightSpeed=scene.rightSpeed+incrementEnemy
		end
	end
end

--return player Points
function scene.getPlayerPoints()
	return player.getPoints()
end

function scene.goBackToPlay()
	composer.removeScene("Play")
	composer.gotoScene( "Play", { time=800, effect="crossFade" })
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