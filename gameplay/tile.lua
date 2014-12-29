--[[
	-------------------------------
		Tile
	-------------------------------
]]

Tile = {}
Tile.__index = Tile;



--[[
			[function] Tile.new(sizeX, sizeY, size)
	
			* Create a new tile grid *
	
			Return: nil
]]
function Tile.new(x, y, size)
	local tbl = {}
	tbl.x = {}

	for i=0,x do
		tbl.x[i] = {}
		for k=0,y do
			tbl.x[i][k] = {}
		end
	end

	local object  = {
		['size'] = size,
		['sizeX'] = x,
		['sizeY'] = y,
		['visibie'] = false,
		['table'] = tbl
	}

	setmetatable(object, Tile);

	return object;
end


--[[
			[function] Tile:setVisible(bool)
	
			* Set the grid visiible *
	
			Return: nil
]]
function Tile:setVisible(bool)
	Tile.rendering = self;
	self.visible = bool;
end

--[[
			[function] Tile:getTileSize()
	
			* Return the tile size *
	
			Return: size
]]
function Tile:getTileSize()
	return self.size;
end

--[[
			[function] Tile:setTileSize(size)
	
			* Set the size of a tile *
	
			Return: nil
]]
function Tile:setTileSize(size)
	if size then	
		self.size = size;
	else
		return false;
	end
end

--[[
			[function] Tile:setSize(x, y)
	
			* The a size for the grid *
	
			Return: nil
]]
function Tile:setSize(x, y)
	self.sizeX = x;
	self.sizeY = y;
end

--[[
			[function] Tile:getSize()
	
			* Return the grid size *
	
			Return: x, y
]]
function Tile:getSize()
	return self.sizeX, self.sizeY;
end

--[[
			[function] Tile:setTileData(xID, yID, dataName, data)
	
			* Set a data for a specific tile *
	
			Return: nil
]]
function Tile:setTileData(x, y, dataName, data)
	if x and y and data then
		self.table['x'][x][y].data = {};
		self.table['x'][x][y].data[dataName] = data;
	end
end

--[[
			[function] Tile:getTileData(x, y, dataName)
	
			* Return a data for a specific tile *
	
			Return: data
]]
function Tile:getTileData(x, y, dataName)
	if x and y and dataName then
		if self.table['x'][x][y].data then
			return self.table['x'][x][y].data[dataName];
		end
	end
end

--[[
			[function] Tile:getTile(x, y)
	
			* Return a tile *
	
			Return: table, false
]]
function Tile:getTile(x,y)
	if x and y then
		return self.table['x'][x][y];
	else
		return false;
	end
end

--[[
			[function] Tile:getTileFromPosition(x, y)
	
			* Return a tile from a specitif coordinates *
	
			Return: x, y
]]
function Tile:getTileFromPosition(x, y)
	if x and y then
		for i=0, #self:getTiles()do
			for k=0, #self:getTiles()[i]do
				if getDistanceBetweenPoints2D(i*self:getTileSize(), k*self:getTileSize(), x, y) <= self:getTileSize() then
					return i, k
				end
			end
		end
	end
end

--[[
			[function] Tile:isOnTile(tX, tY, x, y, dataName, dataWhoIsSupposedToBeEqual)
	
			* Check if the position x, y is on the tile tX, tY  AND can check if a data is equals to something *
	
			Return: true, false
]]
function Tile:isOnTile(tX, tY, x, y, dataName, dataWhoIsSupposedToBeEqual)
	if x and y and tX and tY then
		local t, z = tX*self:getTileSize(), tY*self:getTileSize();
		if (x >= t) and (x <= t+self:getTileSize()) and (y >= z) and (y <= z+self:getTileSize()) then
			if dataName then
				if self:getTileData(tX, tY, dataName) == dataWhoIsSupposedToBeEqual then
					return true;
				else
					return false;
				end
			else
				return true;
			end
		else
			return false;
		end
	else
		return false;
	end
end

--[[
			[function] Tile:getTiles()
	
			* Return every tiles *
	
			Return: table
]]
function Tile:getTiles()
	return self.table['x'];
end

function tileRendering()
	if Tile.rendering then
		
		for i=0,Tile.rendering.sizeX do
			love.graphics.line(i*Tile.rendering.size, 0, i*Tile.rendering.size, Tile.rendering.sizeY*Tile.rendering.size);
		end
		for k=0,Tile.rendering.sizeY do
			love.graphics.line(0, k*Tile.rendering.size, Tile.rendering.sizeX*Tile.rendering.size, k*Tile.rendering.size);
		end
	end
end

--event.addEventHandler("onClientRender", "tileRendering");


return Tile;