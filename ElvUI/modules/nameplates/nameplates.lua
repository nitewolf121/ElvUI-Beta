local E, C, L, DF = unpack(select(2, ...)); --Load Ace3, Ace3-ConfigProfile, Locales, Defaults
local NP = E:NewModule('NamePlates', 'AceTimer-3.0', 'AceHook-3.0', 'AceEvent-3.0')
if C["nameplate"].enable ~= true then return end
E.NamePlates = NP

local OVERLAY = [=[Interface\TargetingFrame\UI-TargetingFrame-Flash]=]
local numChildren = -1
local backdrop
NP.Handled = {} --Skinned Nameplates

function NP:OnEnable()
	self.scanner = self:ScheduleRepeatingTimer("ScanForNameplates", 0.02)
end

function NP:QueueObject(frame, object)
	if not frame.queue then frame.queue = {} end
	frame.queue[object] = true
	
	if object.OldShow then
		object.Show = object.OldShow
		object:Show()
	end
	
	if object.OldTexture then
		object:SetTexture(object.OldTexture)
	end
	
	frame.hp:Hide()
	frame.hp:Show()
end

function NP:CreateVirtualFrame(parent, point)
	if point == nil then point = parent end
	local noscalemult = E.mult * UIParent:GetScale()
	
	if point.backdrop then return end
	point.backdrop = parent:CreateTexture(nil, "BORDER")
	point.backdrop:SetDrawLayer("BORDER", -8)
	point.backdrop:SetPoint("TOPLEFT", point, "TOPLEFT", -noscalemult*3, noscalemult*3)
	point.backdrop:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", noscalemult*3, -noscalemult*3)
	point.backdrop:SetTexture(0, 0, 0, 1)

	point.backdrop2 = parent:CreateTexture(nil, "BORDER")
	point.backdrop2:SetDrawLayer("BORDER", -7)
	point.backdrop2:SetAllPoints(point)
	point.backdrop2:SetTexture(unpack(E["media"].backdropcolor))	
	
	point.bordertop = parent:CreateTexture(nil, "BORDER")
	point.bordertop:SetPoint("TOPLEFT", point, "TOPLEFT", -noscalemult*2, noscalemult*2)
	point.bordertop:SetPoint("TOPRIGHT", point, "TOPRIGHT", noscalemult*2, noscalemult*2)
	point.bordertop:SetHeight(noscalemult)
	point.bordertop:SetTexture(unpack(E["media"].bordercolor))	
	point.bordertop:SetDrawLayer("BORDER", -7)
	
	point.borderbottom = parent:CreateTexture(nil, "BORDER")
	point.borderbottom:SetPoint("BOTTOMLEFT", point, "BOTTOMLEFT", -noscalemult*2, -noscalemult*2)
	point.borderbottom:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", noscalemult*2, -noscalemult*2)
	point.borderbottom:SetHeight(noscalemult)
	point.borderbottom:SetTexture(unpack(E["media"].bordercolor))	
	point.borderbottom:SetDrawLayer("BORDER", -7)
	
	point.borderleft = parent:CreateTexture(nil, "BORDER")
	point.borderleft:SetPoint("TOPLEFT", point, "TOPLEFT", -noscalemult*2, noscalemult*2)
	point.borderleft:SetPoint("BOTTOMLEFT", point, "BOTTOMLEFT", noscalemult*2, -noscalemult*2)
	point.borderleft:SetWidth(noscalemult)
	point.borderleft:SetTexture(unpack(E["media"].bordercolor))	
	point.borderleft:SetDrawLayer("BORDER", -7)
	
	point.borderright = parent:CreateTexture(nil, "BORDER")
	point.borderright:SetPoint("TOPRIGHT", point, "TOPRIGHT", noscalemult*2, noscalemult*2)
	point.borderright:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", -noscalemult*2, -noscalemult*2)
	point.borderright:SetWidth(noscalemult)
	point.borderright:SetTexture(unpack(E["media"].bordercolor))	
	point.borderright:SetDrawLayer("BORDER", -7)	
end

function NP:SetVirtualBorder(parent, r, g, b)
	parent.bordertop:SetTexture(r, g, b)
	parent.borderbottom:SetTexture(r, g, b)
	parent.borderleft:SetTexture(r, g, b)
	parent.borderright:SetTexture(r, g, b)
end

function NP:SetVirtualBackdrop(parent, r, g, b)
	parent.backdrop2:SetTexture(r, g, b)
end

--Run a function for all visible nameplates, we use this for the filter, to check unitguid, and to hide drunken text
function NP:ForEachPlate(functionToRun, ...)
	for frame, _ in pairs(NP.Handled) do
		frame = _G[frame]
		if frame and frame:IsShown() then
			functionToRun(NP, frame, ...)
		end
	end
end

function NP:HideObjects(frame)
	for object in pairs(frame.queue) do
		object.OldShow = object.Show
		object.Show = E.noop
		
		if object:GetObjectType() == "Texture" then
			object.OldTexture = object:GetTexture()
			object:SetTexture(nil)
		end
		
		object:Hide()
	end
end

function NP:CreateAuraIcon(parent)
	local noscalemult = E.mult * UIParent:GetScale()
	local button = CreateFrame("Frame",nil,parent)
	button:SetWidth(20)
	button:SetHeight(20)
	
	button.bg = button:CreateTexture(nil, "BACKGROUND")
	button.bg:SetTexture(unpack(E["media"].backdropcolor))
	button.bg:SetAllPoints(button)
	
	button.bord = button:CreateTexture(nil, "BORDER")
	button.bord:SetTexture(unpack(E["media"].bordercolor))
	button.bord:SetPoint("TOPLEFT",button,"TOPLEFT", noscalemult,-noscalemult)
	button.bord:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-noscalemult,noscalemult)
	
	button.bg2 = button:CreateTexture(nil, "ARTWORK")
	button.bg2:SetTexture(unpack(E["media"].backdropcolor))
	button.bg2:SetPoint("TOPLEFT",button,"TOPLEFT", noscalemult*2,-noscalemult*2)
	button.bg2:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-noscalemult*2,noscalemult*2)	
	
	button.icon = button:CreateTexture(nil, "OVERLAY")
	button.icon:SetPoint("TOPLEFT",button,"TOPLEFT", noscalemult*3,-noscalemult*3)
	button.icon:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-noscalemult*3,noscalemult*3)
	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	button.cd = CreateFrame("Cooldown",nil,button)
	button.cd:SetAllPoints(button)
	button.cd:SetReverse(true)
	button.cd.SizeOverride = 8
	button.count = button:CreateFontString(nil,"OVERLAY")
	button.count:SetFontTemplate(nil,7,'THINOUTLINE')
	button.count:SetShadowColor(0, 0, 0, 0.4)
	button.count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 2)
	return button
end

function NP:UpdateAuraIcon(button, unit, index, filter)
	local name,_,icon,count,debuffType,duration,expirationTime,_,_,_,spellID = UnitAura(unit,index,filter)
	
	button.icon:SetTexture(icon)
	button.cd:SetCooldown(expirationTime-duration,duration)
	button.expirationTime = expirationTime
	button.duration = duration
	button.spellID = spellID
	if count > 1 then 
		button.count:SetText(count)
	else
		button.count:SetText("")
	end
	button:Show()
end

function NP:OnAura(frame, unit)
	if not frame.icons or not frame.unit then return end
	local i = 1
	for index = 1,40 do
		if i > 5 then return end
		local match
		local name = UnitAura(frame.unit,index)
		local debuffName,_,_,_,_,_,_,caster = UnitAura(frame.unit,index, 'HARMFUL')
		
		if C["nameplate"].trackauras == true then
			if caster == "player" then match = 'HARMFUL' end
		end
		
		if C['nameplate'].trackfilter and #C['nameplate'].trackfilter > 1 and (name or debuffName) then
			local spellList = C['unitframe']['aurafilters'][C['nameplate'].trackfilter].spells
			if spellList[name] then
				match = 'HELPFUL'
			elseif spellList[debuffName] then
				match = 'HARMFUL'
			end				
		end
		
		if match then
			if not frame.icons[i] then frame.icons[i] = self:CreateAuraIcon(frame) end
			local icon = frame.icons[i]
			if i == 1 then icon:SetPoint("RIGHT",frame.icons,"RIGHT") end
			if i ~= 1 and i <= 5 then icon:SetPoint("RIGHT", frame.icons[i-1], "LEFT", -2, 0) end
			i = i + 1
			self:UpdateAuraIcon(icon, frame.unit, index, match)
		end
	end
	for index = i, #frame.icons do frame.icons[index]:Hide() end	
end

function NP:CastBar_OnShow(self, frame)
	if self.GetParent then frame = self; self = NP end
	frame:ClearAllPoints()
	frame:SetSize(frame:GetParent().hp:GetWidth(), C['nameplate'].cbheight)
	frame:SetPoint('TOP', frame:GetParent().hp, 'BOTTOM', 0, -8)
	frame:GetStatusBarTexture():SetHorizTile(true)
	if(frame.shield:IsShown()) then
		frame:SetStatusBarColor(0.78, 0.25, 0.25, 1)
	end	
	
	frame:SetStatusBarTexture(E["media"].normTex)
	self:SetVirtualBorder(frame, unpack(E["media"].bordercolor))
	self:SetVirtualBackdrop(frame, unpack(E["media"].backdropcolor))	
	
	frame.icon:Size(C["nameplate"].cbheight + frame:GetParent().hp:GetHeight() + 8)
	self:SetVirtualBorder(frame.icon, unpack(E["media"].bordercolor))
	self:SetVirtualBackdrop(frame.icon, unpack(E["media"].backdropcolor))		
end

function NP:CastBar_UpdateText(self, frame)
	if self.GetParent then frame = self; self = NP end
	local minValue, maxValue = frame:GetMinMaxValues()
	local curValue = frame:GetValue()
	
	if UnitChannelInfo("target") then
		frame.time:SetFormattedText("%.1f ", curValue)
		frame.name:SetText(select(1, (UnitChannelInfo("target"))))
	end
	
	if UnitCastingInfo("target") then
		frame.time:SetFormattedText("%.1f ", maxValue - curValue)
		frame.name:SetText(select(1, (UnitCastingInfo("target"))))
	end
end

function NP:CastBar_OnSizeChanged(self, frame)
	if self.GetParent then frame = self; self = NP end
	frame.needFix = true
end

function NP:CastBar_OnValueChanged(self, frame, curValue)
	if self.GetParent then frame = self; self = NP end
	self:CastBar_UpdateText(frame, curValue)
	if frame.needFix then
		self:CastBar_OnShow(frame)
		frame.needFix = nil
	end	
end

function NP:Colorize(frame)
	local r,g,b = frame.oldhp:GetStatusBarColor()
	for class, _ in pairs(RAID_CLASS_COLORS) do
		local r, g, b = floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100
		if RAID_CLASS_COLORS[class].r == r and RAID_CLASS_COLORS[class].g == g and RAID_CLASS_COLORS[class].b == b then
			frame.hasClass = true
			frame.isFriendly = false
			frame.hp:SetStatusBarColor(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b)
			return
		end
	end
	
	local color
	if g+b == 0 then -- hostile
		color = C["nameplate"].enemy
		r,g,b = color.r, color.g, color.b
		frame.isFriendly = false
	elseif r+b == 0 then -- friendly npc
		color = C["nameplate"].friendlynpc
		r,g,b = color.r, color.g, color.b
		frame.isFriendly = true
	elseif r+g > 1.95 then -- neutral
		color = C["nameplate"].neutral
		r,g,b = color.r, color.g, color.b
		frame.isFriendly = false
	elseif r+g == 0 then -- friendly player
		color = C["nameplate"].friendlyplayer
		r,g,b = color.r, color.g, color.b
		frame.isFriendly = true
	else -- enemy player
		frame.isFriendly = false
	end
	frame.hasClass = false
	
	frame.hp:SetStatusBarColor(r,g,b)
end

function NP:HealthBar_OnShow(self, frame)
	if self.GetParent then frame = self; self = NP end
	frame = frame:GetParent()
	
	local noscalemult = E.mult * UIParent:GetScale()
	local r, g, b = frame.hp:GetStatusBarColor()
	--Have to reposition this here so it doesnt resize after being hidden
	frame.hp:ClearAllPoints()
	frame.hp:Size(C["nameplate"].width, C["nameplate"].height)	
	frame.hp:SetPoint('BOTTOM', frame, 'BOTTOM', 0, 5)
	frame.hp:GetStatusBarTexture():SetHorizTile(true)

	self:HealthBar_ValueChanged(frame.oldhp)
	
	frame.hp.backdrop:SetPoint('TOPLEFT', -noscalemult*3, noscalemult*3)
	frame.hp.backdrop:SetPoint('BOTTOMRIGHT', noscalemult*3, -noscalemult*3)
	self:Colorize(frame)
	
	frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor = frame.hp:GetStatusBarColor()
	
	--Position Overlay
	frame.overlay:ClearAllPoints()
	frame.overlay:SetAllPoints(frame.hp)
	
	--Set the name text
	frame.hp.name:SetText(frame.hp.oldname:GetText())	

	--Level Text
	if C["nameplate"].showlevel == true then
		local level, elite, mylevel = tonumber(frame.hp.oldlevel:GetText()), frame.hp.elite:IsShown(), UnitLevel("player")
		frame.hp.level:ClearAllPoints()
		if C["nameplate"].showhealth == true then
			frame.hp.level:SetPoint("RIGHT", frame.hp, "RIGHT", 2, 0)
		else
			frame.hp.level:SetPoint("RIGHT", frame.hp, "LEFT", -1, 0)
		end
		
		frame.hp.level:SetTextColor(frame.hp.oldlevel:GetTextColor())
		if frame.hp.boss:IsShown() then
			frame.hp.level:SetText("??")
			frame.hp.level:SetTextColor(0.8, 0.05, 0)
			frame.hp.level:Show()
		elseif not elite and level == mylevel then
			frame.hp.level:Hide()
		elseif level then
			frame.hp.level:SetText(level..(elite and "+" or ""))
			frame.hp.level:Show()
		end
	elseif frame.hp.level then
		frame.hp.level:Hide()
	end	
	
	self:HideObjects(frame)
end

function NP:HealthBar_ValueChanged(frame)
	local frame = frame:GetParent()
	frame.hp:SetMinMaxValues(frame.oldhp:GetMinMaxValues())
	frame.hp:SetValue(frame.oldhp:GetValue())
end

function NP:OnHide(frame)
	frame.hp:SetStatusBarColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
	frame.hp.name:SetTextColor(1, 1, 1)
	frame.overlay:Hide()
	frame.cb:Hide()
	frame.unit = nil
	frame.threatStatus = nil
	frame.guid = nil
	frame.hasClass = nil
	frame.customColor = nil
	frame.customScale = nil
	frame.isFriendly = nil
	frame.hp.rcolor = nil
	frame.hp.gcolor = nil
	frame.hp.bcolor = nil
	if frame.icons then
		for _,icon in ipairs(frame.icons) do
			icon:Hide()
		end
	end	
end

function NP:SkinPlate(frame)
	local oldhp, cb = frame:GetChildren()
	local threat, hpborder, overlay, oldname, oldlevel, bossicon, raidicon, elite = frame:GetRegions()
	local _, cbborder, cbshield, cbicon = cb:GetRegions()
	
	--Health Bar
	if not frame.hp then
		frame.oldhp = oldhp
		frame.hp = CreateFrame("Statusbar", nil, frame)
		frame.hp:SetFrameLevel(oldhp:GetFrameLevel())
		frame.hp:SetFrameStrata(oldhp:GetFrameStrata())
		self:CreateVirtualFrame(frame.hp)
	end
	frame.hp:SetStatusBarTexture(E["media"].normTex)
	self:SetVirtualBackdrop(frame.hp, unpack(E["media"].backdropcolor))
	
	--Level Text
	if not frame.hp.level then
		frame.hp.level = frame.hp:CreateFontString(nil, "OVERLAY")
		frame.hp.level:SetFontTemplate(nil, 10, 'THINOUTLINE')
		frame.hp.oldlevel = oldlevel
		frame.hp.boss = bossicon
		frame.hp.elite = elite
	end
	
	--Name Text
	if not frame.hp.name then
		frame.hp.name = frame.hp:CreateFontString(nil, 'OVERLAY')
		frame.hp.name:SetPoint('BOTTOMLEFT', frame.hp, 'TOPLEFT', -10, 3)
		frame.hp.name:SetPoint('BOTTOMRIGHT', frame.hp, 'TOPRIGHT', 10, 3)
		frame.hp.name:SetFontTemplate(nil, 10, 'THINOUTLINE')
		frame.hp.oldname = oldname
	end

	--Health Text
	if not frame.hp.value then
		frame.hp.value = frame.hp:CreateFontString(nil, "OVERLAY")	
		frame.hp.value:SetPoint("CENTER", frame.hp)
		frame.hp.value:SetFontTemplate(nil, 10, 'THINOUTLINE')
	end
	
	--Overlay
	overlay.oldTexture = overlay:GetTexture()
	overlay:SetTexture(1,1,1,0.15)
	frame.overlay = overlay
	
	--Cast Bar
	if not frame.cb then
		self:CreateVirtualFrame(cb)
		frame.cb = cb
	end

	--Cast Time
	if not cb.time then
		cb.time = cb:CreateFontString(nil, "ARTWORK")
		cb.time:SetPoint("RIGHT", cb, "LEFT", -1, 0)
		cb.time:SetFontTemplate(nil, 10, 'THINOUTLINE')
	end
	
	--Cast Name
	if not cb.name then
		cb.name = cb:CreateFontString(nil, "ARTWORK")
		cb.name:SetPoint("TOP", cb, "BOTTOM", 0, -3)
		cb.name:SetFontTemplate(nil, 10, 'THINOUTLINE')
	end
	
	--Cast Icon
	if not cb.icon then
		cbicon:ClearAllPoints()
		cbicon:SetPoint("TOPLEFT", frame.hp, "TOPRIGHT", 8, 0)		
		cbicon:SetTexCoord(.07, .93, .07, .93)
		cbicon:SetDrawLayer("OVERLAY")
		cb.icon = cbicon
		cb.shield = cbshield
		self:CreateVirtualFrame(cb, cb.icon)
	end

	--Raid Icon
	if not frame.raidicon then
		raidicon:ClearAllPoints()
		raidicon:SetPoint("BOTTOM", frame.hp, "TOP", 0, 16)
		raidicon:SetSize(35, 35)
		raidicon:SetTexture([[Interface\AddOns\ElvUI_Launch\media\textures\raidicons.blp]])	
		frame.raidicon = raidicon	
	end
	
	-- Aura tracking
	if (C["nameplate"].trackauras == true or (C['nameplate'].trackfilter and #C['nameplate'].trackfilter > 1)) then
		if not frame.icons then
			frame.icons = CreateFrame("Frame",nil,frame)
			frame.icons:SetPoint("BOTTOMRIGHT",frame.hp.name,"TOPRIGHT", 0, 4)
			frame.icons:SetWidth(C["nameplate"].width)
			frame.icons:SetHeight(25)
			frame.icons:SetFrameLevel(frame.hp:GetFrameLevel()+2)
		end
		
		frame:RegisterEvent("UNIT_AURA")
		frame:HookScript("OnEvent", function(self, unit) NP:OnAura(self, unit) end)
	elseif not (C["nameplate"].trackauras == true and (not C['nameplate'].trackfilter or #C['nameplate'].trackfilter < 2)) and frame.icons then
		frame:UnregisterEvent('UNIT_AURA')
	elseif frame.icons then
		frame.icons:SetWidth(20 + C["nameplate"].width)
	end		
	
	--Hide Old Stuff
	self:QueueObject(frame, oldhp)
	self:QueueObject(frame, oldlevel)
	self:QueueObject(frame, threat)
	self:QueueObject(frame, hpborder)
	self:QueueObject(frame, cbshield)
	self:QueueObject(frame, cbborder)
	self:QueueObject(frame, oldname)
	self:QueueObject(frame, bossicon)
	self:QueueObject(frame, elite)
	
	self:HealthBar_OnShow(frame.hp)
	self:CastBar_OnShow(frame.cb)
	if not self.hooks[frame] then
		self:HookScript(frame.cb, 'OnShow', 'CastBar_OnShow')
		self:HookScript(frame.cb, 'OnSizeChanged', 'CastBar_OnSizeChanged')
		self:HookScript(frame.cb, 'OnValueChanged', 'CastBar_OnValueChanged')				
		self:HookScript(frame.hp, 'OnShow', 'HealthBar_OnShow')		
		self:HookScript(oldhp, 'OnValueChanged', 'HealthBar_ValueChanged')
		self:HookScript(frame, "OnHide", "OnHide")	
	end
	
	NP.Handled[frame:GetName()] = true
end

local good, bad, transition, transition2, combat, goodscale, badscale
function NP:UpdateThreat(frame)
	if frame.hasClass then return end
	combat = InCombatLockdown()
	good = C["nameplate"].goodcolor
	bad = C["nameplate"].badcolor
	goodscale = C["nameplate"].goodscale
	badscale = C["nameplate"].badscale
	transition = C["nameplate"].goodtransitioncolor
	transition2 = C["nameplate"].badtransitioncolor

	if C["nameplate"].enhancethreat ~= true then
		if(frame.region:IsShown()) then
			local _, val = frame.region:GetVertexColor()
			if(val > 0.7) then
				self:SetVirtualBorder(frame.hp, transition.r, transition.g, transition.b)
				if not frame.customScale and (goodscale ~= 1 or badscale ~= 1) then
					frame.hp:Height(C["nameplate"].height)
					frame.hp:Width(C['nameplate'].width)
				end					
			else
				self:SetVirtualBorder(frame.hp, bad.r, bad.g, bad.b)
				if not frame.customScale and badscale ~= 1 then
					frame.hp:Height(C["nameplate"].height * badscale)
					frame.hp:Width(C['nameplate'].width * badscale)
				end						
			end
		else
			self:SetVirtualBorder(frame.hp, unpack(E["media"].bordercolor))
			if not frame.customScale and goodscale ~= 1 then
				frame.hp:Height(C["nameplate"].height * goodscale)
				frame.hp:Width(C['nameplate'].width * goodscale)
			end								
		end
		frame.hp.name:SetTextColor(1, 1, 1)
	else
		if not frame.region:IsShown() then
			if combat and frame.isFriendly ~= true then
				--No Threat
				if E.role == "Tank" then
					if not frame.customColor then
						frame.hp:SetStatusBarColor(bad.r, bad.g, bad.b)
					end

					if not frame.customScale and badscale ~= 1 then
						frame.hp:Height(C["nameplate"].height * badscale)
						frame.hp:Width(C['nameplate'].width * badscale)
					end								
					frame.threatStatus = "BAD"
				else
					if not frame.customColor then
						frame.hp:SetStatusBarColor(good.r, good.g, good.b)
					end
					
					if not frame.customScale and goodscale ~= 1 then
						frame.hp:Height(C["nameplate"].height * goodscale)
						frame.hp:Width(C['nameplate'].width * goodscale)
					end					
					frame.threatStatus = "GOOD"
				end		
			else
				--Set colors to their original, not in combat
				if not frame.customColor then
					frame.hp:SetStatusBarColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
				end
				
				if not frame.customScale and (goodscale ~= 1 or badscale ~= 1) then
					frame.hp:Height(C["nameplate"].height)
					frame.hp:Width(C['nameplate'].width)
				end			
				frame.threatStatus = nil
			end
		else
			--Ok we either have threat or we're losing/gaining it
			local r, g, b = frame.region:GetVertexColor()
			if g + b == 0 then
				--Have Threat
				if E.role == "Tank" then
					if not frame.customColor then
						frame.hp:SetStatusBarColor(good.r, good.g, good.b)
					end
					
					if not frame.customScale and goodscale ~= 1 then
						frame.hp:Height(C["nameplate"].height * goodscale)
						frame.hp:Width(C['nameplate'].width * goodscale)
					end
					
					frame.threatStatus = "GOOD"
				else
					if not frame.customColor then
						frame.hp:SetStatusBarColor(bad.r, bad.g, bad.b)
					end
					
					if not frame.customScale and badscale ~= 1 then
						frame.hp:Height(C["nameplate"].height * badscale)
						frame.hp:Width(C['nameplate'].width * badscale)
					end					
					frame.threatStatus = "BAD"
				end
			else
				--Losing/Gaining Threat
				
				if not frame.customScale and (goodscale ~= 1 or badscale ~= 1) then
					frame.hp:Height(C["nameplate"].height)
					frame.hp:Width(C['nameplate'].width)
				end	
				
				if E.role == "Tank" then
					if frame.threatStatus == "GOOD" then
						--Losing Threat
						if not frame.customColor then
							frame.hp:SetStatusBarColor(transition2.r, transition2.g, transition2.b)	
						end
					else
						--Gaining Threat
						if not frame.customColor then
							frame.hp:SetStatusBarColor(transition.r, transition.g, transition.b)	
						end
					end
				else
					if frame.threatStatus == "GOOD" then
						--Losing Threat
						if not frame.customColor then
							frame.hp:SetStatusBarColor(transition.r, transition.g, transition.b)		
						end
					else
						--Gaining Threat
						if not frame.customColor then
							frame.hp:SetStatusBarColor(transition2.r, transition2.g, transition2.b)	
						end
					end				
				end
			end
		end
		
		if combat then
			frame.hp.name:SetTextColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
		else
			frame.hp.name:SetTextColor(1, 1, 1)
		end
	end
end

function NP:ScanHealth(frame)
	-- show current health value
	local minHealth, maxHealth = frame.oldhp:GetMinMaxValues()
	local valueHealth = frame.oldhp:GetValue()
	local d =(valueHealth/maxHealth)*100
	
	if C["nameplate"].showhealth == true then
		frame.hp.value:Show()
		frame.hp.value:SetText(E:ShortValue(valueHealth).." - "..(string.format("%d%%", math.floor((valueHealth/maxHealth)*100))))
	else
		frame.hp.value:Hide()
	end
			
	--Setup frame shadow to change depending on enemy players health, also setup targetted unit to have white shadow
	if frame.hasClass == true or frame.isFriendly == true then
		if(d <= 50 and d >= 20) then
			self:SetVirtualBorder(frame.hp, 1, 1, 0)
		elseif(d < 20) then
			self:SetVirtualBorder(frame.hp, 1, 0, 0)
		else
			self:SetVirtualBorder(frame.hp, unpack(E["media"].bordercolor))
		end
	elseif (frame.hasClass ~= true and frame.isFriendly ~= true) and C["nameplate"].enhancethreat == true then
		self:SetVirtualBorder(frame.hp, unpack(E["media"].bordercolor))
	end
end

--Attempt to match a nameplate with a GUID from the combat log
function NP:MatchGUID(frame, destGUID, spellID)
	if not frame.guid then return end

	if frame.guid == destGUID then
		for _,icon in ipairs(frame.icons) do 
			if icon.spellID == spellID then 
				icon:Hide() 
			end 
		end
	end
end

--Scan all visible nameplate for a known unit.
function NP:CheckUnit_Guid(frame, ...)
	--local numParty, numRaid = GetNumPartyMembers(), GetNumRaidMembers()
	if UnitExists("target") and frame:GetAlpha() == 1 and UnitName("target") == frame.hp.name:GetText() then
		frame.guid = UnitGUID("target")
		frame.unit = "target"
		self:OnAura(frame, "target")
	elseif frame.overlay:IsShown() and UnitExists("mouseover") and UnitName("mouseover") == frame.hp.name:GetText() then
		frame.guid = UnitGUID("mouseover")
		frame.unit = "mouseover"
		self:OnAura(frame, "mouseover")
	else
		frame.unit = nil
	end	
end

function NP:TogglePlate(frame, hide)
	if hide == true then
		frame.hp:Hide()
		frame.cb:Hide()
		frame.overlay:Hide()
		frame.overlay:SetTexture(nil)
		frame.hp.oldlevel:Hide()	
	else
		frame.hp:Show()
		frame.overlay:SetTexture(1, 1, 1, 0.15)	
	end
end

--Create our blacklist for nameplates, so prevent a certain nameplate from ever showing
function NP:CheckFilter(frame, ...)
	local name = frame.hp.name:GetText()
	local db = C["nameplate"]["filter"][name]
	
	if db and db.enable then
		if db.hide then
			self:TogglePlate(frame, true)
		else
			self:TogglePlate(frame, false)
			
			if db.customColor then
				frame.customColor = db.customColor

				frame.hp:SetStatusBarColor(db.color.r, db.color.g, db.color.b)
			else
				frame.customColor = nil	
			end
			
			if db.customScale and db.customScale ~= 1 then
				frame.hp:Height(C["nameplate"].height * db.customScale)
				frame.hp:Width(C['nameplate'].width * db.customScale)
				frame.customScale = db.customScale
			else
				frame.customScale = nil
			end
		end
	else
		self:TogglePlate(frame, false)
	end
end

function NP:COMBAT_LOG_EVENT_UNFILTERED(_, _, event, ...)
	if event == "SPELL_AURA_REMOVED" then
		local _, sourceGUID, _, _, _, destGUID, _, _, _, spellID = ...
		if sourceGUID == UnitGUID("player") then
			self:ForEachPlate(NP.MatchGUID, destGUID, spellID)
		end
	end
end

function NP:PLAYER_REGEN_ENABLED()
	SetCVar("nameplateShowEnemies", 0)
end

function NP:PLAYER_REGEN_DISABLED()
	SetCVar("nameplateShowEnemies", 1)
end

function NP:PLAYER_ENTERING_WORLD()
	if InCombatLockdown() then 
		SetCVar("nameplateShowEnemies", 1) 
	else 
		SetCVar("nameplateShowEnemies", 0) 
	end
end

function NP:UpdateAllPlates()
	for frame, _ in pairs(NP.Handled) do
		frame = _G[frame]
		self:SkinPlate(frame)
	end
	
	if C["nameplate"].trackauras == true or C["nameplate"].trackccauras == true then
		self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	else
		self:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	end
	
	if C["nameplate"].combat == true then
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
		self:RegisterEvent('PLAYER_REGEN_DISABLED')
		self:RegisterEvent('PLAYER_ENTERING_WORLD')
		NP:PLAYER_ENTERING_WORLD()
	else
		self:UnregisterEvent('PLAYER_REGEN_ENABLED')
		self:UnregisterEvent('PLAYER_REGEN_DISABLED')	
		SetCVar("nameplateShowEnemies", 1)
	end
end
NP:UpdateAllPlates()

function NP:HookFrames(...)
	for index = 1, select('#', ...) do
		local frame = select(index, ...)
		local region = frame:GetRegions()
		
		if(not NP.Handled[frame:GetName()] and (frame:GetName() and frame:GetName():find("NamePlate%d")) and region and region:GetObjectType() == 'Texture' and region:GetTexture() == OVERLAY) then
			NP:SkinPlate(frame)
			frame.region = region
		end
	end
end

function NP:ScanForNameplates()
	if(WorldFrame:GetNumChildren() ~= numChildren) then
		numChildren = WorldFrame:GetNumChildren()
		self:HookFrames(WorldFrame:GetChildren())
	end	
	
	self:ForEachPlate(NP.ScanHealth)
	self:ForEachPlate(NP.CheckUnit_Guid)
	self:ForEachPlate(NP.UpdateThreat)
	self:ForEachPlate(NP.CheckFilter)
end