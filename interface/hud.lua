--[[
	-------------------------------
		HUD
	-------------------------------
]]

HUD = {}
HUD.isActive = false;

local ammo_image = love.graphics.newImage("files/images/ammo.png");
local pts_image = love.graphics.newImage("files/images/points.png");
local health_image = love.graphics.newImage("files/images/health.png");

--[[
			[function] HUDRender()
	
			* Rendering the HUD *
	
			Return: nil
]]
function HUDRender()
	if HUD.isActive then
		-- health bar
		local health = me:getHealth();
		love.graphics.draw(health_image, 70, 10);
		love.graphics.print(health.."%", 110, 20);

		local ammo = me:getAmmo();
		love.graphics.draw(ammo_image, 10, 10);
		love.graphics.print(ammo, 45, 20);

		local pts = points:getPoints();
		love.graphics.draw(pts_image, 150, 10);
		love.graphics.print(pts, 185, 20);
	end
end


--[[
			[function] HUD.start()
	
			* Init the HUD *
	
			Return: nil
]]
function HUD.start()

	HUD.isActive = true;
	event.addEventHandler("onClientRender", "HUDRender");
end

