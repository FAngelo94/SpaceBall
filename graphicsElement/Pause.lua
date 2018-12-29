--This class manages the stop/resume during the game
local pause={}
local path="img/gameComponents/"

--public varibles
local groupButton
local resumeButton
local stopButton
local backButton
local level
local composer

function pause.create(l, c)
	level=l
	composer=c
	groupButton=display.newGroup()
	stopButton=display.newImageRect(groupButton, path.."pause.png",70,70)
	stopButton.x=0
	stopButton.y=45
	stopButton:addEventListener("touch", stopTap)
end

function stopTap(event)
	if event.phase=="began" then
		pause.destroy()
		groupButton=display.newGroup()
		resumeButton=display.newImageRect(groupButton, path.."resume.png",70,70)
		resumeButton.x=display.contentWidth
		resumeButton.y=45
		backButton=display.newImageRect(groupButton, path.."goBack.png",70,70)
		backButton.x=display.contentWidth
		backButton.y=125
		level.pause()
		resumeButton:addEventListener("touch", resumeTap)
		backButton:addEventListener("touch", goBack)
	end
end

function resumeTap(event)
	if event.phase=="ended" then
		pause.destroy()
		level.resume()
		stopButton:addEventListener("touch", stopTap)
	end
end

function goBack(event)
	if event.phase=="ended" then
		local world=level.selectedLevel/15+0.95
		local pageSend=string.format("%.0i", world)
		composer.removeScene("Play")
		local options =
		{
			params = {
				page = pageSend
			}
		}
		composer.gotoScene( "Play", options)
	end
end

function pause.destroy()
	display.remove(groupButton)
end

return pause