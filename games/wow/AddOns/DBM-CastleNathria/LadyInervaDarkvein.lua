local mod	= DBM:NewMod(2420, "DBM-CastleNathria", nil, 1190)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20201013203549")
mod:SetCreatureID(165521)
mod:SetEncounterID(2406)
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)
mod:SetHotfixNoticeRev(20200816000000)--2020, 8, 16
--mod:SetMinSyncRevision(20200816000000)--2020, 8, 16
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 342321 331550 334017 339521 341621 342320 342322 342280 342281 342282 341623 341625",
--	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED 325382 325936 324983 332664 335396 339525 340477 340452",
	"SPELL_AURA_APPLIED_DOSE 325382",
	"SPELL_AURA_REMOVED 340452 332664 324983 339525 340477",
	"SPELL_PERIODIC_DAMAGE 325713",
	"SPELL_PERIODIC_MISSED 325713",
--	"UNIT_DIED"
	"UNIT_SPELLCAST_SUCCEEDED boss1",
	"UPDATE_UI_WIDGET"
)

--TODO, also figure out optimized tank swap priority
--TODO, add pre debuff if blizz adds it for shared suffering
--TODO, rework timers further since they are still hardly that accurate and blizz will no doubt change power rates again.
--TODO, does https://shadowlands.wowhead.com/spell=331573/unconscionable-guilt need anything? doesn't say it stacks
--TODO, if container fill timers work, maybe support doing it with infoframe instead
--TODO, fix initial timers using a valid transcriptor log that resets boss and repulls boss to cleanup the bad first pull data from bugged ES event
--[[
(ability.id = 342321 or ability.id = 342280 or ability.id = 342281 or ability.id = 342282 or ability.id = 341621 or ability.id = 342320 or ability.id = 342322 or ability.id = 341623 or ability.id = 341625) and type = "begincast"
 or ability.id = 324983 and type = "applydebuff"
 or ability.id = 331844
 or (ability.id = 331550 or ability.id = 334017 or ability.id = 339521) and type = "begincast"
--]]
--TODO, same approach and margock, make it so warnings show which rank it is
local warnWarpedDesires							= mod:NewStackAnnounce(325382, 2, nil, "Tank|Healer")
local warnSharedCognition						= mod:NewTargetNoFilterAnnounce(325936, 4, nil, "Healer")
local warnChangeofHeart							= mod:NewTargetNoFilterAnnounce(340452, 3)
local warnBottledAnima							= mod:NewSpellAnnounce(325769, 2)
local warnSharedSuffering						= mod:NewTargetNoFilterAnnounce(324983, 3)
local warnConcentrateAnima						= mod:NewTargetNoFilterAnnounce(342321, 3)
local warnCondemnTank							= mod:NewCastAnnounce(334017, 3, nil, nil, "Tank")

local specWarnExposeDesires						= mod:NewSpecialWarningDefensive(341621, false, nil, nil, 1, 2)--Optional warning that the cast is happening toward you
local specWarnWarpedDesires						= mod:NewSpecialWarningTaunt(325382, false, nil, 2, 1, 2)
local specWarnHiddenDesire						= mod:NewSpecialWarningYou(335396, nil, nil, nil, 1, 2)
local specWarnHiddenDesireTaunt					= mod:NewSpecialWarningTaunt(335396, nil, nil, nil, 1, 2)
local yellHiddenDesire							= mod:NewYell(335396, nil, false)--Remove?
local specWarnChangeofHeart						= mod:NewSpecialWarningMoveAway(340452, nil, nil, nil, 3, 2)--Triggered by rank 3 Exposed Desires
local yellChangeofHeartFades					= mod:NewFadesYell(340452)--^^
local specWarnSharedSuffering					= mod:NewSpecialWarningMoveTo(324983, nil, nil, nil, 1, 2)
local yellSharedSuffering						= mod:NewShortYell(324983)
local specWarnConcentrateAnima					= mod:NewSpecialWarningMoveAway(342321, nil, nil, nil, 1, 2)--Rank 1-2
local yellConcentrateAnimaFades					= mod:NewShortFadesYell(342321)--^^
local specWarnGTFO								= mod:NewSpecialWarningGTFO(325713, nil, nil, nil, 1, 8)
--Anima Constructs
local specWarnCondemn							= mod:NewSpecialWarningInterrupt(331550, "HasInterrupt", nil, nil, 1, 2)--Don't really want to hard interrupt warning for something with 10 second cast, this is opt in

--mod:AddTimerLine(BOSS)
local timerDesiresContainer						= mod:NewTimer(120, "timerDesiresContainer", 341621, false, "timerContainers")
local timerBottledContainer						= mod:NewTimer(120, "timerBottledContainer", 342280, false, "timerContainers")
local timerSinsContainer						= mod:NewTimer(120, "timerSinsContainer", 325064, false, "timerContainers")
local timerConcentrateContainer					= mod:NewTimer(120, "timerConcentrateContainer", 342321, false, "timerContainers")
local timerFocusAnimaCD							= mod:NewCDTimer(100, 331844, nil, nil, nil, 6)
local timerExposedDesiresCD						= mod:NewCDTimer(8.5, 341621, nil, "Tank|Healer", nil, 5, nil, DBM_CORE_L.TANK_ICON)--8.5-25 because yeah, boss spell queuing+CD even changing when higher rank
local timerBottledAnimaCD						= mod:NewCDTimer(10.8, 342280, nil, nil, nil, 3)--10-36
local timerSinsandSufferingCD					= mod:NewCDTimer(44.3, 325064, nil, nil, nil, 3)
local timerConcentratedAnimaCD					= mod:NewCDTimer(35.4, 342321, nil, nil, nil, 1, nil, nil, nil, 1, 3)--Technically targetted(3) bar type as well, but since bar is both, and 2 other bars are already 3s, 1 makes more sense
local timerChangeofHeart						= mod:NewTargetTimer(4, 340452, nil, nil, nil, 5, nil, DBM_CORE_L.HEALER_ICON)

--local berserkTimer							= mod:NewBerserkTimer(600)

--mod:AddRangeFrameOption(10, 310277)
mod:AddBoolOption("timerContainers", true, "timer", nil, 6)
--mod:AddInfoFrameOption(325225, true)
mod:AddSetIconOption("SetIconOnSharedSuffering", 324983, true, false, {1, 2, 3})
mod:AddSetIconOption("SetIconOnAdds", "ej21227", true, true, {5, 6, 7, 8})
--mod:AddNamePlateOption("NPAuraOnVolatileCorruption", 312595)

mod.vb.sufferingIcon = 1
mod.vb.addIcon = 8
mod.vb.containerActive = 0
local castsPerGUID = {}
local playerName = UnitName("player")
local containerProgress = {
	[2380] = {--Hidden Desires
		[1] = 0,--Current container value
		[2] = 0,--Previous Congtainer Value
		[3] = 0,--Previous Container rate
	},
	[2399] = {--Bottled Anima
		[1] = 0,
		[2] = 0,
		[3] = 0,
	},
	[2400] = {--Sins and Suffering
		[1] = 0,
		[2] = 0,
		[3] = 0,
	},
	[2401] = {--Concentrate Anima
		[1] = 0,
		[2] = 0,
		[3] = 0,
	},
}
--[[
Notes:
1. Sequencing looks good at first, but there is clearly more to it then that.
2. Only super clear thing is the empowered container is always shorter CD, but still many variationsn to explain

--Heroic
"Bottled Anima-325774-npc:165521 = pull:29.4, 34.0, 19.6, 26.8, 10.8, 14.9, 18.3, 17.4, 18.3, 33.7, 36.9, 36.5", -- [2]
"Bottled Anima-325774-npc:165521 = pull:29.3, 34.1, 19.6, 21.1, 17.9, 14.7, 18.4, 17.4, 17.9, 28.8, 38.3, 38.3", -- [2]
--Mythic
"Bottled Anima-325774-npc:165521 = pull:35.9, 32.5, 32.4, 18.3, 33.1, 27.3, 37.8, 31.9, 34.3, 42.7", -- [2]
"Bottled Anima-325774-npc:165521 = pull:35.9, 34.8, 26.4, 22.1, 31.9, 24.4, 38.1, 56.6, 32.5", -- [2]
"Bottled Anima-325774-npc:165521 = pull:35.6, 32.6, 32.2, 18.8, 27.8, 17.1, 46.2, 41.5", -- [2]

--Heroic
"Concentrate Anima-332665-npc:165521 = pull:54.6, 35.4, 36.6, 35.7, 35.4, 41.4, 37.7, 35.3", -- [1]
"Concentrate Anima-332665-npc:165521 = pull:54.6, 35.4, 37.8, 35.5, 73.1, 37.8, 35.8", -- [1]
--Mythic
"Concentrate Anima-332665-npc:165521 = pull:44.0, 62.3, 100.4, 74.8, 42.8", -- [1]
"Concentrate Anima-332665-npc:165521 = pull:44.0, 65.1, 98.0, 73.7", -- [1]
"Concentrate Anima-332665-npc:165521 = pull:44.2, 62.3, 74.9, 62.3, 64.7", -- [1]

--Heroic
"Hidden Desire-335322-npc:171801 = pull:13.9, 9.4, 8.5, 8.9, 9.3, 8.9, 9.7, 8.2, 9.8, 8.5, 17.1, 10.9, 11.0, 11.0, 11.7, 10.6, 13.4, 11.0, 25.2, 15.0, 13.4, 13.4, 13.4, 15.4, 12.6", -- [5]
"Hidden Desire-335322-npc:171801 = pull:13.9, 9.7, 9.8, 8.5, 9.3, 8.5, 9.8, 9.8, 8.6, 19.9, 11.8, 12.2, 11.0, 11.0, 13.2, 11.2, 11.0, 24.4, 14.6, 13.8, 13.0, 13.5, 13.0, 13.0", -- [5]
--Mythic
"Expose Desires-325379-npc:165521 = pull:12.4, 8.6, 9.7, 8.6, 8.7, 9.8, 14.8, 10.8, 11.0, 11.0, 11.2, 11.0, 12.3, 12.2, 18.3, 13.5, 13.4, 13.4, 12.2, 13.5, 13.5, 13.4, 13.5, 12.2, 14.7, 12.2, 19.5, 13.5", -- [3]

--Heroic
"Sins and Suffering-325064-npc:165521 = pull:18.0, 26.8, 26.5, 40.2, 33.0, 35.3, 29.3, 17.4, 19.5, 19.1, 18.3", -- [13]
"Sins and Suffering-325064-npc:165521 = pull:18.9, 26.8, 26.8, 26.9, 43.9, 35.7, 33.8, 17.5, 18.3, 19.5, 18.2", -- [18]
--Mythic
"Sins and Suffering-325064-npc:165521 = pull:18.1, 60.6, 53.9, 62.4, 32.4, 52.6, 53.2", -- [19]
"Sins and Suffering-325064-npc:165521 = pull:17.6, 65.1, 53.2, 53.9, 37.3, 33.9, 41.3", -- [13]
--]]

--[[
local updateInfoFrame
do
	local twipe = table.wipe
	local lines = {}
	local sortedLines = {}
	local function addLine(key, value)
		-- sort by insertion order
		lines[key] = value
		sortedLines[#sortedLines + 1] = key
	end
	updateInfoFrame = function()
		twipe(lines)
		twipe(sortedLines)
		--Do Stuff?
		return lines, sortedLines
	end
end
--]]

function mod:OnCombatStart(delay)
	--Reset on pull for a reason, no touch
	containerProgress[2380][1] = 0
	containerProgress[2380][2] = 0
	containerProgress[2380][3] = 0

	containerProgress[2399][1] = 0
	containerProgress[2399][2] = 0
	containerProgress[2399][3] = 0

	containerProgress[2400][1] = 0
	containerProgress[2400][2] = 0
	containerProgress[2400][3] = 0

	containerProgress[2401][1] = 0
	containerProgress[2401][2] = 0
	containerProgress[2401][3] = 0
	self.vb.containerActive = 0
	table.wipe(castsPerGUID)
--	if self:IsMythic() then
		timerFocusAnimaCD:Start(3.7-delay)
		timerExposedDesiresCD:Start(10.9-delay)
		timerSinsandSufferingCD:Start(17.6-delay)--23.6
		timerBottledAnimaCD:Start(35.6-delay)--31.5
		timerConcentratedAnimaCD:Start(44-delay)--Not cast on normal until near end of fight
--	else
--		timerFocusAnimaCD:Start(3.8-delay)
--		timerExposedDesiresCD:Start(13.9-delay)
--		timerSinsandSufferingCD:Start(18-delay)
--		timerBottledAnimaCD:Start(29.3-delay)
--		timerConcentratedAnimaCD:Start(54.6-delay)
--	end
--	if self.Options.NPAuraOnVolatileCorruption then
--		DBM:FireEvent("BossMod_EnableHostileNameplates")
--	end
--	if self.Options.InfoFrame then
--		DBM.InfoFrame:SetHeader(DBM_CORE_L.INFOFRAME_POWER)
--		DBM.InfoFrame:Show(3, "enemypower")--TODO, add right power type
--	end
--	if self.Options.RangeFrame then
--		DBM.RangeCheck:Show(4)--For Acid Splash
--	end
--	berserkTimer:Start(-delay)--Confirmed normal and heroic
end

function mod:OnCombatEnd()
	table.wipe(castsPerGUID)
--	if self.Options.InfoFrame then
--		DBM.InfoFrame:Hide()
--	end
--	if self.Options.RangeFrame then
--		DBM.RangeCheck:Hide()
--	end
--	if self.Options.NPAuraOnVolatileCorruption then
--		DBM.Nameplate:Hide(true, nil, nil, nil, true, true)
--	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 341621 or spellId == 341623 or spellId == 341625 then--Rank 1, Rank 2, Rank 3
		--1 Expose Desires (tank), 2 Bottled Anima (bouncing bottles), 3 Sins and Suffering (links), 4 Concentrate Anima (adds)
		timerExposedDesiresCD:Start(self.vb.containerActive == 1 and 8.2 or 10.6)--Possibly 8, 10, and 13
		if self:IsTanking("player", "boss1", nil, true) then
			specWarnExposeDesires:Show()
			specWarnExposeDesires:Play("defensive")
		end
	elseif spellId == 342320 or spellId == 342321 or spellId == 342322 then--Rank 1, Rank 2, Rank 3
		self.vb.addIcon = 8
		--1 Expose Desires (tank), 2 Bottled Anima (bouncing bottles), 3 Sins and Suffering (links), 4 Concentrate Anima (adds)
		timerConcentratedAnimaCD:Start(self.vb.containerActive == 4 and 42.8 or 62.3)
	elseif spellId == 342280 or spellId == 342281 or spellId == 342282 then--Rank 1, Rank 2, Rank 3
		warnBottledAnima:Show()
		timerBottledAnimaCD:Start(self.vb.containerActive == 2 and 17.1 or 30)
	elseif spellId == 331550 or spellId == 339521 then--Conjured Manifestation casting Condemn
		if not castsPerGUID[args.sourceGUID] then
			castsPerGUID[args.sourceGUID] = 0
			if self.Options.SetIconOnAdds and self.vb.addIcon > 3 then--Only use up to 5 icons
				self:ScanForMobs(args.sourceGUID, 2, self.vb.addIcon, 1, 0.2, 12)
			end
			self.vb.addIcon = self.vb.addIcon - 1
		end
--		if (self.vb.interruptBehavior == "Four" and castsPerGUID[args.sourceGUID] == 4) or (self.vb.interruptBehavior == "Five" and castsPerGUID[args.sourceGUID] == 5) or (self.vb.interruptBehavior == "Six" and castsPerGUID[args.sourceGUID] == 6) then
--			castsPerGUID[args.sourceGUID] = 0
--		end
		castsPerGUID[args.sourceGUID] = castsPerGUID[args.sourceGUID] + 1
		local count = castsPerGUID[args.sourceGUID]
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnCondemn:Show(args.sourceName, count)
			if count == 1 then
				specWarnCondemn:Play("kick1r")
			elseif count == 2 then
				specWarnCondemn:Play("kick2r")
			elseif count == 3 then
				specWarnCondemn:Play("kick3r")
			elseif count == 4 then
				specWarnCondemn:Play("kick4r")
			elseif count == 5 then
				specWarnCondemn:Play("kick5r")
			else--Shouldn't happen, but fallback rules never hurt
				specWarnCondemn:Play("kickcast")
			end
		end
	elseif spellId == 334017 then--Harnessed Specter (only used if not actively tanked)
		warnCondemnTank:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 325382 then
		local amount = args.amount or 1
		warnWarpedDesires:Show(args.destName, amount)
		if args:IsPlayer() then
			--Nothing
		else
			specWarnWarpedDesires:Show(args.destName)
			specWarnWarpedDesires:Play("tauntboss")
		end
	elseif spellId == 340452 then
		if args:IsPlayer() then
			specWarnChangeofHeart:Show()
			specWarnChangeofHeart:Play("runout")
			yellChangeofHeartFades:Countdown(spellId)
		else
			warnChangeofHeart:Show(args.destName)
		end
		timerChangeofHeart:Start(args.destName)
	elseif spellId == 325936 then
		warnSharedCognition:CombinedShow(0.3, args.destName)
	elseif spellId == 324983 then
		warnSharedSuffering:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnSharedSuffering:Show()
			specWarnSharedSuffering:Play("targetyou")
			yellSharedSuffering:Yell()
		end
		if self.Options.SetIconOnSharedSuffering and self.vb.sufferingIcon < 4 then--Icons for this are nice, but reserve 5 of them for adds
			self:SetIcon(args.destName, self.vb.sufferingIcon)
		end
		self.vb.sufferingIcon = self.vb.sufferingIcon + 1
	elseif spellId == 332664 or spellId == 340477 or spellId == 339525 then--332664 was used on heroic testing, 340477 and 332664 both occured on mythic, not seen 339525 yet
		warnConcentrateAnima:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnConcentrateAnima:Show()
			specWarnConcentrateAnima:Play("runout")
			yellConcentrateAnimaFades:CountdownSay(spellId)--SAY (white letters for avoid)
		end
	elseif spellId == 335396 then
		if args:IsPlayer() then
			specWarnHiddenDesire:Show()
			specWarnHiddenDesire:Play("targetyou")
			yellHiddenDesire:Yell()
		else
			specWarnHiddenDesireTaunt:Show(args.destName)
			specWarnHiddenDesireTaunt:Play("tauntboss")
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 340452 then
		if args:IsPlayer() then
			yellChangeofHeartFades:Cancel()
		end
		timerChangeofHeart:Stop(args.destName)
	elseif spellId == 332664 or spellId == 340477 or spellId == 339525 then
		if args:IsPlayer() then
			yellConcentrateAnimaFades:Cancel()
		end
	elseif spellId == 324983 then
		if self.Options.SetIconOnSharedSuffering then
			self:SetIcon(args.destName, 0)
		end
	end
end

--[[
function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 170199 then--Harnessed Specter

	elseif cid == 170197 then--Conjured Manifestation

	end
end
--]]

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 325713 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

--TODO, maybe these scripts run, if so detecting ranks could be cleaner
--Concentrate Anima: Rank 1 326258, Rank 2 325922, rank 3 325923
function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 325064 then--Sins and Suffering
		self.vb.sufferingIcon = 1
		--1 Expose Desires (tank), 2 Bottled Anima (bouncing bottles), 3 Sins and Suffering (links), 4 Concentrate Anima (adds)
		timerSinsandSufferingCD:Start(self.vb.containerActive == 3 and 32.4 or 53.4)
	elseif spellId == 338749 then--Disable Container
--		timerFocusAnimaCD:Start(99.5)--62-99.5
		--1 Expose Desires (tank), 2 Bottled Anima (bouncing bottles), 3 Sins and Suffering (links), 4 Concentrate Anima (adds)
		self.vb.containerActive = self.vb.containerActive + 1
		if self.vb.containerActive == 5 then
			self.vb.containerActive = 1
		end
	end
end

function mod:UPDATE_UI_WIDGET(table)
	local id = table.widgetID
	if not containerProgress[id] then return end
	local widgetInfo = C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(id)
	local value = widgetInfo.barValue
	if not value then return end
	containerProgress[id][1] = value
	if self.Options.timerContainers then
		if value ~= containerProgress[id][2] then--Make sure value isn't same as previous value, if it is there is nothing to do
			local energyRate = containerProgress[id][1] - containerProgress[id][2]--Current progress minus previous progress
			if containerProgress[id][3] ~= energyRate then--Energy rate has changed, we don't want to perform below operations if energy rate is the same
				if energyRate > 0 then--Gaining
					local timeElapsed, timeTotal = value / energyRate, 1600 / energyRate
					--Create/Update a bar with time left and progress relative to container fill status
					if id == 2380 then
						timerDesiresContainer:Update(timeElapsed, timeTotal)
					elseif id == 2380 then
						timerBottledContainer:Update(timeElapsed, timeTotal)
					elseif id == 2380 then
						timerSinsContainer:Update(timeElapsed, timeTotal)
					else--2401
						timerConcentrateContainer:Update(timeElapsed, timeTotal)
					end
				else--Draining
					--If container is currently being drained, terminate timer until they begin to fill again
					if id == 2380 then
						timerDesiresContainer:Stop()
					elseif id == 2380 then
						timerBottledContainer:Stop()
					elseif id == 2380 then
						timerSinsContainer:Stop()
					else--2401
						timerConcentrateContainer:Stop()
					end
				end
				containerProgress[id][3] = energyRate
			end
			containerProgress[id][2] = value--Set previous progress for next cycle, even if energy rate hasn't changed
		end
	end
end
