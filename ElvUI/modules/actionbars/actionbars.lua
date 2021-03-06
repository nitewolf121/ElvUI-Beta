local E, C, L, DF = unpack(select(2, ...)); --Load Ace3, Ace3-ConfigProfile, Locales, Defaults
local AB = E:NewModule('ActionBars', 'AceHook-3.0', 'AceEvent-3.0');
--/run E, C, L = unpack(ElvUI); AB = E:GetModule('ActionBars'); AB:ToggleMovers()
if C["actionbar"].enable ~= true then return; end
local Sticky = LibStub("LibSimpleSticky-1.0")
E.ActionBars = AB;

local gsub = string.gsub

--Make our own strings
local KEY_MOUSEBUTTON = KEY_BUTTON10;
KEY_MOUSEBUTTON = gsub(KEY_MOUSEBUTTON, '10', '');
local KEY_NUMPAD = KEY_NUMPAD0;
KEY_NUMPAD = gsub(KEY_NUMPAD, '0', '');

AB["handledbuttons"] = {} --List of all buttons that have been modified.
AB["movers"] = {} --List of all created movers.
AB["snapBars"] = { E.UIParent }

function AB:Load()
	self:DisableBlizzard()
	self:SecureHook('TalentFrame_LoadUI', 'FixKeybinds')
	self:SecureHook('ActionButton_Update', 'StyleButton')
	self:SecureHook('PetActionBar_Update', 'UpdatePet')
	self:SecureHook('ActionButton_UpdateHotkeys', 'FixKeybindText')
	self:SecureHook("ActionButton_UpdateFlyout", 'StyleFlyout')
	self:RawHook('ActionButton_HideGrid', E.noop, true)
	SetActionBarToggles(1, 1, 1, 1, 0)
	SetCVar("alwaysShowActionBars", 0)
	
	self:CreateActionBars()
	self:LoadKeyBinder()
	self:LoadButtonColoring()
	self:UpdateCooldownSettings()
	self:UnregisterEvent('PLAYER_ENTERING_WORLD')
end
AB:RegisterEvent('PLAYER_ENTERING_WORLD', 'Load')

function AB:CreateActionBars()
	self:CreateBar1()
	self:CreateBar2()
	self:CreateBar3()
	self:CreateBar4()
	self:CreateBar5()
	self:CreateBarPet()
	self:CreateBarShapeShift()
	if E.myclass == "SHAMAN" then
		self:CreateTotemBar()
	end	
	
	for button, _ in pairs(self["handledbuttons"]) do
		if button then
			self:StyleFlyout(button)
		else
			self["handledbuttons"][button] = nil
		end
	end	
end

function AB:UpdateButtonSettings()
	if InCombatLockdown() then E:Print(ERR_NOT_IN_COMBAT); return; end
	for button, _ in pairs(self["handledbuttons"]) do
		if button then
			self:StyleButton(button, button.noResize, button.noBackdrop)
			self:StyleFlyout(button)
		else
			self["handledbuttons"][button] = nil
		end
	end
	
	self:PositionAndSizeBar1()
	self:PositionAndSizeBar2()
	self:PositionAndSizeBar3()
	self:PositionAndSizeBar4()
	self:PositionAndSizeBar5()
	self:PositionAndSizeBarPet()
	self:PositionAndSizeBarShapeShift()
	
	--Movers snap update
	for _, mover in pairs(self["snapBars"]) do
		mover:SetScript("OnDragStart", function(mover) 
			if InCombatLockdown() then E:Print(ERR_NOT_IN_COMBAT) return end
			local offset = C["actionbar"].buttonspacing/2
			if mover.padding then offset = mover.padding end
			Sticky:StartMoving(mover, self["snapBars"], offset, offset, offset, offset)
		end)	
	end
end

function AB:GetPage(bar, defaultPage, condition)
	local page = C['actionbar'][bar]['paging'][E.myclass]
	if not condition then condition = '' end
	if not page then page = '' end
	if page then
		condition = condition.." "..page
	end
	condition = condition.." "..defaultPage
	return condition
end

function AB:StyleButton(button, noResize, noBackdrop)	
	local name = button:GetName();
	local icon = _G[name.."Icon"];
	local count = _G[name.."Count"];
	local flash	 = _G[name.."Flash"];
	local hotkey = _G[name.."HotKey"];
	local border  = _G[name.."Border"];
	local macroName = _G[name.."Name"];
	local normal  = _G[name.."NormalTexture"];
	local normal2 = button:GetNormalTexture()
	local shine = _G[name.."Shine"];
	local combat = InCombatLockdown()
	
	if flash then flash:SetTexture(nil); end
	if normal then normal:SetTexture(nil); normal:Hide(); normal:SetAlpha(0); end	
	if normal2 then normal2:SetTexture(nil); normal2:Hide(); normal2:SetAlpha(0); end	
	if border then border:Kill(); end
	
	if button:GetScale() > 0.5 then
		button:SetAlpha(1)
	end
	
	if not button.noResize then
		button.noResize = noResize;
	end
	
	if not button.noBackdrop then
		button.noBackdrop = noBackdrop;
	end
	
	if count then
		count:ClearAllPoints();
		count:SetPoint("BOTTOMRIGHT", 0, 2);
		count:SetFontTemplate(nil, 11, "THINOUTLINE");
	end
	
	if macroName then
		if C["actionbar"].macrotext then
			macroName:Show()
			macroName:SetFontTemplate(nil, 11, 'THINOUTLINE')
			macroName:ClearAllPoints()
			macroName:Point('BOTTOM', 2, 2)
			macroName:SetJustifyH('CENTER')
		else
			macroName:Hide()
		end
	end
	
	if not button.noBackdrop and not button.backdrop then
		button:CreateBackdrop('Default', true)
		button.backdrop:SetAllPoints()
	end
	
	if not button.noResize and not combat then
		if button.sizeOverride then
			button:Size(button.sizeOverride)
		else
			button:Size(C["actionbar"].buttonsize)
		end
	end
	
	if icon then
		icon:SetTexCoord(.08, .92, .08, .92);
		icon:ClearAllPoints()
		icon:Point('TOPLEFT', 2, -2)
		icon:Point('BOTTOMRIGHT', -2, 2)
	end
	
	if shine then
		shine:SetAllPoints()
	end
	
	if C["actionbar"].hotkeytext then
		hotkey:ClearAllPoints();
		hotkey:Point("TOPRIGHT", 0, -3);
		hotkey:SetFontTemplate(nil, C.actionbar.fontsize, "THINOUTLINE");
	end
	
	self:FixKeybindText(button);
	button:StyleButton();
	self["handledbuttons"][button] = true;
end

function AB:Bar_OnEnter(bar)
	UIFrameFadeIn(bar, 0.2, bar:GetAlpha(), 1)
end

function AB:Bar_OnLeave(bar)
	UIFrameFadeOut(bar, 0.2, bar:GetAlpha(), 0)
end

function AB:Button_OnEnter(button)
	local bar = button:GetParent()
	UIFrameFadeIn(bar, 0.2, bar:GetAlpha(), 1)
end

function AB:Button_OnLeave(button)
	local bar = button:GetParent()
	UIFrameFadeOut(bar, 0.2, bar:GetAlpha(), 0)
end

function AB:DisableBlizzard()
	MainMenuBar:SetScale(0.00001);
	MainMenuBar:EnableMouse(false);
	VehicleMenuBar:SetScale(0.00001);
	PetActionBarFrame:EnableMouse(false);
	ShapeshiftBarFrame:EnableMouse(false);
	
	local elements = {
		MainMenuBar, 
		MainMenuBarArtFrame, 
		BonusActionBarFrame, 
		VehicleMenuBar,
		PossessBarFrame, 
		PetActionBarFrame, 
		ShapeshiftBarFrame,
		ShapeshiftBarLeft, 
		ShapeshiftBarMiddle, 
		ShapeshiftBarRight,
	};
	for _, element in pairs(elements) do
		if element:GetObjectType() == "Frame" then
			element:UnregisterAllEvents();
			
			if element == MainMenuBarArtFrame then
				element:RegisterEvent("CURRENCY_DISPLAY_UPDATE");
			end
		end
		
		if element ~= MainMenuBar then
			element:Hide();
		end
		element:SetAlpha(0);
	end
	elements = nil;
	
	local uiManagedFrames = {
		"MultiBarLeft",
		"MultiBarRight",
		"MultiBarBottomLeft",
		"MultiBarBottomRight",
		"ShapeshiftBarFrame",
		"PossessBarFrame",
		"PETACTIONBAR_YPOS",
		"MultiCastActionBarFrame",
		"MULTICASTACTIONBAR_YPOS",
		--"ChatFrame1",
		--"ChatFrame2",
	};
	for _, frame in pairs(uiManagedFrames) do
		UIPARENT_MANAGED_FRAME_POSITIONS[frame] = nil;
	end
	uiManagedFrames = nil;
end

function AB:FixKeybinds()
	PlayerTalentFrame:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED');
end

function AB:FixKeybindText(button, type)
	local hotkey = _G[button:GetName()..'HotKey'];
	local text = hotkey:GetText();
	
	if text then
		text = gsub(text, L['KEY_LOCALE_SHIFT'], L['KEY_SHIFT']);
		text = gsub(text, L['KEY_LOCALE_ALT'], L['KEY_ALT']);
		text = gsub(text, L['KEY_LOCALE_CTRL'], L['KEY_CTRL']);
		text = gsub(text, KEY_MOUSEBUTTON, L['KEY_MOUSEBUTTON']);
		text = gsub(text, KEY_MOUSEWHEELUP, L['KEY_MOUSEWHEELUP']);
		text = gsub(text, KEY_MOUSEWHEELDOWN, L['KEY_MOUSEWHEELDOWN']);
		text = gsub(text, KEY_BUTTON3, L['KEY_BUTTON3']);
		text = gsub(text, KEY_NUMPAD, L['KEY_NUMPAD']);
		text = gsub(text, KEY_PAGEUP, L['KEY_PAGEUP']);
		text = gsub(text, KEY_PAGEDOWN, L['KEY_PAGEDOWN']);
		text = gsub(text, KEY_SPACE, L['KEY_SPACE']);
		text = gsub(text, KEY_INSERT, L['KEY_INSERT']);
		text = gsub(text, KEY_HOME, L['KEY_HOME']);
		text = gsub(text, KEY_DELETE, L['KEY_DELETE']);
		text = gsub(text, KEY_MOUSEWHEELUP, L['KEY_MOUSEWHEELUP']);
		text = gsub(text, KEY_MOUSEWHEELDOWN, L['KEY_MOUSEWHEELDOWN']);
		
		if hotkey:GetText() == RANGE_INDICATOR then
			hotkey:SetText('');
		else
			hotkey:SetText(text);
		end
	end
	
	if C["actionbar"].hotkeytext == true then
		hotkey:Show();
	else
		hotkey:Hide();
	end
	
	hotkey:ClearAllPoints();
	hotkey:Point("TOPRIGHT", 0, -3);	
end

function AB:ToggleMovers()
	for name, _ in pairs(self.movers) do
		local mover = self.movers[name].bar
		if mover:IsShown() then
			mover:Hide()
		else
			mover:Show()
		end
	end
end
TOGGLEAB = function() AB:ResetMovers() end

function AB:ResetMovers(bar)
	for name, _ in pairs(self.movers) do
		if name == bar then
			local mover = self.movers[name].bar
			mover:ClearAllPoints()
			mover:Point(self.movers[name]["p"], self.movers[name]["p2"], self.movers[name]["p3"], self.movers[name]["p4"], self.movers[name]["p5"])
			
			C['actionbar'][name]['position'] = nil
		end
	end
end

function AB:CreateMover(bar, text, name, padding)
	local p, p2, p3, p4, p5 = bar:GetPoint()

	local mover = CreateFrame('Button', nil, bar)
	mover:SetSize(bar:GetSize())
	mover:SetFrameStrata('HIGH')
	mover:SetTemplate('Default', true)	
	
	tinsert(AB["snapBars"], mover)
	
	if self.movers[name] == nil then 
		self.movers[name] = {}
		self.movers[name]["bar"] = mover
		self.movers[name]["p"] = p
		self.movers[name]["p2"] = p2 or E.UIParent
		self.movers[name]["p3"] = p3
		self.movers[name]["p4"] = p4
		self.movers[name]["p5"] = p5
	end	

	if C['actionbar'] and C['actionbar'][name] and C['actionbar'][name]["position"] then
		mover:SetPoint(C['actionbar'][name]["position"].p, E.UIParent, C['actionbar'][name]["position"].p2, C['actionbar'][name]["position"].p3, C['actionbar'][name]["position"].p4)
	else
		mover:SetPoint(p, p2, p3, p4, p5)
	end
	
	mover.padding = padding
	
	mover:RegisterForDrag("LeftButton", "RightButton")
	mover:SetScript("OnDragStart", function(self) 
		if InCombatLockdown() then E:Print(ERR_NOT_IN_COMBAT) return end
		local offset = C["actionbar"].buttonspacing/2
		if padding then offset = padding end
		Sticky:StartMoving(self, AB["snapBars"], offset, offset, offset, offset)
	end)
	
	mover:SetScript("OnDragStop", function(self) 
		if InCombatLockdown() then E:Print(ERR_NOT_IN_COMBAT) return end
		Sticky:StopMoving(self)
		
		C['actionbar'][name]['position'] = {}
		
		local p, _, p2, p3, p4 = self:GetPoint()
		C['actionbar'][name]['position']["p"] = p
		C['actionbar'][name]['position']["p2"] = p2
		C['actionbar'][name]['position']["p3"] = p3
		C['actionbar'][name]['position']["p4"] = p4
		AB:UpdateButtonSettings()
		
		self:SetUserPlaced(false)
	end)	
	
	bar:ClearAllPoints()
	bar:SetPoint(p3, mover, p3, 0, 0)

	local fs = mover:CreateFontString(nil, "OVERLAY")
	fs:SetFontTemplate()
	fs:SetJustifyH("CENTER")
	fs:SetPoint("CENTER")
	fs:SetText(text or name)
	fs:SetTextColor(unpack(E["media"].rgbvaluecolor))
	mover:SetFontString(fs)
	mover.text = fs
	
	mover:SetScript("OnEnter", function(self) 
		self.text:SetTextColor(1, 1, 1)
		self:SetBackdropBorderColor(unpack(E["media"].rgbvaluecolor))
	end)
	mover:SetScript("OnLeave", function(self)
		self.text:SetTextColor(unpack(E["media"].rgbvaluecolor))
		self:SetTemplate("Default", true)
	end)
	
	mover:SetMovable(true)
	mover:Hide()	
	bar.mover = mover
end


local buttons = 0
local function SetupFlyoutButton()
	for i=1, buttons do
		--prevent error if you don't have max ammount of buttons
		if _G["SpellFlyoutButton"..i] then
			AB:StyleButton(_G["SpellFlyoutButton"..i], true)
			_G["SpellFlyoutButton"..i]:StyleButton()
		end
	end
end
SpellFlyout:HookScript("OnShow", SetupFlyoutButton)


function AB:StyleFlyout(button)
	if not button.FlyoutBorder then return end
	local combat = InCombatLockdown()
	
	button.FlyoutBorder:SetAlpha(0)
	button.FlyoutBorderShadow:SetAlpha(0)
	
	SpellFlyoutHorizontalBackground:SetAlpha(0)
	SpellFlyoutVerticalBackground:SetAlpha(0)
	SpellFlyoutBackgroundEnd:SetAlpha(0)
	
	for i=1, GetNumFlyouts() do
		local x = GetFlyoutID(i)
		local _, _, numSlots, isKnown = GetFlyoutInfo(x)
		if isKnown then
			buttons = numSlots
			break
		end
	end
	
	--Change arrow direction depending on what bar the button is on
	local arrowDistance
	if ((SpellFlyout:IsShown() and SpellFlyout:GetParent() == button) or GetMouseFocus() == button) then
		arrowDistance = 5
	else
		arrowDistance = 2
	end

	if button:GetParent() and button:GetParent():GetParent() and button:GetParent():GetParent():GetName() and button:GetParent():GetParent():GetName() == "SpellBookSpellIconsFrame" then 
		return 
	end

	if button:GetParent() then
		local point = E:GetScreenQuadrant(button:GetParent())
		if point == "UNKNOWN" then return end
		
		if strfind(point, "TOP") then
			button.FlyoutArrow:ClearAllPoints()
			button.FlyoutArrow:SetPoint("BOTTOM", button, "BOTTOM", 0, -arrowDistance)
			SetClampedTextureRotation(button.FlyoutArrow, 180)
			if not combat then button:SetAttribute("flyoutDirection", "DOWN") end			
		elseif point == "RIGHT" then
			button.FlyoutArrow:ClearAllPoints()
			button.FlyoutArrow:SetPoint("LEFT", button, "LEFT", -arrowDistance, 0)
			SetClampedTextureRotation(button.FlyoutArrow, 270)
			if not combat then button:SetAttribute("flyoutDirection", "LEFT") end		
		elseif point == "LEFT" then
			button.FlyoutArrow:ClearAllPoints()
			button.FlyoutArrow:SetPoint("RIGHT", button, "RIGHT", arrowDistance, 0)
			SetClampedTextureRotation(button.FlyoutArrow, 90)
			if not combat then button:SetAttribute("flyoutDirection", "RIGHT") end				
		elseif point == "CENTER" or strfind(point, "BOTTOM") then
			button.FlyoutArrow:ClearAllPoints()
			button.FlyoutArrow:SetPoint("TOP", button, "TOP", 0, arrowDistance)
			SetClampedTextureRotation(button.FlyoutArrow, 0)
			if not combat then button:SetAttribute("flyoutDirection", "UP") end
		end
	end
end