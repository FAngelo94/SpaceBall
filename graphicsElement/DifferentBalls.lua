--DifferentBalls
--This class create ball with different shape
local differentBalls={}
local path="img/gameComponents/normal/differentBalls/"

--Create a new ball
function differentBalls.createBall(ring, world)
	local whereSpawn=math.random(4)
	differentBalls.whereSpawn=whereSpawn
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
	local shape=math.random(1, 4)
	local ball=display.newImageRect(path.."ballShape "..shape..".png", 60, 60)
	ball.x=x
	ball.y=y
	return ball
end

return differentBalls