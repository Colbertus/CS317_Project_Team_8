local composer = require("composer")
local scene = composer.newScene()

-- The scene create function
-- Instantiate both background images, runtime and the scroll speed of the background images
----------------------------------------
function scene:create(event)
	local sceneGroup = self.view
	local bg1
	local bg2
	local runtime = 0
	local scrollSpeed = 1.4

-- This function instantiates both background images for the moving background
----------------------------------------
	local function addScrollableBg()
		
		-- The first bgImage that is used with bg1 and bg2
		local bgImage = { type="image", filename="starfield.png" }

		-- Add First bg image
		bg1 = display.newRect(0, 0, display.actualContentWidth, display.contentHeight)
		bg1.fill = bgImage
		bg1.x = display.contentCenterX
		bg1.y = display.contentCenterY

		-- Add Second bg image
		bg2 = display.newRect(0, 0, display.actualContentWidth, display.contentHeight)
		bg2.fill = bgImage
		bg2.x = display.contentCenterX - display.actualContentWidth
		bg2.y = display.contentCenterY
	end

-- This function moves the background images horizontally and loops 
----------------------------------------
	local function moveBg(dt)
		
		-- Set the scroll speeds of the backgrounds 
		bg1.x = bg1.x + scrollSpeed * dt
		bg2.x = bg2.x + scrollSpeed * dt
		
		-- Loop the backgrounds whenever they goes off the screen 
		if (bg1.x - display.actualContentWidth / 2) > display.actualContentWidth then
			bg1.x = bg2.x - display.actualContentWidth
		end
		if (bg2.x - display.actualContentWidth / 2) > display.actualContentWidth then
			bg2.x = bg1.x - display.actualContentWidth
		end
	end

-- This function is used in parallel with the moveBg function to move the background
----------------------------------------
	local function getDeltaTime()
		local temp = system.getTimer()
		local dt = (temp-runtime) / (1000/60)
		runtime = temp
		return dt
	end

-- This function calls the move function using the dt variable from the getDeltaTime function
----------------------------------------
	local function enterFrame()
		local dt = getDeltaTime()
		moveBg(dt)
	end

-- This function is what starts off the background images along with their other functions 
-- Call the init function to start moving the background
----------------------------------------
	function init()
		addScrollableBg()
		Runtime:addEventListener("enterFrame", enterFrame)
	end

	init()

end

-- The show function of the scene
----------------------------------------
function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		--timer.performWithDelay(20000, init, 0) 
	elseif ( phase == "did" ) then

	end
end

-- The hide function of the scene 
----------------------------------------
function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then

	elseif ( phase == "did" ) then

	end
end

-- The destroy function of the scene 
----------------------------------------
function scene:destroy(event)
	local sceneGroup = self.view

end

-- Scene Listeners
----------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene