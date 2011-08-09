local E, C, L, DF = unpack(select(2, ...)); --Load Ace3, Ace3-ConfigProfile, Locales, Defaults

--Determine if Eyefinity is being used, setup the pixel perfect script.
local scale
function E:UIScale()
	self.screenheight = tonumber(string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)"));
	self.screenwidth = tonumber(string.match(({GetScreenResolutions()})[GetCurrentResolution()], "(%d+)x+%d"));

	if self.db.profile.core.autoscale == true then
		scale = min(1, max(.64, 768/self.screenheight));
	else
		scale = C["core"].uiscale
	end

	if self.screenwidth < 1600 then
			self.lowversion = true;
	elseif self.screenwidth >= 3840 or (UIParent:GetWidth() + 1 > self.screenwidth) then
		local width = self.screenwidth;
		local height = self.screenheight;
	
		-- because some user enable bezel compensation, we need to find the real width of a single monitor.
		-- I don't know how it really work, but i'm assuming they add pixel to width to compensate the bezel. :P

		-- HQ resolution
		if width >= 9840 then width = 3280; end                   	                -- WQSXGA
		if width >= 7680 and width < 9840 then width = 2560; end                     -- WQXGA
		if width >= 5760 and width < 7680 then width = 1920; end 	                -- WUXGA & HDTV
		if width >= 5040 and width < 5760 then width = 1680; end 	                -- WSXGA+

		-- adding height condition here to be sure it work with bezel compensation because WSXGA+ and UXGA/HD+ got approx same width
		if width >= 4800 and width < 5760 and height == 900 then width = 1600; end   -- UXGA & HD+

		-- low resolution screen
		if width >= 4320 and width < 4800 then width = 1440; end 	                -- WSXGA
		if width >= 4080 and width < 4320 then width = 1360; end 	                -- WXGA
		if width >= 3840 and width < 4080 then width = 1224; end 	                -- SXGA & SXGA (UVGA) & WXGA & HDTV
		
		-- yep, now set ElvUI to lower resolution if screen #1 width < 1600
		if width < 1600 then
			self.lowversion = true;
		end
		
		-- register a constant, we will need it later for launch.lua
		self.eyefinity = width;
	end
	
	if self.db.profile.core.resolutionoverride == "Low" then
		self.lowversion = true;
	elseif self.db.profile.core.resolutionoverride == "High" then
		self.lowversion = false;
	end
	
	self.mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/scale;

	--Set UIScale, NOTE: SetCVar for UIScale can cause taints so only do this when we need to..
	if E.Round and E:Round(UIParent:GetScale(), 5) ~= E:Round(scale, 5) and E.EnteredWorld then
		SetCVar("useUiScale", 1);
		SetCVar("uiScale", scale);
	end	
end
E:UIScale();

-- pixel perfect script of custom ui scale.
function E:Scale(x)
    return E.mult*math.floor(x/E.mult+.5);
end