--[[
	-------------------------------
		Menu
	-------------------------------
]]

Menu = {}
Menu.buildings = {}
Menu.sun_image = love.graphics.newImage("files/images/sun.png");
Menu.infos = love.graphics.newImage("files/images/menu_tip.png");
Menu.btn_play = love.graphics.newImage("files/images/btn_play.png");
Menu.btn_quit = love.graphics.newImage("files/images/btn_quit.png");
Menu.btn_score = love.graphics.newImage("files/images/btn_score.png");
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
function MenuRender1()
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

end
function MenuRender2()
	local screenX, screenY = system.getScreenSize();

	love.graphics.draw(Menu.logo, screenX/4-(575/4), 100, 0, 0.5, 0.5);
	love.graphics.draw(Menu.infos, screenX-300, screenY-300);
	love.graphics.print("© William DA SILVA - www.williamdasilva.fr", 50, screenY-45);

	-- drawing buttons
	love.graphics.draw(Menu.btn_play, 50, screenY-220);
	love.graphics.draw(Menu.btn_score, 50, screenY-160);
	love.graphics.draw(Menu.btn_quit, 50, screenY-100);


end


--[[
			[function] Menu.start()
	
			* Enable the menu *
	
			Return: nil
]]
function Menu.start()
	love.audio.play(Menu.soundtrack);
	Menu.soundTrackLooping = time.setTimer(12720, 0, "MenuSoundtrackLooping");


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

	event.addEventHandler("onClientRender", "MenuRender1");
	event.addEventHandler("onClientUpdate", "MenuUpdating");
	event.addEventHandler("onClientRender", "MenuRender2");
	event.addEventHandler("onClientClick", "MenuClick");
end

function MenuSoundtrackLooping()
	love.audio.play(Menu.soundtrack);
end


--[[
			[function] Menu.close()
	
			* Close the menu tempo *
	
			Return: nil
]]
function Menu.close()
	event.removeEventHandler("onClientRender", "MenuRender2");
	event.removeEventHandler("onClientClick", "MenuClick");
end

--[[
			[function] Menu.open()
	
			*  *
	
			Return: 
]]
function Menu.open()
	event.addEventHandler("onClientRender", "MenuRender2");
	event.addEventHandler("onClientClick", "MenuClick");
end

--[[
			[function] Menu.destroy()
	
			* Destroy the menu *
	
			Return: nil
]]
function Menu.destroy()
	time.destroyTimer(Menu.soundTrackLooping);
	love.audio.pause(Menu.soundtrack);

	Menu.close();
end

--[[
			[function] MenuClick()
	
			* When click *
	
			Return: nil
]]
function MenuClick(button, state, x, y)
	local screenX, screenY = system.getScreenSize();
	if (button == "left") and (state == "down") then
		if(x >= 50) and (x <= 350) and (y >= screenY-220) and (y <= screenY-220+50) then
			-- play
			startGame();
			hud.start();
			Menu.destroy();
		elseif(x >= 50) and (x <= 350) and (y >= screenY-100) and (y <= screenY-100+50) then
			-- quit
			love.event.quit();
		elseif(x >= 50) and (x <= 350) and (y >= screenY-160) and (y <= screenY-160+50) then
			-- scoreboard
			hud.quit();
			scoreboard.new();
			Menu.close();
		end
	end
end



return Menu;