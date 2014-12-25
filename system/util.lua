--[[
	-------------------------------
		Util
	-------------------------------
]]

table.indexOf = function( t, object )
	local result
	if "table" == type( t ) then
		for i=1,#t do
			if object == t[i] then
				result = i
				break
			end
		end
	end
	 
	return result
end 

--[[
			[function] getDistanceBetweenPoints2D(x, y, tX, tY)
	
			* Returns the distance between two points *
	
			Return: distance
]]
function getDistanceBetweenPoints2D(x, y, tX, tY)
	if x and y and tX and tY then
		return	math.sqrt(math.pow(x-tX, 2)+math.pow(y-tY, 2));
	else
		return false;
	end
end

--[[
			[function] isRectangleInRectangle(x, y, w, h, x, y, w, h)
	
			* Check if a rectangle is in another one *
	
			Return: true, false
]]
function isRectangleInRectangle(x, y, w, h, a, b, c, d)
	local did = false;
	for i=0, w do
		for k=0, h do
			if (x+i >= a) and (x+i <= a+c) and (y+k >= b) and (y+k <= b+d) then
				did = true;
			end
		end
	end
	return did;
end