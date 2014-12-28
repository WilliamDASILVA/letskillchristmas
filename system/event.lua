--[[
	-------------------------------
		Event
	-------------------------------
]]

Event = {}
Event.events = {}


--[[
			[function] addEvent(eventName)
	
			* Create an artifical event *
	
			Return: true, false
]]
function Event.addEvent(eventName)
	if eventName then
		for i, e in ipairs(Event.events)do
			if e.name == eventName then
				return;
			end
		end

		local k = {}
		k.name = eventName;
		k.functions = {}

		table.insert(Event.events, k);

		return true;
	else
		return false;
	end
end

--[[
			[function] addEventHandler(eventName, functionCalled)
	
			* Gives a function to call when the event is stared *
	
			Return: true, false
]]
function Event.addEventHandler(eventName, functionToCall)
	if eventName and functionToCall then
		for i, e in ipairs(Event.events)do
			if eventName == e.name then
				table.insert(Event.events[i].functions, tostring(functionToCall));
				return true;
			end
		end
	else
		return false;
	end
end

--[[
			[function] triggerEvent(eventName, [args])
	
			* Call each function who is attached to the event *
	
			Return: true, false
]]
function Event.triggerEvent(eventName, ...)
	if eventName then
		local arguments = {...}
		for i, e in ipairs(Event.events)do
			if eventName == e.name then
				for i, func in ipairs(e.functions)do
					_G[func](unpack(arguments));
				end

				return true;
			end
		end
	else
		return false;
	end
end

--[[
			[function] removeEventHandler(eventName, functionCalled)
	
			* Remove a function to an event *
	
			Return: true, false
]]
function Event.removeEventHandler(eventName, functionCalled)
	if eventName and functionCalled then
		for i, e in ipairs(Event.events)do
			if eventName == e.name  then
				for k, func in ipairs(e.functions)do
					if tostring(functionCalled) == func then
						table.remove(Event.events[i].functions, k);
					end
				end
			end
		end
	else
		return false;
	end
end


return Event;