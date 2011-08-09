local ElvUI = LibStub("AceAddon-3.0"):NewAddon("ElvUI", "AceConsole-3.0", "AceEvent-3.0");
local DEFAULT_WIDTH = 890
local DEFAULT_HEIGHT = 650
ElvUI.DF = {}; ElvUI.DF["profile"] = {} -- Defaults
ElvUI.Options = {
	type = "group",
	name = "ElvUI",
	args = {},
}

local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local ACR = LibStub("AceConfigRegistry-3.0")

function ElvUI:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("ElvData_Beta", self.DF);
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
end

function ElvUI:OnProfileChanged()

end

function ElvUI:LoadConfig()	
	AC:RegisterOptionsTable("ElvUI", self.Options)
	ACD:SetDefaultSize("ElvUI", DEFAULT_WIDTH, DEFAULT_HEIGHT)	
	
	--Create Profiles Table
	self.Options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db);
	AC:RegisterOptionsTable("ElvProfiles", self.Options.args.profiles)
	self.Options.args.profiles.order = -10		
end

function ElvUI:ToggleConfig() 
	ACD[ACD.OpenFrames.ElvUI and "Close" or "Open"](ACD,"ElvUI") 
end