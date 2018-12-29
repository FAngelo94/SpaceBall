--Menu button
--In this class create and setup the proprieties of "Menu" button
local menuButton={}
local composer

function goToMenu()
	composer.removeScene("Menu")
	composer.gotoScene("Menu")
end

function menuButton.create(comp, group)
	composer=comp
	menu=display.newImageRect(group, "img/menu.png",200,80)
	menu.anchorY=1
	menu.anchorX=1
	menu.y=display.contentHeight
	menu.x=display.contentWidth+50
	menu:addEventListener("tap", goToMenu)
end

return menuButton