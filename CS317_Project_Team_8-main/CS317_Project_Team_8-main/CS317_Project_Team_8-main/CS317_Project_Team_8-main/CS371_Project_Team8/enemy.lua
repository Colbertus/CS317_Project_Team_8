--Caleb Bagwell

local soundTable = require("soundTable")

--Creates table that contains the info for the enemy class
----------------------------------------------------------
-- I had to remove "local" for this to work. I'm not sure why if someone
-- else wants to look at it.
enemy = {tag="enemy", HP=1, xPos=0, yPos=0, fR=0, sR=0, bR=0, fT=1000, sT=500, bT	=500};

--Constructor for enemy
-----------------------
function enemy:new (o)
	o = o or {}; 
	setmetatable(o, self);
	self.__index = self;
	return o;
end

--This function will spawn the enemy. Default shape will be a circle.
----------------------------------------------------------------------
function enemy:spawn()
	self.shape=display.newCircle(self.xPos, self.yPos,15);
	self.shape.pp = self;  -- parent object
	self.shape.tag = self.tag; -- “enemy”
	self.shape:setFillColor (1,1,0);
	physics.addBody(self.shape, "kinematic"); 
end

--This function will move the enemy backwards
----------------------------------------------
function enemy:back ()
	transition.to(self.shape, {x=self.shape.x+100, y=150,  
	time=self.fB, rotation=self.bR, 
	onComplete=function (obj) self:forward() end} );
end

--This function will move the enemy forwards
---------------------------------------------
function enemy:side ()   
	transition.to(self.shape, {x=self.shape.x-200, 
	time=self.fS, rotation=self.sR, 
	onComplete=function (obj) self:back() end } );
end

--This function will move the enemy forwards
---------------------------------------------
function enemy:forward ()   
	transition.to(self.shape, {x=self.shape.x+100, y=800, 
	time=self.fT, rotation=self.fR, 
	onComplete= function (obj) self:side() end } );
end

--This function will move the enemy, starting forward
function enemy:move ()	
	self:forward();
end

--This function will calculate whether or not the enemy is dead
---------------------------------------------------------------
function enemy:hit () 
	self.HP = self.HP - 1;
	if (self.HP > 0) then
		audio.play(soundTable["bulletToEnemy"]);
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
		audio.play(soundTable["enemyBullet"])
		
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

--Returns the enemy
-------------------
return enemy