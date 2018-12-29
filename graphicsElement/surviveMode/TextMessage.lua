--TextMessage
local textMessage={}
local message

function textMessage.write(textPrint)
	message.text=textPrint
end

function textMessage.create(groupGraph)
	message=display.newText(groupGraph, "0", -40, display.contentHeight-100,native.systemFont, 70 )
	message.anchorX=0
end

return textMessage
