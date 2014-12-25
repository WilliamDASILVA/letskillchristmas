--[[
	-------------------------------
		Time
	-------------------------------
]]

Time = {}
Time.timers = {}


--[[
			[function] Time.setTimer(ms, infinite, functionToCall)
	
			* Create an timer and call a function after that *
	
			Return: timer, false;
]]
function Time.setTimer(ms, infinite, functionToCall, ...)
	if ms and infinite and functionToCall then

		local args = {...}

		local t = {}
		t.ms = ms;
		t.infinite = infinite;
		t.functionToCall = functionToCall;
		t.currentTime = love.timer.getTime()*1000;
		t.functionArgs = args;
		if infinite == 1 then
			t.isDone = false;
		else
			t.numberOfLoops = 0;
		end

		table.insert(Time.timers, t);
		return t;
	else
		return false;
	end
end

--[[
			[function] Time.setTimerMS(timer, ms)
	
			* Edit the ms of a timer *
	
			Return: nil
]]
function Time.setTimerMS(timer, ms)
	for i, t in ipairs(Time.timers)do
		if t == timer then
			t.ms = ms;
		end
	end
end

--[[
			[function] Time.destroyTimer(timer)
	
			* Destroy an timer *
	
			Return: true, false
]]
function Time.destroyTimer(timer)
	if timer then
		for i, t in ipairs(Time.timers)do
			if t == timer then
				table.remove(Time.timers, i);
				return true;
			end
		end
	else
		return false;
	end
end


--[[
			[function] timers()
	
			* Manage the timers *
	
			Return: nil
]]
function timers()
	for i, timer in ipairs(Time.timers)do
		local theTime = love.timer.getTime()*1000;
		if timer.ms <= (theTime - timer.currentTime) then
			if timer.infinite == 0 then
				-- timer infini
				timer.numberOfLoops = timer.numberOfLoops+1;
				timer.currentTime = love.timer.getTime()*1000;
				_G[timer.functionToCall](timer.functionArgs);
			else
				if not timer.isDone then
					-- timer fini
					_G[timer.functionToCall](timer.functionArgs);
					timer.isDone = true;
				end
			end
		end
	end
end

--[[
	-------------------------------
		Events
	-------------------------------
]]
event.addEventHandler("onClientUpdate", "timers");


return Time;