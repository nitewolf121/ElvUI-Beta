local E, C, L, DF = unpack(select(2, ...)); --Load Ace3, Ace3-ConfigProfile, Locales, Defaults

StaticPopupDialogs["CONFIG_RL"] = {
	text = L["One or more of the changes you have made require a ReloadUI."],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() ReloadUI() end,
	timeout = 0,
	whileDead = 1,
}

StaticPopupDialogs["KEYBIND_MODE"] = {
	text = L["Hover your mouse over any actionbutton or spellbook button to bind it. Press the escape key or right click to clear the current actionbutton's keybinding."],
	button1 = L['Save'],
	button2 = L['Discard'],
	OnAccept = function() local AB = E:GetModule('ActionBars'); AB:DeactivateBindMode(true) end,
	OnCancel = function() local AB = E:GetModule('ActionBars'); AB:DeactivateBindMode(false) end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false
}