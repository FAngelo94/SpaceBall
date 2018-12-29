--This is the Christmas Event
--Player has the power to frozen the game (everything in the game stop exceot the user ship for some seconds)
local composer = require( "composer" )
local scene = composer.newScene()
local myMath=require("myLibrary.myMath")

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
--Real level selected = Christmas (in the event this variable is usefull only in the other class)
local selectedLevel
--Timer to count how many time the game is frozen
local timerFrozen


--In this function do all require the game need
function setRequire()
	local pathGraphics="graphicsElement."
	pathLogic="logicElement."
	player=require(pathLogic.."Player")
	ball=require(pathLogic.."Ball")
	if selectedLevel==15 then
		enemy=require(pathLogic.."Boss")
		ringG=require(pathGraphics.."RingBoss")
	else
		enemy=require(pathLogic.."Enemy")
		ringG=require(pathGraphics.."Ring")
	end
	frozenPower=require(pathLogic.."FrozenPower")
	quitEvent=require(pathGraphics.."QuitEvent")
end

--Combine graphics and logic elements to create the game
function createGraphicsAndLogic(groupGraph)
	--create big background to touch event for player
	background=display.newRect(groupGraph, display.contentCenterX, display.contentCenterY, 2000, display.contentHeight)
	background:setFillColor( 000000 )
	background:toBack()
	ringG.create(groupGraph, scene)
	--Setup Game Logic
	ball.setup(scene, ringG.getRing(), "christmas")
	player.setup(groupGraph, scene, ball, ringG)
	enemy.setup(groupGraph, scene, ball, ringG, 100)
	frozenPower.setup(groupGraph, scene, player)
	frozenPower.setupPlayer(player)
end
	
function setup(groupGraph, comp, level)
	selectedLevel=level
	scene.selectedLevel="christmas" --For other class
	scene.world="christmas"
	composer=comp
	--GAME PROPRIETIES
	speedStartEnemy=10
	incrementEnemy=10
	maxEnemySpeed=20
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
	scene.ballTimeMin=3500
	scene.ballTimeMax=5000
	scene.maxBalls=5
	if selectedLevel==15 then --Boss settings
		scene.ballTimeMin=6000
		scene.ballTimeMax=8000
		maxEnemySpeed=10
		incrementEnemy=0
		scene.maxBalls=3
	end
	scene.bossPoints=10
	--How far the ball is when enemy follow it
	scene.distanceBallAction=400
	--Start points
	scene.playerPoints=10
	scene.enemyPoints=4+level
	--Time neeeds to recharge the frozen power
	scene.rechargePower=5000	
	timerFrozen=nil
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
	if enemy.finishGame() or playerPoints==0 then
		scene.goToTheEnd()
	end
end
function scene.goToTheEnd()
	local options =
		{
			params = {
				level = selectedLevel,
				goal=scene.getPlayerPoints(),
				nameEvent="christmas",
			}
		}
		composer.removeScene("The End.TheEndEvent")
		composer.gotoScene("The End.TheEndEvent", options)
end

--Functions to create quit button after a few seconds
function scene.createQuitButton()
	quitEvent.create(groupGraph, composer)
end

--With this function I create all timers need in the game
--Save all timer will be created
local timersTable={}
function createTimers()
	local t1=timer.performWithDelay(100, ball.spawnBall, 0)
	table.insert(timersTable,t1)
	t1=timer.performWithDelay(200, ball.deleteOutBalls, 0)
	table.insert(timersTable,t1)
	t1=timer.performWithDelay(50, enemy.manageEnemies, 0)
	table.insert(timersTable,t1)
	t1=timer.performWithDelay(20,player.checkBallsOut,0)
	table.insert(timersTable,t1)
	t1=timer.performWithDelay(20,enemy.managePoints,0)
	table.insert(timersTable,t1)
	t1=timer.performWithDelay(50,isGameEnd,0)
	table.insert(timersTable, t1)
	timer.performWithDelay(2000, scene.createQuitButton,1)
end

--This function frozen the game and it is called when the player press
--Frozen Power Button
function scene.frozenTheGame()
	physics.pause()
	--Now I put in pause all timer
	for i=#timersTable, 1, -1 do
		timer.pause(timersTable[i])
	end
	local frozenDuration=2000
	timerFrozen=timer.performWithDelay(frozenDuration, scene.stopFrozenTheGame, 1)
end
function scene.stopFrozenTheGame()
	--Now I put resume all timer
	for i=#timersTable, 1, -1 do
		timer.resume(timersTable[i])
	end
	physics.start()
	frozenPower.removeIce()
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

--SCENE
function scene:create( event )
    local sceneGroup = self.view
	local params = event.params
	local level=params.level
	--Setup gravity
	physics.start()
	physics.setGravity(0,0)
	physics.pause()
	groupGraph=display.newGroup()
	sceneGroup:insert(groupGraph)
	setupSound()
	setup(groupGraph, composer, level)
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
		if timerFrozen~=nil then
			timer.cancel(timerFrozen)
			frozenPower.removePlayerTimer()
		end
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