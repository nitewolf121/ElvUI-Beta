local E, C, L, DF = unpack(select(2, ...)); --Load Ace3, Ace3-ConfigProfile, Locales, Defaults
local UF = E:NewModule('UnitFrames', 'AceTimer-3.0', 'AceEvent-3.0');
local LSM = LibStub("LibSharedMedia-3.0");

E.UnitFrames = UF;
--/run E, C, L = unpack(ElvUI); UF = E:GetModule('UnitFrames'); UF:Update_AllFrames()

local _, ns = ...
local ElvUF = ns.oUF

assert(ElvUF, "ElvUI was unable to locate oUF.")

UF['unitgroupstoload'] = {}
UF['unitstoload'] = {}

UF['handledgroupunits'] = {}
UF['handledunits'] = {}

UF['statusbars'] = {}
UF['fontstrings'] = {}
UF['aurafilters'] = {}

if C["unitframe"].enable ~= true then return; end

local find = string.find
local gsub = string.gsub

function UF:Construct_UF(frame, unit)
	frame:RegisterForClicks("AnyUp")
	frame:SetScript('OnEnter', UnitFrame_OnEnter)
	frame:SetScript('OnLeave', UnitFrame_OnLeave)	
	
	frame.menu = self.SpawnMenu
	
	frame:SetFrameLevel(5)
	
	if not self['handledgroupunits'][unit] then
		local stringTitle = E:StringTitle(unit)
		if stringTitle:find('target') then
			stringTitle = gsub(stringTitle, 'target', 'Target')
		end
		self["Construct_"..stringTitle.."Frame"](self, frame, unit)
	else
		self['handledgroupunits'][unit](self, frame, unit)
	end
	
	self:Update_StatusBars()
	self:Update_FontStrings()	
	return frame
end

function UF:GetTextOffset(position)
	local x, y = 0, 0
	if find(position, 'LEFT') then
		x = 2
	elseif find(position, 'RIGHT') then
		x = -2
	end					
	
	if find(position, 'TOP') then
		y = -2
	elseif find(position, 'BOTTOM') then
		y = 2
	end
	
	return x, y
end

function UF:GetAuraOffset(p1, p2)
	local x, y = 0, 0
	if p1 == "RIGHT" and p2 == "LEFT" then
		x = -3
	elseif p1 == "LEFT" and p2 == "RIGHT" then
		x = 3
	end
	
	if find(p1, 'TOP') and find(p2, 'BOTTOM') then
		y = -1
	elseif find(p1, 'BOTTOM') and find(p2, 'TOP') then
		y = 1
	end
	
	return E:Scale(x), E:Scale(y)
end

function UF:GetAuraAnchorFrame(frame, attachTo, otherAuraAnchor)
	if attachTo == otherAuraAnchor or attachTo == 'FRAME' then
		return frame
	elseif attachTo == 'BUFFS' then
		return frame.Buffs
	elseif attachTo == 'DEBUFFS' then
		return frame.Debuffs
	else
		return frame
	end
end

function UF:UpdateColors()
	local db = C['unitframe'].colors
	local tapped = db.tapped
	local dc = db.disconnected
	local mana = db.power.MANA
	local rage = db.power.RAGE
	local focus = db.power.FOCUS
	local energy = db.power.ENERGY
	local runic = db.power.RUNIC_POWER
	local good = db.reaction.GOOD
	local bad = db.reaction.BAD
	local neutral = db.reaction.NEUTRAL
	local health = db.health
	
	ElvUF['colors'] = setmetatable({
		tapped = {tapped.r, tapped.g, tapped.b},
		disconnected = {dc.r, dc.g, dc.b},
		health = {health.r, health.g, health.b},
		power = setmetatable({
			["MANA"] = {mana.r, mana.g, mana.b},
			["RAGE"] = {rage.r, rage.g, rage.b},
			["FOCUS"] = {focus.r, focus.g, focus.b},
			["ENERGY"] = {energy.r, energy.g, energy.b},
			["RUNES"] = {0.55, 0.57, 0.61},
			["RUNIC_POWER"] = {runic.r, runic.g, runic.b},
			["AMMOSLOT"] = {0.8, 0.6, 0},
			["FUEL"] = {0, 0.55, 0.5},
			["POWER_TYPE_STEAM"] = {0.55, 0.57, 0.61},
			["POWER_TYPE_PYRITE"] = {0.60, 0.09, 0.17},
		}, {__index = ElvUF['colors'].power}),
		runes = setmetatable({
				[1] = {.69,.31,.31},
				[2] = {.33,.59,.33},
				[3] = {.31,.45,.63},
				[4] = {.84,.75,.65},
		}, {__index = ElvUF['colors'].runes}),
		reaction = setmetatable({
			[1] = {bad.r, bad.g, bad.b}, -- Hated
			[2] = {bad.r, bad.g, bad.b}, -- Hostile
			[3] = {bad.r, bad.g, bad.b}, -- Unfriendly
			[4] = {neutral.r, neutral.g, neutral.b}, -- Neutral
			[5] = {good.r, good.g, good.b}, -- Friendly
			[6] = {good.r, good.g, good.b}, -- Honored
			[7] = {good.r, good.g, good.b}, -- Revered
			[8] = {good.r, good.g, good.b}, -- Exalted	
		}, {__index = ElvUF['colors'].reaction}),
		class = setmetatable({
			["DEATHKNIGHT"] = { 196/255,  30/255,  60/255 },
			["DRUID"]       = { 255/255, 125/255,  10/255 },
			["HUNTER"]      = { 171/255, 214/255, 116/255 },
			["MAGE"]        = { 104/255, 205/255, 255/255 },
			["PALADIN"]     = { 245/255, 140/255, 186/255 },
			["PRIEST"]      = { 212/255, 212/255, 212/255 },
			["ROGUE"]       = { 255/255, 243/255,  82/255 },
			["SHAMAN"]      = {  41/255,  79/255, 155/255 },
			["WARLOCK"]     = { 148/255, 130/255, 201/255 },
			["WARRIOR"]     = { 199/255, 156/255, 110/255 },
		}, {__index = ElvUF['colors'].class}),
		smooth = setmetatable({
			1, 0, 0,
			1, 1, 0,
			health.r, health.g, health.b
		}, {__index = ElvUF['colors'].smooth}),
		
	}, {__index = ElvUF['colors']})
end

function UF:Update_StatusBars()
	for statusbar in pairs(UF['statusbars']) do
		statusbar:SetStatusBarTexture(LSM:Fetch("statusbar", C["unitframe"].statusbar))
	end
end

function UF:Update_FontStrings()
	for font in pairs(UF['fontstrings']) do
		font:SetFontTemplate(LSM:Fetch("font", C["unitframe"].font), C['unitframe'].fontsize, C['unitframe'].fontoutline)
	end
end

function UF:Update_AllFrames()
	if InCombatLockdown() then return end
	self:UpdateColors()
	for unit in pairs(self['handledunits']) do
		if C['unitframe']['layouts'][self.ActiveLayout][unit].enable then
			self[unit]:Enable()
			
			local stringTitle = E:StringTitle(unit)
			if stringTitle:find('target') then
				stringTitle = gsub(stringTitle, 'target', 'Target')
			end			
			
			UF["Update_"..stringTitle.."Frame"](self, self[unit], C['unitframe']['layouts'][self.ActiveLayout][unit])
		else
			self[unit]:Disable()
		end
	end
end

function UF:CreateAndUpdateUFGroup(group, numGroup)
	if InCombatLockdown() then return end	
	
	self:UpdateColors()
	
	for i=1, numGroup do
		if C['unitframe']['layouts'][self.ActiveLayout][group].enable then
			local unit = group..i
			if not self[unit] then
				self['handledgroupunits'][unit] = UF["Construct_"..E:StringTitle(group).."Frames"]
				self[unit] = ElvUF:Spawn(unit, 'ElvUF_'..unit)
				self[unit].index = i
			else
				self[unit]:Enable()
			end
			
			UF["Update_"..E:StringTitle(group).."Frames"](self, self[unit], C['unitframe']['layouts'][self.ActiveLayout][group])	
		elseif self[unit] then
			self[unit]:Disable()
		end
	end
end

function UF:CreateAndUpdateUF(unit)
	assert(unit, 'No unit provided to create or update.')
	if InCombatLockdown() then return end
	
	self:UpdateColors()
	
	if C['unitframe']['layouts'][self.ActiveLayout][unit].enable then
		if not self[unit] then
			self[unit] = ElvUF:Spawn(unit, 'ElvUF_'..unit)
			self['handledunits'][unit] = true
		else
			self[unit]:Enable()
		end
		
		local stringTitle = E:StringTitle(unit)
		if stringTitle:find('target') then
			stringTitle = gsub(stringTitle, 'target', 'Target')
		end
		UF["Update_"..stringTitle.."Frame"](self, self[unit], C['unitframe']['layouts'][self.ActiveLayout][unit])
	elseif self[unit] then
		self[unit]:Disable()
	end
end


function UF:LoadUnits()
	for _, unit in pairs(self['unitstoload']) do
		self:CreateAndUpdateUF(unit)
	end	
	self['unitstoload'] = nil
	
	for group, numGroup in pairs(self['unitgroupstoload']) do
		self:CreateAndUpdateUFGroup(group, numGroup)
	end
	self['unitgroupstoload'] = nil
	
	ElvUF.SmoothInit()
end

function UF:UpdateActiveProfile()
	self.ActiveLayout = 'Primary'
	if C['unitframe'].secondaryLayout then
		if GetActiveTalentGroup() == 2 then
			self.ActiveLayout = 'Secondary'
			self:CopySettings('Primary', 'Secondary')
		end
	end
end

function UF:ACTIVE_TALENT_GROUP_CHANGED()
	if C['unitframe'].secondaryLayout then
		local oldLayout = self.ActiveLayout
		self:UpdateActiveProfile()
		
		if oldLayout ~= self.ActiveLayout then
			self:Update_AllFrames()
		end
	end
end

function UF:InitializeUF()	
	ElvUF:RegisterStyle('ElvUF', function(frame, unit)
		self:Construct_UF(frame, unit)
	end)
	
	self:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
	self:UpdateActiveProfile()
	
	self:LoadUnits()
end
UF:RegisterEvent('PLAYER_LOGIN', 'InitializeUF')

function UF:CopySettings(from, to, wipe)
	if not wipe then
		if not C['unitframe']['layouts'][to] then
			C['unitframe']['layouts'][to] = {}
		end
			
		for unit in pairs(C['unitframe']['layouts'][from]) do
			if not C['unitframe']['layouts'][to][unit] then 
				C['unitframe']['layouts'][to][unit] = {}
			end
			
			for option, value in pairs(C['unitframe']['layouts'][from][unit]) do
				if type(value) ~= 'table' then
					if not C['unitframe']['layouts'][to][unit][option] then
						C['unitframe']['layouts'][to][unit][option] = value
					end
				else
					if not C['unitframe']['layouts'][to][unit][option] then
						C['unitframe']['layouts'][to][unit][option] = {}
					end
					
					for opt, val in pairs(C['unitframe']['layouts'][from][unit][option]) do
						if type(val) ~= 'table' then
							if not C['unitframe']['layouts'][to][unit][option][opt] then
								C['unitframe']['layouts'][to][unit][option][opt] = val
							end
						else
							if not C['unitframe']['layouts'][to][unit][option][opt] then
								C['unitframe']['layouts'][to][unit][option][opt] = {}
							end
							for o, v in pairs(C['unitframe']['layouts'][from][unit][option][opt]) do
								if not C['unitframe']['layouts'][to][unit][option][opt][o] then
									C['unitframe']['layouts'][to][unit][option][opt][o] = v
								end								
							end
						end
					end
				end
			end
		end
	else
		C['unitframe']['layouts'][to] = {}
			
		for unit in pairs(C['unitframe']['layouts'][from]) do
			C['unitframe']['layouts'][to][unit] = {}
			
			for option, value in pairs(C['unitframe']['layouts'][from][unit]) do
				if type(value) ~= 'table' then
					C['unitframe']['layouts'][to][unit][option] = value
				else
					C['unitframe']['layouts'][to][unit][option] = {}
					
					for opt, val in pairs(C['unitframe']['layouts'][from][unit][option]) do
						if type(val) ~= 'table' then
							C['unitframe']['layouts'][to][unit][option][opt] = val
						else
							C['unitframe']['layouts'][to][unit][option][opt] = {}
							for o, v in pairs(C['unitframe']['layouts'][from][unit][option][opt]) do
								C['unitframe']['layouts'][to][unit][option][opt][o] = v							
							end
						end
					end
				end
			end
		end
	end
end

------------------------------------------------------------------------
--	Right-Click on unit frames menu.
------------------------------------------------------------------------

do
	UnitPopupMenus["SELF"] = { "PVP_FLAG", "LOOT_METHOD", "LOOT_THRESHOLD", "OPT_OUT_LOOT_TITLE", "LOOT_PROMOTE", "DUNGEON_DIFFICULTY", "RAID_DIFFICULTY", "RESET_INSTANCES", "RAID_TARGET_ICON", "SELECT_ROLE", "CONVERT_TO_PARTY", "CONVERT_TO_RAID", "LEAVE", "CANCEL" };
	UnitPopupMenus["PET"] = { "PET_PAPERDOLL", "PET_RENAME", "PET_ABANDON", "PET_DISMISS", "CANCEL" };
	UnitPopupMenus["PARTY"] = { "MUTE", "UNMUTE", "PARTY_SILENCE", "PARTY_UNSILENCE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "PROMOTE", "PROMOTE_GUIDE", "LOOT_PROMOTE", "VOTE_TO_KICK", "UNINVITE", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "SELECT_ROLE", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
	UnitPopupMenus["PLAYER"] = { "WHISPER", "INSPECT", "INVITE", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
	UnitPopupMenus["RAID_PLAYER"] = { "MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "SELECT_ROLE", "RAID_LEADER", "RAID_PROMOTE", "RAID_DEMOTE", "LOOT_PROMOTE", "RAID_REMOVE", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" };
	UnitPopupMenus["RAID"] = { "MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "RAID_LEADER", "RAID_PROMOTE", "RAID_MAINTANK", "RAID_MAINASSIST", "RAID_TARGET_ICON", "SELECT_ROLE", "LOOT_PROMOTE", "RAID_DEMOTE", "RAID_REMOVE", "PVP_REPORT_AFK", "CANCEL" };
	UnitPopupMenus["VEHICLE"] = { "RAID_TARGET_ICON", "VEHICLE_LEAVE", "CANCEL" }
	UnitPopupMenus["TARGET"] = { "RAID_TARGET_ICON", "CANCEL" }
	UnitPopupMenus["ARENAENEMY"] = { "CANCEL" }
	UnitPopupMenus["FOCUS"] = { "RAID_TARGET_ICON", "CANCEL" }
	UnitPopupMenus["BOSS"] = { "RAID_TARGET_ICON", "CANCEL" }
end