--[[
~ElvUI Engine~

To load the ElvUI engine add this to the top of your file:
	
	local E, C, L, DF = unpack(select(2, ...)); --Load Ace3, Ace3-ConfigProfile, Locales, Defaults
	
To load the ElvUI engine inside another addon add this to the top of your file:
	
	local E, C, L, DF = unpack(ElvUI); --Load Ace3, Ace3-ConfigProfile, Locales, Defaults
]]

local addonName, engine = ...;
local ElvUI = LibStub("AceAddon-3.0"):GetAddon(addonName);
local Locale = LibStub("AceLocale-3.0"):GetLocale(addonName, false);

engine[1] = ElvUI;
engine[2] = ElvUI.db.profile;
engine[3] = Locale;
engine[4] = ElvUI.DF["profile"];

_G.ElvUI = engine;