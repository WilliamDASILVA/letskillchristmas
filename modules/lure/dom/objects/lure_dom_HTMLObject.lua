function lure.dom.createHTMLObjectElement()
	local self = lure.dom.nodeObj.new(1)
	
	--===================================================================
	-- PROPERTIES                                                       =
	--===================================================================
	self.tagName 	= "object"
	---------------------------------------------------------------------
	self.nodeName 	= "OBJECT"	
	---------------------------------------------------------------------
	self.nodeDesc	= "HTMLObjectElement"
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