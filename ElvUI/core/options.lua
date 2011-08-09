local E, C, L, DF = unpack(select(2, ...)); --Load Ace3, Ace3-ConfigProfile, Locales, Defaults

E.Options.args = {
	ElvUI_Header = {
		order = 1,
		type = "header",
		name = L["Version"]..format(": |cff99ff33%s|r",E.version),
		width = "full",		
	},
	ToggleAnchors = {
		order = 2,
		type = "execute",
		name = L["Toggle Anchors"],
		desc = L["Unlock various elements of the UI to be repositioned."],
		func = function() E:ToggleAnchors() end,
	},
}

E.Options.args.core = {
	type = "group",
	name = L["General"],
	desc = L["General"],
	order = 1,
	childGroups = "tab",
	get = function(info) return C.core[ info[#info] ] end,
	set = function(info, value) C.core[ info[#info] ] = value end,
	args = {
		intro = {
			order = 1,
			type = "description",
			name = L["ELVUI_DESC"],
		},			
		general = {
			order = 2,
			type = "group",
			name = L["General"],
			args = {	
				autoscale = {
					order = 1,
					name = L["Auto Scale"],
					desc = L["Automatically scale the User Interface based on your screen resolution"],
					type = "toggle",	
					set = function(info, value) C.core[ info[#info] ] = value; E:UIScale(); StaticPopup_Show("CONFIG_RL") end
				},
				uiscale = {
					order = 2,
					name = L["Scale"],
					desc = L["Controls the scaling of the entire User Interface"],
					disabled = function(info) return C["core"].autoscale end,
					type = "range",
					min = 0.64, max = 1, step = 0.01,
					isPercent = true,
					set = function(info, value) C.core[ info[#info] ] = value; E:UIScale(); StaticPopup_Show("CONFIG_RL") end
				},		
				classtheme = {
					order = 3,
					name = L["Class Theme"],
					desc = L["Style all frame borders to be your class color, color unitframes to class color"],
					type = "toggle",
					set = function(info, value) C.core[ info[#info] ] = value; E:UpdateMedia(); E:UpdateFrameTemplates(); end,
				},				
				resolutionoverride = {
					order = 4,
					name = L["Resolution Override"],
					desc = L["Set a resolution version to use. By default any screensize > 1600 is considered a High resolution. This effects actionbar/unitframe layouts. If set to None, then it will be automatically determined by your screen size"],
					type = "select",
					values = {
						["NONE"] = L["None"],
						["Low"] = L["Low"],
						["High"] = L["High"],
					},
				},		
			},
		},
		media = {
			order = 3,
			type = "group",
			name = L["Media"],
			args = {
				fonts = {
					order = 1,
					type = "group",
					name = L["Fonts"],
					guiInline = true,
					args = {
						fontsize = {
							order = 1,
							name = L["Font Size"],
							desc = L["Set the font size for everything in UI. Note: This doesn't effect somethings that have their own seperate options (UnitFrame Font, Datatext Font, ect..)"],
							type = "range",
							min = 6, max = 22, step = 1,
							set = function(info, value) C.core[ info[#info] ] = value; E:UpdateMedia(); E:UpdateFontTemplates(); end,
						},	
						font = {
							type = "select", dialogControl = 'LSM30_Font',
							order = 2,
							name = L["Default Font"],
							desc = L["The font that the core of the UI will use."],
							values = AceGUIWidgetLSMlists.font,	
							set = function(info, value) C.core[ info[#info] ] = value; E:UpdateMedia(); E:UpdateFontTemplates(); end,
						},
						dmgfont = {
							type = "select", dialogControl = 'LSM30_Font',
							order = 3,
							name = L["CombatText Font"],
							desc = L["The font that combat text will use. |cffFF0000WARNING: This requires a game restart or re-log for this change to take effect.|r"],
							values = AceGUIWidgetLSMlists.font,		
							set = function(info, value) C.core[ info[#info] ] = value; E:UpdateMedia(); E:UpdateFontTemplates(); end,
						},							
					},
				},	
				textures = {
					order = 2,
					type = "group",
					name = L["Textures"],
					guiInline = true,
					args = {
						normTex = {
							type = "select", dialogControl = 'LSM30_Statusbar',
							order = 1,
							name = L["StatusBar Texture"],
							desc = L["Main statusbar texture."],
							values = AceGUIWidgetLSMlists.statusbar,								
						},
						glossTex = {
							type = "select", dialogControl = 'LSM30_Statusbar',
							order = 2,
							name = L["Gloss Texture"],
							desc = L["This gets used by some objects."],
							values = AceGUIWidgetLSMlists.statusbar,								
						},				
					},
				},
				colors = {
					order = 3,
					type = "group",
					name = L["Colors"],
					guiInline = true,
					args = {
						bordercolor = {
							type = "color",
							order = 1,
							name = L["Border Color"],
							desc = L["Main border color of the UI."],
							hasAlpha = false,
							get = function(info)
								local t = C.core[ info[#info] ]
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b)
								C.core[ info[#info] ] = {}
								local t = C.core[ info[#info] ]
								t.r, t.g, t.b = r, g, b
								E:UpdateMedia()
								E:UpdateBorderColors()
							end,					
						},
						backdropcolor = {
							type = "color",
							order = 2,
							name = L["Backdrop Color"],
							desc = L["Main backdrop color of the UI."],
							hasAlpha = false,
							get = function(info)
								local t = C.core[ info[#info] ]
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b)
								C.core[ info[#info] ] = {}
								local t = C.core[ info[#info] ]
								t.r, t.g, t.b = r, g, b
								E:UpdateMedia()
								E:UpdateBackdropColors()
							end,						
						},
						backdropfadecolor = {
							type = "color",
							order = 3,
							name = L["Backdrop Faded Color"],
							desc = L["Backdrop color of transparent frames"],
							hasAlpha = true,
							get = function(info)
								local t = C.core[ info[#info] ]
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								C.core[ info[#info] ] = {}
								local t = C.core[ info[#info] ]	
								t.r, t.g, t.b, t.a = r, g, b, a
								E:UpdateMedia()
								E:UpdateFrameTemplates()
							end,						
						},	
						resetbutton = {
							type = "execute",
							order = 4,
							name = L["Restore Defaults"],
							func = function() 
								C.core.backdropcolor = DF.core.backdropcolor
								C.core.backdropfadecolor = DF.core.backdropfadecolor
								C.core.bordercolor = DF.core.bordercolor
								E:UpdateMedia()
								E:UpdateFrameTemplates()								
							end,
						},
					},
				},
			},
		},
	},
}