function lure.dom.createHTMLSelectElement()
	local self = lure.dom.nodeObj.new(1)
	
	--===================================================================
	-- PROPERTIES                                                       =
	--===================================================================
	self.tagName 	= "select"
	---------------------------------------------------------------------
	self.nodeName 	= "SELECT"	
	---------------------------------------------------------------------
	self.nodeDesc	= "HTMLSelectElement"
	---------------------------------------------------------------------
	self.style		= lure.dom.HTMLNodeStyleobj.new(self)
	---------------------------------------------------------------------
	
	--===================================================================
	-- MUTATORS                                                         =
	--===================================================================
	
	--===================================================================
	-- METHODS	                                                        =	
	--===================================================================
	self.update = function()
		
	end
	---------------------------------------------------------------------
	self.draw = function()
		
	end
	---------------------------------------------------------------------
	
	return self
end