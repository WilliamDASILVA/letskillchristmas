--[[
	-------------------------------
		Player
	-------------------------------
]]

Player = {}
Player.__index = Player;


--[[
			[function] Player.new()
	
			* Player initialisation *
	
			Return: obj
]]
function Player.new()
	local obj = {
		['x'] = 0,
		['y'] = 0,
		['moving'] = false,
		['ammo'] = 50,
		['health'] = 100,
		['direction'] = nil,
		['active'] = true,
		['size'] = 50,
		['speed'] = 0
	}

	setmetatable(obj, Player);
	return obj;
end

--[[
			[function] Player:getSpeed()
	
			* Return the mob speed *
	
			Return: nil
]]
function Player:getSpeed()
	return self.speed;
end

--[[
			[function] Player:setSpeed(speed)
	
			* Set mob speed *
	
			Return: nil
]]
function Player:setSpeed(speed)
	self.speed = speed;
end

--[[
			[function] Player:getPosition()
	
			* Returns the player position *
	
			Return: x, y
]]
function Player:getPosition()
	return self.x, self.y;
end

--[[
			[function] Player:setPosition(x, y)
	
			* Set the player position *
	
			Return: true, false
]]
function Player:setPosition(x, y)
	if x and y then
		self.x = x;
		self.y = y;
	else
		return false;
	end
end

--[[
			[function] Player:isMoving(bool)
	
			* Check if the player is moving *
	
			Return: true, false
]]
function Player:isMoving(bool)
	if bool == true or bool == false then
		self.moving = bool;
	else
		return self.moving;
	end
end


--[[
			[function] Player:setDirection(direction)
	
			* Set the player's direction *
	
			Return: nil
]]
function Player:setDirection(direction)
	if direction then
		self.direction = direction;
	else
		return false;
	end
end

--[[
			[function] Player:getDirection()
	
			* Return the player's direction *
	
			Return: direction
]]
function Player:getDirection()
	return self.direction;
end

--[[
			[function] Player:getHealth()
	
			* Returns the player's health *
	
			Return: health
]]
function Player:getHealth()
	return self.health;
end

--[[
			[function] Player:setHealth(health)
	
			* Set the player's health *
	
			Return: nil
]]
function Player:setHealth(health)
	if health then
		self.health = health;
	else
		return false;
	end
end


--[[
			[function] Player:isActive(bool)
	
			* Check if it's active *
	
			Return: true, false
]]
function Player:isActive(bool)
	if bool == true or bool == false then
		self.active = bool;
	else
		return self.active;
	end
end

--[[
			[function] Player:getSize()
	
			* Returns the player's size *
	
			Return: size

]]
function Player:getSize()
	return self.size;
end

--[[
			[function] Player:setSize(size)
	
			* Set the player's size *
	
			Return: nil
]]
function Player:setSize(size)
	self.size = size;
end

--[[
			[function] Player:getAmmo()
	
			* Returns the player's ammo *
	
			Return: nil
]]
function Player:getAmmo()
	return self.ammo;
end

--[[
			[function] Player:setAmmo(ammo)
	
			* Set the player's ammo *
	
			Return: nil
]]
function Player:setAmmo(ammo)
	self.ammo = ammo;
end


return Player;