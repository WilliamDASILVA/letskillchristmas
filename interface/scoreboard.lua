--[[
	-------------------------------
		Scoreboard
	-------------------------------
]]
-- require lure module
require("modules/lure.lure");


Scoreboard = {}
Scoreboard.__index = Scoreboard;

--[[
			[function] Scoreboard.new()
	
			* Create a new scoreboard *
	
			Return: object
]]
function Scoreboard.new()
	local obj = {}

	setmetatable(obj, Scoreboard);

	return obj;
end


return Scoreboard;