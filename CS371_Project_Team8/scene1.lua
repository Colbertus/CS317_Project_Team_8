local composer = require("composer")
local widget = require("widget") 
local scene = composer.newScene()


function scene:create(event)
	local sceneGroup = self.view
	local mainGroup = display.newGroup() 
	local title = display.newText("Team 8 OOP Shooter Game", display.contentCenterX, display.contentCenterY - 200, native.systemFont, 60)
	local name1 = display.newText("Colby McClure", display.contentCenterX - 300, display.contentCenterY - 100, native.systemFont, 40)
	local name2 = display.newText("Caleb Bagwell", display.contentCenterX + 300, display.contentCenterY - 100, native.systemFont, 40) 
	local name3 = display.newText("Michael Fechter", display.contentCenterX - 300, display.contentCenterY - 50, native.systemFont, 40) 
	local name4 = display.newText("Anna Taylor", display.contentCenterX + 300, display.contentCenterY - 50, native.systemFont, 40)
	
	local function onPressEvent(event)
		composer.gotoScene(
            "scene2",
            {
                effect = "slideLeft",
                params = {}
            }
        )
	end 
	
	local startButton = widget.newButton(
		{
			label = "Start",
			onEvent = onPressEvent,
			shape = "roundedRect", 
			width = 200,
			height = 100,
			cornerRadius = 2,
			fontSize = 30
		}
	)
	
	startButton.x = display.contentCenterX
	startButton.y = display.contentCenterY + 100 
	
	mainGroup:insert(title)
	mainGroup:insert(name1)
	mainGroup:insert(name2)
	mainGroup:insert(name3)
	mainGroup:insert(name4)
	mainGroup:insert(startButton)
	
	sceneGroup:insert(mainGroup) 
	
end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then

	elseif ( phase == "did" ) then

	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then

	elseif ( phase == "did" ) then

	end
end

function scene:destroy(event)
	local sceneGroup = self.view

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene