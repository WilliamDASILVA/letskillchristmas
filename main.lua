--[[
	-------------------------------
		Main
		Let's kill christmas
		@willia_am
	-------------------------------
]]



--[[
	-------------------------------
		Including all the modules
	-------------------------------
]]

require("system.include");
player = require("gameplay.player");
mob = require("gameplay.player");
bullet = require("gameplay.bullet");
score = require("gameplay.score");
hud = require("interface.hud");
menu = require("interface.menu");
scoreboard = require("interface.scoreboard");
pickup = require("gameplay.pickup");


love.window.setMode(780,600);

me_sprite = sprite.create("files/images/ship.png", 32, 3);
santa = sprite.create("files/images/santa.png", 32, 4);
snowman = sprite.create("files/images/bullet.png", 32, 3);
sugarcane = sprite.create("files/images/sugarcane.png", 32, 1);
lutin = sprite.create("files/images/lutin-2x.png", 64, 4);
star_sprite = sprite.create("files/images/star.png", 32, 8);
health_sprite = sprite.create("files/images/health.png", 32, 1);
ammo_sprite = sprite.create("files/images/ammo.png", 32, 1);

-- sounds
soundtrack = love.audio.newSource("files/sounds/ingame_soundtrack.ogg");
boo = love.audio.newSource("files/sounds/boo.mp3");


-- global vars
isGameOver = false;
spawningTimer = nil;
soundtLoop = nil;
explosionTimer = nil;
enemyShootingTimer = nil;
spritesLoop = nil;
isGameOverDone = false;

f_small = love.graphics.newFont(12);
f_normal = love.graphics.newFont(15);
f_huge = love.graphics.newFont(20);
f_american_normal = love.graphics.newFont("files/fonts/american.ttf", 15);
f_american_huge = love.graphics.newFont("files/fonts/american.ttf", 20);

--[[
	-------------------------------
		Game
	-------------------------------
]]

function startGame()

	-- global tables
	bullets = {}
	enemies = {}
	explosions = {}
	pickups = {}
	stars = {}

	isGameOver = false;
	isGameOverDone = false;

	-- stars
	for i=0, 10 do
		local t = {}
		t.x = 780;
		t.y = math.random(0,600);
		t.speed = math.random(1,8);

		table.insert(stars, t);
	end

	love.audio.play(soundtrack);

	me = player.new();
	me:setSize(64);
	me:setPosition(50,80);
	me:setHealth(100);
	points = score.new();

	spawningTime = 3000;


	event.addEventHandler("onClientUpdate", "updating");
	event.addEventHandler("onClientUpdate", "col");
	event.addEventHandler("onClientRender", "rendering");
	event.addEventHandler("onClientRender", "renderingExplosion");
	event.addEventHandler("onClientKey", "keyboard");
	event.addEventHandler("onClientRender", "ui");
	event.removeEventHandler("onClientCharacter", "charactering");
	event.removeEventHandler("onClientKey", "kBoard");
	event.removeEventHandler("onClientClick", "inputClick");

	spawningTimer = time.setTimer(3000,1, "startSpawning");
	explosionTimer = time.setTimer(80, 0, "changeImageExplosion");
	soundtLoop = time.setTimer(5400, 0, "soundTrackLoop");
	enemyShootingTimer = time.setTimer(1500, 0, "enemyShooting");
	spritesLoop = time.setTimer(80,0,"sprite_loop");
	pickupSpawn = time.setTimer(10000, 0, "pickupSpawning");

	menu.quit();

end

function soundTrackLoop()
	love.audio.play(soundtrack);
end

---
menu.start();
---

function stopGame()
	event.removeEventHandler("onClientUpdate", "updating");
	event.removeEventHandler("onClientUpdate", "col");
	event.removeEventHandler("onClientRender", "rendering");
	event.removeEventHandler("onClientRender", "renderingExplosion");
	event.removeEventHandler("onClientKey", "keyboard");
	event.addEventHandler("onClientCharacter", "charactering");
	event.addEventHandler("onClientKey", "kBoard");
	event.addEventHandler("onClientClick", "inputClick");

	love.audio.pause(soundtrack);

	time.destroyTimer(spawningTimer);
	time.destroyTimer(soundtLoop);
	time.destroyTimer(explosionTimer);
	time.destroyTimer(enemyShootingTimer);
	time.destroyTimer(spritesLoop);

end


--[[
	-------------------------------
		Updating
	-------------------------------
]]
function updating()
	if not isGameOver then
		local x, y = me:getPosition();
		-- move stars
		for i, star in ipairs(stars)do
			if star.x <= 0 then
				star.x = 780;
			else
				star.x = star.x - star.speed;
			end
		end

		-- moving
		if me:isMoving() then
			local direction = me:getDirection();
			if (direction == "up") then
				if y - 5 > 60 and y - 5 < 550 then
					me:setPosition(x, y - 5);
				end
			elseif (direction == "down") then
				if y + 5 > 60 and y + 5 < 550 then
					me:setPosition(x, y + 5);
				end
			end
		end

		-- bullets
		for i, k in ipairs(bullets)do
			local bX, bY = k:getPosition();
			local direction = k:getDirection();
			local tg = k:isTargeted();
			if tg then
				local tX, tY = k:getTargetPosition();
				local vX, vY = tX - bX, tY - bY;

				local distance = getDistanceBetweenPoints2D(bX, bY, tX, tY);
				vX, vY = vX/distance, vY/distance;
				vX, vY = vX*5, vY*5;

				k:setPosition(bX + vX, bY + vY);
				local rotation = findRotation(bX, bY, tX, tY);
				k:setRotation(((rotation-90)*math.pi)/180);
			else
				if (direction == "left") then
					k:setPosition(bX - 5, bY);
				elseif (direction == "right") then
					k:setPosition(bX + 5, bY);
				end
			end
			-- destroy bullets if they quit the zone
			if bX > 780 or bX < 50 then
				table.remove(bullets, i);
			end
		end



		-- mobs mouvement
		for i, mb in ipairs(enemies)do
			if mb:isActive() then
				local mX, mY = mb:getPosition();
				mb:setPosition(mX - mb:getSpeed(), mY);
				if mX <= 0 then
					table.remove(enemies, i);
				end
			end
		end

		-- pickup mouvement
		for i, p in ipairs(pickups)do
			local x, y = p:getPosition();
			p:setPosition(x - 2, y);

			if x <= (-32) then
				table.remove(pickups, i)
			end
		end

		-- check for player's health
		checkForHealth();
	end
end


--[[
	-------------------------------
		Collision
	-------------------------------
]]
function col()
	if not isGameOver then
		local x, y = me:getPosition();

		-- colision with player, mob
		for i, mb in pairs(enemies)do
			local mX, mY = mb:getPosition();
			if isRectangleInRectangle(x, y, me:getSize(), me:getSize(), mX, mY, 50, 50) then
				-- player on a enemy
				table.remove(enemies, i);
				local health = me:getHealth();
				me:setHealth(health-(mb:getHealth()/2));
				createExplosion(mX, mY, 2);
			end
		end

		-- collision with bullet, mob
		for i, bullet in pairs(bullets)do
			local source = bullet:getSource();
			if source == "player" then
				local bX, bY = bullet:getPosition();
				for k, mb in pairs(enemies)do
					local mX, mY = mb:getPosition();
					if isRectangleInRectangle(bX, bY, 10,10, mX, mY, 50, 50) then
						local health = mb:getHealth();
						local dmg = bullet:getDamage();
						mb:setHealth(health - dmg);
						createExplosion(mX, mY, 1);

						if mb:getHealth() <= 0 then
							createExplosion(mX, mY, 3);
							table.remove(enemies, k)
							local ammo = me:getAmmo();
							me:setAmmo(ammo + 5);

							-- score
							local pts = points:getPoints();
							points:setPoints(pts + 1);
						end
						table.remove(bullets, i);
					end
				end
			end
		end

		-- collision with bullet player
		for i, bullet in ipairs(bullets)do
			local source = bullet:getSource();
			if source == "mob" then
				local bX, bY = bullet:getPosition();
				local mX, mY = me:getPosition();

				if isRectangleInRectangle(bX, bY, 10,10, mX, mY, 50, 50) then
					local dmg = bullet:getDamage();
					local health = me:getHealth();
					me:setHealth(health - dmg);
					createExplosion(mX, mY, 1);

					table.remove(bullets, i);
				end
			end
		end

		-- collision with pickup, player
		for i, p in ipairs(pickups)do
			local x, y = me:getPosition();
			local pX, pY = p:getPosition();

			if isRectangleInRectangle(x, y, 50, 50, pX, pY, 32, 32) then
				local typ = p:getType();
				local value = p:getValue();
				if typ == "ammo" then
					local ammo = me:getAmmo();
					me:setAmmo(ammo + value);
				elseif typ == "health" then
					local health = me:getHealth();
					me:setHealth(health + value);
					local health = me:getHealth();
					if health > 100 then
						me:setHealth(100);
					end
				end

				table.remove(pickups, i);
			end
		end
	end
end


--[[
	-------------------------------
		Rendering
	-------------------------------
]]
function rendering()
	if not isGameOver then
		-- stars
		for i, star in ipairs(stars)do
			sprite.drawCurrentSprite(star_sprite, star.x, star.y, 0, 1.5, 1.5);
		end

		-- rendering the player	
		local x, y = me:getPosition();
		--love.graphics.rectangle("fill", x, y, 50, 50);
		sprite.drawCurrentSprite(me_sprite, x, y, 0, 2, 2);


		-- render bullets
		for i, k in pairs(bullets)do
			local bX, bY = k:getPosition();
			local fuu = k:getType();
			if fuu == "snowman" then
				sprite.drawCurrentSprite(snowman, bX, bY, k:getRotation());
			elseif fuu == "sugarcane" then
				sprite.drawCurrentSprite(sugarcane, bX, bY, k:getRotation());
			elseif fuu == "lutin" then
				sprite.drawCurrentSprite(lutin, bX, bY, k:getRotation());
			else
				love.graphics.rectangle("fill", bX, bY, 10,10);
			end
		end

		-- render enemeis
		for i, mb in pairs(enemies)do
			local mX, mY = mb:getPosition();
			--love.graphics.rectangle("fill", mX, mY, 25, 25);
			sprite.drawCurrentSprite(santa, mX, mY, 0, 2, 2);
		end

		-- render explosions
		for i, exp in pairs(explosions)do
			sprite.drawCurrentSprite(explosion, exp.x, exp.y, 0, 2, 2);
		end

		-- render mob health
		for i, mb in pairs(enemies)do
			local x, y = mb:getPosition();
			local health = mb:getHealth();

			love.graphics.setColor(255,255,255,255);
			love.graphics.rectangle("fill", x, (y-10), 50, 10);
			love.graphics.setColor(67, 170, 0, 255);
			love.graphics.rectangle("fill", x+2, (y-10)+2, (health*(50-4))/100, 10-4);
			love.graphics.setColor(255,255,255,255);
		end

		-- rendering pickups
		for i, p in pairs(pickups)do
			local x, y = p:getPosition();
			if p:getType() == "health" then
				sprite.drawCurrentSprite(health_sprite, x, y);
			elseif p:getType() == "ammo" then
				sprite.drawCurrentSprite(ammo_sprite, x, y);
			end
		end
	end
end



--[[
	-------------------------------
		Keyboard
	-------------------------------
]]
function keyboard(button, state)
	if not isGameOver then
		local x, y = me:getPosition();
		if (button == "up") then
			me:setDirection("up");
			if (state == "down") then
				me:isMoving(true);
			else
				me:isMoving(false);
			end
		elseif (button == "down") then
			me:setDirection("down");
			if (state == "down") then
				me:isMoving(true);
			else
				me:isMoving(false);
			end
		elseif (button == "space") and (state == "down") then
			-- shoot
			local ammo = me:getAmmo();
			if ammo > 0 then
				local b = bullet.new(x+me:getSize(), y+25, "snowman", "right", 20);
				b:setSource("player");
				table.insert(bullets, b);

				me:setAmmo(ammo - 1);
				local throw = love.audio.newSource("files/sounds/shooting.ogg");
				love.audio.play(throw);
			end
		end
	end
end

--[[
	-------------------------------
		Enemy spawn
	-------------------------------
]]

function spawnMob()
	if not isGameOver then
		if spawningTime > 1000 then
			spawningTime = spawningTime - 100;
		end
		time.setTimerMS(spawningTimer, spawningTime);
		

		-- spawn
		local mb = mob.new();
		mb:setPosition(800, math.random(80,550))
		mb:setHealth(math.random(50,80));
		mb:setSpeed(math.random(2,4));
		table.insert(enemies, mb);
		
	end
end

function startSpawning()
	spawningTimer = time.setTimer(spawningTime, 0, "spawnMob");
end


--[[
	-------------------------------
		Enemy shooting
	-------------------------------
]]

function enemyShoot(mb)
	if mb then
		local x, y = mb:getPosition();
		local pX, pY = me:getPosition();

		if getDistanceBetweenPoints2D(x, y, pX, pY) >= 500 then

			local b = bullet.new(x, y, "lutin", "left", 5);
			b:isTargeted(true);
			b:setTargetPosition(pX, pY);
			b:setSource("mob");

			table.insert(bullets, b);

			local throw = love.audio.newSource("files/sounds/shooting.ogg");
			love.audio.play(throw);
		end
	end
end

function enemyShooting()
	if not isGameOver then
		for i, mb in ipairs(enemies)do
			enemyShoot(mb);
		end
	end
end

--[[
	-------------------------------
		Health manage
	-------------------------------
]]
function checkForHealth()
	local x, y = me:getPosition();
	local health = me:getHealth();
	if health <= 0 then
		-- game over
		isGameOver = true;
		createExplosion(x, y, 5);
		createExplosion(x-50, y, 5);
		createExplosion(x-50, y-50, 5);
		createExplosion(x, y-50, 5);
	end
end

--[[
	-------------------------------
		Sprites loop
	-------------------------------
]]
function sprite_loop()
	if sprite.getImage(me_sprite) < sprite.getMaxImage(me_sprite) then
		sprite.setImage(me_sprite, sprite.getImage(me_sprite)+1);
	else
		sprite.setImage(me_sprite, 1);
	end
	if sprite.getImage(santa) < sprite.getMaxImage(santa) then
		sprite.setImage(santa, sprite.getImage(santa)+1);
	else
		sprite.setImage(santa, 1);
	end
	if sprite.getImage(snowman) < sprite.getMaxImage(snowman) then
		sprite.setImage(snowman, sprite.getImage(snowman)+1);
	else
		sprite.setImage(snowman, 1);
	end
	if sprite.getImage(sugarcane) < sprite.getMaxImage(sugarcane) then
		sprite.setImage(sugarcane, sprite.getImage(sugarcane)+1);
	else
		sprite.setImage(sugarcane, 1);
	end
	if sprite.getImage(lutin) < sprite.getMaxImage(lutin) then
		sprite.setImage(lutin, sprite.getImage(lutin)+1);
	else
		sprite.setImage(lutin, 1);
	end
	if sprite.getImage(health_sprite) < sprite.getMaxImage(health_sprite) then
		sprite.setImage(health_sprite, sprite.getImage(health_sprite)+1);
	else
		sprite.setImage(health_sprite, 1);
	end
	if sprite.getImage(ammo_sprite) < sprite.getMaxImage(ammo_sprite) then
		sprite.setImage(ammo_sprite, sprite.getImage(ammo_sprite)+1);
	else
		sprite.setImage(ammo_sprite, 1);
	end

	if sprite.getImage(star_sprite) < sprite.getMaxImage(star_sprite) then
		sprite.setImage(star_sprite, sprite.getImage(star_sprite)+1);
	else
		sprite.setImage(star_sprite, 1);
	end
end

--[[
	-------------------------------
		Pickup spawing
	-------------------------------
]]
function pickupSpawning()
	local typ = math.random(1,3);
	if typ == 1 then
		aaha = "health";
		val = math.random(5, 20);
	elseif typ == 2 then
		aaha = "ammo";
		val = math.random(15, 30);
	end

	local p = pickup.new(780, math.random(10, 550), aaha, val);
	table.insert(pickups, p);

end


--[[
	-------------------------------
		Explosion
	-------------------------------
]]

function createExplosion(x, y, size)
	local t = {}
	t.x = x;
	t.y = y;
	t.size = size;
	t.sprite = sprite.create("files/images/explosion.png", 32, 7);
	table.insert(explosions, t);
	local spash = love.audio.newSource("files/sounds/explosion.ogg");
	love.audio.play(spash);

end

function renderingExplosion()
	for i, exp in ipairs(explosions)do
		sprite.drawCurrentSprite(exp.sprite, exp.x, exp.y, 0, exp.size, exp.size);
	end
end

function changeImageExplosion()
	for a, e in ipairs(explosions)do
		if sprite.getImage(e.sprite) < sprite.getMaxImage(e.sprite) then
			sprite.setImage(e.sprite, sprite.getImage(e.sprite)+1);
		else
			sprite.setImage(e.sprite, 1);
			table.remove(explosions, i);
		end
	end

end


--[[
	-------------------------------
		User interface
	-------------------------------
]]
local gameover = love.graphics.newImage("files/images/gameover.png");
local btn_retry = love.graphics.newImage("files/images/btn_retry.png");
local btn_save = love.graphics.newImage("files/images/btn_save.png");
local haveTheFocus = false;
local inputValue = "";


function ui()
	local screenX, screenY = system.getScreenSize();
	-- is game over?
	if isGameOver then
		if not isGameOverDone then
			event.triggerEvent("onGameOver");
			isGameOverDone = true;
		end
		local pts = points:getPoints();
		love.graphics.draw(gameover, screenX/2-100, 100, 0, 2, 2);
		love.graphics.setFont(f_huge);
		love.graphics.print("Points: "..pts, screenX/2-30, 250);
		love.graphics.setFont(f_small);

		-- input
		if pts > 0 then
			love.graphics.setFont(f_normal);
			love.graphics.print("Save your score... put your name here:", screenX/2-150, 300);
			love.graphics.rectangle("fill", screenX/2-150, 320, 300, 50);
			if haveTheFocus then
				love.graphics.setColor(0, 102, 132, 255);
				love.graphics.rectangle("fill", screenX/2-150, 320, 300, 5)
				love.graphics.setColor(255,255,255,255);
			end
			love.graphics.setColor(0,0,0,255);
			love.graphics.print(inputValue, screenX/2-150+5, 335);
			love.graphics.setColor(255,255,255,255);
			love.graphics.draw(btn_save, screenX/2-150, 380);
			love.graphics.setFont(f_small);
		end

		love.graphics.draw(btn_retry, screenX/2-150, 440);


	end
end



function lose()
	stopGame();
	love.audio.play(boo);
end
event.addEvent("onGameOver");
event.addEventHandler("onGameOver", "lose");



--[[
	-------------------------------
		Managing the input field of the game over screen
	-------------------------------
]]
function charactering(str)
	if isGameOver and haveTheFocus then
		inputValue = inputValue..str;
	end
end

function kBoard(key, state)
	if isGameOver and haveTheFocus then
		if key == "backspace" and state == "down" then
			inputValue = string.sub(inputValue, 0, string.len(inputValue)-1);
		end
	end
end

function inputClick(button, state, x, y)
	local screenX, screenY = system.getScreenSize();
	if isGameOver then
		if button == "left" and state == "down" then
			if (x >= screenX/2-150) and (x <= screenX/2-150 + 300) and (y >= 320) and (y <= 370) then
				haveTheFocus = true;
			else
				haveTheFocus = false;
			end

			if (x >= screenX/2-150) and (x <= screenX/2-150 + 300) and (y >= 380) and (y <= 380+50) then
				-- save
				if string.len(inputValue) > 1 then
					local pts = points:getPoints();
					local name = inputValue;
					event.removeEventHandler("onClientRender", "ui");
					
					scoreboard.save(name, pts);
					menu.setActive(true);
					isGameOver = false;
				end
			elseif (x >= screenX/2-150) and (x <= screenX/2-150 + 300) and (y >= 440) and (y <= 440+50) then
				-- retry
				event.removeEventHandler("onClientRender", "ui");
				startGame();
			end
		end
	end
end