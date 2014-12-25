--[[
	-------------------------------
		Bullet
	-------------------------------
]]


Bullet = {}
Bullet.__index = Bullet;


--[[
			[function] Bullet.new(x, y, direction, damage)
	
			* Create a new bullet *
	
			Return: nil
]]
function Bullet.new(initX, initY, direction, damage)
	local obj = {
		['x'] = initX,
		['y'] = initY,
		['direction'] = direction,
		['damage'] = damage
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

return Bullet;