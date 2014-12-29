--[[
	-------------------------------
		Pickup
	-------------------------------
]]

Pickup = {}
Pickup.__index = Pickup;

--[[
			[function] Pickup.new(x, y, type, value)
	
			* Create a new pickup *
	
			Return: nil
]]
function Pickup.new(x, y, type, value)
	local obj = {
		['x'] = x,
		['y'] = y,
		['type'] = type,
		['value'] = value
	}

	setmetatable(obj, Pickup);

	return obj;
end

--[[
			[function] Pickup:setPosition(x, y)
	
			* Set the pickup position *
	
			Return: nil
]]
function Pickup:setPosition(x,y)
	self.x, self.y = x, y;
end

--[[
			[function] Pickup:getPosition()
	
			* Return the pickup position *
	
			Return: x, y
]]
function Pickup:getPosition()
	return self.x, self.y;
end

--[[
			[function] Pickup:setType(type)
	
			* Set the pickup type *
	
			Return: nil
]]
function Pickup:setType(type)
	self.type = type;
end

--[[
			[function] Pickup:getType()
	
			* Get the pickup type *
	
			Return: nil
]]
function Pickup:getType()
	return self.type;
end

--[[
			[function] Pickup:setValue(value)
	
			* Set the pickup value *
	
			Return: nil
]]
function Pickup:setValue(value)
	self.value = value;
end

--[[
			[function] Pickup:getValue()
	
			* Return the pickup value *
	
			Return: value
]]
function Pickup:getValue()
	return self.value;
end

return Pickup;