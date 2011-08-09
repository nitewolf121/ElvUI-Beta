local ElvUI = LibStub("AceAddon-3.0"):GetAddon("ElvUI")
local DF = ElvUI.DF["profile"]['unitframe']['aurafilters']

local function SpellName(id)
	local name, _, _, _, _, _, _, _, _ = GetSpellInfo(id) 	
	return name
end

DF['CCDebuffs'] = {
	['type'] = 'Whitelist',
	['spells'] = {
		-- Death Knight
			[SpellName(47476)] = true, --strangulate
			[SpellName(49203)] = true, --hungering cold
		-- Druid
			[SpellName(33786)] = true, --Cyclone
			[SpellName(2637)] = true, --Hibernate
			[SpellName(339)] = true, --Entangling Roots
			[SpellName(80964)] = true, --Skull Bash
			[SpellName(78675)] = true, --Solar Beam
		-- Hunter
			[SpellName(3355)] = true, --Freezing Trap Effect
			--[SpellName(60210)] = true, --Freezing Arrow Effect
			[SpellName(1513)] = true, --scare beast
			[SpellName(19503)] = true, --scatter shot
			[SpellName(34490)] = true, --silence shot
		-- Mage
			[SpellName(31661)] = true, --Dragon's Breath
			[SpellName(61305)] = true, --Polymorph
			[SpellName(18469)] = true, --Silenced - Improved Counterspell
			[SpellName(122)] = true, --Frost Nova
			[SpellName(55080)] = true, --Shattered Barrier
			[SpellName(82691)] = true, --Ring of Frost
		-- Paladin
			[SpellName(20066)] = true, --Repentance
			[SpellName(10326)] = true, --Turn Evil
			[SpellName(853)] = true, --Hammer of Justice
		-- Priest
			[SpellName(605)] = true, --Mind Control
			[SpellName(64044)] = true, --Psychic Horror
			[SpellName(8122)] = true, --Psychic Scream
			[SpellName(9484)] = true, --Shackle Undead
			[SpellName(15487)] = true, --Silence
		-- Rogue
			[SpellName(2094)] = true, --Blind
			[SpellName(1776)] = true, --Gouge
			[SpellName(6770)] = true, --Sap
			[SpellName(18425)] = true, --Silenced - Improved Kick
		-- Shaman
			[SpellName(51514)] = true, --Hex
			[SpellName(3600)] = true, --Earthbind
			[SpellName(8056)] = true, --Frost Shock
			[SpellName(63685)] = true, --Freeze
			[SpellName(39796)] = true, --Stoneclaw Stun
		-- Warlock
			[SpellName(710)] = true, --Banish
			[SpellName(6789)] = true, --Death Coil
			[SpellName(5782)] = true, --Fear
			[SpellName(5484)] = true, --Howl of Terror
			[SpellName(6358)] = true, --Seduction
			[SpellName(30283)] = true, --Shadowfury
			[SpellName(89605)] = true, --Aura of Foreboding
		-- Warrior
			[SpellName(20511)] = true, --Intimidating Shout
		-- Racial
			[SpellName(25046)] = true, --Arcane Torrent
			[SpellName(20549)] = true, --War Stomp		
	},
}

DF['TurtleBuffs'] = {
	['type'] = 'Whitelist',
	['spells'] = {
		[SpellName(33206)] = true, -- Pain Suppression
		[SpellName(47788)] = true, -- Guardian Spirit	
		[SpellName(1044)] = true, -- Hand of Freedom
		[SpellName(1022)] = true, -- Hand of Protection
		[SpellName(1038)] = true, -- Hand of Salvation
		[SpellName(6940)] = true, -- Hand of Sacrifice
		[SpellName(62618)] = true, --Power Word: Barrier
		[SpellName(70940)] = true, -- Divine Guardian 	
		[SpellName(53480)] = true, -- Roar of Sacrifice
	},
}

DF['DebuffBlacklist'] = {
	['type'] = 'Blacklist',
	['spells'] = {
		[SpellName(8733)] = true, --Blessing of Blackfathom
		[SpellName(57724)] = true, --Sated
		[SpellName(25771)] = true, --forbearance
		[SpellName(57723)] = true, --Exhaustion
		[SpellName(36032)] = true, --arcane blast
		[SpellName(58539)] = true, --watchers corpse
		[SpellName(26013)] = true, --deserter
		[SpellName(6788)] = true, --weakended soul
		[SpellName(71041)] = true, --dungeon deserter
		[SpellName(41425)] = true, --"Hypothermia"
		[SpellName(55711)] = true, --Weakened Heart
		[SpellName(8326)] = true, --ghost
		[SpellName(23445)] = true, --evil twin
		[SpellName(24755)] = true, --gay homosexual tricked or treated debuff
		[SpellName(25163)] = true, --fucking annoying pet debuff oozeling disgusting aura
		[SpellName(80354)] = true, --timewarp debuff
		[SpellName(95223)] = true, --group res debuff
	},
}
