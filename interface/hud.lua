--[[
	-------------------------------
		HUD
	-------------------------------
]]

HUD = {}
HUD.isActive = false;

local hud_background = love.graphics.newImage("files/images/hud.png");
local hud_health = love.graphics.newImage("files/images/hud_health.png");
local ammo_image = love.graphics.newImage("files/images/ammo.png");
local pts_image = love.graphics.newImage("files/images/points.png");
local health_image = love.graphics.newImage("files/images/health.png");
local health_quad = nil;

--[[
			[function] HUDRender()
	
			* Rendering the HUD *
	
			Return: nil
]]
function HUDRender()
	local screenX, screenY = system.getScreenSize();
	if HUD.isActive then
		-- health background
		love.graphics.draw(hud_background, screenX/2-207, 0);

		local health = me:getHealth();
		health_quad = love.graphics.newQuad(0,0, (health*336)/100, 34, hud_health:getDimensions())
		love.graphics.draw(hud_health, health_quad, (screenX/2-207)+70, 0);

		local ammo = me:getAmmo();
		love.graphics.draw(ammo_image, 590, 10);
		love.graphics.setFont(f_american_huge);
		love.graphics.print(ammo.." snowmen", 620, 20);
		love.graphics.setFont(f_small);

		local pts = points:getPoints();
		love.graphics.draw(pts_image, 10, 10);
		love.graphics.setFont(f_american_huge);
		love.graphics.print(pts.." points", 45, 20);
		love.graphics.setFont(f_small);
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

--[[
			[function] HUD.quit()
	
			*  *
	
			Return: 
]]
function HUD.quit()
	HUD.isActive = false;
	event.removeEventHandler("onClientRender", "HUDRender");
end

return HUD;