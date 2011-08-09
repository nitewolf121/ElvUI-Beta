local E, C, L, DB = unpack(ElvUI) -- Import Functions/Constants, Config, Locales
if C.unitframe.enable ~= true then return end
local _, ns = ...
local oUF = ns.oUF or oUF
if not oUF then return end

local smoothing = {}
local function Smooth(self, value)
	if value ~= self:GetValue() or value == 0 then
		smoothing[self] = value
	else
		smoothing[self] = nil
	end
end

local function SmoothBar(self, bar)
	bar.SetValue_ = bar.SetValue
	bar.SetValue = Smooth
end

local function ResetBar(self, bar)
	if bar.SetValue_ then
		bar.SetValue = bar.SetValue_
	end
end

local function hook(frame)
	frame.SmoothBar = SmoothBar
	frame.ResetBar = ResetBar
	if frame.Health and frame.Health.Smooth then
		frame:SmoothBar(frame.Health)
	elseif frame.Health then
		frame:ResetBar(frame.Health)
	end
	if frame.Power and frame.Power.Smooth then
		frame:SmoothBar(frame.Power)
	elseif frame.Power then
		frame:ResetBar(frame.Power)		
	end
	if frame.AltPowerBar and frame.AltPowerBar.Smooth then
		frame:SmoothBar(frame.AltPowerBar)
	elseif frame.AltPowerBar then
		frame:ResetBar(frame.AltPowerBar)		
	end	
end

for i, frame in ipairs(oUF.objects) do hook(frame) end
oUF:RegisterInitCallback(hook)

local f, min, max = CreateFrame('Frame'), math.min, math.max
f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:SetScript('OnUpdate', function()
	local rate = GetFramerate()
	local limit = 30/rate
	for bar, value in pairs(smoothing) do
		local cur = bar:GetValue()
		local new = cur + min((value-cur)/3, max(value-cur, limit))
		if new ~= new then
			-- Mad hax to prevent QNAN.
			new = value
		end
		bar:SetValue_(new)
		if cur == value or abs(new - value) < 2 then
			bar:SetValue_(value)
			smoothing[bar] = nil
		end
	end
end)

function oUF.SmoothInit()
	for i, frame in ipairs(oUF.objects) do hook(frame) end
	oUF:RegisterInitCallback(hook)
end