--[[
	-------------------------------
		Debug
	-------------------------------
]]

lov 	= 	require("system.lov");

	
Debug = {}
Debug.currentLine = 0;
Debug.currentRange = 0;
Debug.fx = {}
Debug.errors = {}


--[[
			[function] Debug.echo(text)
	
			* Show a debug message *
	
			Return: nil
]]
function Debug.echo(text)
	local s = {}
	s.line = Debug.currentLine;
	s.range = 0;
	s.content = tostring(text);
	table.insert(Debug.errors, s);

	Debug.currentLine = Debug.currentLine +1;
end

--[[
			[function] Debug.fixed(text, x, y)
	
			* Draw a fixed debug *
	
			Return: nil
]]
function Debug.fixed(text, x, y)
	Debug.fx.content = text;
	Debug.fx.x = x;
	Debug.fx.y = y;
end

--[[
			[function] Debug.printr(array)
	
			* Print an array *
	
			Return: nil
]]
function Debug.printr(array)
	if array then

		for i, k in pairs(array)do
			local s = {}
			s.line = Debug.currentLine;
			s.range = Debug.currentRange;
			s.content = "["..tostring(i).."] "..tostring(k);
			table.insert(Debug.errors, s);

			if(type(k) == "table")then
				Debug.recursiv(k, 0);
			end

			Debug.currentLine = Debug.currentLine + 1;
		end
	else
		return false;
	end
end

function Debug.recursiv(tbl, deep)
	for i, k in pairs(tbl)do
		Debug.currentLine = Debug.currentLine +1;
		
		local s = {
			['line'] = Debug.currentLine,
			['range'] = deep + 1,
			['content'] = "["..tostring(i).."] "..tostring(k);
		}
		table.insert(Debug.errors, s);

		if(type(k) == "table")then
			Debug.recursiv(k, deep+1);
		end		
	end
end

--[[
			[function] drawing()
	
			* Drawing the debug *
	
			Return: nil
]]
function drawing()
	for i, v in ipairs(Debug.errors)do
		love.graphics.print(v.content, v.range*10,v.line*12)
	end

	if Debug.fx.content then
		love.graphics.print(tostring(Debug.fx.content), Debug.fx.x, Debug.fx.y);
	end
end

event.addEventHandler("onClientRender", "drawing");

--[[
	-------------------------------
		Return the Debug table
	-------------------------------
]]
return Debug;