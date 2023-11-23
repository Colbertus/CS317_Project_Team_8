-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
display.setStatusBar(display.HiddenStatusBar) 

local composer = require("composer") 

local options = {
	effect = "fade",
	time = 500
}

composer.gotoScene("scene1", options)