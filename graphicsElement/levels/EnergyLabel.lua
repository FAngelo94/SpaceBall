--Energy Lable
--Create the label that indicate how many energy the player has
local energyLabel={}
local database=require("Database")

--Variables
local energyAvailable
local timeLabel

function energyLabel.create(group)
	local path="img/play/energy.png"
	local energyImage=display.newImageRect(group, path, 60,60)
	energyImage.x=80
	energyImage.y=10
	energyImage.anchorY=0
	energyAvailable=display.newText( group, 10, energyImage.x-110, 10,native.systemFont, 60 )
	energyAvailable.anchorY=0
	energyAvailable.anchorX=0
	timeLabel=display.newText( group, 10, energyImage.x+40, 10,native.systemFont, 60 )
	timeLabel.anchorY=0
	timeLabel.anchorX=0
	--Button to recharge the enery
	--local buttonRecharge=display.newImageRect(group,"img/play/addEnergy.png", 60,60)
	--buttonRecharge.x=80
	--buttonRecharge.y=80
	--buttonRecharge.anchorY=0
	--buttonRecharge:addEventListener("tap",energyLabel.confirmRecharge)
end

function energyLabel.setTimer(timeRemain)
	timeLabel.text=timeRemain
end

function energyLabel.setEnergy(value)
	energyAvailable.text=value
	
end

--Function to manage energy recharge
function energyLabel.confirmRecharge()
	native.showAlert("Confirm", "Do you want see a video advertisement to recharge completely your energy?", {"Ok", "Close"}, energyLabel.recharge)
end
function energyLabel.recharge(event)
	if ( event.action == "clicked" ) then
        local i = event.index
        if ( i == 1) then
			if energyAvailable.text~="10" and chartboost.isLoaded("rewardedVideo") then
				chartboost.show( "rewardedVideo" )
				database.rechargeEnergy()
				chartboost.load( "rewardedVideo" )
				
			else
				if energyAvailable.text=="10" then
					native.showAlert("Error", "You have full energy", {"Ok"})
				else
					native.showAlert("Sorry", "There aren't AD available", {"Ok"})
				end
			end
        end
    end
end

return energyLabel