--[[
	-------------------------------
		Bullet
	-------------------------------
]]


Bullet = {}
Bullet.__index = Bullet;


--[[
			[function] Bullet.new(x, y, type, direction, damage)
	
			* Create a new bullet *
	
			Return: nil
]]
function Bullet.new(initX, initY, type, direction, damage)
	local obj = {
		['x'] = initX,
		['y'] = initY,
		['direction'] = direction,
		['type'] = type,
		['damage'] = damage,
		['targeted'] = false,
		['source'] = nil,
		['rotation'] = 0,
		['targetPosition'] = {}
	}

	setmetatable(obj, Bullet);

	return obj;
end

--[[
			[function] Bullet:getPosition()
	
			* Returns the position of the bullet *
	
			Return: x, y
]]
function Bullet:getPosition()
	return self.x, self.y;
end

--[[
			[function] Bullet:setPosition(x, y)
	
			* Set the bullet position *
	
			Return: nil, false
]]
function Bullet:setPosition(x, y)
	if x and y then
		self.x, self.y = x,y;
	else
		return false
	end
end

--[[
			[function] Bullet:getDirection()
	
			* Return the direction of the bullet *
	
			Return: direction
]]
function Bullet:getDirection()
	return self.direction;
end

--[[
			[function] Bullet:getDamage()
	
			* Returns the damage of a bullet *
	
			Return: damage
]]
function Bullet:getDamage()
	return self.damage;
end

--[[
			[function] Bullet:getType()
	
			* Returns the bullet type *
	
			Return: nil
]]
function Bullet:getType()
	return self.type;
end

--[[
			[function] Bullet:setTargetPosition(x, y)
	
			* Set a target position to a Bullet *
	
			Return: nil
]]
function Bullet:setTargetPosition(x, y)
	self.targetPosition.x = x;
	self.targetPosition.y = y;
end

--[[
			[function] Bullet:getTargetPosition()
	
			* Get the target position of the bullet *
	
			Return: x, y
]]
function Bullet:getTargetPosition()
	return self.targetPosition.x, self.targetPosition.y;
end

--[[
			[function] Bullet:isTargeted(bool)
	
			* Returns if the bullet is targeted or set it *
	
			Return: bool
]]
function Bullet:isTargeted(bool)
	if bool == true or bool == false then
		self.targeted = bool;
	else
		return self.targeted;
	end
end

--[[
			[function] Bullet:setSource(element)
	
			* Set bullet source *
	
			Return: nil
]]
function Bullet:setSource(element)
	self.source = element;
end

--[[
			[function] Bullet:getSource()
	
			* Return element *
	
			Return: element
]]
function Bullet:getSource()
	return self.source;
end

--[[
			[function] Bullet:setRotation(rot)
	
			* Set the bullet rotation *
	
			Return: nil
]]
function Bullet:setRotation(rotation)
	self.rotation = rotation;
end

--[[
			[function] Bullet:getRotation()
	
			* Get the bullet rotation *
	
			Return: rot
]]
function Bullet:getRotation()
	return self.rotation;
end

return Bullet;