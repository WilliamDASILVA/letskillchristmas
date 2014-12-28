--[[
	-------------------------------
		Scoreboard
	-------------------------------
]]


Scoreboard = {}
Scoreboard.isRendering = false;
Scoreboard.btn_back = love.graphics.newImage("files/images/btn_back.png");
Scoreboard.sprite_trophy = sprite.create("files/images/trophy.png", 32, 9);
Scoreboard.scores = {}
Scoreboard.trophyTimer = nil;


function Scoreboard.new()
	Scoreboard.setVisible(true);
	event.addEventHandler("onClientClick", "ScoreboardClick");
	event.addEventHandler("onClientRender", "ScoreboardRender");
	Scoreboard.trophyTimer = time.setTimer(80,0,"trophySprite");

	local host = 'http://127.0.0.1/perso/williamdasilva/api/LKC_getScores'
	local data, r, e = http.request(host)
	-- Ensure the file was donwnloaded properly
	assert(r == 200 and data,
	   ('Could not download file: %s')
	      :format(host:match('/([^/]+)$')))

	local tbl = json.decode(data);
	for i, k in ipairs(tbl)do
		Scoreboard.add(k.name, k.score);
	end

end


--[[
			[function] Scoreboard.save(name, score)
	
			* Save a new score *
	
			Return: nil
]]
function Scoreboard.save(name, score)
	if name and score then
		local host = 'http://127.0.0.1/perso/williamdasilva/api/LKC_addScore/'..name..'/'..score
		local data, r, e = http.request(host)
		-- Ensure the file was donwnloaded properly
		assert(r == 200 and data,
		   ('Could not download file: %s')
		      :format(host:match('/([^/]+)$')))
		local result = json.decode(data);
		if result['success'] == "true" then
			return true;
		end
	end
end

--[[
			[function] Scoreboard.quit()
	
			* Quit the scoreboard *
	
			Return: nil
]]
function Scoreboard.quit()
	Scoreboard.setVisible(false);
	Scoreboard.scores = {};
	time.destroyTimer(Scoreboard.trophyTimer);
end

--[[
			[function] Scoreboard.setVisible(bool)
	
			* Set the scoreboard visible *
	
			Return: nil
]]
function Scoreboard.setVisible(bool)
	Scoreboard.isRendering = bool;
end

--[[
			[function] Scoreboard.add(name,score)
	
			* Adding a new score to the scoreboard *
	
			Return: nil
]]
function Scoreboard.add(name, score)
	local t = {}
	t.name = name;
	t.score = score;
	table.insert(Scoreboard.scores, t);
end


--[[
			[function] trophySprite()
	
			* Update sprite image *
	
			Return: nil
]]
function trophySprite()
	if sprite.getImage(Scoreboard.sprite_trophy) < sprite.getMaxImage(Scoreboard.sprite_trophy) then
		sprite.setImage(Scoreboard.sprite_trophy, sprite.getImage(Scoreboard.sprite_trophy)+1);
	else
		sprite.setImage(Scoreboard.sprite_trophy, 1);
	end
end



--[[
			[function] ScoreboardRender()
	
			* Rendering scoreboard *
	
			Return: nil
]]
function ScoreboardRender()
	local screenX, screenY = system.getScreenSize();

	if Scoreboard.isRendering then

		-- trophy
		sprite.drawCurrentSprite(Scoreboard.sprite_trophy, screenX/2-48, 10, 0, 3, 3);

		-- btn back
		love.graphics.draw(Scoreboard.btn_back, screenX/2-150,screenY/2+200);

		-- scores
		for i, score in ipairs(Scoreboard.scores)do
			love.graphics.print("#"..i..":"..score.name.." - "..score.score.." points", screenX/2-(3*string.len("#"..i..":"..score.name.." - "..score.score.." points")), 100+(20*i));
		end
	end
end

--[[
			[function] ScoreboardClick(button, state, x, y)
	
			* When player click *
	
			Return: nil
]]
function ScoreboardClick(button, state, x, y)
	if Scoreboard.isRendering then
		local screenX, screenY = system.getScreenSize();
		if(button == "left") and (state == "down") then
			if (x >= screenX/2-150) and (x <= screenX/2-150+300) and (y >= screenY/2+200) and (y <= screenY/2+200+50) then
				Scoreboard.quit();
				Menu.setActive(true);
			end
		end
	end
end


return Scoreboard;