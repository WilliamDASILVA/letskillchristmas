--[[
	-------------------------------
		System
	-------------------------------
]]

System = {}


--[[
			[function] System.getMousePosition()
	
			* Return the mouse coordinates *
	
			Return: x, y
]]
function System.getMousePosition()
	return love.mouse.getPosition();
end

--[[
			[function] System.setMousePosition(x, y)
	
			* Set the mouse coordinates *
	
			Return: nil
]]
function System.setMousePosition(x, y)
	love.mouse.setPosition(x, y);
end

--[[
			[function] System.getScreenSize()
	
			* Return the screen size *
	
			Return: x, y
]]
function System.getScreenSize()
	return love.graphics.getDimensions();
end

return System;