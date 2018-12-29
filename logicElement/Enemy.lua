local enemy={}
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

function enemy.setup(groupGraph, l, b, r, dimension)
	--setup graphics
	if dimension==100 then
		graph=require(pathGraphics.."EnemyShips100x")
	elseif dimension==150 then
		graph=require(pathGraphics.."EnemyShips150x")
	elseif dimension==118 then --Shield
		graph=require(pathGraphics.."EnemyShipsShield")	
	end
	--Special ship for events
	if(l.selectedLevel=="christmas" and dimension==100) then
		graph=require(pathGraphics.."EnemyShipsChristmas100x")
	elseif (l.selectedLevel=="christmas" and dimension==150)then
		graph=require(pathGraphics.."EnemyShipsChristmas150x")
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
function enemy.manageEnemies()
	local topEnemy=graph.getTopShip()
	local leftEnemy=graph.getLeftShip()
	local rightEnemy=graph.getRightShip()
	if topEnemy ~= nil then
		moveTopEnemy(topEnemy)
	end
	if leftEnemy ~= nil then
		moveLeftEnemy(leftEnemy)
	end
	if rightEnemy ~= nil then
		moveRightEnemy(rightEnemy)
	end
end
--The 3 functions below permit to move the different enemies
function moveTopEnemy (enemy)
	local ballsTable=ball.getTable()
	if #ballsTable>0 then
		--first I look for ball nearer to the enemy's ship
		local ballNearer=ballsTable[1]
		for i=#ballsTable, 1, -1 do
			local thisBall=ballsTable[i]
			if ballInRing(thisBall) and thisBall.y<ballNearer.y and thisBall.y>=enemy.y+5 then
				ballNearer=thisBall
			end
		end
		--now I move the enemy's ship to the nearer ball
		local marginRight=ring.x+ring.width/2-ringClass.getSpawnDimension()/2-enemy.width/2
		local marginLeft=ring.x-ring.width/2+ringClass.getSpawnDimension()/2+enemy.width/2
		if(enemy.x<ballNearer.x-precision and enemy.x<marginRight and ballNearer.y<=enemy.y+level.distanceBallAction and ballNearer.y>enemy.y)then
		-- Move to Right
			if directionTop=="left" or directionTop=="stop" then --if change direction the speed restart and image change
				level.startMoveEnemy("top")
				directionTop="right"
				graph.shipDirection(enemy,"left")
			end
			if enemy.x+level.topSpeed>marginRight then
				enemy.x=marginRight
			else
				modifyX(enemy, level.topSpeed)
			end
			level.incrementEnemy("top")
		elseif(enemy.x>ballNearer.x+precision and enemy.x>marginLeft and ballNearer.y<=enemy.y+level.distanceBallAction and ballNearer.y>enemy.y)then 
		--Move to Left
			if directionTop=="right" or directionTop=="stop" then --if change direction the speed restart and image change
				level.startMoveEnemy("top")
				directionTop="left"
				graph.shipDirection(enemy,"right")
			end
			if enemy.x-level.topSpeed<marginLeft then
				enemy.x=marginLeft
			else
				modifyX(enemy, -level.topSpeed)
			end
			level.incrementEnemy("top")
		else
			directionTop="stop"
			graph.shipDirection(enemy,"stop")
		end
	end
end 
function moveLeftEnemy(enemy)
	local ballsTable=ball.getTable()
	if #ballsTable>0 then
		--first I look for ball nearer to the enemy's ship
		local ballNearer=ballsTable[1]
		for i=#ballsTable, 1, -1 do
			local thisBall=ballsTable[i]
			if ballInRing(thisBall) and thisBall.x<ballNearer.x and thisBall.x>=enemy.x+5 then
				ballNearer=thisBall
			end
		end
		--now I move the enemy's ship to the nearer ball
		local marginBot=ring.y+ring.height/2-ringClass.getSpawnDimension()/2-enemy.height/2
		local marginTop=ring.y-ring.height/2+ringClass.getSpawnDimension()/2+enemy.height/2
		if(enemy.y>ballNearer.y+precision and enemy.y>marginTop and ballNearer.x<=enemy.x+level.distanceBallAction and ballNearer.x>enemy.x)then
		-- Move to Top
			if directionLeft=="bot" or directionLeft=="stop" then--if change direction the speed restart and image change
				level.startMoveEnemy("left")
				directionLeft="top"
				graph.shipDirection(enemy,"left")
			end
			if enemy.y-level.leftSpeed<marginTop then
				enemy.y=marginTop
			else
				modifyY(enemy,-level.leftSpeed)
			end
			level.incrementEnemy("left")
		elseif(enemy.y<ballNearer.y-precision and enemy.y<marginBot and ballNearer.x<=enemy.x+level.distanceBallAction and ballNearer.x>enemy.x)then 
		--Move to Bot
			if directionLeft=="top" or directionLeft=="stop" then--if change direction the speed restart and image change
				level.startMoveEnemy("left")
				directionLeft="bot"
				graph.shipDirection(enemy,"right")
			end
			if enemy.y+level.leftSpeed>marginBot then
				enemy.y=marginBot
			else
				modifyY(enemy,level.leftSpeed)
			end
			level.incrementEnemy("left")
		else
			directionLeft="stop"
			graph.shipDirection(enemy,"stop")
		end
	end
end
function moveRightEnemy(enemy)
	local ballsTable=ball.getTable()
	if #ballsTable>0 then
		--first I look for ball nearer to the enemy's ship
		local ballNearer=ballsTable[1]
		for i=#ballsTable, 1, -1 do
			local thisBall=ballsTable[i]
			if ballInRing(thisBall) and thisBall.x>ballNearer.x and thisBall.x<=enemy.x-5 then
				ballNearer=thisBall
			end
		end
		--now I move the enemy's ship to the nearer ball
		local marginBot=ring.y+ring.height/2-ringClass.getSpawnDimension()/2-enemy.height/2
		local marginTop=ring.y-ring.height/2+ringClass.getSpawnDimension()/2+enemy.height/2
		if(enemy.y>ballNearer.y+precision and enemy.y>marginTop and ballNearer.x>=enemy.x-level.distanceBallAction and ballNearer.x<enemy.x)then-- Move to Top
			if directionRight=="bot" or directionRight=="stop" then--if change direction the speed restart and image change
				level.startMoveEnemy("right")
				directionRight="top"
				graph.shipDirection(enemy,"right")
			end
			if enemy.y-level.rightSpeed<marginTop then
				enemy.y=marginTop
			else
				modifyY(enemy,-level.rightSpeed)
			end
			level.incrementEnemy("right")
		elseif(enemy.y<ballNearer.y-precision and enemy.y<marginBot and ballNearer.x>=enemy.x-level.distanceBallAction and ballNearer.x<enemy.x)then --Move to Bot
			if directionRight=="top" or directionRight=="stop" then--if change direction the speed restart and image change
				level.startMoveEnemy("right")
				directionRight="bot"
				graph.shipDirection(enemy,"left")
			end
			if enemy.y+level.rightSpeed>marginBot then
				enemy.y=marginBot
			else
				modifyY(enemy,level.rightSpeed)
			end
			level.incrementEnemy("right")
		else
			directionRight="stop"
			graph.shipDirection(enemy,"stop")
		end
	end
end
--Modify Y and X of the enemy
function modifyY(enemy, move)
	transition.to(enemy,{time=20, y=(enemy.y+move)})
end
function modifyX(enemy, move)
	transition.to(enemy,{time=20, x=(enemy.x+move)})
end
--Check that the ball is in the ring, return false if the ball is out of the ring
function ballInRing(ball)
	if (ball.x>ring.x-ring.width/2 and ball.x<ring.x+ring.width/2 and
		ball.y>ring.y-ring.height/2 and ball.y<ring.y+ring.height/2) then
		return true
	end
	return false
end
--Functions to manage the enemies points
function enemy.managePoints()
	local topEnemy=graph.getTopShip()
	local leftEnemy=graph.getLeftShip()
	local rightEnemy=graph.getRightShip()
	if topEnemy~=nil then
		topPoints(topEnemy)
	end
	if leftEnemy~=nil then
		leftPoints(leftEnemy)
	end
	if rightEnemy~=nil then
		rightPoints(rightEnemy)
	end
end
function topPoints(ship)
	local ballsTable=ball.getTable(ship)
	for i=#ballsTable, 1, -1 do
		local ball=ballsTable[i]
		if ball.myName=="in" then --Check only the balls that weren't go out
			if(ball.y<ship.y-ship.height/2)then
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
function leftPoints(ship)
	local ballsTable=ball.getTable(ship)
	for i=#ballsTable, 1, -1 do
		local ball=ballsTable[i]
		if ball.myName=="in" then --Check only the balls that weren't go out
			if(ball.x<ship.x-ship.width/2)then
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
function rightPoints(ship)
	local ballsTable=ball.getTable(ship)
	for i=#ballsTable, 1, -1 do
		local ball=ballsTable[i]
		if ball.myName=="in" then --Check only the balls that weren't go out
			if(ball.x>ship.x+ship.width/2)then
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
function enemy.getTopEnemy()
	return graph.getTopShip()
end
function enemy.getLeftEnemy()
	return graph.getLeftShip()
end
function enemy.getRightEnemy()
	return graph.getRightShip()
end

--Functions to know if some enemy is alive
function enemy.isAlive(who)
	if who=="top" then
		if pointsTop>0 then
			return true
		else
			return false
		end
	elseif who=="right" then
		if pointsRight>0 then
			return true
		else
			return false
		end
	elseif who=="left" then
		if pointsLeft>0 then
			return true
		else
			return false
		end
	end
end
--Return the number of enemy alive
function enemy.howManyEnemiesIsAlive()
	local enemiesAlive=0
	if enemy.isAlive("top")==true then
		enemiesAlive=enemiesAlive+1
	end
	if enemy.isAlive("right")==true then
		enemiesAlive=enemiesAlive+1
	end
	if enemy.isAlive("left")==true then
		enemiesAlive=enemiesAlive+1
	end
	return enemiesAlive
end

--This function return true if all enemy have 0 or less points
function enemy.finishGame()
	if pointsTop<=0 and pointsLeft<=0 and pointsRight<=0 then
		return true
	end
	return false
end

return enemy