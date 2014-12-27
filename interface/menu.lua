--[[
	-------------------------------
		Menu
	-------------------------------
]]

Menu = {}
Menu.isActive = false;
Menu.buildings = {}
Menu.sun_image = love.graphics.newImage("files/images/sun.png");
Menu.infos = love.graphics.newImage("files/images/menu_tip.png");
Menu.btn_play = love.graphics.newImage("files/images/btn_play.png");
Menu.btn_quit = love.graphics.newImage("files/images/btn_quit.png");
Menu.logo = love.graphics.newImage("files/images/logo.png");
Menu.soundtrack = love.audio.newSource("files/sounds/menu_soundtrack.wav");
Menu.soundTrackLooping = nil;

--[[
			[function] MenuUpdating()
	
			* Updating *
	
			Return: nil
]]
function MenuUpdating()
	local screenX, screenY = system.getScreenSize();

	-- updating building positions
	for i, b in ipairs(Menu.buildings)do
		if b.x <= 0-b.sX then
			b.x = screenX;
		end
		b.x = b.x - b.speed;
	end
end

--[[
			[function] MenuRender()
	
			* Rendering the menu *
	
			Return: nil
]]
function MenuRender()
	local screenX, screenY = system.getScreenSize();

	-- drawing background
	love.graphics.setColor(35, 40, 48, 255);
	love.graphics.rectangle("fill",0,0,screenX, screenY);
	love.graphics.setColor(0,0,0, 255);
	love.graphics.rectangle("fill",0,screenY-100,screenX,100);
	love.graphics.setColor(255,255,255, 255);
	love.graphics.draw(Menu.sun_image, screenX/2-150, screenY-100-152);

	-- drawing buildings
	for i, b in ipairs(Menu.buildings)do
		love.graphics.setColor(0,0,0,255);
		love.graphics.rectangle("fill", b.x, screenY-b.sY, b.sX, b.sY);

	end
	love.graphics.setColor(255,255,255,255);

	if Menu.isActive then
		love.graphics.draw(Menu.logo, screenX/4-(575/4), 100, 0, 0.5, 0.5);
		love.graphics.draw(Menu.infos, screenX-300, screenY-300);
		love.graphics.print("© William DA SILVA - www.williamdasilva.fr", 50, screenY-45);

		-- drawing buttons
		love.graphics.draw(Menu.btn_play, 50, screenY-160);
		love.graphics.draw(Menu.btn_quit, 50, screenY-100);

	end

end

--[[
			[function] MenuClick()
	
			* When click *
	
			Return: nil
]]
function MenuClick(button, state, x, y)
	if Menu.isActive then
		local screenX, screenY = system.getScreenSize();
		if (button == "left") and (state == "down") then
			if(x >= 50) and (x <= 350) and (y >= screenY-160) and (y <= screenY-160+50) then
				startGame();
				HUD.start();
				Menu.isActive = false;
				love.audio.pause(Menu.soundtrack);
				time.destroyTimer(Menu.soundTrackLooping);
			elseif(x >= 50) and (x <= 350) and (y >= screenY-100) and (y <= screenY-100+50) then
				love.event.quit();
			end
		end
	end
end

--[[
			[function] Menu.start()
	
			* Enable the menu *
	
			Return: nil
]]
function Menu.start()
	Menu.isActive = true;
	Menu.soundTrackLooping = time.setTimer(12720, 0, "MenuSoundtrackLooping");
	love.audio.play(Menu.soundtrack);


	-- creating buildings
	for i=0, 10 do
		local t = {}
		t.x = 0;
		t.y = 0;
		t.sX = math.random(100, 400);
		t.sY = math.random(100, 200);
		t.speed = math.random(1,5);

		table.insert(Menu.buildings, t);
	end

	event.addEventHandler("onClientRender", "MenuRender");
	event.addEventHandler("onClientUpdate", "MenuUpdating");
	event.addEventHandler("onClientClick", "MenuClick");
end

function MenuSoundtrackLooping()
	love.audio.play(Menu.soundtrack);
end






return Menu;