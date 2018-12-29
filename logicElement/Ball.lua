local ball={}
--REQUIRE
local pathGraphics="graphicsElement."
local graph
--Save the references to other class I use
local level
local ring
local ballInRing

--Decide if it is time to spawn
local canSpawn-- 1=yes, 2=no, 3=finish game

--Save the timer that restore can spawn
local timerBall

function ball.setup(l, r, option)
	timerBall=nil
	level=l
	ring=r
	canSpawn=1
	ballInRing=0
	if option==nil then
		graph=require(pathGraphics.."Ballsx60")
	elseif option=="differentShape" then
		graph=require(pathGraphics.."DifferentBalls")
	elseif option=="christmas" then
		graph=require(pathGraphics.."BallsChristmas")
	end
end

--FUNCTIONS BASE TO MANAGE CREATION AND MOVIMENT BALLS
--Create a ball in some spawnBall in random way
local ballsTable={}
function ball.spawnBall()
	if (canSpawn==1 and ballInRing<level.maxBalls) or ballInRing==0 then
		if(timerBall~=nil and ballInRing==0)then
			timer.cancel(timerBall)
		end
		ballInRing=ballInRing+1
		local ball=graph.createBall(ring, level.world)
		ball.myName="in"
		physics.addBody(ball, "dynamic", {bounce=level.bounceBall})
		table.insert(ballsTable,ball)
		local where=graph.whereSpawn
		local xVelocity
		local yVelocity
		if where==1 then --TopSx
			xVelocity=math.random(level.minBallVelocity, level.maxBallVelocity)
			yVelocity=math.random(level.minBallVelocity, level.maxBallVelocity)
		elseif where==2 then --TopDx
			xVelocity=math.random(-level.maxBallVelocity, -level.minBallVelocity)
			yVelocity=math.random(level.minBallVelocity, level.maxBallVelocity)
		elseif where==3 then --BotDx
			xVelocity=math.random( -level.maxBallVelocity, -level.minBallVelocity)
			yVelocity=math.random(-level.maxBallVelocity, -level.minBallVelocity)
		elseif where==4 then --BotSx
			xVelocity=math.random(level.minBallVelocity, level.maxBallVelocity)
			yVelocity=math.random(-level.maxBallVelocity, -level.minBallVelocity)
		end
		ball:setLinearVelocity(xVelocity,yVelocity)
		canSpawn=2
		t=math.random(level.ballTimeMin, level.ballTimeMax)
		timerBall=timer.performWithDelay(t, restoreCanSpawn, 1)
		--return true so in the survive I know when the ball is spawned
		return true
	end
	return false
end

function restoreCanSpawn()
	if canSpawn~=3 then
		canSpawn=1
	end
end

--Delete the balls that go out of display
function ball.deleteOutBalls()
	for i=#ballsTable, 1, -1 do
		local ball=ballsTable[i]
		if(ball.x<0 or ball.y<0 or ball.x>display.contentWidth or ball.y>display.contentHeight) and ball.myName=="out" then
			display.remove(ball)
			ballInRing=ballInRing-1
			table.remove(ballsTable, i)
		end
	end
end

--When the game finished with this function I remove all balls remain in the ring
function ball.removeAllBalls()
	canSpawn=3 --So the game can't create other balls while old balls are deleting
	for i=#ballsTable, 1, -1 do
		local ball=ballsTable[i]
		display.remove(ball)
		table.remove(ballsTable, i)
	end
end

--Return all the balls
function ball.getTable()
	return ballsTable
end

--Count the balls in the ring
function ball.countBall()
	return #ballsTable
end

return ball