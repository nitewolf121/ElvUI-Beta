local E, C, L, DF = unpack(select(2, ...)); --Load Ace3, Ace3-ConfigProfile, Locales, Defaults
local UF = E:GetModule('UnitFrames');
local LSM = LibStub("LibSharedMedia-3.0");
if C["unitframe"].enable ~= true then return; end

local abs = math.abs
local _, ns = ...
local ElvUF = ns.oUF
assert(ElvUF, "ElvUI was unable to locate oUF.")

local function GetHealthText(unit, r, g, b, min, max, reverse)
	local value
	if reverse then
		if C['unitframe']['layouts'][UF.ActiveLayout][unit]['health'].text_format == 'current-percent' then
			value = format("|cff%02x%02x%02x%d%%|r |cffD7BEA5-|r |cffAF5050%s|r", r * 255, g * 255, b * 255, floor(min / max * 100), E:ShortValue(min))
		elseif C['unitframe']['layouts'][UF.ActiveLayout][unit]['health'].text_format == 'current-max' then
			value = format("|cff%02x%02x%02x%s|r |cffD7BEA5-|r |cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, E:ShortValue(max), r * 255, g * 255, b * 255, E:ShortValue(min))
		elseif C['unitframe']['layouts'][UF.ActiveLayout][unit]['health'].text_format == 'current' then
			value = format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, E:ShortValue(min))	
		elseif C['unitframe']['layouts'][UF.ActiveLayout][unit]['health'].text_format == 'percent' then
			value = format("|cff%02x%02x%02x%d%%|r", r * 255, g * 255, b * 255, floor(min / max * 100))
		elseif C['unitframe']['layouts'][UF.ActiveLayout][unit]['health'].text_format == 'deficit' then
			value = format("|cff%02x%02x%02x-%d|r", r * 255, g * 255, b * 255, min)
		end	
	else
		if C['unitframe']['layouts'][UF.ActiveLayout][unit]['health'].text_format == 'current-percent' then
			value = format("|cffAF5050%s|r |cffD7BEA5-|r |cff%02x%02x%02x%d%%|r", E:ShortValue(min), r * 255, g * 255, b * 255, floor(min / max * 100))
		elseif C['unitframe']['layouts'][UF.ActiveLayout][unit]['health'].text_format == 'current-max' then
			value = format("|cff%02x%02x%02x%s|r |cffD7BEA5-|r |cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, E:ShortValue(min), r * 255, g * 255, b * 255, E:ShortValue(max))
		elseif C['unitframe']['layouts'][UF.ActiveLayout][unit]['health'].text_format == 'current' then
			value = format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, E:ShortValue(min))	
		elseif C['unitframe']['layouts'][UF.ActiveLayout][unit]['health'].text_format == 'percent' then
			value = format("|cff%02x%02x%02x%d%%|r", r * 255, g * 255, b * 255, floor(min / max * 100))
		elseif C['unitframe']['layouts'][UF.ActiveLayout][unit]['health'].text_format == 'deficit' then
			value = format("|cff%02x%02x%02x-%d|r", r * 255, g * 255, b * 255, min)
		end
	end
	
	return value
end

function UF:PostUpdateHealth(unit, min, max)
	local r, g, b = self:GetStatusBarColor()
	self.defaultColor = {r, g, b}
	
	if C["core"].classtheme then
		self.backdrop:SetBackdropBorderColor(r, g, b)
		if self:GetParent().Portrait and self:GetParent().Portrait.backdrop then
			self:GetParent().Portrait.backdrop:SetBackdropBorderColor(r, g, b)
		end
	end

	if C["unitframe"]['colors'].healthclass == true and C["unitframe"]['colors'].colorhealthbyvalue == true and not (UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)) then
		local newr, newg, newb = ElvUF.ColorGradient(min / max, 1, 0, 0, 1, 1, 0, r, g, b)

		self:SetStatusBarColor(newr, newg, newb)
		if self.bg and self.bg.multiplier then
			local mu = self.bg.multiplier
			self.bg:SetVertexColor(newr * mu, newg * mu, newb * mu)
		end
	end

	if C["unitframe"]['colors'].classbackdrop then
		local t
			if UnitIsPlayer(unit) then
				local _, class = UnitClass(unit)
				t = self:GetParent().colors.class[class]
			elseif UnitReaction(unit, 'player') then
				t = self:GetParent().colors.reaction[UnitReaction(unit, "player")]
			end

		if t then
			self.bg:SetVertexColor(t[1], t[2], t[3])
		end
	end
	
	--Backdrop
	if C['unitframe']['colors'].customhealthbackdrop then
		local backdrop = C["unitframe"]['colors'].health_backdrop
		self.bg:SetVertexColor(backdrop.r, backdrop.g, backdrop.b)		
	end	
	
	if not self.value or self.value and not self.value:IsShown() then return end
	
	local connected, dead, ghost = UnitIsConnected(unit), UnitIsDead(unit), UnitIsGhost(unit)
	if not connected or dead or ghost then
		if not connected then
			self.value:SetText("|cffD7BEA5"..L['Offline'].."|r")
		elseif dead then
			self.value:SetText("|cffD7BEA5"..DEAD.."|r")
		elseif ghost then
			self.value:SetText("|cffD7BEA5"..L['Ghost'].."|r")
		end
	else
		if min ~= max then
			local r, g, b = ElvUF.ColorGradient(min/max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
			local reverse
			if unit == "target" then
				reverse = true
			end
					
			self.value:SetText(GetHealthText(unit, r, g, b, min, max, reverse))
		else
			self.value:SetText("|cff559655"..E:ShortValue(max).."|r")
		end
	end
end

local function GetPowerText(unit, min, max, reverse)
	local value
	
	if reverse then
		if C['unitframe']['layouts'][UF.ActiveLayout][unit]['power'].text_format == 'current-percent' then
			value = format("%s |cffD7BEA5-|r %d%%", E:ShortValue(max - (max - min)), floor(min / max * 100))
		elseif C['unitframe']['layouts'][UF.ActiveLayout][unit]['power'].text_format == 'current-max' then
			value = format("%s |cffD7BEA5-|r %d%%", E:ShortValue(max - (max - min)), max)
		elseif C['unitframe']['layouts'][UF.ActiveLayout][unit]['power'].text_format == 'current' then
			value = format("%s", E:ShortValue(max - (max - min)))	
		elseif C['unitframe']['layouts'][UF.ActiveLayout][unit]['power'].text_format == 'percent' then
			value = format("%d%%", floor(min / max * 100))
		elseif C['unitframe']['layouts'][UF.ActiveLayout][unit]['power'].text_format == 'deficit' then
			value = format("-%d", min)
		end
	else
		if C['unitframe']['layouts'][UF.ActiveLayout][unit]['power'].text_format == 'current-percent' then
			value = format("%d%% |cffD7BEA5-|r %s", floor(min / max * 100), E:ShortValue(max - (max - min)))
		elseif C['unitframe']['layouts'][UF.ActiveLayout][unit]['power'].text_format == 'current-max' then
			value = format("%d%% |cffD7BEA5-|r %s", max, E:ShortValue(max - (max - min)))
		elseif C['unitframe']['layouts'][UF.ActiveLayout][unit]['power'].text_format == 'current' then
			value = format("%s", E:ShortValue(max - (max - min)))	
		elseif C['unitframe']['layouts'][UF.ActiveLayout][unit]['power'].text_format == 'percent' then
			value = format("%d%%", floor(min / max * 100))
		elseif C['unitframe']['layouts'][UF.ActiveLayout][unit]['power'].text_format == 'deficit' then
			value = format("-%d", min)
		end	
	end
	
	return value
end

function UF:PostNamePosition(frame, unit)
	if frame.Power.value:GetText() and UnitIsPlayer(unit) and frame.Power.value:IsShown() then
		local position = C['unitframe']['layouts'][UF.ActiveLayout][unit].name.position
		local x, y = self:GetTextOffset(position)
		frame.Power.value:SetAlpha(1)
		
		frame.Name:ClearAllPoints()
		frame.Name:Point(position, frame.Health, position, x, y)	
	elseif frame.Power.value:IsShown() then
		frame.Power.value:SetAlpha(0)
		
		frame.Name:ClearAllPoints()
		frame.Name:SetPoint(frame.Power.value:GetPoint())
	end
end

function UF:PostUpdatePower(unit, min, max)
	local pType, pToken, altR, altG, altB = UnitPowerType(unit)
	local color = ElvUF['colors'].power[pToken]
	local perc = floor(min / max * 100)
	
	if C["core"].classtheme then
		self.backdrop:SetBackdropBorderColor(self:GetParent().Health.backdrop:GetBackdropBorderColor())
	end
	
	if not self.value or self.value and not self.value:IsShown() then return end		

	if color then
		self.value:SetTextColor(color[1], color[2], color[3])
	else
		self.value:SetTextColor(altR, altG, altB, 1)
	end	

	if min == 0 then 
		self.value:SetText() 
	else
		if (not UnitIsPlayer(unit) and not UnitPlayerControlled(unit) or not UnitIsConnected(unit)) and not (unit and unit:find("boss%d")) then
			self.value:SetText()
		elseif UnitIsDead(unit) or UnitIsGhost(unit) then
			self.value:SetText()
		else
			if min ~= max then
				if pType == 0 then
					local reverse
					if unit == "target" then
						reverse = true
					end
					
					self.value:SetText(GetPowerText(unit, min, max, reverse))
				else
					self.value:SetText(max - (max - min))
				end
			else
				self.value:SetText(E:ShortValue(min))
			end
		end
	end
	
	if self.LowManaText then
		if pToken == 'MANA' then
			if perc <= C['unitframe']['layouts'][UF.ActiveLayout][unit].lowmana then
				self.LowManaText:SetText(LOW..' '..MANA)
				E:Flash(self.LowManaText, 0.6)
			else
				self.LowManaText:SetText()
				E:StopFlash(self.LowManaText)
			end
		else
			self.LowManaText:SetText()
			E:StopFlash(self.LowManaText)
		end
	end
	
	if C['unitframe']['layouts'][UF.ActiveLayout][unit] and C['unitframe']['layouts'][UF.ActiveLayout][unit]['power'].hideonnpc then
		UF:PostNamePosition(self:GetParent(), unit)
	end	
end

function UF:PortraitUpdate(unit)
	if not C['unitframe']['layouts'][UF.ActiveLayout][unit] then return end
	
	if C['unitframe']['layouts'][UF.ActiveLayout][unit]['portrait'].enable and C['unitframe']['layouts'][UF.ActiveLayout][unit]['portrait'].overlay then
		self:SetAlpha(0) self:SetAlpha(0.35) 
	else
		self:SetAlpha(1)
	end
	
	if self:GetModel() and self:GetModel().find and self:GetModel():find("worgenmale") then
		self:SetCamera(1)
	end	
end

local day, hour, minute, second = 86400, 3600, 60, 1
function UF:FormatTime(s, reverse)
	if s >= day then
		return format("%dd", ceil(s / hour))
	elseif s >= hour then
		return format("%dh", ceil(s / hour))
	elseif s >= minute then
		return format("%dm", ceil(s / minute))
	elseif s >= minute / 12 then
		return floor(s)
	end
	
	if reverse and reverse == true and s >= second then
		return floor(s)
	else	
		return format("%.1f", s)
	end
end

function UF:UpdateAuraTimer(elapsed)	
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 then
				local time = UF:FormatTime(self.timeLeft)
				if self.reverse then time = UF:FormatTime(abs(self.timeLeft - self.duration), true) end
				self.text:SetText(time)
				if self.timeLeft <= 5 then
					self.text:SetTextColor(0.99, 0.31, 0.31)
				else
					self.text:SetTextColor(1, 1, 1)
				end
			else
				self.text:Hide()
				self:SetScript("OnUpdate", nil)
			end
			if (not self.debuff) and C["core"].classtheme == true then
				local r, g, b = self:GetParent():GetParent().Health.backdrop:GetBackdropBorderColor()
				self:SetBackdropBorderColor(r, g, b)
			end
			self.elapsed = 0
		end
	end
end

function UF:PostUpdateAura(unit, button, index, offset, filter, isDebuff, duration, timeLeft)
	local name, _, _, _, dtype, duration, expirationTime, unitCaster, _, _, spellID = UnitAura(unit, index, button.filter)
	
	button.text:Show()
	button.text:SetFontTemplate(LSM:Fetch("font", C["unitframe"].font), C['unitframe']['layouts'][UF.ActiveLayout][unit][self.type].fontsize, 'THINOUTLINE')
	button.count:SetFontTemplate(LSM:Fetch("font", C["unitframe"].font), C['unitframe']['layouts'][UF.ActiveLayout][unit][self.type].fontsize, 'THINOUTLINE')
	
	if button.debuff then
		if(not UnitIsFriend("player", unit) and button.owner ~= "player" and button.owner ~= "vehicle") --[[and (not E.DebuffWhiteList[name])]] then
			button:SetBackdropBorderColor(unpack(E["media"].bordercolor))
			button.icon:SetDesaturated(true)
		else
			local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
			if (name == "Unstable Affliction" or name == "Vampiric Touch") and E.myclass ~= "WARLOCK" then
				button:SetBackdropBorderColor(0.05, 0.85, 0.94)
			else
				button:SetBackdropBorderColor(color.r * 0.6, color.g * 0.6, color.b * 0.6)
			end
			button.icon:SetDesaturated(false)
		end
	else
		if (button.isStealable or ((E.myclass == "PRIEST" or E.myclass == "SHAMAN" or E.myclass == "MAGE") and dtype == "Magic")) and not UnitIsFriend("player", unit) then
			button:SetBackdropBorderColor(237/255, 234/255, 142/255)
		else
			if C["core"].classtheme == true then
				local r, g, b = button:GetParent():GetParent().Health.backdrop:GetBackdropBorderColor()
				button:SetBackdropBorderColor(r, g, b)
			else
				button:SetBackdropBorderColor(unpack(E["media"].bordercolor))
			end			
		end	
	end
	
	button.duration = duration
	button.timeLeft = expirationTime
	button.first = true	
	
	local size = button:GetParent().size
	if size then
		button:Size(size)
	end
	
	--[[if E.ReverseTimer and E.ReverseTimer[spellID] then 
		button.reverse = true 
	else
		button.reverse = nil
	end]]
	
	button:SetScript('OnUpdate', UF.UpdateAuraTimer)
end

function UF:CustomCastDelayText(duration)
	self.Time:SetText(("%.1f |cffaf5050%s %.1f|r"):format(self.channeling and duration or self.max - duration, self.channeling and "- " or "+", self.delay))
end

function UF:PostCastStart(unit, name, rank, castid)
	if unit == "vehicle" then unit = "player" end
	self.Text:SetText(string.sub(name, 0, math.floor((((32/245) * self:GetWidth()) / C["unitframe"].fontsize) * 12)))
		
	local color
	if not C['unitframe']['layouts'][UF.ActiveLayout][unit] then return end
	if self.interrupt and unit ~= "player" then
		if UnitCanAttack("player", unit) then
			color = C['unitframe']['layouts'][UF.ActiveLayout][unit]['castbar']['interruptcolor']
			self:SetStatusBarColor(color.r, color.g, color.b)
		else
			color = C['unitframe']['layouts'][UF.ActiveLayout][unit]['castbar']['color']
			self:SetStatusBarColor(color.r, color.g, color.b)
		end
	else
		if C["core"].classtheme ~= true then
			color = C['unitframe']['layouts'][UF.ActiveLayout][unit]['castbar']['color']
			self:SetStatusBarColor(color.r, color.g, color.b)
		else
			self:SetStatusBarColor(self:GetParent().Health.backdrop:GetBackdropBorderColor())
			if self.bg then self.bg:SetBackdropBorderColor(self:GetStatusBarColor()) end
			if self.Icon and self.Icon.bg then self.Icon.bg:SetBackdropBorderColor(self:GetStatusBarColor()) end				
		end	
	end
end

function UF:PostCastInterruptible(unit)
	if not C['unitframe']['layouts'][UF.ActiveLayout][unit] then return end
	
	if unit == "vehicle" then unit = "player" end
	if unit ~= "player" then
		local color
		if UnitCanAttack("player", unit) then
			color = C['unitframe']['layouts'][UF.ActiveLayout][unit]['castbar'].interruptcolor
		else
			color = C['unitframe']['layouts'][UF.ActiveLayout][unit]['castbar'].color
		end		
		self:SetStatusBarColor(color.r, color.g, color.b)
	end
end

function UF:PostCastNotInterruptible(unit)
	local color = C['unitframe']['layouts'][UF.ActiveLayout][unit]['castbar'].interruptcolor
	self:SetStatusBarColor(color.r, color.g, color.b)
end

function UF:UpdateHoly(event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= 'HOLY_POWER')) then return end
	local num = UnitPower(unit, SPELL_POWER_HOLY_POWER)

	for i = 1, MAX_HOLY_POWER do
		if(i <= num) then
			self.HolyPower[i]:SetAlpha(1)
		else
			self.HolyPower[i]:SetAlpha(.2)
		end
	end
end	

function UF:UpdateShards(event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= 'SOUL_SHARDS')) then return end
	local num = UnitPower(unit, SPELL_POWER_SOUL_SHARDS)
	for i = 1, SHARD_BAR_NUM_SHARDS do
		if(i <= num) then
			self.SoulShards[i]:SetAlpha(1)
		else
			self.SoulShards[i]:SetAlpha(.2)
		end
	end
end

function UF:EclipseDirection()
	local direction = GetEclipseDirection()
	if direction == "sun" then
		self.Text:SetText(">")
		self.Text:SetTextColor(.2,.2,1,1)
	elseif direction == "moon" then
		self.Text:SetText("<")
		self.Text:SetTextColor(1,1,.3, 1)
	else
		self.Text:SetText("")
	end
end

function UF:DruidResourceBarVisibilityUpdate(unit)
	local db = C['unitframe']['layouts'][UF.ActiveLayout].player
	local health = self:GetParent().Health
	local frame = self:GetParent()
	local PORTRAIT_WIDTH = db.portrait.width
	local USE_PORTRAIT = db.portrait.enable
	local USE_PORTRAIT_OVERLAY = db.portrait.overlay and USE_PORTRAIT
	local eclipseBar = self:GetParent().EclipseBar
	local druidAltMana = self:GetParent().DruidAltMana
	local CLASSBAR_HEIGHT = db.classbar.height
	local USE_CLASSBAR = db.classbar.enable
	local USE_MINI_CLASSBAR = db.classbar.fill == "spaced" and USE_CLASSBAR
	
	if USE_PORTRAIT_OVERLAY or not USE_PORTRAIT then
		PORTRAIT_WIDTH = 0
	end
	
	if USE_MINI_CLASSBAR then
		CLASSBAR_HEIGHT = CLASSBAR_HEIGHT / 2
	end
	
	if eclipseBar:IsShown() or druidAltMana:IsShown() then
		if db.power.offset ~= 0 then
			health:Point("TOPRIGHT", frame, "TOPRIGHT", -(2+db.power.offset), -(2 + CLASSBAR_HEIGHT + 1))
		else
			health:Point("TOPRIGHT", frame, "TOPRIGHT", -2, -(2 + CLASSBAR_HEIGHT + 1))
		end
		health:Point("TOPLEFT", frame, "TOPLEFT", PORTRAIT_WIDTH + 2, -(2 + CLASSBAR_HEIGHT + 1))	
	else
		if db.power.offset ~= 0 then
			health:Point("TOPRIGHT", frame, "TOPRIGHT", -(2 + db.power.offset), -2)
		else
			health:Point("TOPRIGHT", frame, "TOPRIGHT", -2, -2)
		end
		health:Point("TOPLEFT", frame, "TOPLEFT", PORTRAIT_WIDTH + 2, -2)	
	end
end

function UF:DruidPostUpdateAltPower(unit, min, max)
	local powerText = self:GetParent().Power.value
	
	if min ~= max then
		local color = ElvUF['colors'].power['MANA']
		color = E:RGBToHex(color[1], color[2], color[3])
		
		self.Text:ClearAllPoints()
		if powerText:GetText() then
			if select(4, powerText:GetPoint()) < 0 then
				self.Text:SetPoint("RIGHT", powerText, "LEFT", 3, 0)
				self.Text:SetFormattedText(color.."%d%%|r |cffD7BEA5- |r", floor(min / max * 100))			
			else
				self.Text:SetPoint("LEFT", powerText, "RIGHT", -3, 0)
				self.Text:SetFormattedText("|cffD7BEA5-|r"..color.." %d%%|r", floor(min / max * 100))
			end
		else
			self.Text:SetPoint(powerText:GetPoint())
			self.Text:SetFormattedText(color.."%d%%|r", floor(min / max * 100))
		end	
	else
		self.Text:SetText()
	end
end

function UF:UpdatePvPText(frame)
	local unit = frame.unit
	local PvPText = frame.PvPText
	local LowManaText = frame.Power.LowManaText
	
	if PvPText and frame:IsMouseOver() then
		PvPText:Show()
		if LowManaText and LowManaText:IsShown() then LowManaText:Hide() end
		
		local time = GetPVPTimer()
		local min = format("%01.f", floor((time / 1000) / 60))
		local sec = format("%02.f", floor((time / 1000) - min * 60)) 
		
		if(UnitIsPVPFreeForAll(unit)) then
			if time ~= 301000 and time ~= -1 then
				PvPText:SetText(PVP.." ".."("..min..":"..sec..")")
			else
				PvPText:SetText(PVP)
			end
		elseif UnitIsPVP(unit) then
			if time ~= 301000 and time ~= -1 then
				PvPText:SetText(PVP.." ".."("..min..":"..sec..")")
			else
				PvPText:SetText(PVP)
			end
		else
			PvPText:SetText("")
		end
	elseif PvPText then
		PvPText:Hide()
		if LowManaText and not LowManaText:IsShown() then LowManaText:Show() end
	end
end

function UF:UpdateThreat(event, unit)
	if (self.unit ~= unit) or not unit then return end
	local status = UnitThreatSituation(unit)
	
	if status and status > 1 then
		local r, g, b = GetThreatStatusColor(status)
		if self.Threat and self.Threat:GetBackdrop() then
			self.Threat:Show()
			self.Threat:SetBackdropBorderColor(r, g, b)
		elseif self.Health.backdrop then
			self.Health.backdrop:SetBackdropBorderColor(r, g, b)
			
			if self.Power and self.Power.backdrop then
				self.Power.backdrop:SetBackdropBorderColor(r, g, b)
			end
		end
	else
		if self.Threat and self.Threat:GetBackdrop() then
			self.Threat:Hide()
		elseif self.Health.backdrop then
			self.Health.backdrop:SetTemplate("Default")
			
			if self.Power and self.Power.backdrop then
				self.Power.backdrop:SetTemplate("Default")
			end
		end	
	end
end

function UF:AltPowerBarPostUpdate(min, cur, max)
	local perc = math.floor((cur/max)*100)
	
	if perc < 35 then
		self:SetStatusBarColor(0, 1, 0)
	elseif perc < 70 then
		self:SetStatusBarColor(1, 1, 0)
	else
		self:SetStatusBarColor(1, 0, 0)
	end
	
	local unit = self:GetParent().unit
	
	if unit == "player" and self.text then 
		local type = select(10, UnitAlternatePowerInfo(unit))
				
		if perc > 0 then
			self.text:SetText(type..": "..format("%d%%", perc))
		else
			self.text:SetText(type..": 0%")
		end
	elseif unit and unit:find("boss%d") and self.text then
		self.text:SetTextColor(self:GetStatusBarColor())
		if not self:GetParent().Power.value:GetText() or self:GetParent().Power.value:GetText() == "" then
			self.text:Point("BOTTOMRIGHT", self:GetParent().Health, "BOTTOMRIGHT")
		else
			self.text:Point("RIGHT", self:GetParent().Power.value.value, "LEFT", 2, E.mult)	
		end
		if perc > 0 then
			self.text:SetText("|cffD7BEA5[|r"..format("%d%%", perc).."|cffD7BEA5]|r")
		else
			self.text:SetText(nil)
		end
	end
end

function UF:UpdateComboDisplay(event, unit)
	if(unit == 'pet') then return end
	
	local cpoints = self.CPoints
	local cp
	if (UnitHasVehicleUI("player") or UnitHasVehicleUI("vehicle")) then
		cp = GetComboPoints('vehicle', 'target')
	else
		cp = GetComboPoints('player', 'target')
	end

	for i=1, MAX_COMBO_POINTS do
		if(i <= cp) then
			cpoints[i]:SetAlpha(1)
		else
			cpoints[i]:SetAlpha(0.15)
		end
	end
	
	local BORDER = E:Scale(2)
	local SPACING = E:Scale(1)
	local db = C['unitframe']['layouts'][UF.ActiveLayout].target
	local USE_COMBOBAR = db.combobar.enable
	local USE_MINI_COMBOBAR = db.combobar.fill == "spaced" and USE_COMBOBAR
	local COMBOBAR_HEIGHT = db.combobar.height
	local USE_PORTRAIT = db.portrait.enable
	local USE_PORTRAIT_OVERLAY = db.portrait.overlay and USE_PORTRAIT	
	local PORTRAIT_WIDTH = db.portrait.width
	

	if USE_PORTRAIT_OVERLAY or not USE_PORTRAIT then
		PORTRAIT_WIDTH = 0
	end
	
	if cpoints[1]:GetAlpha() == 1 then
		cpoints:Show()
		if USE_MINI_COMBOBAR then
			self.Portrait.backdrop:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, -((COMBOBAR_HEIGHT/2) + SPACING - BORDER))
			self.Health:Point("TOPRIGHT", self, "TOPRIGHT", -(BORDER+PORTRAIT_WIDTH), -(SPACING + (COMBOBAR_HEIGHT/2)))
		else
			self.Portrait.backdrop:SetPoint("TOPRIGHT", self, "TOPRIGHT")
			self.Health:Point("TOPRIGHT", self, "TOPRIGHT", -(BORDER+PORTRAIT_WIDTH), -(BORDER + SPACING + COMBOBAR_HEIGHT))
		end		

	else
		cpoints:Hide()
		self.Portrait.backdrop:SetPoint("TOPRIGHT", self, "TOPRIGHT")
		self.Health:Point("TOPRIGHT", self, "TOPRIGHT", -(BORDER+PORTRAIT_WIDTH), -BORDER)
	end
end

function UF:AuraFilter(unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster)	
	local isPlayer, isFriend
	local frameUnit = self:GetParent().unit
	
	local db = C['unitframe']['layouts'][UF.ActiveLayout][frameUnit]
	if(caster == 'player' or caster == 'vehicle') then
		isPlayer = true
	end
	
	if UnitIsFriend('player', frameUnit) then
		isFriend = true
	end
	
	icon.isPlayer = isPlayer
	icon.owner = caster
	
	if db and db[self.type].durationLimit ~= 0 then
		if duration > db[self.type].durationLimit or duration == 0 then
			return false
		end
	end
	
	if db and db[self.type].showPlayerOnly and isPlayer then
		return true
	elseif db and db[self.type].useFilter and C['unitframe']['aurafilters'][db[self.type].useFilter] then
		local type = C['unitframe']['aurafilters'][db[self.type].useFilter].type
		local spellList = C['unitframe']['aurafilters'][db[self.type].useFilter].spells
		
		--Prevent filtering on friendly target's debuffs.
		if (frameUnit:find('target') or frameUnit == 'focus') and isFriend and self.type == 'debuffs' and type == 'Whitelist' then
			return true
		end
		
		if type == 'Whitelist' then
			if spellList[name] then
				return true
			else
				return false
			end		
		elseif type == 'Blacklist' then
			if spellList[name] then
				return false
			else
				return true
			end				
		end
	elseif frameUnit:find('raid%d') then --Raid Frames
	
	elseif frameUnit:find('boss%d') then --Boss Frames
	
	elseif frameUnit:find('arena%d') then --Arena Frames
	
	else
		if db and not db[self.type].showPlayerOnly then
			return true
		else
			return false
		end
	end	
end
