--[[
	-------------------------------
		Mob
	-------------------------------
]]

Mob = {}
Mob.__index = Mob;


--[[
			[function] Mob.new()
	
			* Mob initialisation *
	
			Return: obj
]]
function Mob.new()
	local obj = {
		['x'] = 0,
		['y'] = 0,
		['moving'] = false,
		['health'] = 100,
		['direction'] = nil,
		['active'] = true,
		['size'] = 50,
		['speed'] = 0
	}

	setmetatable(obj, Mob);
	return obj;
end

--[[
			[function] Mob:getSpeed()
	
			* Return the mob speed *
	
			Return: nil
]]
function Mob:getSpeed()
	return self.speed;
end

--[[
			[function] Mob:setSpeed(speed)
	
			* Set mob speed *
	
			Return: nil
]]
function Mob:setSpeed(speed)
	self.speed = speed;
end

--[[
			[function] Mob:getPosition()
	
			* Returns the mob position *
	
			Return: x, y
]]
function Mob:getPosition()
	return self.x, self.y;
end

--[[
			[function] Mob:setPosition(x, y)
	
			* Set the mob position *
	
			Return: true, false
]]
function Mob:setPosition(x, y)
	if x and y then
		self.x = x;
		self.y = y;
	else
		return false;
	end
end

--[[
			[function] Mob:isMoving(bool)
	
			* Check if the mob is moving *
	
			Return: true, false
]]
function Mob:isMoving(bool)
	if bool == true or bool == false then
		self.moving = bool;
	else
		return self.moving;
	end
end


--[[
			[function] Mob:setDirection(direction)
	
			* Set the mob's direction *
	
			Return: nil
]]
function Mob:setDirection(direction)
	if direction then
		self.direction = direction;
	else
		return false;
	end
end

--[[
			[function] Mob:getDirection()
	
			* Return the mob's direction *
	
			Return: direction
]]
function Mob:getDirection()
	return self.direction;
end

--[[
			[function] Mob:getHealth()
	
			* Returns the mob's health *
	
			Return: health
]]
function Mob:getHealth()
	return self.health;
end

--[[
			[function] Mob:setHealth(health)
	
			* Set the mob's health *
	
			Return: nil
]]
function Mob:setHealth(health)
	if health then
		self.health = health;
	else
		return false;
	end
end


--[[
			[function] Mob:isActive(bool)
	
			* Check if it's active *
	
			Return: true, false
]]
function Mob:isActive(bool)
	if bool == true or bool == false then
		self.active = bool;
	else
		return self.active;
	end
end

--[[
			[function] Mob:getSize()
	
			* Returns the mob's size *
	
			Return: size

]]
function Mob:getSize()
	return self.size;
end

--[[
			[function] Mob:setSize(size)
	
			* Set the mob's size *
	
			Return: nil
]]
function Mob:setSize(size)
	self.size = size;
end



return Mob;