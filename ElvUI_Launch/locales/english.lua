-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("ElvUI", "enUS", true);
if not L then return; end

--Static Popup
do
	L["One or more of the changes you have made require a ReloadUI."] = true;
end

--General
do
	L["Version"] = true;
	L["Enable"] = true;

	L["General"] = true;
	L["ELVUI_DESC"] = "ElvUI is a complete User Interface replacement addon for World of Warcraft.";
	L["Auto Scale"] = true;
		L["Automatically scale the User Interface based on your screen resolution"] = true;
	L["Scale"] = true;
		L["Controls the scaling of the entire User Interface"] = true;
	 L["Resolution Override"] = true;
		L["Set a resolution version to use. By default any screensize > 1600 is considered a High resolution. This effects actionbar/unitframe layouts. If set to None, then it will be automatically determined by your screen size"] = true;
			L["None"] = true;
			L["Low"] = true;
			L["High"] = true;
	L["Class Theme"] = true;		
	L["Style all frame borders to be your class color, color unitframes to class color"] = true;
end

--Media	
do
	L["Media"] = true;
	L["Fonts"] = true;
	L["Font Size"] = true;
		L["Set the font size for everything in UI. Note: This doesn't effect somethings that have their own seperate options (UnitFrame Font, Datatext Font, ect..)"] = true;
	L["Default Font"] = true;
		L["The font that the core of the UI will use."] = true;
	L["UnitFrame Font"] = true;
		L["The font that unitframes will use"] = true;
	L["CombatText Font"] = true;
		L["The font that combat text will use. |cffFF0000WARNING: This requires a game restart or re-log for this change to take effect.|r"] = true;
	L["Textures"] = true;
	L["StatusBar Texture"] = true;
		L["Main statusbar texture."] = true;
	L["Gloss Texture"] = true;
		L["This gets used by some objects."] = true;
	L["Colors"] = true;	
	L["Border Color"] = true;
		L["Main border color of the UI."] = true;
	L["Backdrop Color"] = true;
		L["Main backdrop color of the UI."] = true;
	L["Backdrop Faded Color"] = true;
		L["Backdrop color of transparent frames"] = true;
	L["Restore Defaults"] = true;
		
	L["Toggle Anchors"] = true;
	L["Unlock various elements of the UI to be repositioned."] = true;
end

--NamePlate Config
do
	L["NamePlates"] = true;
	L["NAMEPLATE_DESC"] = "Modify the nameplate settings."
	L["Width"] = true;
		L["Controls the width of the nameplate"] = true;
	L["Height"] = true;
		L["Controls the height of the nameplate"] = true;
	L["Good Color"] = true;
		L["This is displayed when you have threat as a tank, if you don't have threat it is displayed as a DPS/Healer"] = true;
	L["Bad Color"] = true;
		L["This is displayed when you don't have threat as a tank, if you do have threat it is displayed as a DPS/Healer"] = true;
	L["Good Transition Color"] = true;
		L["This color is displayed when gaining/losing threat, for a tank it would be displayed when gaining threat, for a dps/healer it would be displayed when losing threat"] = true;
	L["Bad Transition Color"] = true;
		L["This color is displayed when gaining/losing threat, for a tank it would be displayed when losing threat, for a dps/healer it would be displayed when gaining threat"] = true;	
	L["Castbar Height"] = true;
		L["Controls the height of the nameplate's castbar"] = true;
	L["Health Text"] = true;
		L["Toggles health text display"] = true;
	L["Personal Debuffs"] = true;
		L["Display your personal debuffs over the nameplate."] = true;
	L["Display level text on nameplate for nameplates that belong to units that aren't your level."] = true;
	L["Enhance Threat"] = true;
		L["Color the nameplate's healthbar by your current threat, Example: good threat color is used if your a tank when you have threat, opposite for DPS."] = true;
	L["Combat Toggle"] = true;
		L["Toggles the nameplates off when not in combat."] = true;
	L["Friendly NPC"] = true;
	L["Friendly Player"] = true;
	L["Neutral"] = true;
	L["Enemy"] = true;
	L["Threat"] = true;
	L["Reactions"] = true;
	L["Filters"] = true;
	L['Add Name'] = true;
	L['Remove Name'] = true;
	L['Use this filter.'] = true;
	L["You can't remove a default name from the filter, disabling the name."] = true;
	L['Hide'] = true;
		L['Prevent any nameplate with this unit name from showing.'] = true;
	L['Custom Color'] = true;
		L['Disable threat coloring for this plate and use the custom color.'] = true;
	L['Custom Scale'] = true;
		L['Set the scale of the nameplate.'] = true;
	L['Good Scale'] = true;
	L['Bad Scale'] = true;
	L["Auras"] = true;
end
	
--ACTIONBARS
do
	--HOTKEY TEXTS
	L['KEY_SHIFT'] = 'S';
	L['KEY_ALT'] = 'A';
	L['KEY_CTRL'] = 'C';
	L['KEY_MOUSEBUTTON'] = 'M';
	L['KEY_MOUSEWHEELUP'] = 'MU';
	L['KEY_MOUSEWHEELDOWN'] = 'MD';
	L['KEY_BUTTON3'] = 'M3';
	L['KEY_NUMPAD'] = 'N';
	L['KEY_PAGEUP'] = 'PU';
	L['KEY_PAGEDOWN'] = 'PD';
	L['KEY_SPACE'] = 'SpB';
	L['KEY_INSERT'] = 'Ins';
	L['KEY_HOME'] = 'Hm';
	L['KEY_DELETE'] = 'Del';
	L['KEY_MOUSEWHEELUP'] = 'MwU';
	L['KEY_MOUSEWHEELDOWN'] = 'MwD';

	--BLIZZARD MODIFERS TO SEARCH FOR
	L['KEY_LOCALE_SHIFT'] = '(s%-)';
	L['KEY_LOCALE_ALT'] = '(a%-)';
	L['KEY_LOCALE_CTRL'] = '(c%-)';
	
	--KEYBINDING
	L["Hover your mouse over any actionbutton or spellbook button to bind it. Press the escape key or right click to clear the current actionbutton's keybinding."] = true;
	L['Save'] = true;
	L['Discard'] = true;
	L['Binds Saved'] = true;
	L['Binds Discarded'] = true;
	L["All keybindings cleared for |cff00ff00%s|r."] = true;
	L[" |cff00ff00bound to |r"] = true;
	L["No bindings set."] = true;
	L["Binding"] = true;
	L["Key"] = true;	
	L['Trigger'] = true;
	
	--CONFIG
	L["ActionBars"] = true;
		L["Keybind Mode"] = true;
		
	L['Macro Text'] = true;
		L['Display macro names on action buttons.'] = true;
	L['Keybind Text'] = true;
		L['Display bind names on action buttons.'] = true;
	L['Button Size'] = true;
		L['The size of the main action buttons.'] = true;
	L['Button Spacing'] = true;
		L['The spacing between buttons.'] = true;
	L['Bar '] = true;
	L['Backdrop'] = true;
		L['Toggles the display of the actionbars backdrop.'] = true;
	L['Buttons'] = true;
		L['The ammount of buttons to display.'] = true;
	L['Buttons Per Row'] = true;
		L['The ammount of buttons to display per row.'] = true;
	L['Anchor Point'] = true;
		L['The first button anchors itself to this point on the bar.'] = true;
	L['Height Multiplier'] = true;
	L['Width Multiplier'] = true;
		L['Multiply the backdrops height or width by this value. This is usefull if you wish to have more than one bar behind a backdrop.'] = true;
	L['Action Paging'] = true;
		L["This works like a macro, you can run differant situations to get the actionbar to page differantly.\n Example: '[combat] 2;'"] = true;
	L['Visibility State'] = true;
		L["This works like a macro, you can run differant situations to get the actionbar to show/hide differantly.\n Example: '[combat] show;hide'"] = true;
	L['Restore Bar'] = true;
		L['Restore the actionbars default settings'] = true;
		L['Set the font size of the action buttons.'] = true;
	L['Mouse Over'] = true;
		L['The frame is not shown unless you mouse over the frame.'] = true;
	L['Pet Bar'] = true;
	L['Alt-Button Size'] = true;
		L['The size of the Pet and Shapeshift bar buttons.'] = true;
	L['ShapeShift Bar'] = true;
	L['Cooldown Text'] = true;
		L['Display cooldown text on anything with the cooldown spiril.'] = true;
	L['Low Threshold'] = true;
		L['Threshold before text turns red and is in decimal form. Set to -1 for it to never turn red'] = true;
	L['Expiring'] = true;
		L['Color when the text is about to expire'] = true;
	L['Seconds'] = true;
		L['Color when the text is in the seconds format.'] = true;
	L['Minutes'] = true;
		L['Color when the text is in the minutes format.'] = true;
	L['Hours'] = true;
		L['Color when the text is in the hours format.'] = true;
	L['Days'] = true;
		L['Color when the text is in the days format.'] = true;
	L['Totem Bar'] = true;
end

--UNITFRAMES
do
	L['Offline'] = true;
	L['UnitFrames'] = true;
	L['Ghost'] = true;
	L['Secondary Layout'] = true;
		L['If set then when you change your spec a differant layout will be created, at first it is created based off your primary settings.'] = true;
	L['Smooth Bars'] = true;
		L['Bars will transition smoothly.'] = true;
	L["The font that the unitframes will use."] = true;
		L["Set the font size for unitframes."] = true;
	L['Font Outline'] = true;
		L["Set the font outline."] = true;
	L['Bars'] = true;
	L['Fonts'] = true;
	L['Class Health'] = true;
		L['Color health by classcolor or reaction.'] = true;
	L['Class Power'] = true;
		L['Color power by classcolor or reaction.'] = true;
	L['Health By Value'] = true;
		L['Color health by ammount remaining.'] = true;
	L['Custom Health Backdrop'] = true;
		L['Use the custom health backdrop color instead of a multiple of the main health color.'] = true;
	L['Class Backdrop'] = true;
		L['Color the health backdrop by class or reaction.'] = true;
	L['Health'] = true;
	L['Health Backdrop'] = true;
	L['Tapped'] = true;
	L['Disconnected'] = true;
	L['Powers'] = true;
	L['Reactions'] = true;
	L['Bad'] = true;
	L['Neutral'] = true;
	L['Good'] = true;
	L['Player Frame'] = true;
	L['Width'] = true;
	L['Height'] = true;
	L['Low Mana Threshold'] = true;
		L['When you mana falls below this point, text will flash on the player frame.'] = true;
	L['Combat Fade'] = true;
		L['Fade the unitframe when out of combat, not casting, no target exists.'] = true;
	L['Health'] = true;
		L['Text'] = true;
		L['Text Format'] = true;	
	L['Current - Percent'] = true;
	L['Current - Max'] = true;
	L['Current'] = true;
	L['Percent'] = true;
	L['Deficit'] = true;
	L['Filled'] = true;
	L['Spaced'] = true;
	L['Power'] = true;
	L['Offset'] = true;
		L['Offset of the powerbar to the healthbar, set to 0 to disable.'] = true;
	L['Alt-Power'] = true;
	L['Overlay'] = true;
		L['Overlay the healthbar']= true;
	L['Portrait'] = true;
	L['Name'] = true;
	L['Up'] = true;
	L['Down'] = true;
	L['Left'] = true;
	L['Right'] = true;
	L['Num Rows'] = true;
	L['Per Row'] = true;
	L['Buffs'] = true;
	L['Debuffs'] = true;
	L['Y-Growth'] = true;
	L['X-Growth'] = true;
		L['Growth direction of the buffs'] = true;
	L['Initial Anchor'] = true;
		L['The initial anchor point of the buffs on the frame'] = true;
	L['Castbar'] = true;
	L['Icon'] = true;
	L['Latency'] = true;
	L['Color'] = true;
	L['Interrupt Color'] = true;
	L['Match Frame Width'] = true;
	L['Fill'] = true;
	L['Classbar'] = true;
	L['Position'] = true;
	L['Target Frame'] = true;
	L['Text Toggle On NPC'] = true;
		L['Power text will be hidden on NPC targets, in addition the name text will be repositioned to the power texts anchor point.'] = true;
	L['Combobar'] = true;
	L['Use Filter'] = true;
		L['Select a filter to use.'] = true;
		L['Select a filter to use. These are imported from the unitframe aura filter.'] = true;
	L['Personal Auras'] = true;
	L['If set only auras belonging to yourself in addition to any aura that passes the set filter may be shown.'] = true;
	L['Create Filter'] = true;
		L['Create a filter, once created a filter can be set inside the buffs/debuffs section of each unit.'] = true;
	L['Delete Filter'] = true;
		L['Delete a created filter, you cannot delete pre-existing filters, only custom ones.'] = true;
	L["You can't remove a pre-existing filter."] = true;
	L['Select Filter'] = true;
	L['Whitelist'] = true;
	L['Blacklist'] = true;
	L['Filter Type'] = true;
		L['Set the filter type, blacklisted filters hide any aura on the like and show all else, whitelisted filters show any aura on the filter and hide all else.'] = true;
	L['Add Spell'] = true;
		L['Add a spell to the filter.'] = true;
	L['Remove Spell'] = true;
		L['Remove a spell from the filter.'] = true;
	L['You may not remove a spell from a default filter that is not customly added. Setting spell to false instead.'] = true;
	L['Unit Reaction'] = true;
		L['This filter only works for units with the set reaction.'] = true;
		L['All'] = true;
		L['Friend'] = true;
		L['Enemy'] = true;
	L['Duration Limit'] = true;
		L['The aura must be below this duration for the buff to show, set to 0 to disable. Note: This is in seconds.'] = true;
	L['TargetTarget Frame'] = true;
	L['Attach To'] = true;
		L['What to attach the buff anchor frame to.'] = true;
		L['Frame'] = true;
	L['Anchor Point'] = true;
		L['What point to anchor to the frame you set to attach to.'] = true;
	L['Focus Frame'] = true;
	L['FocusTarget Frame'] = true;
	L['Pet Frame'] = true;
	L['PetTarget Frame'] = true;
	L['Boss Frames'] = true;
	L['Growth Direction'] = true;
	L['Arena Frames'] = true;
end
