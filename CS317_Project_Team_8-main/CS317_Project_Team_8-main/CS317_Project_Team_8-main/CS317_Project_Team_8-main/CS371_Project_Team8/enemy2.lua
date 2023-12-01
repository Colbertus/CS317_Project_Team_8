local Enemy = require("enemy")

enemy2 = enemy:new({HP = 3, bR = 360, fT = 500, bT = 300});

function enemy2:spawn()
    self.shape = display.newPolygon(self.xPos, self.yPos, {-15, -15, 15, -15, 0, 15});
    self.shape.pp = self;
    self.shape.tag = "enemy";
    self.shape:setFillColor(1, 0, 1);
    physics.addBody(self.shape, "kinematic", {shape = {-15, -15, 15, -15, 0, 15}});
end

--This function should move toward player object which hasn't been finished
function enemy2:move()
    transition.to(self.shape, {x= 0, y =0, time = self.fT, rotation= self.fR,
		onComplete= function(obj) self:side() end});
end

return enemy2;