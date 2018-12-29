--QuitButton
--Setup button to quit to the app
local quitButton={}

function quitToGame()
	native.requestExit()
end

function quitButton.create(group)
	button=display.newImageRect(group, "img/menu/quit.png", 95, 95)
	button.x=-10
	button.y=115
	button:addEventListener("tap", quitToGame)
end

return quitButton