local E, C, L, DF = unpack(select(2, ...)); --Load Ace3, Ace3-ConfigProfile, Locales, Defaults
local AB = E:GetModule('ActionBars');
if C["actionbar"].enable ~= true then return; end

local ceil = math.ceil;

local bar = CreateFrame('Frame', 'ElvUI_BarShapeShift', E.UIParent, 'SecureHandlerStateTemplate');
bar:CreateBackdrop('Default');
bar.backdrop:SetAllPoints();
bar:Point('TOPLEFT', E.UIParent, 'TOPLEFT', 4, -4);

local states = {
	["DRUID"] = "show",
	["WARRIOR"] = "show",
	["PALADIN"] = "show",
	["DEATHKNIGHT"] = "show",
	["ROGUE"] = "show,",
	["PRIEST"] = "show,",
	["HUNTER"] = "show,",
	["WARLOCK"] = "show,",
};

function AB:StyleShapeShift()
	local numForms = GetNumShapeshiftForms();
	local texture, name, isActive, isCastable;
	local buttonName, button, icon, cooldown;
	local start, duration, enable;
	
	for i = 1, NUM_SHAPESHIFT_SLOTS do
		buttonName = "ShapeshiftButton"..i;
		button = _G[buttonName];
		icon = _G[buttonName.."Icon"];
		cooldown = _G[buttonName.."Cooldown"];
		
		if i <= numForms then
			texture, name, isActive, isCastable = GetShapeshiftFormInfo(i);
			icon:SetTexture(texture);
			
			if texture then
				cooldown:SetAlpha(1);
			else
				cooldown:SetAlpha(0);
			end
			
			start, duration, enable = GetShapeshiftFormCooldown(i);
			CooldownFrame_SetTimer(cooldown, start, duration, enable);
			
			if isActive then
				ShapeshiftBarFrame.lastSelected = button:GetID();
				button:SetChecked(1);
			else
				button:SetChecked(0);
			end

			if isCastable then
				icon:SetVertexColor(1.0, 1.0, 1.0);
			else
				icon:SetVertexColor(0.4, 0.4, 0.4);
			end
		end
	end
end

function AB:AdjustMaxShapeShiftButtons()
	if InCombatLockdown() then return; end
	
	local button;
	for i = 1, NUM_SHAPESHIFT_SLOTS do
		button = _G["ShapeshiftButton"..i];
		local _, name = GetShapeshiftFormInfo(i);
		if name then
			button:Show();
			bar.LastButton = i;
		else
			button:Hide();
		end
	end
	self:PositionAndSizeBarShapeShift();
end

function AB:PositionAndSizeBarShapeShift()
	local spacing = E:Scale(C['actionbar'].buttonspacing);
	local buttonsPerRow = C['actionbar']['bar1'].buttonsPerRow;
	local numButtons = C['actionbar']['bar1'].buttons;
	local size = E:Scale(C['actionbar'].altbuttonsize);
	local point = C['actionbar']['barShapeShift'].point;
	local widthMult = C['actionbar']['barShapeShift'].widthMult;
	local heightMult = C['actionbar']['barShapeShift'].heightMult;

	if bar.LastButton and numButtons > bar.LastButton then	
		numButtons = bar.LastButton;
	end

	if bar.LastButton and buttonsPerRow > bar.LastButton then	
		buttonsPerRow = bar.LastButton;
	end
	
	if numButtons < buttonsPerRow then
		buttonsPerRow = numButtons;
	end
	
	local numColumns = ceil(numButtons / buttonsPerRow);
	if numColumns < 1 then
		numColumns = 1;
	end

	bar:SetWidth(spacing + ((size * (buttonsPerRow * widthMult)) + ((spacing * (buttonsPerRow - 1)) * widthMult) + (spacing * widthMult)));
	bar:SetHeight(spacing + ((size * (numColumns * heightMult)) + ((spacing * (numColumns - 1)) * heightMult) + (spacing * heightMult)));
	bar.mover:SetSize(bar:GetSize());

	if C['actionbar']['barShapeShift'].enabled then
		bar:SetScale(1);
		bar:SetAlpha(1);
	else
		bar:SetScale(0.000001);
		bar:SetAlpha(0);
	end
	
	if C['actionbar']['barShapeShift'].backdrop == true then
		bar.backdrop:Show();
	else
		bar.backdrop:Hide();
	end
	
	local horizontalGrowth, verticalGrowth;
	if point == "TOPLEFT" or point == "TOPRIGHT" then
		verticalGrowth = "DOWN";
	else
		verticalGrowth = "UP";
	end
	
	if point == "BOTTOMLEFT" or point == "TOPLEFT" then
		horizontalGrowth = "RIGHT";
	else
		horizontalGrowth = "LEFT";
	end
	
	local button, lastButton, lastColumnButton;
	local possibleButtons = {};
	for i=1, NUM_SHAPESHIFT_SLOTS do
		button = _G["ShapeshiftButton"..i];
		lastButton = _G["ShapeshiftButton"..i-1];
		lastColumnButton = _G["ShapeshiftButton"..i-buttonsPerRow];
		button:SetParent(bar);
		button:ClearAllPoints();
		button:Size(C["actionbar"].altbuttonsize);
		
		possibleButtons[((i * buttonsPerRow) + 1)] = true;

		if C['actionbar']['barShapeShift'].mouseover == true then
			bar:SetAlpha(0);
			if not self.hooks[bar] then
				self:HookScript(bar, 'OnEnter', 'Bar_OnEnter');
				self:HookScript(bar, 'OnLeave', 'Bar_OnLeave');	
			end
			
			if not self.hooks[button] then
				self:HookScript(button, 'OnEnter', 'Button_OnEnter');
				self:HookScript(button, 'OnLeave', 'Button_OnLeave');					
			end
		else
			bar:SetAlpha(1);
			if self.hooks[bar] then
				self:Unhook(bar, 'OnEnter');
				self:Unhook(bar, 'OnLeave');
			end
			
			if self.hooks[button] then
				self:Unhook(button, 'OnEnter');	
				self:Unhook(button, 'OnLeave');		
			end
		end
		
		if i == 1 then
			local x, y;
			if point == "BOTTOMLEFT" then
				x, y = spacing, spacing;
			elseif point == "TOPRIGHT" then
				x, y = -spacing, -spacing;
			elseif point == "TOPLEFT" then
				x, y = spacing, -spacing;
			else
				x, y = -spacing, spacing;
			end

			button:Point(point, bar, point, x, y);
		elseif possibleButtons[i] then
			local x = 0;
			local y = -spacing;
			local buttonPoint, anchorPoint = "TOP", "BOTTOM";
			if verticalGrowth == 'UP' then
				y = spacing;
				buttonPoint = "BOTTOM";
				anchorPoint = "TOP";
			end
			button:Point(buttonPoint, lastColumnButton, anchorPoint, x, y);		
		else
			local x = spacing;
			local y = 0;
			local buttonPoint, anchorPoint = "LEFT", "RIGHT";
			if horizontalGrowth == 'LEFT' then
				x = -spacing;
				buttonPoint = "RIGHT";
				anchorPoint = "LEFT";
			end
			
			button:Point(buttonPoint, lastButton, anchorPoint, x, y);
		end
		
		if i > numButtons then
			button:SetScale(0.000001);
			button:SetAlpha(0);
		else
			button:SetScale(1);
			button:SetAlpha(1);
		end
		
		self:StyleButton(button, true);
		self:StyleShapeShift();
	end
	possibleButtons = nil;
end

function AB:CreateBarShapeShift()
	bar:SetAttribute("_onstate-show", [[		
		if newstate == "hide" then
			self:Hide();
		else
			self:Show();
		end	
	]]);

	self:RegisterEvent('UPDATE_SHAPESHIFT_FORMS', 'AdjustMaxShapeShiftButtons');
	self:RegisterEvent('UPDATE_SHAPESHIFT_USABLE', 'StyleShapeShift');
	self:RegisterEvent('UPDATE_SHAPESHIFT_COOLDOWN', 'StyleShapeShift');
	self:RegisterEvent('UPDATE_SHAPESHIFT_FORM', 'StyleShapeShift');
	self:RegisterEvent('ACTIONBAR_PAGE_CHANGED', 'StyleShapeShift');
	
	self:CreateMover(bar, 'Shift Bar', 'barShapeShift', -5);
	self:AdjustMaxShapeShiftButtons();
	self:PositionAndSizeBarShapeShift();
	RegisterStateDriver(bar, "show", states[E.myclass] or "hide");
end