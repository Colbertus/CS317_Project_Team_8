--boss

local enemy = require("enemy")
local soundTable = require("soundTable")

--creates the frames for all the individual body parts of the Bayonet
local opt =
{
	frames = {
		{x = 1, y = 0, width = 167, height = 50}, --main body frame (1)
		{x = 186, y = 19, width = 16, height = 9}, --snout frame 1 (2)
		{x = 207, y = 19, width = 16, height = 9}, --snout frame 2 (3)
		{x = 228, y = 19, width = 16, height = 9}, --snout frame 3 (4)
		{x = 260, y = 12, width = 56, height = 26}, --mouth frame 1 (5)
		{x = 323, y = 12, width = 56, height = 26}, --mouth frame 2 (6)
		{x = 386, y = 12, width = 56, height = 26}, --mouth frame 3 (7)
		{x = 1, y = 85, width = 52, height = 37}, --bottom fin frame 1 (8)
		{x = 59, y = 91, width = 53, height = 31}, --bottom fin frame 2 (9)
		{x = 119, y = 94, width = 54, height = 28}, --bottom fin frame 3 (10)
		{x = 189, y = 62, width = 48, height = 92}, --back fin frame 1 (11)
		{x = 246, y = 74, width = 55, height = 70}, --back fin frame 2 (12)
		{x = 310, y = 81, width = 60, height = 55}, --back fin frame 3 (13)
		{x = 384, y = 85, width = 60, height = 46}, --top fin frame (14)
	}
}

--Creates new instance of enemy, setting the HP to 30
local boss = enemy:new({HP = 30})

--Overwrites the spawn function from enemy with a new spawn function
function boss:spawn()
	local bayonet = graphics.newImageSheet("KingBayonet2.png", opt)

	--displays all of the body parts to form the full body
	local bottomFin = display.newImage(bayonet, 8)
	bottomFin.x = display.contentWidth/2 + 28
	bottomFin.y = display.contentHeight/2 + 30

	local topFin = display.newImage(bayonet, 14)
	topFin.x = display.contentWidth/2 + 15
	topFin.y = display.contentHeight/2 - 39

	local mainBody = display.newImage(bayonet, 1)
	mainBody.x = display.contentWidth/2
	mainBody.y = display.contentHeight/2

	local snout = display.newImage(bayonet, 2)
	snout.x = display.contentWidth/2 - 90
	snout.y = display.contentHeight/2 + 3

	local mouth = display.newImage(bayonet, 5)
	mouth.x = display.contentWidth/2 - 39
	mouth.y = display.contentHeight/2 + 7

	local backFin = display.newImage(bayonet, 11)
	backFin.x = display.contentWidth/2 + 100
	backFin.y = display.contentHeight/2 - 4
	--creates a new group that'll house all the individual body parts
	self.shape = display.newGroup(bottomFin, topFin, mainBody, snout, mouth, backFin)
	self.shape.pp = self;
	self.shape.tag = "boss";
end

--this function will move the bayonet around if the condition isMoving is true
------------------------------------------------------------------------------
function boss:move()
	transition.to(self.shape, {x = math.random(0, 1163), y = math.random(0, 640), time = 5000})
end

--This function will calculate whether or not the enemy is dead
---------------------------------------------------------------
function enemy:hit () 
	self.HP = self.HP - 1;
	if (self.HP > 0) then
		audio.play(soundTable["bulletToBoss"]);
		self.shape:setFillColor(0.5,0.5,0.5);
		
    transition.cancel( self.shape );
		
		if (self.timerRef ~= nil) then
			timer.cancel ( self.timerRef );
		end

		self.shape:removeSelf();
		self.shape=nil;	 
	end		
end

--This function will cause the enemy to shoot bullets
-----------------------------------------------------
function enemy:shoot (interval)
	interval = interval or 1500;
	local function createShot(obj)
		local p = display.newRect (obj.shape.x, obj.shape.y+50, 
                               10,10);
		p:setFillColor(1,0,0);
		p.anchorY=0;
		physics.addBody (p, "dynamic");
		p:applyForce(0, 1, p.x, p.y);
		audio.play(soundTable["bossBullet"])
		
		local function shotHandler (event)
			if (event.phase == "began") then
			event.target:removeSelf();
			event.target = nil;
		end
    end
		p:addEventListener("collision", shotHandler);		
	end
	self.timerRef = timer.performWithDelay(interval, 
		function (event) createShot(self) end, -1);
end

--Returns the boss
------------------
return boss