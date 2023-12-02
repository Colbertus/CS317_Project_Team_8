local composer = require("composer")
local scene = composer.newScene()
local physics = require("physics")
local widget = require("widget")
physics.start()
local enemy = require("enemy")
local enemy1 = require("enemy1")
local enemy2 = require("enemy2")
local boss = require("boss")
physics.setGravity(0,0);

-- The scene create function
-- Instantiate both background images, runtime, and the scroll speed of the background images
-- Instantiate the hp at 5 and the score at 0 
----------------------------------------
function scene:create(event)
	local gameTimer = 0 
	local score = 0 
	local hp = 5
	local hpText
	local sceneGroup = self.view
	local bg1
	local bg2
	local runtime = 0
	local scrollSpeed = 5
	local scrollSpeed2 = 1
	local bossHasSpawn = false

-- border to make projectiles despawn

	local right = display.newRect(display.contentWidth+70, 0,20,display.contentHeight);
	right.anchorX = 0; right.anchorY = 0;
	physics.addBody( right, "static" );

-- player
	local player = display.newRect(300, 300, 50, 50)
	player:setFillColor(3, 2, 1)

	physics.addBody (player, "dynamic");

	local controlBar = display.newRect (20, display.contentCenterY, 150, display.contentHeight);
	controlBar:setFillColor(1,1,1,0.5);
	physics.addBody(controlBar, "kinematic")

-- player control
	local function move ( event )
		 if event.phase == "began" then		
			player.markY = player.y 
		 elseif event.phase == "moved" then	 	
		 	local y = (event.y - event.yStart) + player.markY	 	
		 	
		 	if (y <= 20 + player.height/2) then
			   player.y = 20+player.height/2;
			elseif (y >= display.contentHeight-20-player.height/2) then
			   player.y = display.contentHeight-20-player.height/2;
			else
			   player.y = y;		
			end

		end
	end
	controlBar:addEventListener("touch", move);

-- Projectile 
	local cnt = 0;
	local function fire (event) 
	    if (cnt < 3) then
			cnt = cnt+1;
			local p = display.newCircle (player.x+75, player.y, 20);
			p.anchorX = 1;
			p:setFillColor(0,1,0);
			physics.addBody (p, "dynamic", {radius=5} );
			p:applyForce(2, 0, p.x, p.y);

			--audio.play( soundTable["shootSound"] );

			local function removeProjectile (event)
				if (event.phase=="began") then
				event.target:removeSelf();
				event.target=nil;
				cnt = cnt - 1;

					if (event.other.tag == "enemy") then

						event.other.pp:hit();
	         	
					end
				end
			end
			p:addEventListener("collision", removeProjectile);
		end
	end

	Runtime:addEventListener("tap", fire)
	
	-- function that'll display the game over or you won text as well as the return button
	--------------------------------------
	local function endOfGame(text)
		
		gameOverText = display.newText(text, display.contentCenterX, display.contentCenterY, native.systemFont, 60)
		sceneGroup:insert(gameOverText)
		-- The function for when the "return" button gets pressed
		----------------------------------------
		local function onPressEvent(event)
			composer.gotoScene(
				"scene1",
				{
					effect = "slideLeft",
					params = {}
				}
			)
		
			composer.removeScene("scene2")
		
			timer.pause(spawn)
			if bossMoving ~= nil then
				timer.pause(bossMoving)
			end
		end
	
		-- Instantiate the "return" button for the scene 
		----------------------------------------
		local returnButton = widget.newButton(
			{
				label = "Return",
				onEvent = onPressEvent,
				shape = "roundedRect", 
				width = 200,
				height = 100,
				cornerRadius = 2,
				fontSize = 30
			}
		)
	
		returnButton.x = display.contentCenterX
		returnButton.y = 70
	
		sceneGroup:insert(returnButton)
	end

-- player collision

	local function playerCollision (event)
	    if (event.phase=="began") then
		   	 
			if(hp > 0) then
				hp = hp - 1
				hpText:removeSelf();
				hpText=nil;
				hpText = display.newText("HP: "..hp, display.contentCenterX + 400, display.statusBarHeight, native.systemFont, 35)
	        end
	      	if (hp == 0) then
	      		endOfGame("Game Over")
	        end


	    end
	end
	player:addEventListener("collision", playerCollision);
	
--enemy collision

	local function enemyCollision (event)
		if (event.phase == "began") then
		
			if (event.other == player or event.other == controlBar) then
				event.target:removeSelf()
				event.target = nil
			end
		end
	end

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
		
-- Instantiate the score and hp HUD 
----------------------------------------
		local scoreText = display.newText("Score: "..score, display.contentCenterX - 300, display.statusBarHeight, native.systemFont, 35)
		hpText = display.newText("HP: "..hp, display.contentCenterX + 400, display.statusBarHeight, native.systemFont, 35)
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
		
		if bg1.x ~= nil and bg2.x ~= nil and bg3.x ~= nil and bg4.x ~= nil then
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
	local function init()
		addScrollableBg()
		Runtime:addEventListener("enterFrame", enterFrame)
	end

	init()
	
	sceneGroup:insert(right)
	sceneGroup:insert(player)
	sceneGroup:insert(controlBar)
	sceneGroup:insert(hpText)
	
-- This function uses the timer variable declared in the beginning and spawns an enemy randomly after 3 seconds
-- Use this function to spawn the boss since the timer logic is there
----------------------------------------
	function enemySpawn(event)
		gameTimer = gameTimer + 1   
		local en1 = math.random() 
		local en2 = math.random() 
		if (gameTimer % 3 == 0 and gameTimer < 240) then 
			if en1 < 0.5 then
				sq = enemy1:new({xPos = 1300, yPos = math.random(10, 600)})
				sq:spawn()
				sq:move()
				print("Enemy 1 spawned")
			end
			
			if en2 > 0.5 then
				tri = enemy2:new({xPos = 1300, yPos = math.random(10, 600)})
				tri:spawn()
				tri:move()
				print("Enemy 2 spawned")
			end
		elseif (gameTimer >= 120) then
			if (bossHasSpawn == false) then
				bayonet = boss:new({xPos = 1300, yPos = math.random(10, 600)})
				bayonet:spawn()
				bossHasSpawn = true
			end
			bayonet:move()
			bossMoving = timer.performWithDelay(5000, bayonet:move(), 0)
		end
	end
	
	spawn = timer.performWithDelay(1000, enemySpawn, 400)
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