--In this world the ship enemy have a shield that permit them to push the ball
--with more energy than usually
--The speed become faster and faster in the 15 levels
local composer = require( "composer" )
local scene = composer.newScene()
local myMath=require("myLibrary.myMath")
local checkContinue=require("logicElement.CheckContinueGame")


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
--Real level selected from 1 to 15
local selectedLevel

--In this function do all require the game need
function setRequire()
	local pathGraphics="graphicsElement."
	pathLogic="logicElement."
	player=require(pathLogic.."Player")
	ball=require(pathLogic.."Ball")
	if myMath.restOfDivision(selectedLevel, 15)==0 then
		enemy=require(pathLogic.."Boss")
		ringG=require(pathGraphics.."RingBoss")
	else
		enemy=require(pathLogic.."Enemy")
		ringG=require(pathGraphics.."Ring")
	end
	pause=require(pathGraphics.."Pause")
end

--Combine graphics and logic elements to create the game
function createGraphicsAndLogic(groupGraph)
	--create big background to touch event for player
	background=display.newRect(groupGraph, display.contentCenterX, display.contentCenterY, 2000, display.contentHeight)
	background:setFillColor( 000000 )
	background:toBack()
	ringG.create(groupGraph, scene)
	--Setup Game Logic
	ball.setup(scene, ringG.getRing())
	player.setup(groupGraph, scene, ball, ringG)
	enemy.setup(groupGraph, scene, ball, ringG, 118)
end
	
function setup(groupGraph, comp, sl)
	selectedLevel=sl
	scene.selectedLevel=sl --For other class
	scene.world=6
	composer=comp
	--GAME PROPRIETIES
	speedStartEnemy=10
	incrementEnemy=15
	maxEnemySpeed=25
	scene.speed=0
	--Enemy speed
	scene.topSpeed=speedStartEnemy
	scene.leftSpeed=speedStartEnemy
	scene.rightSpeed=speedStartEnemy
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
	scene.ballTimeMin=5000
	scene.ballTimeMax=6000
	scene.maxBalls=5
	if selectedLevel==90 then
		scene.ballTimeMin=6000
		scene.ballTimeMax=8000
		maxEnemySpeed=10
		incrementEnemy=0
		scene.maxBalls=3
	end
	--How far the ball is when enemy follow it
	scene.distanceBallAction=300+selectedLevel*3
	--Start points
	scene.playerPoints=10
	scene.enemyPoints=5+myMath.restOfDivision((selectedLevel-1),15)
	scene.bossPoints=10
	--Create graphics, logic and timer
	setRequire()
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

--Functions to add life to player
function scene.addLifeToPlayer()
	player.setPoints(5)
end

--This function check if the game is end
function isGameEnd()
	local playerPoints=player.getPoints()
	if enemy.finishGame() or (playerPoints==0 and selectedLevel==90) then
		scene.goToTheEnd()
	elseif playerPoints==0 and checkContinue.check() then
		scene.goToTheEnd()
	end
end
function scene.goToTheEnd()
	local options =
		{
			params = {
				level = selectedLevel,
				goal=scene.getPlayerPoints(),
			}
		}
		composer.removeScene("The End.TheEnd")
		composer.gotoScene("The End.TheEnd", options)
end

--With this function I create all timers need in the game
--Save all timer will be created
local timersTable={}
function createTimers()
	local t1=timer.performWithDelay(100, ball.spawnBall, 0)
	table.insert(timersTable,t1)
	t1=timer.performWithDelay(1000, ball.deleteOutBalls, 0)
	table.insert(timersTable,t1)
	t1=timer.performWithDelay(50, enemy.manageEnemies, 0)
	table.insert(timersTable,t1)
	t1=timer.performWithDelay(20,player.checkBallsOut,0)
	table.insert(timersTable,t1)
	t1=timer.performWithDelay(20,enemy.managePoints,0)
	table.insert(timersTable,t1)
	t1=timer.performWithDelay(50,isGameEnd,0)
	table.insert(timersTable, t1)
	timer.performWithDelay(2000, pause.create(scene, composer), 1)
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

--Functions to Stop and Resume the level
function scene.pause()
	removeListener()
	physics.pause()
	cancelTimers()
end
function scene.resume()
	setupListener()
	physics.start()
	pause.destroy()
	createTimers()
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
	local params = event.params
	groupGraph=display.newGroup()
	sceneGroup:insert(groupGraph)
	physics.pause()
	setupSound()
	setup(groupGraph, composer, params.level)
	setupListener()
	checkContinue.set(scene)
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