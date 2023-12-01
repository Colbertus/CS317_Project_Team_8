-- Anna Taylor
-- enemy1 inherits from enemy.lua

local physics = require ("physics")
local Enemy = require("enemy")

enemy1 = enemy:new({HP=2, fR = 720, fT = 1500, bT = 1500});

function enemy1:spawn()
    self.shape = display.newRect(self.xPos, self.yPos, 30, 30);
    self.shape.pp = self;
    self.shape.tag = "enemy1";
    self.shape:setFillColor(0, 1, 1);
    physics.addBody(self.shape, "kinematic");
end

function enemy1:move()
    transition.to(self.shape, {x= -self.xPos, y=0, time = self.fT, rotation= self.fR, 
    onComplete= function (obj) self:side() end})
end

return enemy1;

    
