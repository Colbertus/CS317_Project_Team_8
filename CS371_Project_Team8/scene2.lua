local composer = require("composer")
local scene = composer.newScene()

-- The scene create function
-- Instantiate both background images, runtime, and the scroll speed of the background images
-- Instantiate the hp at 5 and the score at 0 
----------------------------------------
function scene:create(event)
	local score = 0 
	local hp = 5
	local sceneGroup = self.view
	local bg1
	local bg2
	local runtime = 0
	local scrollSpeed = 5
	local scrollSpeed2 = 1

-- This function instantiates both background images for the moving background
----------------------------------------
	local function addScrollableBg()
		
		-- The first bgImage that is used with bg1 and bg2
		local bgImage = { type="image", filename="farback.png" }
		local bgImage2 = { type ="image", filename = "starfield.png" }

		-- Add First bg image (farback.png)
		bg1 = display.newRect(0, 0, display.actualContentWidth, display.contentHeight)
		sceneGroup:insert(bg1) 
		bg1.fill = bgImage
		bg1.x = display.contentCenterX
		bg1.y = display.contentCenterY

		-- Add Second bg image (farback.png)
		bg2 = display.newRect(0, 0, display.actualContentWidth, display.contentHeight)
		sceneGroup:insert(bg2)
		bg2.fill = bgImage
		bg2.x = display.contentCenterX - display.actualContentWidth
		bg2.y = display.contentCenterY
		
		-- Add Third bg image (starfield.png)
		bg3 = display.newRect(0, 0, display.actualContentWidth, display.contentHeight)
		sceneGroup:insert(bg3) 
		bg3.fill = bgImage2
		bg3.x = display.contentCenterX
		bg3.y = display.contentCenterY
		
		-- Add Fourth bg image (starfield.png) 
		bg4 = display.newRect(0, 0, display.actualContentWidth, display.contentHeight)
		sceneGroup:insert(bg4) 
		bg4.fill = bgImage2
		bg4.x = display.contentCenterX - display.actualContentWidth
		bg4.y = display.contentCenterY

-- Instantiate the sound table for the collistion sounds 
----------------------------------------
		local soundTable = {
			bulletToEnemy = audio.loadSound("bulletToEnemy.wav"), 
			bulletToBoss = audio.loadSound("bulletToBoss.wav"),
			enemyBullet = audio.loadSound("enemyBulletToPlayer.wav"),
			bossBullet = audio.loadSound("bossBulletToPlayer.wav")
		}
		
-- Instantiate the score and hp HUD 
----------------------------------------
		local scoreText = display.newText("Score: "..score, display.contentCenterX - 500, display.statusBarHeight, native.systemFont, 35)
		local hpText = display.newText("HP: "..hp, display.contentCenterX + 500, display.statusBarHeight, native.systemFont, 35)
		sceneGroup:insert(scoreText)
		sceneGroup:insert(hpText) 
		
-- Here are both the congratulation and game over messages. Put them in when the game ends
----------------------------------------
		--local congrats = display.newText("Congratulations, You Win!!", display.contentCenterX, display.contentCenterY, native.systemFont, 60)
		--sceneGroup:insert(congrats) 
		
		--local gameOver = display.newText("Game Over, You Lose!!", display.contentCenterX, display.contentCenterY, native.systemFont, 60)
		--sceneGroup:insert(gameOver)
		
	end

-- This function moves the background images horizontally and loops 
----------------------------------------
	local function moveBg(dt)
		
		-- Set the scroll speeds of the backgrounds 
		bg1.x = bg1.x + scrollSpeed2 * dt
		bg2.x = bg2.x + scrollSpeed2 * dt
		
		bg3.x = bg3.x + scrollSpeed * dt
		bg4.x = bg4.x + scrollSpeed * dt
		
		
		-- Loop the backgrounds whenever they goes off the screen
		if (bg1.x - display.actualContentWidth / 2.35) > display.actualContentWidth then
			bg1.x = bg2.x - display.actualContentWidth
		end
		if (bg2.x - display.actualContentWidth / 2.35) > display.actualContentWidth then
			bg2.x = bg1.x - display.actualContentWidth
		end
		
		if (bg3.x - display.actualContentWidth / 2) > display.actualContentWidth then
			bg3.x = bg4.x - display.actualContentWidth
		end
		if (bg4.x - display.actualContentWidth / 2) > display.actualContentWidth then
			bg4.x = bg3.x - display.actualContentWidth
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