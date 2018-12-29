--Boss
--In this class manage the logic of the boss, it is like enemy
local boss={}
--REQUIRE
local pathGraphics="graphicsElement."
local graph--Save the graphics class boss ship
local textPoints=require(pathGraphics.."SimpleText")--save the graphics class to modify the text of points

local level--save level class
local ball--save ball logic class
local ringClass--save the graphics class ring
local ring --save only the ring element(not spawn or margin)

--this variable decide the maxinum distance to y ball from y ship
local precision

--Variables to save directions
local directionBoss --I save the direction to Top's ship, when the direction change the speed restart
--Variables below save the point of each boss
local pointsBoss

function boss.setup(groupGraph, l, b, r, dimension)
	--setup graphics
	if dimension==100 then
		graph=require(pathGraphics.."BossShip150x")
	elseif dimension==150 then
		graph=require(pathGraphics.."BossShip200x")
	elseif dimension==118 then --Shield
		graph=require(pathGraphics.."BossShipShield150x")	
	end
	--Special ship for events
	if(l.selectedLevel=="christmas" and dimension==100) then
		graph=require(pathGraphics.."EnemyShipsChristmas150x")
		print ("ci siamo")
	end
	--setup other things
	level=l
	ball=b
	ringClass=r
	ring=ringClass.getRing()
	graph.create(groupGraph, level, ring, ringClass.getSpawnDimension())
	--Direction start
	directionBoss="stop"
	--Points Setup
	pointsBoss=level.bossPoints
	textPoints.create(groupGraph, ring)
	textPoints.createEnemyPoints()
	textPoints.setTopPointsText(pointsBoss)
	precision=40
end

--FUNCTIONS AND VARIABLES TO MANAGE ENEMIES'S SHIP MOVEMENTS
function boss.manageEnemies()
	local bossEnemy=graph.getBossShip()
	if bossEnemy ~= nil then
		boss.moveBoss(bossEnemy)
	end
end
--The 3 functions below permit to move the different enemies
function boss.moveBoss (ship)
	local ballsTable=ball.getTable()
	if #ballsTable>0 then
		--first I look for ball nearer to the boss's ship
		local ballNearer=ballsTable[1]
		for i=#ballsTable, 1, -1 do
			local thisBall=ballsTable[i]
			if boss.ballInRing(thisBall) and thisBall.y<ballNearer.y and thisBall.y>=ship.y+5 then
				ballNearer=thisBall
			end
		end
		--now I move the boss's ship to the nearer ball
		local marginRight=ring.x+ring.width/2-ringClass.getSpawnDimension()/2-ship.width/2
		local marginLeft=ring.x-ring.width/2+ringClass.getSpawnDimension()/2+ship.width/2
		if(ship.x<ballNearer.x-precision and ship.x<marginRight and ballNearer.y<=ship.y+level.distanceBallAction and ballNearer.y>(ship.y+ship.width/2))then
		-- Move to Right
			if directionBoss=="left" or directionBoss=="stop" then --if change direction the speed restart and image change
				level.startMoveEnemy("top")
				directionBoss="right"
				graph.shipDirection(ship,"left")
			end
			if ship.x+level.topSpeed>marginRight then
				ship.x=marginRight
			else
				boss.modifyX(ship, level.topSpeed)
			end
			level.incrementEnemy("top")
		elseif(ship.x>ballNearer.x+precision and ship.x>marginLeft and ballNearer.y<=ship.y+level.distanceBallAction and ballNearer.y>(ship.y+ship.width/4))then 
		--Move to Left
			if directionBoss=="right" or directionBoss=="stop" then --if change direction the speed restart and image change
				level.startMoveEnemy("top")
				directionBoss="left"
				graph.shipDirection(ship,"right")
			end
			if ship.x-level.topSpeed<marginLeft then
				ship.x=marginLeft
			else
				boss.modifyX(ship, -level.topSpeed)
			end
			level.incrementEnemy("top")
		else
			directionBoss="stop"
			graph.shipDirection(ship,"stop")
		end
	end
end 

--Modify X of the boss
function boss.modifyX(ship, move)
	transition.to(ship,{time=20, x=(ship.x+move)})
end
--Check that the ball is in the ring, return false if the ball is out of the ring
function boss.ballInRing(ball)
	if (ball.x>ring.x-ring.width/2 and ball.x<ring.x+ring.width/2 and
		ball.y>ring.y-ring.height/2 and ball.y<ring.y+ring.height/2) then
		return true
	end
	return false
end

--Functions to manage the enemies points
function boss.managePoints()
	local bossEnemy=graph.getBossShip()
	if bossEnemy~=nil then
		boss.bossPoints(bossEnemy)
	end
end
function boss.bossPoints(ship)
	local ballsTable=ball.getTable(ship)
	for i=#ballsTable, 1, -1 do
		local ball=ballsTable[i]
		if ball.myName=="in" then --Check only the balls that weren't go out
			if(ball.y<ship.y-ball.height/2)then
				ball.myName="out"
				pointsBoss=pointsBoss-1
				textPoints.setTopPointsText(pointsBoss)
			end
		end
	end
end

--Functions to get the boss ship
function boss.getTopEnemy()
	return graph.getBossShip()
end
function boss.getLeftEnemy()
	return nil
end
function boss.getRightEnemy()
	return nil
end


--Return the number of boss alive
function boss.howManyEnemiesIsAlive()
	if pointsBoss>0 then
		return 1
	else
		return 0
	end
end

--This function return true if all boss have 0 or less points
function boss.finishGame()
	if pointsBoss<=0 then
		return true
	end
	return false
end

return boss