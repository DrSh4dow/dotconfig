local E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule('UnitFrames')

local unpack = unpack

local function Defaults(priorityOverride)
	return {
		enable = true,
		priority = priorityOverride or 0,
		stackThreshold = 0
	}
end

G.unitframe.aurafilters = {};

-- These are debuffs that are some form of CC
G.unitframe.aurafilters.CCDebuffs = {
	type = 'Whitelist',
	spells = {
	-- Death Knight
		[47476]  = Defaults(2), -- Strangulate
		[108194] = Defaults(4), -- Asphyxiate UH
		[221562] = Defaults(4), -- Asphyxiate Blood
		[207171] = Defaults(4), -- Winter is Coming
		[206961] = Defaults(3), -- Tremble Before Me
		[207167] = Defaults(4), -- Blinding Sleet
		[212540] = Defaults(1), -- Flesh Hook (Pet)
		[91807]  = Defaults(1), -- Shambling Rush (Pet)
		[204085] = Defaults(1), -- Deathchill
		[233395] = Defaults(1), -- Frozen Center
		[212332] = Defaults(4), -- Smash (Pet)
		[212337] = Defaults(4), -- Powerful Smash (Pet)
		[91800]  = Defaults(4), -- Gnaw (Pet)
		[91797]  = Defaults(4), -- Monstrous Blow (Pet)
		[210141] = Defaults(3), -- Zombie Explosion
	-- Demon Hunter
		[207685] = Defaults(4), -- Sigil of Misery
		[217832] = Defaults(3), -- Imprison
		[221527] = Defaults(5), -- Imprison (Banished version)
		[204490] = Defaults(2), -- Sigil of Silence
		[179057] = Defaults(3), -- Chaos Nova
		[211881] = Defaults(4), -- Fel Eruption
		[205630] = Defaults(3), -- Illidan's Grasp
		[208618] = Defaults(3), -- Illidan's Grasp (Afterward)
		[213491] = Defaults(4), -- Demonic Trample (it's this one or the other)
		[208645] = Defaults(4), -- Demonic Trample
	-- Druid
		[81261]  = Defaults(2), -- Solar Beam
		[5211]   = Defaults(4), -- Mighty Bash
		[163505] = Defaults(4), -- Rake
		[203123] = Defaults(4), -- Maim
		[202244] = Defaults(4), -- Overrun
		[99]     = Defaults(4), -- Incapacitating Roar
		[33786]  = Defaults(5), -- Cyclone
		[209753] = Defaults(5), -- Cyclone Balance
		[45334]  = Defaults(1), -- Immobilized
		[102359] = Defaults(1), -- Mass Entanglement
		[339]    = Defaults(1), -- Entangling Roots
		[2637]   = Defaults(1), -- Hibernate
		[102793] = Defaults(1), -- Ursol's Vortex
	-- Hunter
		[202933] = Defaults(2), -- Spider Sting (it's this one or the other)
		[233022] = Defaults(2), -- Spider Sting
		[213691] = Defaults(4), -- Scatter Shot
		[19386]  = Defaults(3), -- Wyvern Sting
		[3355]   = Defaults(3), -- Freezing Trap
		[203337] = Defaults(5), -- Freezing Trap (Survival PvPT)
		[209790] = Defaults(3), -- Freezing Arrow
		[24394]  = Defaults(4), -- Intimidation
		[117526] = Defaults(4), -- Binding Shot
		[190927] = Defaults(1), -- Harpoon
		[201158] = Defaults(1), -- Super Sticky Tar
		[162480] = Defaults(1), -- Steel Trap
		[212638] = Defaults(1), -- Tracker's Net
		[200108] = Defaults(1), -- Ranger's Net
	-- Mage
		[61721]  = Defaults(3), -- Rabbit (Poly)
		[61305]  = Defaults(3), -- Black Cat (Poly)
		[28272]  = Defaults(3), -- Pig (Poly)
		[28271]  = Defaults(3), -- Turtle (Poly)
		[126819] = Defaults(3), -- Porcupine (Poly)
		[161354] = Defaults(3), -- Monkey (Poly)
		[161353] = Defaults(3), -- Polar bear (Poly)
		[61780] = Defaults(3),  -- Turkey (Poly)
		[161355] = Defaults(3), -- Penguin (Poly)
		[161372] = Defaults(3), -- Peacock (Poly)
		[277787] = Defaults(3), -- Direhorn (Poly)
		[277792] = Defaults(3), -- Bumblebee (Poly)
		[118]    = Defaults(3), -- Polymorph
		[82691]  = Defaults(3), -- Ring of Frost
		[31661]  = Defaults(3), -- Dragon's Breath
		[122]    = Defaults(1), -- Frost Nova
		[33395]  = Defaults(1), -- Freeze
		[157997] = Defaults(1), -- Ice Nova
		[228600] = Defaults(1), -- Glacial Spike
		[198121] = Defaults(1), -- Forstbite
	-- Monk
		[119381] = Defaults(4), -- Leg Sweep
		[202346] = Defaults(4), -- Double Barrel
		[115078] = Defaults(4), -- Paralysis
		[198909] = Defaults(3), -- Song of Chi-Ji
		[202274] = Defaults(3), -- Incendiary Brew
		[233759] = Defaults(2), -- Grapple Weapon
		[123407] = Defaults(1), -- Spinning Fire Blossom
		[116706] = Defaults(1), -- Disable
		[232055] = Defaults(4), -- Fists of Fury (it's this one or the other)
	-- Paladin
		[853]    = Defaults(3), -- Hammer of Justice
		[20066]  = Defaults(3), -- Repentance
		[105421] = Defaults(3), -- Blinding Light
		[31935]  = Defaults(2), -- Avenger's Shield
		[217824] = Defaults(2), -- Shield of Virtue
		[205290] = Defaults(3), -- Wake of Ashes
	-- Priest
		[9484]   = Defaults(3), -- Shackle Undead
		[200196] = Defaults(4), -- Holy Word: Chastise
		[200200] = Defaults(4), -- Holy Word: Chastise
		[226943] = Defaults(3), -- Mind Bomb
		[605]    = Defaults(5), -- Mind Control
		[8122]   = Defaults(3), -- Psychic Scream
		[15487]  = Defaults(2), -- Silence
		[64044]  = Defaults(1), -- Psychic Horror
	-- Rogue
		[2094]   = Defaults(4), -- Blind
		[6770]   = Defaults(4), -- Sap
		[1776]   = Defaults(4), -- Gouge
		[1330]   = Defaults(2), -- Garrote - Silence
		[207777] = Defaults(2), -- Dismantle
		[199804] = Defaults(4), -- Between the Eyes
		[408]    = Defaults(4), -- Kidney Shot
		[1833]   = Defaults(4), -- Cheap Shot
		[207736] = Defaults(5), -- Shadowy Duel (Smoke effect)
		[212182] = Defaults(5), -- Smoke Bomb
	-- Shaman
		[51514]  = Defaults(3), -- Hex
		[211015] = Defaults(3), -- Hex (Cockroach)
		[211010] = Defaults(3), -- Hex (Snake)
		[211004] = Defaults(3), -- Hex (Spider)
		[210873] = Defaults(3), -- Hex (Compy)
		[196942] = Defaults(3), -- Hex (Voodoo Totem)
		[269352] = Defaults(3), -- Hex (Skeletal Hatchling)
		[277778] = Defaults(3), -- Hex (Zandalari Tendonripper)
		[277784] = Defaults(3), -- Hex (Wicker Mongrel)
		[118905] = Defaults(3), -- Static Charge
		[77505]  = Defaults(4), -- Earthquake (Knocking down)
		[118345] = Defaults(4), -- Pulverize (Pet)
		[204399] = Defaults(3), -- Earthfury
		[204437] = Defaults(3), -- Lightning Lasso
		[157375] = Defaults(4), -- Gale Force
		[64695]  = Defaults(1), -- Earthgrab
	-- Warlock
		[710]    = Defaults(5), -- Banish
		[6789]   = Defaults(3), -- Mortal Coil
		[118699] = Defaults(3), -- Fear
		[6358]   = Defaults(3), -- Seduction (Succub)
		[171017] = Defaults(4), -- Meteor Strike (Infernal)
		[22703]  = Defaults(4), -- Infernal Awakening (Infernal CD)
		[30283]  = Defaults(3), -- Shadowfury
		[89766]  = Defaults(4), -- Axe Toss
		[233582] = Defaults(1), -- Entrenched in Flame
	-- Warrior
		[5246]   = Defaults(4), -- Intimidating Shout
		[7922]   = Defaults(4), -- Warbringer
		[132169] = Defaults(4), -- Storm Bolt
		[132168] = Defaults(4), -- Shockwave
		[199085] = Defaults(4), -- Warpath
		[105771] = Defaults(1), -- Charge
		[199042] = Defaults(1), -- Thunderstruck
		[236077] = Defaults(2), -- Disarm
	-- Racial
		[20549]  = Defaults(4), -- War Stomp
		[107079] = Defaults(4), -- Quaking Palm
	},
}

-- These are buffs that can be considered 'protection' buffs
G.unitframe.aurafilters.TurtleBuffs = {
	type = 'Whitelist',
	spells = {
	-- Death Knight
		[48707]  = Defaults(), -- Anti-Magic Shell
		[81256]  = Defaults(), -- Dancing Rune Weapon
		[55233]  = Defaults(), -- Vampiric Blood
		[193320] = Defaults(), -- Umbilicus Eternus
		[219809] = Defaults(), -- Tombstone
		[48792]  = Defaults(), -- Icebound Fortitude
		[207319] = Defaults(), -- Corpse Shield
		[194844] = Defaults(), -- BoneStorm
		[145629] = Defaults(), -- Anti-Magic Zone
		[194679] = Defaults(), -- Rune Tap
	-- Demon Hunter
		[207811] = Defaults(), -- Nether Bond (DH)
		[207810] = Defaults(), -- Nether Bond (Target)
		[187827] = Defaults(), -- Metamorphosis
		[263648] = Defaults(), -- Soul Barrier
		[209426] = Defaults(), -- Darkness
		[196555] = Defaults(), -- Netherwalk
		[212800] = Defaults(), -- Blur
		[188499] = Defaults(), -- Blade Dance
		[203819] = Defaults(), -- Demon Spikes
	-- Druid
		[102342] = Defaults(), -- Ironbark
		[61336]  = Defaults(), -- Survival Instincts
		[210655] = Defaults(), -- Protection of Ashamane
		[22812]  = Defaults(), -- Barkskin
		[200851] = Defaults(), -- Rage of the Sleeper
		[234081] = Defaults(), -- Celestial Guardian
		[202043] = Defaults(), -- Protector of the Pack (it's this one or the other)
		[201940] = Defaults(), -- Protector of the Pack
		[201939] = Defaults(), -- Protector of the Pack (Allies)
		[192081] = Defaults(), -- Ironfur
	-- Hunter
		[186265] = Defaults(), -- Aspect of the Turtle
		[53480]  = Defaults(), -- Roar of Sacrifice
		[202748] = Defaults(), -- Survival Tactics
	-- Mage
		[45438]  = Defaults(), -- Ice Block
		[113862] = Defaults(), -- Greater Invisibility
		[198111] = Defaults(), -- Temporal Shield
		[198065] = Defaults(), -- Prismatic Cloak
		[11426]  = Defaults(), -- Ice Barrier
		[235313] = Defaults(), -- Blazing Barrier
	-- Monk
		[122783] = Defaults(), -- Diffuse Magic
		[122278] = Defaults(), -- Dampen Harm
		[125174] = Defaults(), -- Touch of Karma
		[201318] = Defaults(), -- Fortifying Elixir
		[201325] = Defaults(), -- Zen Moment
		[202248] = Defaults(), -- Guided Meditation
		[120954] = Defaults(), -- Fortifying Brew
		[116849] = Defaults(), -- Life Cocoon
		[202162] = Defaults(), -- Guard
		[215479] = Defaults(), -- Ironskin Brew
	-- Paladin
		[642]    = Defaults(), -- Divine Shield
		[498]    = Defaults(), -- Divine Protection
		[205191] = Defaults(), -- Eye for an Eye
		[184662] = Defaults(), -- Shield of Vengeance
		[1022]   = Defaults(), -- Blessing of Protection
		[6940]   = Defaults(), -- Blessing of Sacrifice
		[204018] = Defaults(), -- Blessing of Spellwarding
		[199507] = Defaults(), -- Spreading The Word: Protection
		[216857] = Defaults(), -- Guarded by the Light
		[228049] = Defaults(), -- Guardian of the Forgotten Queen
		[31850]  = Defaults(), -- Ardent Defender
		[86659]  = Defaults(), -- Guardian of Ancien Kings
		[212641] = Defaults(), -- Guardian of Ancien Kings (Glyph of the Queen)
		[209388] = Defaults(), -- Bulwark of Order
		[204335] = Defaults(), -- Aegis of Light
		[152262] = Defaults(), -- Seraphim
		[132403] = Defaults(), -- Shield of the Righteous
	-- Priest
		[81782]  = Defaults(), -- Power Word: Barrier
		[47585]  = Defaults(), -- Dispersion
		[19236]  = Defaults(), -- Desperate Prayer
		[213602] = Defaults(), -- Greater Fade
		[27827]  = Defaults(), -- Spirit of Redemption
		[197268] = Defaults(), -- Ray of Hope
		[47788]  = Defaults(), -- Guardian Spirit
		[33206]  = Defaults(), -- Pain Suppression
	-- Rogue
		[5277]   = Defaults(), -- Evasion
		[31224]  = Defaults(), -- Cloak of Shadows
		[1966]   = Defaults(), -- Feint
		[199754] = Defaults(), -- Riposte
		[45182]  = Defaults(), -- Cheating Death
		[199027] = Defaults(), -- Veil of Midnight
	-- Shaman
		[204293] = Defaults(), -- Spirit Link
		[204288] = Defaults(), -- Earth Shield
		[210918] = Defaults(), -- Ethereal Form
		[207654] = Defaults(), -- Servant of the Queen
		[108271] = Defaults(), -- Astral Shift
		[98007]  = Defaults(), -- Spirit Link Totem
		[207498] = Defaults(), -- Ancestral Protection
	-- Warlock
		[108416] = Defaults(), -- Dark Pact
		[104773] = Defaults(), -- Unending Resolve
		[221715] = Defaults(), -- Essence Drain
		[212295] = Defaults(), -- Nether Ward
	-- Warrior
		[118038] = Defaults(), -- Die by the Sword
		[184364] = Defaults(), -- Enraged Regeneration
		[209484] = Defaults(), -- Tactical Advance
		[97463]  = Defaults(), -- Commanding Shout
		[213915] = Defaults(), -- Mass Spell Reflection
		[199038] = Defaults(), -- Leave No Man Behind
		[223658] = Defaults(), -- Safeguard
		[147833] = Defaults(), -- Intervene
		[198760] = Defaults(), -- Intercept
		[12975]  = Defaults(), -- Last Stand
		[871]    = Defaults(), -- Shield Wall
		[23920]  = Defaults(), -- Spell Reflection
		[216890] = Defaults(), -- Spell Reflection (PvPT)
		[227744] = Defaults(), -- Ravager
		[203524] = Defaults(), -- Neltharion's Fury
		[190456] = Defaults(), -- Ignore Pain
		[132404] = Defaults(), -- Shield Block
	-- Racial
		[65116]  = Defaults(), -- Stoneform
	-- Potion
		[251231] = Defaults(), -- Steelskin Potion (BfA Armor Potion)
	},
}

G.unitframe.aurafilters.PlayerBuffs = {
	type = 'Whitelist',
	spells = {
	-- Death Knight
		[48707]  = Defaults(), -- Anti-Magic Shell
		[81256]  = Defaults(), -- Dancing Rune Weapon
		[55233]  = Defaults(), -- Vampiric Blood
		[193320] = Defaults(), -- Umbilicus Eternus
		[219809] = Defaults(), -- Tombstone
		[48792]  = Defaults(), -- Icebound Fortitude
		[207319] = Defaults(), -- Corpse Shield
		[194844] = Defaults(), -- BoneStorm
		[145629] = Defaults(), -- Anti-Magic Zone
		[194679] = Defaults(), -- Rune Tap
		[51271]  = Defaults(), -- Pilar of Frost
		[207256] = Defaults(), -- Obliteration
		[152279] = Defaults(), -- Breath of Sindragosa
		[233411] = Defaults(), -- Blood for Blood
		[212552] = Defaults(), -- Wraith Walk
		[215711] = Defaults(), -- Soul Reaper
		[194918] = Defaults(), -- Blighted Rune Weapon
	-- Demon Hunter
		[207811] = Defaults(), -- Nether Bond (DH)
		[207810] = Defaults(), -- Nether Bond (Target)
		[187827] = Defaults(), -- Metamorphosis
		[263648] = Defaults(), -- Soul Barrier
		[209426] = Defaults(), -- Darkness
		[196555] = Defaults(), -- Netherwalk
		[212800] = Defaults(), -- Blur
		[188499] = Defaults(), -- Blade Dance
		[203819] = Defaults(), -- Demon Spikes
		[206804] = Defaults(), -- Rain from Above
		[211510] = Defaults(), -- Solitude
		[162264] = Defaults(), -- Metamorphosis
		[205629] = Defaults(), -- Demonic Trample
		[206649] = Defaults(), -- Eye of Leotheras
	-- Druid
		[102342] = Defaults(), -- Ironbark
		[61336]  = Defaults(), -- Survival Instincts
		[210655] = Defaults(), -- Protection of Ashamane
		[22812]  = Defaults(), -- Barkskin
		[200851] = Defaults(), -- Rage of the Sleeper
		[234081] = Defaults(), -- Celestial Guardian
		[202043] = Defaults(), -- Protector of the Pack (it's this one or the other)
		[201940] = Defaults(), -- Protector of the Pack
		[201939] = Defaults(), -- Protector of the Pack (Allies)
		[192081] = Defaults(), -- Ironfur
		[29166]  = Defaults(), -- Innervate
		[208253] = Defaults(), -- Essence of G'Hanir
		[194223] = Defaults(), -- Celestial Alignment
		[102560] = Defaults(), -- Incarnation: Chosen of Elune
		[102543] = Defaults(), -- Incarnation: King of the Jungle
		[102558] = Defaults(), -- Incarnation: Guardian of Ursoc
		[117679] = Defaults(), -- Incarnation
		[106951] = Defaults(), -- Berserk
		[5217]   = Defaults(), -- Tiger's Fury
		[1850]   = Defaults(), -- Dash
		[137452] = Defaults(), -- Displacer Beast
		[102416] = Defaults(), -- Wild Charge
		[77764]  = Defaults(), -- Stampeding Roar (Cat)
		[77761]  = Defaults(), -- Stampeding Roar (Bear)
		[305497] = Defaults(), -- Thorns
		[233756] = Defaults(), -- Eclipse (it's this one or the other)
		[234084] = Defaults(), -- Eclipse
		[22842]  = Defaults(), -- Frenzied Regeneration
	-- Hunter
		[186265] = Defaults(), -- Aspect of the Turtle
		[53480]  = Defaults(), -- Roar of Sacrifice
		[202748] = Defaults(), -- Survival Tactics
		[62305]  = Defaults(), -- Master's Call (it's this one or the other)
		[54216]  = Defaults(), -- Master's Call
		[193526] = Defaults(), -- Trueshot
		[193530] = Defaults(), -- Aspect of the Wild
		[19574]  = Defaults(), -- Bestial Wrath
		[186289] = Defaults(), -- Aspect of the Eagle
		[186257] = Defaults(), -- Aspect of the Cheetah
		[118922] = Defaults(), -- Posthaste
		[90355]  = Defaults(), -- Ancient Hysteria (Pet)
		[160452] = Defaults(), -- Netherwinds (Pet)
	-- Mage
		[45438]  = Defaults(), -- Ice Block
		[113862] = Defaults(), -- Greater Invisibility
		[198111] = Defaults(), -- Temporal Shield
		[198065] = Defaults(), -- Prismatic Cloak
		[11426]  = Defaults(), -- Ice Barrier
		[190319] = Defaults(), -- Combustion
		[80353]  = Defaults(), -- Time Warp
		[12472]  = Defaults(), -- Icy Veins
		[12042]  = Defaults(), -- Arcane Power
		[116014] = Defaults(), -- Rune of Power
		[198144] = Defaults(), -- Ice Form
		[108839] = Defaults(), -- Ice Floes
		[205025] = Defaults(), -- Presence of Mind
		[198158] = Defaults(), -- Mass Invisibility
		[221404] = Defaults(), -- Burning Determination
	-- Monk
		[122783] = Defaults(), -- Diffuse Magic
		[122278] = Defaults(), -- Dampen Harm
		[125174] = Defaults(), -- Touch of Karma
		[201318] = Defaults(), -- Fortifying Elixir
		[201325] = Defaults(), -- Zen Moment
		[202248] = Defaults(), -- Guided Meditation
		[120954] = Defaults(), -- Fortifying Brew
		[116849] = Defaults(), -- Life Cocoon
		[202162] = Defaults(), -- Guard
		[215479] = Defaults(), -- Ironskin Brew
		[152173] = Defaults(), -- Serenity
		[137639] = Defaults(), -- Storm, Earth, and Fire
		[216113] = Defaults(), -- Way of the Crane
		[213664] = Defaults(), -- Nimble Brew
		[201447] = Defaults(), -- Ride the Wind
		[195381] = Defaults(), -- Healing Winds
		[116841] = Defaults(), -- Tiger's Lust
		[119085] = Defaults(), -- Chi Torpedo
		[199407] = Defaults(), -- Light on Your Feet
		[209584] = Defaults(), -- Zen Focus Tea
	-- Paladin
		[642]    = Defaults(), -- Divine Shield
		[498]    = Defaults(), -- Divine Protection
		[205191] = Defaults(), -- Eye for an Eye
		[184662] = Defaults(), -- Shield of Vengeance
		[1022]   = Defaults(), -- Blessing of Protection
		[6940]   = Defaults(), -- Blessing of Sacrifice
		[204018] = Defaults(), -- Blessing of Spellwarding
		[199507] = Defaults(), -- Spreading The Word: Protection
		[216857] = Defaults(), -- Guarded by the Light
		[228049] = Defaults(), -- Guardian of the Forgotten Queen
		[31850]  = Defaults(), -- Ardent Defender
		[86659]  = Defaults(), -- Guardian of Ancien Kings
		[212641] = Defaults(), -- Guardian of Ancien Kings (Glyph of the Queen)
		[209388] = Defaults(), -- Bulwark of Order
		[204335] = Defaults(), -- Aegis of Light
		[152262] = Defaults(), -- Seraphim
		[132403] = Defaults(), -- Shield of the Righteous
		[31884]  = Defaults(), -- Avenging Wrath
		[105809] = Defaults(), -- Holy Avenger
		[231895] = Defaults(), -- Crusade
		[200652] = Defaults(), -- Tyr's Deliverance
		[216331] = Defaults(), -- Avenging Crusader
		[1044]   = Defaults(), -- Blessing of Freedom
		[210256] = Defaults(), -- Blessing of Sanctuary
		[199545] = Defaults(), -- Steed of Glory
		[210294] = Defaults(), -- Divine Favor
		[221886] = Defaults(), -- Divine Steed
		[31821]  = Defaults(), -- Aura Mastery
		[203538] = Defaults(), -- Greater Blessing of Kings
		[203539] = Defaults(), -- Greater Blessing of Wisdom
	-- Priest
		[81782]  = Defaults(), -- Power Word: Barrier
		[47585]  = Defaults(), -- Dispersion
		[19236]  = Defaults(), -- Desperate Prayer
		[213602] = Defaults(), -- Greater Fade
		[27827]  = Defaults(), -- Spirit of Redemption
		[197268] = Defaults(), -- Ray of Hope
		[47788]  = Defaults(), -- Guardian Spirit
		[33206]  = Defaults(), -- Pain Suppression
		[200183] = Defaults(), -- Apotheosis
		[10060]  = Defaults(), -- Power Infusion
		[47536]  = Defaults(), -- Rapture
		[194249] = Defaults(), -- Voidform
		[193223] = Defaults(), -- Surrdender to Madness
		[197862] = Defaults(), -- Archangel
		[197871] = Defaults(), -- Dark Archangel
		[197874] = Defaults(), -- Dark Archangel
		[215769] = Defaults(), -- Spirit of Redemption
		[213610] = Defaults(), -- Holy Ward
		[121557] = Defaults(), -- Angelic Feather
		[214121] = Defaults(), -- Body and Mind
		[65081]  = Defaults(), -- Body and Soul
		[197767] = Defaults(), -- Speed of the Pious
		[210980] = Defaults(), -- Focus in the Light
		[221660] = Defaults(), -- Holy Concentration
		[15286]  = Defaults(), -- Vampiric Embrace
	-- Rogue
		[5277]   = Defaults(), -- Evasion
		[31224]  = Defaults(), -- Cloak of Shadows
		[1966]   = Defaults(), -- Feint
		[199754] = Defaults(), -- Riposte
		[45182]  = Defaults(), -- Cheating Death
		[199027] = Defaults(), -- Veil of Midnight
		[121471] = Defaults(), -- Shadow Blades
		[13750]  = Defaults(), -- Adrenaline Rush
		[51690]  = Defaults(), -- Killing Spree
		[185422] = Defaults(), -- Shadow Dance
		[198368] = Defaults(), -- Take Your Cut
		[198027] = Defaults(), -- Turn the Tables
		[213985] = Defaults(), -- Thief's Bargain
		[197003] = Defaults(), -- Maneuverability
		[212198] = Defaults(), -- Crimson Vial
		[185311] = Defaults(), -- Crimson Vial
		[209754] = Defaults(), -- Boarding Party
		[36554]  = Defaults(), -- Shadowstep
		[2983]   = Defaults(), -- Sprint
		[202665] = Defaults(), -- Curse of the Dreadblades (Self Debuff)
	-- Shaman
		[204293] = Defaults(), -- Spirit Link
		[204288] = Defaults(), -- Earth Shield
		[210918] = Defaults(), -- Ethereal Form
		[207654] = Defaults(), -- Servant of the Queen
		[108271] = Defaults(), -- Astral Shift
		[98007]  = Defaults(), -- Spirit Link Totem
		[207498] = Defaults(), -- Ancestral Protection
		[204366] = Defaults(), -- Thundercharge
		[209385] = Defaults(), -- Windfury Totem
		[208963] = Defaults(), -- Skyfury Totem
		[204945] = Defaults(), -- Doom Winds
		[205495] = Defaults(), -- Stormkeeper
		[208416] = Defaults(), -- Sense of Urgency
		[2825]   = Defaults(), -- Bloodlust
		[16166]  = Defaults(), -- Elemental Mastery
		[167204] = Defaults(), -- Feral Spirit
		[114050] = Defaults(), -- Ascendance (Elem)
		[114051] = Defaults(), -- Ascendance (Enh)
		[114052] = Defaults(), -- Ascendance (Resto)
		[79206]  = Defaults(), -- Spiritwalker's Grace
		[58875]  = Defaults(), -- Spirit Walk
		[157384] = Defaults(), -- Eye of the Storm
		[192082] = Defaults(), -- Wind Rush
		[2645]   = Defaults(), -- Ghost Wolf
		[32182]  = Defaults(), -- Heroism
		[108281] = Defaults(), -- Ancestral Guidance
	-- Warlock
		[108416] = Defaults(), -- Dark Pact
		[104773] = Defaults(), -- Unending Resolve
		[221715] = Defaults(), -- Essence Drain
		[212295] = Defaults(), -- Nether Ward
		[212284] = Defaults(), -- Firestone
		[196098] = Defaults(), -- Soul Harvest
		[221705] = Defaults(), -- Casting Circle
		[111400] = Defaults(), -- Burning Rush
		[196674] = Defaults(), -- Planeswalker
	-- Warrior
		[118038] = Defaults(), -- Die by the Sword
		[184364] = Defaults(), -- Enraged Regeneration
		[209484] = Defaults(), -- Tactical Advance
		[97463]  = Defaults(), -- Commanding Shout
		[213915] = Defaults(), -- Mass Spell Reflection
		[199038] = Defaults(), -- Leave No Man Behind
		[223658] = Defaults(), -- Safeguard
		[147833] = Defaults(), -- Intervene
		[198760] = Defaults(), -- Intercept
		[12975]  = Defaults(), -- Last Stand
		[871]    = Defaults(), -- Shield Wall
		[23920]  = Defaults(), -- Spell Reflection
		[216890] = Defaults(), -- Spell Reflection (PvPT)
		[227744] = Defaults(), -- Ravager
		[203524] = Defaults(), -- Neltharion's Fury
		[190456] = Defaults(), -- Ignore Pain
		[132404] = Defaults(), -- Shield Block
		[1719]   = Defaults(), -- Battle Cry
		[107574] = Defaults(), -- Avatar
		[227847] = Defaults(), -- Bladestorm (Arm)
		[46924]  = Defaults(), -- Bladestorm (Fury)
		[12292]  = Defaults(), -- Bloodbath
		[118000] = Defaults(), -- Dragon Roar
		[199261] = Defaults(), -- Death Wish
		[18499]  = Defaults(), -- Berserker Rage
		[202164] = Defaults(), -- Bounding Stride
		[215572] = Defaults(), -- Frothing Berserker
		[199203] = Defaults(), -- Thirst for Battle
	-- Racials
		[65116] = Defaults(), -- Stoneform
		[59547] = Defaults(), -- Gift of the Naaru
		[20572] = Defaults(), -- Blood Fury
		[26297] = Defaults(), -- Berserking
		[68992] = Defaults(), -- Darkflight
		[58984] = Defaults(), -- Shadowmeld
	-- Consumables
		[251231] = Defaults(), -- Steelskin Potion (BfA Armor)
		[251316] = Defaults(), -- Potion of Bursting Blood (BfA Melee)
		[269853] = Defaults(), -- Potion of Rising Death (BfA Caster)
		[279151] = Defaults(), -- Battle Potion of Intellect (BfA Intellect)
		[279152] = Defaults(), -- Battle Potion of Agility (BfA Agility)
		[279153] = Defaults(), -- Battle Potion of Strength (BfA Strength)
		[178207] = Defaults(), -- Drums of Fury
		[230935] = Defaults(), -- Drums of the Mountain (Legion)
		[256740] = Defaults(), -- Drums of the Maelstrom (BfA)
		[298155] = Defaults(), -- Superior Steelskin Potion
		[298152] = Defaults(), -- Superior Battle Potion of Intellect
		[298146] = Defaults(), -- Superior Battle Potion of Agility
		[298154] = Defaults(), -- Superior Battle Potion of Strength
		[298153] = Defaults(), -- Superior Battle Potion of Stamina
		[298836] = Defaults(), -- Greater Flask of the Currents
		[298837] = Defaults(), -- Greater Flask of Endless Fathoms
		[298839] = Defaults(), -- Greater Flask of the Vast Horizon
		[298841] = Defaults(), -- Greater Flask of the Undertow
	-- Shadowlands Consumables
		[307159] = Defaults(), -- Potion of Spectral Agility
		[307160] = Defaults(), -- Potion of Hardened Shadows
		[307161] = Defaults(), -- Potion of Spiritual Clarity
		[307162] = Defaults(), -- Potion of Spectral Intellect
		[307163] = Defaults(), -- Potion of Spectral Stamina
		[307164] = Defaults(), -- Potion of Spectral Strength
		[307165] = Defaults(), -- Spiritual Anti-Venom
		[307185] = Defaults(), -- Spectral Flask of Power
		[307187] = Defaults(), -- Spectral Flask of Stamina
		[307195] = Defaults(), -- Potion of Hidden Spirit
		[307196] = Defaults(), -- Potion of Shaded Sight
		[307199] = Defaults(), -- Potion of Soul Purity
		[307494] = Defaults(), -- Potion of Empowered Exorcisms
		[307495] = Defaults(), -- Potion of Phantom Fire
		[307496] = Defaults(), -- Potion of Divine Awakening
		[307497] = Defaults(), -- Potion of Deathly Fixation
		[307501] = Defaults(), -- Potion of Specter Swiftness
		[308397] = Defaults(), -- Butterscotch Marinated Ribs
		[308402] = Defaults(), -- Surprisingly Palatable Feast
		[308404] = Defaults(), -- Cinnamon Bonefish Stew
		[308412] = Defaults(), -- Meaty Apple Dumplings
		[308425] = Defaults(), -- Sweet Silvergrill Sausages
		[308434] = Defaults(), -- Phantasmal Souffle and Fries
		[308488] = Defaults(), -- Tenebrous Crown Roast Aspic
		[308506] = Defaults(), -- Crawler Ravioli with Apple Sauce
		[308514] = Defaults(), -- Steak a la Mode
		[308525] = Defaults(), -- Banana Beef Pudding
		[308637] = Defaults(), -- Smothered Shank
		[322302] = Defaults(), -- Potion of Sacrificial Anima
		[327708] = Defaults(), -- Feast of Gluttonous Hedonism
		[327715] = Defaults(), -- Fried Bonefish
		[327851] = Defaults(), -- Seraph Tenders
	},
}

-- Buffs that really we dont need to see
G.unitframe.aurafilters.Blacklist = {
	type = 'Blacklist',
	spells = {
		[36900]  = Defaults(), -- Soul Split: Evil!
		[36901]  = Defaults(), -- Soul Split: Good
		[36893]  = Defaults(), -- Transporter Malfunction
		[97821]  = Defaults(), -- Void-Touched
		[36032]  = Defaults(), -- Arcane Charge
		[8733]   = Defaults(), -- Blessing of Blackfathom
		[25771]  = Defaults(), -- Forbearance (Pally: Divine Shield, Blessing of Protection, and Lay on Hands)
		[57724]  = Defaults(), -- Sated (lust debuff)
		[57723]  = Defaults(), -- Exhaustion (heroism debuff)
		[80354]  = Defaults(), -- Temporal Displacement (timewarp debuff)
		[95809]  = Defaults(), -- Insanity debuff (hunter pet heroism: ancient hysteria)
		[58539]  = Defaults(), -- Watcher's Corpse
		[26013]  = Defaults(), -- Deserter
		[71041]  = Defaults(), -- Dungeon Deserter
		[41425]  = Defaults(), -- Hypothermia
		[55711]  = Defaults(), -- Weakened Heart
		[8326]   = Defaults(), -- Ghost
		[23445]  = Defaults(), -- Evil Twin
		[24755]  = Defaults(), -- Tricked or Treated
		[25163]  = Defaults(), -- Oozeling's Disgusting Aura
		[124275] = Defaults(), -- Stagger
		[124274] = Defaults(), -- Stagger
		[124273] = Defaults(), -- Stagger
		[117870] = Defaults(), -- Touch of The Titans
		[123981] = Defaults(), -- Perdition
		[15007]  = Defaults(), -- Ress Sickness
		[113942] = Defaults(), -- Demonic: Gateway
		[89140]  = Defaults(), -- Demonic Rebirth: Cooldown
		[287825] = Defaults(), -- Lethargy debuff (fight or flight)
		[206662] = Defaults(), -- Experience Eliminated (in range)
		[306600] = Defaults(), -- Experience Eliminated (oor - 5m)
		[206151] = Defaults(), -- Challenger's Burden
	},
}

-- A list of important buffs that we always want to see
G.unitframe.aurafilters.Whitelist = {
	type = 'Whitelist',
	spells = {
		-- Bloodlust effects
		[2825]   = Defaults(), -- Bloodlust
		[32182]  = Defaults(), -- Heroism
		[80353]  = Defaults(), -- Time Warp
		[90355]  = Defaults(), -- Ancient Hysteria
		-- Paladin
		[31821]  = Defaults(), -- Aura Mastery
		[1022]   = Defaults(), -- Blessing of Protection
		[204018] = Defaults(), -- Blessing of Spellwarding
		[6940]   = Defaults(), -- Blessing of Sacrifice
		[1044]   = Defaults(), -- Blessing of Freedom
		-- Priest
		[47788]  = Defaults(), -- Guardian Spirit
		[33206]  = Defaults(), -- Pain Suppression
		[62618]  = Defaults(), -- Power Word: Barrier
		-- Monk
		[116849] = Defaults(), -- Life Cocoon
		-- Druid
		[102342] = Defaults(), -- Ironbark
		-- Shaman
		[98008]  = Defaults(), -- Spirit Link Totem
		[20608]  = Defaults(), -- Reincarnation
		-- Other
		[97462]  = Defaults(), -- Rallying Cry
		[196718] = Defaults(), -- Darkness
	},
}

-- RAID DEBUFFS: This should be pretty self explainitory
G.unitframe.aurafilters.RaidDebuffs = {
	type = 'Whitelist',
	spells = {
	-- Mythic+ Dungeons
		-- General Affix
		[209858] = Defaults(), -- Necrotic
		[226512] = Defaults(), -- Sanguine
		[240559] = Defaults(), -- Grievous
		[240443] = Defaults(), -- Bursting
		-- Shadowlands Affix
		[342494] = Defaults(), -- Belligerent Boast (Prideful)

	-- Shadowlands Dungeons
		-- Halls of Atonement
		[335338] = Defaults(), -- Ritual of Woe
		[326891] = Defaults(), -- Anguish
		[329321] = Defaults(), -- Jagged Swipe 1
		[344993] = Defaults(), -- Jagged Swipe 2
		[319603] = Defaults(), -- Curse of Stone
		[319611] = Defaults(), -- Turned to Stone
		[325876] = Defaults(), -- Curse of Obliteration
		[326632] = Defaults(), -- Stony Veins
		[323650] = Defaults(), -- Haunting Fixation
		[326874] = Defaults(), -- Ankle Bites
		[340446] = Defaults(), -- Mark of Envy
		-- Mists of Tirna Scithe
		[325027] = Defaults(), -- Bramble Burst
		[323043] = Defaults(), -- Bloodletting
		[322557] = Defaults(), -- Soul Split
		[331172] = Defaults(), -- Mind Link
		[322563] = Defaults(), -- Marked Prey
		[322487] = Defaults(), -- Overgrowth 1
		[322486] = Defaults(), -- Overgrowth 2
		[328756] = Defaults(), -- Repulsive Visage
		[325021] = Defaults(), -- Mistveil Tear
		[321891] = Defaults(), -- Freeze Tag Fixation
		[325224] = Defaults(), -- Anima Injection
		[326092] = Defaults(), -- Debilitating Poison
		[325418] = Defaults(), -- Volatile Acid
		-- Plaguefall
		[336258] = Defaults(), -- Solitary Prey
		[331818] = Defaults(), -- Shadow Ambush
		[329110] = Defaults(), -- Slime Injection
		[325552] = Defaults(), -- Cytotoxic Slash
		[336301] = Defaults(), -- Web Wrap
		[322358] = Defaults(), -- Burning Strain
		[322410] = Defaults(), -- Withering Filth
		[328180] = Defaults(), -- Gripping Infection
		[320542] = Defaults(), -- Wasting Blight
		[340355] = Defaults(), -- Rapid Infection
		[328395] = Defaults(), -- Venompiercer
		[320512] = Defaults(), -- Corroded Claws
		[333406] = Defaults(), -- Assassinate
		[332397] = Defaults(), -- Shroudweb
		[330069] = Defaults(), -- Concentrated Plague
		-- The Necrotic Wake
		[321821] = Defaults(), -- Disgusting Guts
		[323365] = Defaults(), -- Clinging Darkness
		[338353] = Defaults(), -- Goresplatter
		[333485] = Defaults(), -- Disease Cloud
		[338357] = Defaults(), -- Tenderize
		[328181] = Defaults(), -- Frigid Cold
		[320170] = Defaults(), -- Necrotic Bolt
		[323464] = Defaults(), -- Dark Ichor
		[323198] = Defaults(), -- Dark Exile
		[343504] = Defaults(), -- Dark Grasp
		[343556] = Defaults(), -- Morbid Fixation 1
		[338606] = Defaults(), -- Morbid Fixation 2
		[324381] = Defaults(), -- Chill Scythe
		[320573] = Defaults(), -- Shadow Well
		[333492] = Defaults(), -- Necrotic Ichor
		[334748] = Defaults(), -- Drain FLuids
		[333489] = Defaults(), -- Necrotic Breath
		[320717] = Defaults(), -- Blood Hunger
		-- Theater of Pain
		[333299] = Defaults(), -- Curse of Desolation 1
		[333301] = Defaults(), -- Curse of Desolation 2
		[319539] = Defaults(), -- Soulless
		[326892] = Defaults(), -- Fixate
		[321768] = Defaults(), -- On the Hook
		[323825] = Defaults(), -- Grasping Rift
		[342675] = Defaults(), -- Bone Spear
		[323831] = Defaults(), -- Death Grasp
		[330608] = Defaults(), -- Vile Eruption
		[330868] = Defaults(), -- Necrotic Bolt Volley
		[323750] = Defaults(), -- Vile Gas
		[323406] = Defaults(), -- Jagged Gash
		[330700] = Defaults(), -- Decaying Blight
		[319626] = Defaults(), -- Phantasmal Parasite
		[324449] = Defaults(), -- Manifest Death
		[341949] = Defaults(), -- Withering Blight
		-- Sanguine Depths
		[326827] = Defaults(), -- Dread Bindings
		[326836] = Defaults(), -- Curse of Suppression
		[322554] = Defaults(), -- Castigate
		[321038] = Defaults(), -- Burden Soul
		[328593] = Defaults(), -- Agonize
		[325254] = Defaults(), -- Iron Spikes
		[335306] = Defaults(), -- Barbed Shackles
		[322429] = Defaults(), -- Severing Slice
		[334653] = Defaults(), -- Engorge
		-- Spires of Ascension
		[338729] = Defaults(), -- Charged Stomp
		[338747] = Defaults(), -- Purifying Blast
		[327481] = Defaults(), -- Dark Lance
		[322818] = Defaults(), -- Lost Confidence
		[322817] = Defaults(), -- Lingering Doubt
		[324205] = Defaults(), -- Blinding Flash
		[331251] = Defaults(), -- Deep Connection
		[328331] = Defaults(), -- Forced Confession
		[341215] = Defaults(), -- Volatile Anima
		[323792] = Defaults(), -- Anima Field
		[317661] = Defaults(), -- Insidious Venom
		[330683] = Defaults(), -- Raw Anima
		[328434] = Defaults(), -- Intimidated
		-- De Other Side
		[320786] = Defaults(), -- Power Overwhelming
		[334913] = Defaults(), -- Master of Death
		[325725] = Defaults(), -- Cosmic Artifice
		[328987] = Defaults(), -- Zealous
		[334496] = Defaults(), -- Soporific Shimmerdust
		[339978] = Defaults(), -- Pacifying Mists
		[323692] = Defaults(), -- Arcane Vulnerability
		[333250] = Defaults(), -- Reaver
		[330434] = Defaults(), -- Buzz-Saw 1
		[320144] = Defaults(), -- Buzz-Saw 2
		[331847] = Defaults(), -- W-00F
		[327649] = Defaults(), -- Crushed Soul
		[331379] = Defaults(), -- Lubricate
		[332678] = Defaults(), -- Gushing Wound
		[322746] = Defaults(), -- Corrupted Blood
		[323687] = Defaults(), -- Arcane Lightning
		[323877] = Defaults(), -- Echo Finger Laser X-treme
		[334535] = Defaults(), -- Beak Slice

	-- Castle Nathria
		-- Shriekwing
		[328897] = Defaults(), -- Exsanguinated
		[330713] = Defaults(), -- Reverberating Pain
		[329370] = Defaults(), -- Deadly Descent
		[336494] = Defaults(), -- Echo Screech
		-- Huntsman Altimor
		[335304] = Defaults(), -- Sinseeker
		[334971] = Defaults(), -- Jagged Claws
		[335111] = Defaults(), -- Huntsman's Mark 1
		[335112] = Defaults(), -- Huntsman's Mark 2
		[335113] = Defaults(), -- Huntsman's Mark 3
		[334945] = Defaults(), -- Bloody Thrash
		-- Hungering Destroyer
		[334228] = Defaults(), -- Volatile Ejection
		[329298] = Defaults(), -- Gluttonous Miasma
		-- Lady Inerva Darkvein
		[325936] = Defaults(), -- Shared Cognition
		[335396] = Defaults(), -- Hidden Desire
		[324983] = Defaults(), -- Shared Suffering
		[324982] = Defaults(), -- Shared Suffering (Partner)
		[332664] = Defaults(), -- Concentrate Anima
		[325382] = Defaults(), -- Warped Desires
		-- Sun King's Salvation
		[333002] = Defaults(), -- Vulgar Brand
		[326078] = Defaults(), -- Infuser's Boon
		[325251] = Defaults(), -- Sin of Pride
		-- Artificer Xy'mox
		[327902] = Defaults(), -- Fixate
		[326302] = Defaults(), -- Stasis Trap
		[325236] = Defaults(), -- Glyph of Destruction
		[327414] = Defaults(), -- Possession
		-- The Council of Blood
		[327052] = Defaults(), -- Drain Essence 1
		[327773] = Defaults(), -- Drain Essence 2
		[346651] = Defaults(), -- Drain Essence Mythic
		[328334] = Defaults(), -- Tactical Advance
		[330848] = Defaults(), -- Wrong Moves
		[331706] = Defaults(), -- Scarlet Letter
		[331636] = Defaults(), -- Dark Recital 1
		[331637] = Defaults(), -- Dark Recital 2
		-- Sludgefist
		[335470] = Defaults(), -- Chain Slam
		[339181] = Defaults(), -- Chain Slam (Root)
		[331209] = Defaults(), -- Hateful Gaze
		[335293] = Defaults(), -- Chain Link
		[335270] = Defaults(), -- Chain This One!
		[335295] = Defaults(), -- Shattering Chain
		-- Stone Legion Generals
		[334498] = Defaults(), -- Seismic Upheaval
		[337643] = Defaults(), -- Unstable Footing
		[334765] = Defaults(), -- Heart Rend
		[333377] = Defaults(), -- Wicked Mark
		[334616] = Defaults(), -- Petrified
		[334541] = Defaults(), -- Curse of Petrification
		[339690] = Defaults(), -- Crystalize
		[342655] = Defaults(), -- Volatile Anima Infusion
		[342698] = Defaults(), -- Volatile Anima Infection
		-- Sire Denathrius
		[326851] = Defaults(), -- Blood Price
		[327796] = Defaults(), -- Night Hunter
		[327992] = Defaults(), -- Desolation
		[328276] = Defaults(), -- March of the Penitent
		[326699] = Defaults(), -- Burden of Sin
		[329181] = Defaults(), -- Wracking Pain
		[335873] = Defaults(), -- Rancor
		[329951] = Defaults(), -- Impale

	},
}

--[[
	RAID BUFFS:
	Buffs that are provided by NPCs in raid or other PvE content.
	This can be buffs put on other enemies or on players.
]]
G.unitframe.aurafilters.RaidBuffsElvUI = {
	type = 'Whitelist',
	spells = {
		-- Mythic+ General
		[209859] = Defaults(), -- Bolster
		[178658] = Defaults(), -- Raging
		[226510] = Defaults(), -- Sanguine
		-- Mythic+ Shadowlands Season 1
		[343502] = Defaults(), -- Inspiring
		[342332] = Defaults(), -- Bursting With Pride (Prideful)
		[340880] = Defaults(), -- Prideful
	},
}

-- Spells that we want to show the duration backwards
E.ReverseTimer = {}

-- AuraWatch: List of personal spells to show on unitframes as icon
function UF:AuraWatch_AddSpell(id, point, color, anyUnit, onlyShowMissing, displayText, textThreshold, xOffset, yOffset)

	local r, g, b = 1, 1, 1
	if color then r, g, b = unpack(color) end

	return {
		id = id,
		enabled = true,
		point = point or 'TOPLEFT',
		color = { r = r, g = g, b = b },
		anyUnit = anyUnit or false,
		onlyShowMissing = onlyShowMissing or false,
		displayText = displayText or false,
		textThreshold = textThreshold or -1,
		xOffset = xOffset or 0,
		yOffset = yOffset or 0,
		style = 'coloredIcon',
		sizeOffset = 0,
	}
end

G.unitframe.aurawatch = {
	GLOBAL = {},
	PRIEST = {
		[139]    = UF:AuraWatch_AddSpell(139, 'BOTTOMLEFT', {0.4, 0.7, 0.2}),			-- Renew
		[17]     = UF:AuraWatch_AddSpell(17, 'TOPLEFT', {0.7, 0.7, 0.7}, true), 		-- Power Word: Shield
		[193065] = UF:AuraWatch_AddSpell(193065, 'BOTTOMRIGHT', {0.54, 0.21, 0.78}),	-- Masochism
		[194384] = UF:AuraWatch_AddSpell(194384, 'TOPRIGHT', {1, 1, 0.66}), 			-- Atonement
		[214206] = UF:AuraWatch_AddSpell(214206, 'TOPRIGHT', {1, 1, 0.66}), 			-- Atonement (PvP)
		[33206]  = UF:AuraWatch_AddSpell(33206, 'LEFT', {0.47, 0.35, 0.74}, true),		-- Pain Suppression
		[41635]  = UF:AuraWatch_AddSpell(41635, 'BOTTOMRIGHT', {0.2, 0.7, 0.2}),		-- Prayer of Mending
		[47788]  = UF:AuraWatch_AddSpell(47788, 'LEFT', {0.86, 0.45, 0}, true), 		-- Guardian Spirit
		[6788]   = UF:AuraWatch_AddSpell(6788, 'BOTTOMLEFT', {0.89, 0.1, 0.1}), 		-- Weakened Soul
	},
	DRUID = {
		[774]    = UF:AuraWatch_AddSpell(774, 'TOPRIGHT', {0.8, 0.4, 0.8}), 			-- Rejuvenation
		[155777] = UF:AuraWatch_AddSpell(155777, 'RIGHT', {0.8, 0.4, 0.8}), 			-- Germination
		[8936]   = UF:AuraWatch_AddSpell(8936, 'BOTTOMLEFT', {0.2, 0.8, 0.2}),			-- Regrowth
		[33763]  = UF:AuraWatch_AddSpell(33763, 'TOPLEFT', {0.4, 0.8, 0.2}), 			-- Lifebloom
		[188550] = UF:AuraWatch_AddSpell(188550, 'TOPLEFT', {0.4, 0.8, 0.2}),			-- Lifebloom (Shadowlands Legendary)
		[48438]  = UF:AuraWatch_AddSpell(48438, 'BOTTOMRIGHT', {0.8, 0.4, 0}),			-- Wild Growth
		[207386] = UF:AuraWatch_AddSpell(207386, 'TOP', {0.4, 0.2, 0.8}), 				-- Spring Blossoms
		[102351] = UF:AuraWatch_AddSpell(102351, 'LEFT', {0.2, 0.8, 0.8}),				-- Cenarion Ward (Initial Buff)
		[102352] = UF:AuraWatch_AddSpell(102352, 'LEFT', {0.2, 0.8, 0.8}),				-- Cenarion Ward (HoT)
		[200389] = UF:AuraWatch_AddSpell(200389, 'BOTTOM', {1, 1, 0.4}),				-- Cultivation
		[203554] = UF:AuraWatch_AddSpell(203554, 'TOP', {1, 1, 0.4}),					-- Focused Growth (PvP)
	},
	PALADIN = {
		[53563]  = UF:AuraWatch_AddSpell(53563, 'TOPRIGHT', {0.7, 0.3, 0.7}),			-- Beacon of Light
		[156910] = UF:AuraWatch_AddSpell(156910, 'TOPRIGHT', {0.7, 0.3, 0.7}),			-- Beacon of Faith
		[200025] = UF:AuraWatch_AddSpell(200025, 'TOPRIGHT', {0.7, 0.3, 0.7}),			-- Beacon of Virtue
		[1022]   = UF:AuraWatch_AddSpell(1022, 'BOTTOMRIGHT', {0.2, 0.2, 1}, true), 	-- Blessing of Protection
		[1044]   = UF:AuraWatch_AddSpell(1044, 'BOTTOMRIGHT', {0.89, 0.45, 0}, true),	-- Blessing of Freedom
		[6940]   = UF:AuraWatch_AddSpell(6940, 'BOTTOMRIGHT', {0.89, 0.1, 0.1}, true),	-- Blessing of Sacrifice
		[204018] = UF:AuraWatch_AddSpell(204018, 'BOTTOMRIGHT', {0.2, 0.2, 1}, true),	-- Blessing of Spellwarding
		[223306] = UF:AuraWatch_AddSpell(223306, 'BOTTOMLEFT', {0.7, 0.7, 0.3}),		-- Bestow Faith
		[287280] = UF:AuraWatch_AddSpell(287280, 'TOPLEFT', {0.2, 0.8, 0.2}),			-- Glimmer of Light (T50 Talent)
		[157047] = UF:AuraWatch_AddSpell(157047, 'TOP', {0.15, 0.58, 0.84}),			-- Saved by the Light (T25 Talent)
	},
	SHAMAN = {
		[61295]  = UF:AuraWatch_AddSpell(61295, 'TOPRIGHT', {0.7, 0.3, 0.7}),			-- Riptide
		[974]    = UF:AuraWatch_AddSpell(974, 'BOTTOMRIGHT', {0.2, 0.2, 1}),			-- Earth Shield
	},
	MONK = {
		[119611] = UF:AuraWatch_AddSpell(119611, 'TOPLEFT', {0.3, 0.8, 0.6}),			-- Renewing Mist
		[116849] = UF:AuraWatch_AddSpell(116849, 'TOPRIGHT', {0.2, 0.8, 0.2}, true),	-- Life Cocoon
		[124682] = UF:AuraWatch_AddSpell(124682, 'BOTTOMLEFT', {0.8, 0.8, 0.25}),		-- Enveloping Mist
		[191840] = UF:AuraWatch_AddSpell(191840, 'BOTTOMRIGHT', {0.27, 0.62, 0.7}),		-- Essence Font
		[116841] = UF:AuraWatch_AddSpell(116841, 'TOP', {0.12, 1.00, 0.53}),			-- Tiger's Lust (Freedom)
	},
	ROGUE = {
		[57934]  = UF:AuraWatch_AddSpell(57934, 'TOPRIGHT', {0.89, 0.09, 0.05}),		-- Tricks of the Trade
	},
	WARRIOR = {
		[3411]   = UF:AuraWatch_AddSpell(3411, 'TOPRIGHT', {0.89, 0.09, 0.05}),			-- Intervene
	},
	PET = {
		-- Warlock Pets
		[193396] = UF:AuraWatch_AddSpell(193396, 'TOPRIGHT', {0.6, 0.2, 0.8}, true),	-- Demonic Empowerment
		-- Hunter Pets
		[272790] = UF:AuraWatch_AddSpell(272790, 'TOPLEFT', {0.89, 0.09, 0.05}, true),	-- Frenzy
		[136] = UF:AuraWatch_AddSpell(290819, 'TOPRIGHT', {0.2, 0.8, 0.2}, true),		-- Mend Pet
	},
	HUNTER = {
		[90361]  = UF:AuraWatch_AddSpell(90361, 'TOP', {0.34, 0.47, 0.31}),				-- Spirit Mend (HoT)
	},
	DEMONHUNTER = {}, -- Keep for reference to G.unitframe.aurawatch[E.myclass][SomeValue]
	WARLOCK = {},
	MAGE = {},
	DEATHKNIGHT = {},
}

-- Profile specific BuffIndicator
P.unitframe.filters = {
	aurawatch = {},
}

-- List of spells to display ticks
G.unitframe.ChannelTicks = {
	-- Racials
	[291944] = 6,	-- Regeneratin (Zandalari)
	-- Warlock
	[198590] = 5,	-- Drain Soul
	[755]    = 5,	-- Health Funnel
	[234153] = 5,	-- Drain Life
	-- Priest
	[64843]  = 4,	-- Divine Hymn
	[15407]  = 6,	-- Mind Flay
	[48045]  = 6,	-- Mind Sear
	[47757]  = 3,	-- Penance (heal)
	[47758]  = 3,	-- Penance (dps)
	[64902]  = 5,	-- Symbol of Hope (Mana Hymn)
	-- Mage
	[5143]   = 4,	-- Arcane Missiles
	[12051]  = 6,	-- Evocation
	[205021] = 5,	-- Ray of Frost
	-- Druid
	[740]    = 4,	-- Tranquility
	-- DK
	[206931] = 3,	-- Blooddrinker
	-- DH
	[198013] = 10,	-- Eye Beam
	[212084] = 10,	-- Fel Devastation
	-- Hunter
	[120360] = 15,	-- Barrage
	[257044] = 7,	-- Rapid Fire
}

-- Spells Effected By Talents
G.unitframe.TalentChannelTicks = {
	-- Priest
	[47757]  = {tier = 1, column = 1, ticks = 4},	-- Penance (heal)
	[47758]  = {tier = 1, column = 1, ticks = 4},	-- Penance (dps)
}

G.unitframe.ChannelTicksSize = {
	-- Warlock
	[198590] = 1,	-- Drain Soul
	-- Mage
	[205021] = 1,	-- Ray of Frost
}

-- Spells Effected By Haste, these spells require a Tick Size (table above)
G.unitframe.HastedChannelTicks = {
	-- Mage
	[205021] = true,	-- Ray of Frost
}

-- This should probably be the same as the whitelist filter + any personal class ones that may be important to watch
G.unitframe.AuraBarColors = {
	[2825]  = { enable = true, color = {r = 0.98, g = 0.57, b = 0.10 }}, -- Bloodlust
	[32182] = { enable = true, color = {r = 0.98, g = 0.57, b = 0.10 }}, -- Heroism
	[80353] = { enable = true, color = {r = 0.98, g = 0.57, b = 0.10 }}, -- Time Warp
	[90355] = { enable = true, color = {r = 0.98, g = 0.57, b = 0.10 }}, -- Ancient Hysteria
}

G.unitframe.AuraHighlightColors = {}

G.unitframe.specialFilters = {
	-- Whitelists
	Boss = true,
	MyPet = true,
	OtherPet = true,
	Personal = true,
	nonPersonal = true,
	CastByUnit = true,
	notCastByUnit = true,
	Dispellable = true,
	notDispellable = true,
	CastByNPC = true,
	CastByPlayers = true,
	BlizzardNameplate = true,

	-- Blacklists
	blockNonPersonal = true,
	blockCastByPlayers = true,
	blockNoDuration = true,
	blockDispellable = true,
	blockNotDispellable = true,
};
