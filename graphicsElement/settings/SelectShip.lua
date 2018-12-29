--In this class create the graphics component that permit to the user 
--to select a different ship in setting menu
local selectShip={}
local database=require("Database")
local widget = require( "widget" )

function selectShip.setup(settingGroup)
	--Scroll for list of ships
	scrollShips = widget.newScrollView(
		{
			top = 300,
			left = 0,
			width = 300,
			height = 480,
			scrollHeight = 800,
			hideBackground=true,
			horizontalScrollDisabled=true
		}
	)
	--Add all ships, green the ship available, red the others
	local shipName=display.newText( settingGroup, "Standard Ship", 0, 0,native.systemFont, 40 )
	shipName.anchorX=0
	shipName.anchorY=0
	scrollShips:insert(shipName)
	if database.isAvailable(1) then
		shipName:setTextColor(0,1,0)
		shipName:addEventListener("tap",selectShip.confirmShip1)
	else
		shipName:setTextColor(1,0,0)
	end
	shipName=display.newText( settingGroup, "Christmas Ship", 0, 50,native.systemFont, 40 )
	shipName.anchorX=0
	shipName.anchorY=0
	scrollShips:insert(shipName)
	if database.isAvailable(2) then
		shipName:setTextColor(0,1,0)
		shipName:addEventListener("tap",selectShip.confirmShip2)
	else
		shipName:setTextColor(1,0,0)
	end
end

--Functions to select the available ships
function selectShip.confirmShip1()
	database.selectShip(1)
	native.showAlert("Confirmed", "Standard Ship is selected", {"Ok"})
end
function selectShip.confirmShip2()
	database.selectShip(2)
	native.showAlert("Confirmed", "Christmas Ship is selected", {"Ok"})
end

function selectShip.destroyScroll()
	display.remove(scrollShips)
end

return selectShip