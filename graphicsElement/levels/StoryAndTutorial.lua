--Story and Tutorial
--In this class manage the tutorial point and the story point
--For every levels page
local storyAndTutorial={}

--Variables
local groupStoryAndTutorial
local worldSelected
local tutorialButton
local storyButton
local tutorialScreen
local storyPage
local storyScreen

--This variable check if the player is reading story or tutorial and disable for the moment goToGame
local storyOrTutorial=false

function storyAndTutorial.create(group, world)
	local path="img/play/"
	groupStoryAndTutorial=group
	worldSelected=world
	tutorialButton=display.newImageRect(group, path.."tutorial.png", 100,100)
	tutorialButton.x=0
	tutorialButton.y=500
	tutorialButton:addEventListener("tap", storyAndTutorial.showTutorial)
	storyButton=display.newImageRect(group, path.."story.png", 100,100)
	storyButton.x=0
	storyButton.y=620
	storyButton:addEventListener("tap", storyAndTutorial.showFirstStoryPage)
	timer.performWithDelay(1000,storyAndTutorial.setFalseStoryOrTutorial,1 )
end

--Functions to manage the show and remove of tutorial screens
function storyAndTutorial.showTutorial()
	if(storyOrTutorial==false)then
		local path="img/play/tutorials/world "..worldSelected..".jpg"
		tutorialScreen=display.newImageRect(path, 1200, display.contentHeight)
		tutorialScreen.x=display.contentCenterX
		tutorialScreen.y=display.contentCenterY
		display.remove(tutorialButton)
		display.remove(storyButton)
		tutorialScreen:addEventListener("tap", storyAndTutorial.removeTutorial)
		storyOrTutorial=true
	end
end
function storyAndTutorial.removeTutorial()
	display.remove(tutorialScreen)
	storyAndTutorial.create(groupStoryAndTutorial, worldSelected)
end

--Functions to manage the show and remove of story page
function storyAndTutorial.showFirstStoryPage()
	if(storyOrTutorial==false)then
		storyPage=1
		local path="img/play/storyBoard/world "..worldSelected.."."..storyPage..".jpg"
		storyScreen=display.newImageRect(path, 1200, display.contentHeight)
		storyScreen.x=display.contentCenterX
		storyScreen.y=display.contentCenterY
		display.remove(tutorialButton)
		display.remove(storyButton)
		storyScreen:addEventListener("tap", storyAndTutorial.nextStoryPage)
		storyOrTutorial=true
	end
end
function storyAndTutorial.nextStoryPage()
	storyPage=storyPage+1
	local path="img/play/storyBoard/world "..worldSelected.."."..storyPage..".jpg"
	display.remove(storyScreen)
	storyScreen=display.newImageRect(path, 1200, display.contentHeight)
	if storyScreen~=nil then
		storyScreen.x=display.contentCenterX
		storyScreen.y=display.contentCenterY
		storyScreen:addEventListener("tap", storyAndTutorial.nextStoryPage)
	else
		storyAndTutorial.create(groupStoryAndTutorial, worldSelected)
	end
end

--Function to read the state of Story and Tutorial
function storyAndTutorial.readStoryOrTutorial()
	return storyOrTutorial
end
function storyAndTutorial.setFalseStoryOrTutorial()
	storyOrTutorial=false
end

return storyAndTutorial