local E, C, L, DF = unpack(select(2, ...)); --Load Ace3, Ace3-ConfigProfile, Locales, Defaults
local LSM = LibStub("LibSharedMedia-3.0")

--Variables
_, E.myclass = UnitClass("player");
E.myname, _ = UnitName("player");
E.myguid = UnitGUID('player');
E.version = GetAddOnMetadata("ElvUI", "Version"); 
E.myrealm = GetRealmName();
_, E.wowbuild = GetBuildInfo(); E.wowbuild = tonumber(E.wowbuild);
E.noop = function() end;

--Table contains the SharedMedia values of all the fonts/textures
E["media"] = {};

--Table contains every frame we use :SetTemplate or every text we use :SetFontTemplate on
E["frames"] = {};
E["texts"] = {};

function E:ToggleAnchors()
	E:ToggleMovers()
end

function E:UpdateMedia()
	--[[if E.UnitFrames and E.UnitFrames['handledunits'] then --If user updates the main bordercolor setting, update the health and castbars default colors, if they are matching the old colors.
		for unit in pairs(E.UnitFrames['handledunits']) do
			local r, g, b = unpack(E["media"].bordercolor)

			if C['unitframe'][unit]['castbar']['color'].r == r and C['unitframe'][unit]['castbar']['color'].g == g and C['unitframe'][unit]['castbar']['color'].b == b then
				C['unitframe'][unit]['castbar']['color'].r = C["core"].backdropcolor.r
				C['unitframe'][unit]['castbar']['color'].g = C["core"].backdropcolor.g
				C['unitframe'][unit]['castbar']['color'].b = C["core"].backdropcolor.b
				_G['ElvUF_'..unit]:UpdateAllElements()	
			end		
			
			if C['unitframe']['colors']['health'].r == r and C['unitframe']['colors']['health'].g == g and C['unitframe']['colors']['health'].b == b then
				C['unitframe']['colors']['health'].r = C["core"].backdropcolor.r
				C['unitframe']['colors']['health'].g = C["core"].backdropcolor.g
				C['unitframe']['colors']['health'].b = C["core"].backdropcolor.b				
				E.UnitFrames:UpdateColors()
				_G['ElvUF_'..unit]:UpdateAllElements()	
			end	
		end
	end]] --WHY DOESN'T THIS WORK!! NEEDS FIX
	
	--Fonts
	E["media"].normFont = LSM:Fetch("font", C["core"].font)
	E["media"].combatFont = LSM:Fetch("font", C["core"].dmgfont)

	--Textures
	E["media"].blankTex = LSM:Fetch("background", "ElvUI Blank")
	E["media"].normTex = LSM:Fetch("statusbar", C["core"].normTex)
	E["media"].glossTex = LSM:Fetch("statusbar", C["core"].glossTex)

	--Border Color
	local border = C["core"].bordercolor
	E["media"].bordercolor = {border.r, border.g, border.b}

	--Backdrop Color
	local backdrop = C["core"].backdropcolor
	E["media"].backdropcolor = {backdrop.r, backdrop.g, backdrop.b}

	--Backdrop Fade Color
	backdrop = C["core"].backdropfadecolor
	E["media"].backdropfadecolor = {backdrop.r, backdrop.g, backdrop.b, backdrop.a}
	
	--Value Color
	local value = C["core"].valuecolor
	E["media"].hexvaluecolor = ""
	E["media"].rgbvaluecolor = {value.r, value.g, value.b}
	
	E:UpdateBlizzardFonts()
end
E:UpdateMedia();

function E:UpdateFrameTemplates()
	for frame, _ in pairs(E["frames"]) do
		if frame and frame.template then
			frame:SetTemplate(frame.template);
		else
			E["frames"][frame] = nil;
		end
	end
end

function E:UpdateBorderColors()
	for frame, _ in pairs(E["frames"]) do
		if frame then
			if frame.template == 'Default' or frame.template == 'Transparent' or frame.template == nil then
				frame:SetBackdropBorderColor(unpack(E['media'].bordercolor))
			end
		else
			E["frames"][frame] = nil;
		end
	end
end	

function E:UpdateBackdropColors()
	for frame, _ in pairs(E["frames"]) do
		if frame then
			if frame.template == 'Default' or frame.template == nil then
				if frame.backdropTexture then
					frame.backdropTexture:SetVertexColor(unpack(E['media'].backdropcolor))
				else
					frame:SetBackdropColor(unpack(E['media'].backdropcolor))				
				end
			end
		else
			E["frames"][frame] = nil;
		end
	end
end	

function E:UpdateFontTemplates()
	for text, _ in pairs(E["texts"]) do
		if text then
			text:SetFontTemplate(text.font, text.fontSize, text.fontStyle);
		else
			E["texts"][text] = nil;
		end
	end
end

--This frame everything in ElvUI should be anchored to for Eyefinity support.
E.UIParent = CreateFrame('Frame', 'ElvUIParent', UIParent);
E.UIParent:SetFrameLevel(UIParent:GetFrameLevel());
E.UIParent:SetPoint('CENTER', UIParent, 'CENTER');
E.UIParent:SetSize(UIParent:GetSize());

--Check if PTR version of WoW is loaded
function E:IsPTR()
	if self.wowbuild > 14333 then
		return true;
	else
		return false;
	end
	return false;
end

--Check the player's role
function E:CheckRole()
	local tree = GetPrimaryTalentTree();
	local resilience;
	local resilperc = GetCombatRatingBonus(COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN)
	if resilperc > GetDodgeChance() and resilperc > GetParryChance() then
		resilience = true;
	else
		resilience = false;
	end
	if ((self.myclass == "PALADIN" and tree == 2) or 
	(self.myclass == "WARRIOR" and tree == 3) or 
	(self.myclass == "DEATHKNIGHT" and tree == 1)) and
	resilience == false or
	(self.myclass == "DRUID" and tree == 2 and GetBonusBarOffset() == 3) then
		self.role = "Tank";
	else
		local playerint = select(2, UnitStat("player", 4));
		local playeragi	= select(2, UnitStat("player", 2));
		local base, posBuff, negBuff = UnitAttackPower("player");
		local playerap = base + posBuff + negBuff;

		if (((playerap > playerint) or (playeragi > playerint)) and not (self.myclass == "SHAMAN" and tree ~= 1 and tree ~= 3) and not 
		(UnitBuff("player", GetSpellInfo(24858)) or UnitBuff("player", GetSpellInfo(65139)))) or self.myclass == "ROGUE" or self.myclass == "HUNTER" or (self.myclass == "SHAMAN" and tree == 2) then
			self.role = "Melee";
		else
			self.role = "Caster";
		end
	end
end

E:RegisterEvent("PLAYER_ENTERING_WORLD", "CheckRole");
E:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", "CheckRole");
E:RegisterEvent("PLAYER_TALENT_UPDATE", "CheckRole");
E:RegisterEvent("CHARACTER_POINTS_CHANGED", "CheckRole");
E:RegisterEvent("UNIT_INVENTORY_CHANGED", "CheckRole");
E:RegisterEvent("UPDATE_BONUS_ACTIONBAR", "CheckRole");

function E:PLAYER_LOGIN()
	E.EnteredWorld = true
	E:LoadConfig(); --Load In-Game Config
	E:UIScale(); --Set UIScale
	E:LoadMovers(); --Load Movers
	E:LoadCommands(); --Load Commands
		
	--Resize E.UIParent if Eyefinity is on.
	if E.eyefinity then
		local width = E.eyefinity;
		local height = E.screenheight;
		
		-- if autoscale is off, find a new width value of E.UIParent for screen #1.
		if not C["core"].autoscale or height > 1200 then
			local h = UIParent:GetHeight();
			local ratio = E.screenheight / h;
			local w = E.eyefinity / ratio;
			
			width = w;
			height = h;	
		end
		
		E.UIParent:SetSize(width, height);
	else
		E.UIParent:SetSize(UIParent:GetSize());
	end		
	
	E.UIParent:ClearAllPoints();
	E.UIParent:SetPoint("CENTER");
end
E:RegisterEvent("PLAYER_LOGIN");