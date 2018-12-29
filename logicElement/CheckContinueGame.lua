--Check Continue Game
--When player lose if he has other energy he can continue using it and he obtain other 
--5 entra life
local checkContinue={}
local database=require("Database")

local level
--User can use continue just one time
local continueIsUsed

function checkContinue.set(scene)
	level=scene
	continueIsUsed=false
end

function checkContinue.check()
	local energy=database.getEnergyAvailable()
	if energy>0 and continueIsUsed==false then
		level.pause()
		native.showAlert("The End", "You finish your lives but you can use 1 extra energy to receive other 5 life", {"continue", "exit"}, checkContinue.continueOrExit)
		return false --User can chose continue
	end
	return true--Game end, user doesn't have other energy
end

function checkContinue.continueOrExit(event)
	if ( event.action == "clicked" ) then
        local i = event.index
		print(i)
        if ( i == 1 ) then
			continueIsUsed=true
            database.decrementEnergyToPlay()
			level.addLifeToPlayer()
			level.resume()
        elseif ( i == 2 ) then
            level.goToTheEnd()
        end
    end
end

return checkContinue