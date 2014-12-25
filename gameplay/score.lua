--[[
	-------------------------------
		Score
	-------------------------------
]]

Score = {}
Score.__index = Score;


function Score.new()
	local obj = {
		['points'] = 0
	}

	setmetatable(obj, Score);
	return obj;
end

--[[
			[function] Score:getPoints()
	
			* Returns the points *
	
			Return: points
]]
function Score:getPoints()
	return self.points;
end

--[[
			[function] Score:setPoints(points)
	
			* Set the player's points *
	
			Return: nil
]]
function Score:setPoints(points)
	if points then
		self.points = points;
	else
		return false;
	end
end


return Score;