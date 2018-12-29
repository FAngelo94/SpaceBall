local invincibleEnemy={}
--REQUIRE
local pathGraphics="graphicsElement."
local graph--Save the graphics class enemy ship
local textPoints=require(pathGraphics.."SimpleText")--save the graphics class to modify the text of points

local level--save level class
local ball--save ball logic class
local ringClass--save the graphics class ring
local ring --save only the ring element(not spawn or margin)

--this variable decide the maxinum distance to y ball from y ship
local precision

--Variables to save directions
local directionTop --I save the direction to Top's ship, when the direction change the speed restart
local directionLeft --I save the direction to Left's ship, when the direction change the speed restart
local directionRight --I save the direction to Right's ship, when the direction change the speed restart
--Variables below save the point of each enemy
local pointsTop
local pointsLeft
local pointsRight

function invincibleEnemy.setup(groupGraph, l, b, r, dimension)
	--setup graphics
	if dimension==100 then
		graph=require(pathGraphics.."EnemyShips100x")
	elseif dimension==150 then
		graph=require(pathGraphics.."EnemyShips150x")
	end
	--setup other things
	level=l
	ball=b
	ringClass=r
	ring=ringClass.getRing()
	graph.create(groupGraph, level, ring, ringClass.getSpawnDimension())
	--Direction start
	directionTop="stop"
	directionLeft="stop"
	directionRight="stop"
	--Points Setup
	pointsTop=level.enemyPoints
	pointsLeft=level.enemyPoints
	pointsRight=level.enemyPoints
	textPoints.create(groupGraph, ring)
	textPoints.createEnemyPoints()
	textPoints.setTopPointsText(pointsTop)
	textPoints.setLeftPointsText(pointsLeft)
	textPoints.setRightPointsText(pointsRight)
	precision=40
end

--FUNCTIONS AND VARIABLES TO MANAGE ENEMIES'S SHIP MOVEMENTS
function invincibleEnemy.manageEnemies()
	local topEnemy=graph.getTopShip()
	local leftEnemy=graph.getLeftShip()
	local rightEnemy=graph.getRightShip()
	if topEnemy ~= nil then
		invincibleEnemy.moveTopEnemy(topEnemy)
	end
	if leftEnemy ~= nil then
		invincibleEnemy.moveLeftEnemy(leftEnemy)
	end
	if rightEnemy ~= nil then
		invincibleEnemy.moveRightEnemy(rightEnemy)
	end
end
--The 3 functions below permit to move the different enemies
function invincibleEnemy.moveTopEnemy (enemy)
	local ballsTable=ball.getTable()
	if #ballsTable>0 then
		--first I look for ball nearer to the enemy's ship
		local ballNearer=ballsTable[1]
		for i=#ballsTable, 1, -1 do
			local thisBall=ballsTable[i]
			if invincibleEnemy.ballInRing(thisBall) and thisBall.y<ballNearer.y and thisBall.y>=enemy.y+5 then
				ballNearer=thisBall
			end
		end
		--now I move the enemy's ship to the nearer ball
		local marginRight=ring.x+ring.width/2-ringClass.getSpawnDimension()/2-enemy.width/2
		local marginLeft=ring.x-ring.width/2+ringClass.getSpawnDimension()/2+enemy.width/2
		if(enemy.x<ballNearer.x-precision and enemy.x<marginRight and ballNearer.y<=enemy.y+level.distanceBallAction)then
		-- Move to Right
			if directionTop=="left" or directionTop=="stop" then --if change direction the speed restart and image change
				level.startMoveEnemy("top")
				directionTop="right"
				graph.shipDirection(enemy,"left")
			end
			if enemy.x+level.topSpeed>marginRight then
				enemy.x=marginRight
			else
				invincibleEnemy.modifyX(enemy, ballNearer)
			end
			level.incrementEnemy("top")
		elseif(enemy.x>ballNearer.x+precision and enemy.x>marginLeft and ballNearer.y<=enemy.y+level.distanceBallAction)then 
		--Move to Left
			if directionTop=="right" or directionTop=="stop" then --if change direction the speed restart and image change
				level.startMoveEnemy("top")
				directionTop="left"
				graph.shipDirection(enemy,"right")
			end
			if enemy.x-level.topSpeed<marginLeft then
				enemy.x=marginLeft
			else
				invincibleEnemy.modifyX(enemy, ballNearer)
			end
			level.incrementEnemy("top")
		else
			directionTop="stop"
			graph.shipDirection(enemy,"stop")
		end
	end
end 
function invincibleEnemy.moveLeftEnemy(enemy)
	local ballsTable=ball.getTable()
	if #ballsTable>0 then
		--first I look for ball nearer to the enemy's ship
		local ballNearer=ballsTable[1]
		for i=#ballsTable, 1, -1 do
			local thisBall=ballsTable[i]
			if invincibleEnemy.ballInRing(thisBall) and thisBall.x<ballNearer.x and thisBall.x>=enemy.x+5 then
				ballNearer=thisBall
			end
		end
		--now I move the enemy's ship to the nearer ball
		local marginBot=ring.y+ring.height/2-ringClass.getSpawnDimension()/2-enemy.height/2
		local marginTop=ring.y-ring.height/2+ringClass.getSpawnDimension()/2+enemy.height/2
		if(enemy.y>ballNearer.y+precision and enemy.y>marginTop and ballNearer.x<=enemy.x+level.distanceBallAction)then
		-- Move to Top
			if directionLeft=="bot" or directionLeft=="stop" then--if change direction the speed restart and image change
				level.startMoveEnemy("left")
				directionLeft="top"
				graph.shipDirection(enemy,"left")
			end
			if enemy.y-level.leftSpeed<marginTop then
				enemy.y=marginTop
			else
				invincibleEnemy.modifyY(enemy,ballNearer)
			end
			level.incrementEnemy("left")
		elseif(enemy.y<ballNearer.y-precision and enemy.y<marginBot and ballNearer.x<=enemy.x+level.distanceBallAction)then 
		--Move to Bot
			if directionLeft=="top" or directionLeft=="stop" then--if change direction the speed restart and image change
				level.startMoveEnemy("left")
				directionLeft="bot"
				graph.shipDirection(enemy,"right")
			end
			if enemy.y+level.leftSpeed>marginBot then
				enemy.y=marginBot
			else
				invincibleEnemy.modifyY(enemy,ballNearer)
			end
			level.incrementEnemy("left")
		else
			directionLeft="stop"
			graph.shipDirection(enemy,"stop")
		end
	end
end
function invincibleEnemy.moveRightEnemy(enemy)
	local ballsTable=ball.getTable()
	if #ballsTable>0 then
		--first I look for ball nearer to the enemy's ship
		local ballNearer=ballsTable[1]
		for i=#ballsTable, 1, -1 do
			local thisBall=ballsTable[i]
			if invincibleEnemy.ballInRing(thisBall) and thisBall.x>ballNearer.x and thisBall.x<=enemy.x-5 then
				ballNearer=thisBall
			end
		end
		--now I move the enemy's ship to the nearer ball
		local marginBot=ring.y+ring.height/2-ringClass.getSpawnDimension()/2-enemy.height/2
		local marginTop=ring.y-ring.height/2+ringClass.getSpawnDimension()/2+enemy.height/2
		if(enemy.y>ballNearer.y+precision and enemy.y>marginTop and ballNearer.x>=enemy.x-level.distanceBallAction)then-- Move to Top
			if directionRight=="bot" or directionRight=="stop" then--if change direction the speed restart and image change
				level.startMoveEnemy("right")
				directionRight="top"
				graph.shipDirection(enemy,"right")
			end
			if enemy.y-level.rightSpeed<marginTop then
				enemy.y=marginTop
			else
				invincibleEnemy.modifyY(enemy,ballNearer)
			end
			level.incrementEnemy("right")
		elseif(enemy.y<ballNearer.y-precision and enemy.y<marginBot and ballNearer.x>=enemy.x-level.distanceBallAction)then --Move to Bot
			if directionRight=="top" or directionRight=="stop" then--if change direction the speed restart and image change
				level.startMoveEnemy("right")
				directionRight="bot"
				graph.shipDirection(enemy,"left")
			end
			if enemy.y+level.rightSpeed>marginBot then
				enemy.y=marginBot
			else
				invincibleEnemy.modifyY(enemy,ballNearer)
			end
			level.incrementEnemy("right")
		else
			directionRight="stop"
			graph.shipDirection(enemy,"stop")
		end
	end
end
--Modify Y and X of the enemy
function invincibleEnemy.modifyY(enemy, ball)
	enemy.y=ball.y
end
function invincibleEnemy.modifyX(enemy, ball)
	enemy.x=ball.x
end
--Check that the ball is in the ring, return false if the ball is out of the ring
function invincibleEnemy.ballInRing(ball)
	if (ball.x>ring.x-ring.width/2 and ball.x<ring.x+ring.width/2 and
		ball.y>ring.y-ring.height/2 and ball.y<ring.y+ring.height/2) then
		return true
	end
	return false
end
--Functions to manage the enemies points
function invincibleEnemy.managePoints()
	local topEnemy=graph.getTopShip()
	local leftEnemy=graph.getLeftShip()
	local rightEnemy=graph.getRightShip()
	if topEnemy~=nil then
		invincibleEnemy.topPoints(topEnemy)
	end
	if leftEnemy~=nil then
		invincibleEnemy.leftPoints(leftEnemy)
	end
	if rightEnemy~=nil then
		invincibleEnemy.rightPoints(rightEnemy)
	end
end
function invincibleEnemy.topPoints(ship)
	local ballsTable=ball.getTable(ship)
	for i=#ballsTable, 1, -1 do
		local ball=ballsTable[i]
		if ball.myName=="in" then --Check only the balls that weren't go out
			if(ball.y<ship.y-ball.height/2)then
				ball.myName="out"
				pointsTop=pointsTop-1
				textPoints.setTopPointsText(pointsTop)
			end
		end
	end
	if pointsTop <=0 then
		graph.deleteEnemy("top", ringClass)
	end
end
function invincibleEnemy.leftPoints(ship)
	local ballsTable=ball.getTable(ship)
	for i=#ballsTable, 1, -1 do
		local ball=ballsTable[i]
		if ball.myName=="in" then --Check only the balls that weren't go out
			if(ball.x<ship.x-ball.width/2)then
				ball.myName="out"
				pointsLeft=pointsLeft-1
				textPoints.setLeftPointsText(pointsLeft)
			end
		end
	end
	if pointsLeft <=0 then
		graph.deleteEnemy("left", ringClass)
	end
end
function invincibleEnemy.rightPoints(ship)
	local ballsTable=ball.getTable(ship)
	for i=#ballsTable, 1, -1 do
		local ball=ballsTable[i]
		if ball.myName=="in" then --Check only the balls that weren't go out
			if(ball.x>ship.x+ball.width/2)then
				ball.myName="out"
				pointsRight=pointsRight-1
				textPoints.setRightPointsText(pointsRight)
			end
		end
	end
	if pointsRight <=0 then
		graph.deleteEnemy("right", ringClass)
	end
end

--Functions to get the enemy ship
function invincibleEnemy.getTopEnemy()
	return graph.getTopShip()
end
function invincibleEnemy.getLeftEnemy()
	return graph.getLeftShip()
end
function invincibleEnemy.getRightEnemy()
	return graph.getRightShip()
end

--This function return true if all enemy have 0 or less points
function invincibleEnemy.finishGame()
	if pointsTop<=0 and pointsLeft<=0 and pointsRight<=0 then
		return true
	end
	return false
end

return invincibleEnemy