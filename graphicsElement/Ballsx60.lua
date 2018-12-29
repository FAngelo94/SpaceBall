--In this class will be created and destroyed balls and implement
--all functions to modify the balls in the game
local balls={}
local path="img/gameComponents/normal/"

--Create a new ball
function balls.createBall(ring, world)
	local whereSpawn=math.random(4)
	balls.whereSpawn=whereSpawn
	local x
	local y
	if whereSpawn==1 then --TopLeft
		x=ring.x-220
		y=ring.y-220
	elseif whereSpawn==2 then -- TopRight
		x=ring.x+220
		y=ring.y-220
	elseif whereSpawn==3 then --BotRight
		x=ring.x+220
		y=ring.y+220
	elseif whereSpawn==4 then --BotLeft
		x=ring.x-220
		y=ring.y+220
	end
	local ball=display.newImageRect(path.."colorBall "..world..".png", 60, 60)
	ball.x=x
	ball.y=y
	return ball
end

return balls