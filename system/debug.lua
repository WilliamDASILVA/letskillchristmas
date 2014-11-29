--[[
	-------------------------------
		Debug
	-------------------------------
]]

lov 	= 	require("system.lov");

	
Debug = {}
Debug.errors = {}


--[[
			[function] Debug.echo(text)
	
			* Show a debug message *
	
			Return: nil
]]
function Debug.echo(text)
	if text then
		table.insert(Debug.errors, text);
	end	
end

--[[
			[function] drawing()
	
			* Drawing the debug *
	
			Return: nil
]]
function drawing()
	for i, v in ipairs(Debug.errors)do
		love.graphics.print(v, 0,12*i)
	end
end

event.addEventHandler("onClientRender", "drawing");

--[[
	-------------------------------
		Return the Debug table
	-------------------------------
]]
return Debug;