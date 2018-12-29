--Backbutton
--Here I disble backbutton of the smartphone
local backbutton={}

-- Called when a key event has been received
function onKeyEvent( event )
    -- If the "back" key was pressed on Android or Windows Phone, prevent it from backing out of the app
    if ( event.keyName == "back" ) then
        local platformName = system.getInfo( "platformName" )
        if ( platformName == "Android" ) or ( platformName == "WinPhone" ) then
            return true
        end
    end
end

function backbutton.disable()
	Runtime:addEventListener( "key", onKeyEvent )
end

return backbutton