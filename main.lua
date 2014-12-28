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
bullet = require("gameplay.bullet");
score = require("gameplay.score");
hud = require("interface.hud");
menu = require("interface.menu");
scoreboard = require("interface.scoreboard");


love.window.setMode(780,600);

-- global tables
bullets = {}
enemies = {}
explosions = {}



me_sprite = sprite.create("files/images/ship.png", 32, 3);
santa = sprite.create("files/images/santa.png", 32, 1);
balle = sprite.create("files/images/bullet.png", 32, 3);
points = score.new();


-- stars
stars = {}
star_sprite = sprite.create("files/images/star.png", 32, 8);
for i=0, 10 do
	local t = {}
	t.x = 780;
	t.y = math.random(0,600);
	t.speed = math.random(1,8);

	table.insert(stars, t);
end

-- sounds
soundtrack = love.audio.newSource("files/sounds/ingame_soundtrack.ogg");
boo = love.audio.newSource("files/sounds/boo.mp3");


-- global vars
isGameOver = false;
spawningTimer = nil;

--[[
	-------------------------------
		Game
	-------------------------------
]]

function startGame()
	love.audio.play(soundtrack);
	time.setTimer(5333, 0, "soundTrackLoop");

	me = player.new();
	me:setSize(64);
	me:setPosition(50,50);
	me:setHealth(100);

	event.addEventHandler("onClientUpdate", "updating");
	event.addEventHandler("onClientUpdate", "col");
	event.addEventHandler("onClientRender", "rendering");
	event.addEventHandler("onClientRender", "renderingExplosion");

	spawningTimer = time.setTimer(3000,1, "startSpawning");
end

function soundTrackLoop()
	if not isGameOver then
		--love.audio.rewind(soundtrack);
		love.audio.play(soundtrack);
	end
end
menu.start();


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
				if y - 5 > 0 and y - 5 < 550 then
					me:setPosition(x, y - 5);
				end
			elseif (direction == "down") then
				if y + 5 > 0 and y + 5 < 550 then
					me:setPosition(x, y + 5);
				end
			end
		end

		-- bullets
		for i, k in ipairs(bullets)do
			local bX, bY = k:getPosition();
			local direction = k:getDirection();
			if (direction == "left") then
				k:setPosition(bX - 1, bY);
			elseif (direction == "right") then
				k:setPosition(bX + 5, bY);
			end
			-- destroy bullets if they quit the zone
			if bX >= 780 then
				table.remove(bullets, i);
			end
		end



		-- mobs mouvement
		for i, mob in ipairs(enemies)do
			if mob:isActive() then
				local mX, mY = mob:getPosition();
				mob:setPosition(mX - mob:getSpeed(), mY);
				if mX <= 0 then
					table.remove(enemies, i);
				end
			end
		end
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
		for i, mob in pairs(enemies)do
			local mX, mY = mob:getPosition();
			if isRectangleInRectangle(x, y, me:getSize(), me:getSize(), mX, mY, 50, 50) then
				-- player on a enemy
				table.remove(enemies, i);
				local health = me:getHealth();
				me:setHealth(health-(mob:getHealth()/2));
				checkForHealth();
				createExplosion(mX, mY, 2);
			end
		end

		-- collision with bullet, mob
		for i, bullet in pairs(bullets)do
			local bX, bY = bullet:getPosition();
			for k, mob in pairs(enemies)do
				local mX, mY = mob:getPosition();
				if isRectangleInRectangle(bX, bY, 10,10, mX, mY, 50, 50) then
					local health = mob:getHealth();
					local dmg = bullet:getDamage();
					mob:setHealth(health - dmg);
					createExplosion(mX, mY, 1);

					if mob:getHealth() <= 0 then
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
			--love.graphics.rectangle("fill", bX, bY, 10,10);
			sprite.drawCurrentSprite(balle, bX, bY);
		end

		-- render enemeis
		for i, mob in pairs(enemies)do
			local mX, mY = mob:getPosition();
			--love.graphics.rectangle("fill", mX, mY, 25, 25);
			sprite.drawCurrentSprite(santa, mX, mY, 0, 2, 2);
		end

		-- render explosions
		for i, exp in pairs(explosions)do
			sprite.drawCurrentSprite(explosion, exp.x, exp.y, 0, 2, 2);
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
				local b = bullet.new(x+me:getSize(), y+25, "right", 20);
				table.insert(bullets, b);
				me:setAmmo(ammo - 1);
				local throw = love.audio.newSource("files/sounds/shooting.ogg");
				love.audio.play(throw);
			end
		end
	end
end
event.addEventHandler("onClientKey", "keyboard");

--[[
	-------------------------------
		Enemy spawn
	-------------------------------
]]
local spawningTime = 3000;
function spawnMob()
	if not isGameOver then
		if spawningTime > 1000 then
			spawningTime = spawningTime - 100;
		end
		time.setTimerMS(spawningTimer, spawningTime);
		

		-- spawn
		local mob = player.new();
		mob:setPosition(800, math.random(0,550))
		mob:setHealth(50);
		mob:setSpeed(math.random(2,6));
		table.insert(enemies, mob);
	end
end

function startSpawning()
	spawningTimer = time.setTimer(spawningTime, 0, "spawnMob");
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
	if sprite.getImage(balle) < sprite.getMaxImage(balle) then
		sprite.setImage(balle, sprite.getImage(balle)+1);
	else
		sprite.setImage(balle, 1);
	end
	if sprite.getImage(star_sprite) < sprite.getMaxImage(star_sprite) then
		sprite.setImage(star_sprite, sprite.getImage(star_sprite)+1);
	else
		sprite.setImage(star_sprite, 1);
	end
end
time.setTimer(80,0,"sprite_loop");

--[[
	-------------------------------
		Explosion
	-------------------------------
]]
local explosionTimer = time.setTimer(80, 0, "changeImageExplosion");

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
local isGameOverDone = false;
function ui()
	local screenX, screenY = system.getScreenSize();
	-- is game over?
	if isGameOver then
		if not isGameOverDone then
			event.triggerEvent("onGameOver");
			isGameOverDone = true;
		end
		local pts = points:getPoints();
		love.graphics.draw(gameover, screenX/2-100, screenY/2-100, 0, 2, 2);
		love.graphics.print("Points: "..pts, screenX/2-50, screenY/2+50, 0, 2, 2);
	end
end
event.addEventHandler("onClientRender", "ui");

function quitGame()
	love.event.quit();
end

function lose()
	event.removeEventHandler("onClientKey", "keyboard");
	event.removeEventHandler("onClientRender", "rendering");
	event.removeEventHandler("onClientUpdate", "col");
	event.removeEventHandler("onClientUpdate", "updating");

	love.audio.stop(soundtrack);
	love.audio.play(boo);

	time.setTimer(5000, 1, "quitGame");
end
event.addEvent("onGameOver");
event.addEventHandler("onGameOver", "lose");