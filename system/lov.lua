--[[
	-------------------------------
		Love
	-------------------------------
]]

event 	= 	require("system.event");

Lov = {}
--[[
	-------------------------------
		Events
	-------------------------------
]]
event.addEvent("onWindowResize");
event.addEvent("onWindowFocus");
event.addEvent("onWindowQuit");
event.addEvent("onClientClick");
event.addEvent("onClientCharacter");
event.addEvent("onClientKey");
event.addEvent("onClientUpdate");
event.addEvent("onClientRender");


--[[
			[function] love.draw()
	
			* Rendering *
	
			Return: nil
]]
function love.draw()
	event.triggerEvent("onClientRender");
end


--[[
			[function] love.focus(f)
	
			* When the window receive or lose the focus *
	
			Return: nil
]]
function love.focus(f)
	event.triggerEvent("onWindowFocus", f);
end

--[[
			[function] love.resize(newWidth, newHeight)
	
			* When the window is resized *
	
			Return: nil
]]
function love.resize(newWidth, newHeight)
	event.triggerEvent("onWindowResize", newWidth, newHeight);
end	

--[[
			[function] love.quit()
	
			* When the window is closed *
	
			Return: nil
]]
function love.quit()
	event.triggerEvent("onWindowQuit");
end

--[[
			[function] love.mousepressed(x, y, button)
	
			* When the player press a button in his mouse *
	
			Return: nil
]]
function love.mousepressed(x, y, button)
	event.triggerEvent("onClientClick", button, "down", x, y);
end

--[[
			[function] love.mousereleased(x, y, button)
	
			* When the player release a button in his mouse *
	
			Return: nil
]]
function love.mousereleased(x, y, button)
	event.triggerEvent("onClientClick", button, "up", x, y);
end

--[[
			[function] love.textinput(text)
	
			* When the player type *
	
			Return: nil
]]
function love.textinput(text)
	event.triggerEvent("onClientCharacter", text);
end

--[[
			[function] love.keypressed(key, repeat)
	
			* When the player press a key *
	
			Return: nil
]]
function love.keypressed(key, rep)
	if(key == " ")then
		key = "space";
	end
	event.triggerEvent("onClientKey", key, "down", rep);
end

--[[
			[function] love.keyreleased(key)
	
			* When the player release a key *
	
			Return: nil
]]
function love.keyreleased(key)
	if(key == " ")then
		key = "space";
	end
	event.triggerEvent("onClientKey", key, "up", nil);
end

--[[
			[function] love.update(time)
	
			* When the system update itself *
	
			Return: nil
]]
function love.update(time)
	event.triggerEvent("onClientUpdate", time)
end



return Lov;