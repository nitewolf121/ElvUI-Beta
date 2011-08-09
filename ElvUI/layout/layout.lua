local E, C, L, DF = unpack(select(2, ...)); --Load Ace3, Ace3-ConfigProfile, Locales, Defaults

-- STRESS TEST
--[[for i=1, 1200 do
	local x = CreateFrame('Frame', "X"..i, E.UIParent)
	if i > 1 then
		x:Point('TOPLEFT', _G["X"..i-1], 'BOTTOMRIGHT', i + 2, -(i + 2))
	else
		x:Point('TOPLEFT', E.UIParent, 'TOPLEFT', i + 2, -(i + 2))
	end
	x:SetTemplate('Default')
	x:Size(50, 50)
	if i > 70 then x:Hide() end
	
end]]


--[[E:CreateMover(ShapeshiftBarFrame, 'PlayerFrameMover', 'Player', nil, function() E:Print('lol moved') end);

E:CreateMover(TargetFrame, 'TargetFrameMover', 'Target', nil, function() E:Print('lol moved') end);]]