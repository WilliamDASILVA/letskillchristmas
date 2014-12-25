--[[
	-------------------------------
		Sprite
	-------------------------------
]]

Sprite = {}
Sprite.sprites = {}


--[[
			[function] Sprite.create(image, size, numbersOfSprites)
	
			* Create an sprite *
	
			Return: currentSprite, false
]]
function Sprite.create(imagePath, sizeFrame, numbersOfSprites)
	if imagePath and sizeFrame and numbersOfSprites then
		local image = love.graphics.newImage(imagePath);

		local spriteData = {}
		spriteData.image = image;
		spriteData.frameSize = sizeFrame;
		spriteData.numbersOfSprites = numbersOfSprites;
		spriteData.sprites = {}
		spriteData.currentSprite = 1;

		-- creating sprites
		for i=0,numbersOfSprites do
			local sprt = {}
			sprt.x = sizeFrame*i;
			sprt.y = 0;
			sprt.id = i;
			sprt.quad = love.graphics.newQuad(sizeFrame*i, 0, sizeFrame, sizeFrame, image:getDimensions())
			table.insert(spriteData.sprites, sprt);
		end

		table.insert(Sprite.sprites, spriteData);

		return spriteData;
	else
		return false;
	end
end

--[[
			[function] Sprite.setImage(sprite, spriteNumber)
	
			* Set the image to draw *
	
			Return: true, false
]]
function Sprite.setImage(sprite, spriteNumber)
	if spriteNumber then
		for i, sprt in pairs(Sprite.sprites)do
			if sprite == sprt then
				sprt.currentSprite = spriteNumber;
				return true;
			end
		end
	else
		return false;
	end
end

--[[
			[function] Sprite.getMaxImage(sprite)
	
			* Get the max images that a sprite can have *
	
			Return: int, false
]]
function Sprite.getMaxImage(sprite)
	if sprite then	
		for i, sprt in pairs(Sprite.sprites)do
			if sprt == sprite then
				return sprt.numbersOfSprites;
			end
		end
	else
		return false;
	end
end

--[[
			[function] Sprite.getImage(sprite)
	
			* Get the image to draw *
	
			Return: int, false
]]
function Sprite.getImage(sprite)
	if sprite then	
		for i, sprt in pairs(Sprite.sprites)do
			if sprt == sprite then
				return sprt.currentSprite;
			end
		end
	else
		return false;
	end
end

--[[
			[function] Sprite.drawCurrentSprite(sprite, x, y, ...)
	
			* Draw the current image of a sprite *
	
			Return: true, false
]]
function Sprite.drawCurrentSprite(sprite, x, y, ...)
	local arguments = {...}

	for i, sprt in pairs(Sprite.sprites)do
		if sprite == sprt then
			local currentSprite = sprt.currentSprite;
			local img = sprt.sprites[currentSprite];
			love.graphics.draw(sprt.image, img.quad, x, y, unpack(arguments));
		end
	end
end




return Sprite;