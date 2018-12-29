--In this class will be created and destroyed the Text to show the points and implement
--all functions to modify it
local points={}

local pointsGroup
--Point Text
local playerPoints
local topPoints
local leftPoints
local rightPoints
local ring

function points.create(groupGraph, rin)
	pointsGroup=groupGraph
	ring=rin
end

--Functions to create the text points
function points.createPlayerPoints()
	playerPoints=display.newText(pointsGroup, "", ring.x, ring.y+ring.height/2+40,native.systemFont, 70 )
end
function points.createEnemyPoints()
	topPoints=display.newText( pointsGroup, "", ring.x, ring.y-ring.height/2-40,native.systemFont, 70 )
	rightPoints=display.newText( pointsGroup, "", ring.x+ring.width/2+40, ring.y,native.systemFont, 70 )
	leftPoints=display.newText( pointsGroup, "", ring.x-ring.width/2-40, ring.y,native.systemFont, 70 )
end

--Functions return modify point
function points.setPlayerPointsText(points)
	if points>0 then
		playerPoints.text=points
	else
		playerPoints.text=""
	end
end
function points.setTopPointsText(points)
	if points>0 then
		topPoints.text=points
	else
		topPoints.text=""
	end
end
function points.setLeftPointsText(points)
	if points>0 then
		leftPoints.text=points
	else
		leftPoints.text=""
	end
end
function points.setRightPointsText(points)
	if points>0 then
		rightPoints.text=points
	else
		rightPoints.text=""
	end
end

function points.destroy()
	display.remove(pointsGroup)
end

return points