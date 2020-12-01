local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

local _G = _G
local pairs, select, unpack = pairs, select, unpack

local hooksecurefunc = hooksecurefunc
local GetAchievementCriteriaInfo = GetAchievementCriteriaInfo
local GetAchievementNumCriteria = GetAchievementNumCriteria
local GetNumFilteredAchievements = GetNumFilteredAchievements
local IsAddOnLoaded = IsAddOnLoaded
local CreateFrame = CreateFrame

local blueAchievement = { r = 0.1, g = 0.2, b = 0.3 }
local function blueBackdrop(self)
	self:SetBackdropColor(blueAchievement.r, blueAchievement.g, blueAchievement.b)
end

local function skinAch(Achievement, BiggerIcon)
	if Achievement.isSkinned then return; end

	Achievement:SetFrameLevel(Achievement:GetFrameLevel() + 2)
	Achievement:StripTextures(true)
	Achievement:CreateBackdrop(nil, true)
	Achievement.backdrop:SetInside()
	Achievement.icon:CreateBackdrop(nil, nil, nil, nil, nil, nil, true)
	Achievement.icon:Size(BiggerIcon and 54 or 36, BiggerIcon and 54 or 36)
	Achievement.icon:ClearAllPoints()
	Achievement.icon:Point('TOPLEFT', 8, -8)
	Achievement.icon.bling:Kill()
	Achievement.icon.frame:Kill()
	Achievement.icon.texture:SetTexCoord(unpack(E.TexCoords))
	Achievement.icon.texture:SetInside()

	if Achievement.highlight then
		Achievement.highlight:StripTextures()
		Achievement:HookScript('OnEnter', function(self) self.backdrop:SetBackdropBorderColor(1, 1, 0) end)
		Achievement:HookScript('OnLeave', function(self) self.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor)) end)
	end

	if Achievement.label then
		Achievement.label:SetTextColor(1, 1, 1)
	end

	if Achievement.description then
		Achievement.description:SetTextColor(.6, .6, .6)
		hooksecurefunc(Achievement.description, 'SetTextColor', function(_, r, g, b)
			if r == 0 and g == 0 and b == 0 then
				Achievement.description:SetTextColor(.6, .6, .6)
			end
		end)
	end

	if Achievement.hiddenDescription then
		Achievement.hiddenDescription:SetTextColor(1, 1, 1)
	end

	if Achievement.tracked then
		Achievement.tracked:GetRegions():SetTextColor(1, 1, 1)
		S:HandleCheckBox(Achievement.tracked)
		Achievement.tracked:Size(18)
		Achievement.tracked:ClearAllPoints()
		Achievement.tracked:Point('TOPLEFT', Achievement.icon, 'BOTTOMLEFT', 0, -2)
	end

	Achievement.isSkinned = true
end

local function SkinStatusBar(bar)
	bar:StripTextures()
	bar:SetStatusBarTexture(E.media.normTex)
	bar:SetStatusBarColor(4/255, 179/255, 30/255)
	bar:CreateBackdrop()
	E:RegisterStatusBar(bar)

	local StatusBarName = bar:GetName()
	if _G[StatusBarName..'Title'] then
		_G[StatusBarName..'Title']:Point('LEFT', 4, 0)
	end
	if _G[StatusBarName..'Label'] then
		_G[StatusBarName..'Label']:Point('LEFT', 4, 0)
	end
	if _G[StatusBarName..'Text'] then
		_G[StatusBarName..'Text']:Point('RIGHT', -4, 0)
	end
end

local function SkinSearchButton(self)
	self:StripTextures()

	if self.icon then
		S:HandleIcon(self.icon)
	end

	self:CreateBackdrop('Transparent')
	self:SetHighlightTexture(E.media.normTex)

	local hl = self:GetHighlightTexture()
	hl:SetVertexColor(1, 1, 1, 0.3)
	hl:Point('TOPLEFT', 1, -1)
	hl:Point('BOTTOMRIGHT', -1, 1)
end

local function playerSaturate(self) -- self is Achievement.player
	local Achievement = self:GetParent()

	local r, g, b = unpack(E.media.bordercolor)
	Achievement.player.backdrop.callbackBackdropColor = nil
	Achievement.friend.backdrop.callbackBackdropColor = nil

	if Achievement.player.accountWide then
		r, g, b = blueAchievement.r, blueAchievement.g, blueAchievement.b
		Achievement.player.backdrop.callbackBackdropColor = blueBackdrop
		Achievement.friend.backdrop.callbackBackdropColor = blueBackdrop
	end

	Achievement.player.backdrop:SetBackdropColor(r, g, b)
	Achievement.friend.backdrop:SetBackdropColor(r, g, b)
end

local function setAchievementColor(frame)
	if frame and frame.backdrop then
		if frame.accountWide then
			frame.backdrop.callbackBackdropColor = blueBackdrop
			frame.backdrop:SetBackdropColor(blueAchievement.r, blueAchievement.g, blueAchievement.b)
		else
			frame.backdrop.callbackBackdropColor = nil
			frame.backdrop:SetBackdropColor(unpack(E.media.backdropcolor))
		end
	end
end

function S:Blizzard_AchievementUI(event)
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.achievement) then return end

	if event == 'PLAYER_ENTERING_WORLD' then
		hooksecurefunc('HybridScrollFrame_CreateButtons', function(frame, template)
			if template == 'AchievementCategoryTemplate' then
				for _, button in pairs(frame.buttons) do
					if button.isSkinned then return; end
					button:StripTextures(true)
					button:StyleButton()
					button.isSkinned = true
				end
			end
			if template == 'AchievementTemplate' then
				for _, Achievement in pairs(frame.buttons) do
					skinAch(Achievement, true)
				end
			end
			if template == 'ComparisonTemplate' then
				for _, Achievement in pairs(frame.buttons) do
					if Achievement.isSkinned then return; end
					skinAch(Achievement.player)
					skinAch(Achievement.friend)

					hooksecurefunc(Achievement.player, 'Saturate', playerSaturate)
				end
			end
			if template == 'StatTemplate' then
				for _, Stats in pairs(frame.buttons) do
					-- Stats:StripTextures(true)
					Stats:StyleButton()
				end
			end
		end)
	end

	if not IsAddOnLoaded('Blizzard_AchievementUI') then return end

	_G.AchievementFrameSummary:StripTextures()
	_G.AchievementFrameSummaryBackground:Hide()
	_G.AchievementFrameSummary:GetChildren():Hide()

	for i = 1, 4 do
		select(i, _G.AchievementFrameHeader:GetRegions()):Hide()
	end

	_G.AchievementFrameHeaderRightDDLInset:SetAlpha(0)
	_G.AchievementFrameHeaderLeftDDLInset:SetAlpha(0)
	select(2, _G.AchievementFrameAchievements:GetChildren()):Hide()
	_G.AchievementFrameAchievementsBackground:Hide()
	select(3, _G.AchievementFrameAchievements:GetRegions()):Hide()
	_G.AchievementFrameStatsBG:Hide()
	_G.AchievementFrameSummaryAchievementsHeaderHeader:Hide()
	_G.AchievementFrameSummaryCategoriesHeaderTexture:Hide()
	select(3, _G.AchievementFrameStats:GetChildren()):Hide()
	select(5, _G.AchievementFrameComparison:GetChildren()):Hide()
	_G.AchievementFrameComparisonHeaderBG:Hide()
	_G.AchievementFrameComparisonHeaderPortrait:Hide()
	_G.AchievementFrameComparisonHeaderPortraitBg:Hide()
	_G.AchievementFrameComparisonBackground:Hide()
	_G.AchievementFrameComparisonDark:SetAlpha(0)
	_G.AchievementFrameComparisonSummaryPlayerBackground:Hide()
	_G.AchievementFrameComparisonSummaryFriendBackground:Hide()

	local summaries = {_G.AchievementFrameComparisonSummaryPlayer, _G.AchievementFrameComparisonSummaryFriend}
	for _, frame in pairs(summaries) do
		frame:SetBackdrop()
	end

	_G.AchievementFrameMetalBorderTopLeft:Hide()
	_G.AchievementFrameWoodBorderTopLeft:Hide()
	_G.AchievementFrameMetalBorderTopRight:Hide()
	_G.AchievementFrameWoodBorderTopRight:Hide()
	_G.AchievementFrameMetalBorderBottomRight:Hide()
	_G.AchievementFrameWoodBorderBottomRight:Hide()
	_G.AchievementFrameMetalBorderBottomLeft:Hide()
	_G.AchievementFrameWoodBorderBottomLeft:Hide()

	local noname_frames = {
		_G.AchievementFrameStats,
		_G.AchievementFrameSummary,
		_G.AchievementFrameAchievements,
		_G.AchievementFrameComparison
	}
	for _, frame in pairs(noname_frames) do
		if frame and frame.GetNumChildren then
			for i=1, frame:GetNumChildren() do
				local child = select(i, frame:GetChildren())
				if child and not child:GetName() then
					child:SetBackdrop()
				end
			end
		end
	end

	local AchievementFrame = _G.AchievementFrame
	AchievementFrame:StripTextures()
	AchievementFrame:CreateBackdrop('Transparent')
	AchievementFrame.backdrop:Point('TOPLEFT', 0, 7)
	AchievementFrame.backdrop:Point('BOTTOMRIGHT')

	_G.AchievementFrameHeaderTitle:ClearAllPoints()
	_G.AchievementFrameHeaderTitle:Point('TOP', AchievementFrame.backdrop, 'TOP', 0, -8)

	_G.AchievementFrameHeaderPoints:ClearAllPoints()
	_G.AchievementFrameHeaderPoints:Point('CENTER', _G.AchievementFrameHeaderTitle, 'CENTER', 0, 0)

	--Backdrops
	_G.AchievementFrameCategories:StripTextures()
	_G.AchievementFrameCategoriesContainerScrollBarBG:SetAlpha(0)
	_G.AchievementFrameCategoriesContainer:CreateBackdrop('Transparent')
	_G.AchievementFrameCategoriesContainer.backdrop:Point('TOPLEFT', 0, 4)
	_G.AchievementFrameCategoriesContainer.backdrop:Point('BOTTOMRIGHT', -2, -3)
	_G.AchievementFrameCategoriesBG:SetAlpha(0)
	_G.AchievementFrameWaterMark:SetAlpha(0)
	--_G.AchievementFrameCategoriesBG:SetInside(_G.AchievementFrameCategoriesContainer.backdrop)

	_G.AchievementFrameAchievementsContainer:CreateBackdrop('Transparent')
	_G.AchievementFrameAchievementsContainer.backdrop:Point('TOPLEFT', -2, 2)
	_G.AchievementFrameAchievementsContainer.backdrop:Point('BOTTOMRIGHT', -2, -3)

	_G.AchievementFrameGuildEmblemRight:Kill()
	_G.AchievementFrameGuildEmblemLeft:Kill()

	S:HandleCloseButton(_G.AchievementFrameCloseButton, AchievementFrame.backdrop)

	S:HandleDropDownBox(_G.AchievementFrameFilterDropDown)
	_G.AchievementFrameFilterDropDown:ClearAllPoints()
	_G.AchievementFrameFilterDropDown:Point('TOPLEFT', _G.AchievementFrameAchievements, 'TOPLEFT', -18, 24)

	S:HandleEditBox(AchievementFrame.searchBox)
	AchievementFrame.searchBox.backdrop:Point('TOPLEFT', AchievementFrame.searchBox, 'TOPLEFT', -3, -3)
	AchievementFrame.searchBox.backdrop:Point('BOTTOMRIGHT', AchievementFrame.searchBox, 'BOTTOMRIGHT', 0, 3)
	AchievementFrame.searchBox:ClearAllPoints()
	AchievementFrame.searchBox:Point('TOPRIGHT', AchievementFrame, 'TOPRIGHT', -50, 8)
	AchievementFrame.searchBox:Size(107, 25)

	local scrollBars = {
		_G.AchievementFrameCategoriesContainerScrollBar,
		_G.AchievementFrameAchievementsContainerScrollBar,
		_G.AchievementFrameStatsContainerScrollBar,
		_G.AchievementFrameComparisonContainerScrollBar,
		_G.AchievementFrameComparisonStatsContainerScrollBar,
	}

	for _, scrollbar in pairs(scrollBars) do
		if scrollbar then
			S:HandleScrollBar(scrollbar, 5)
		end
	end

	-- Search
	AchievementFrame.searchResults:StripTextures()
	AchievementFrame.searchResults:CreateBackdrop('Transparent')
	AchievementFrame.searchPreviewContainer:StripTextures()
	AchievementFrame.searchPreviewContainer:ClearAllPoints()
	AchievementFrame.searchPreviewContainer:Point('TOPLEFT', AchievementFrame, 'TOPRIGHT', 2, 6)

	for i = 1, 5 do
		SkinSearchButton(AchievementFrame.searchPreviewContainer['searchPreview'..i])
	end
	SkinSearchButton(AchievementFrame.searchPreviewContainer.showAllSearchResults)

	hooksecurefunc('AchievementFrame_UpdateFullSearchResults', function()
		local numResults = GetNumFilteredAchievements()

		local scrollFrame = AchievementFrame.searchResults.scrollFrame
		local offset = _G.HybridScrollFrame_GetOffset(scrollFrame)
		local results = scrollFrame.buttons
		local result, index

		for i = 1, #results do
			result = results[i]
			index = offset + i

			if index <= numResults then
				if not result.styled then
					result:SetNormalTexture('')
					result:SetPushedTexture('')
					result:GetRegions():Hide()

					result.resultType:SetTextColor(1, 1, 1)
					result.path:SetTextColor(1, 1, 1)

					result.styled = true
				end

				if result.icon:GetTexCoord() == 0 then
					result.icon:SetTexCoord(unpack(E.TexCoords))
				end
			end
		end
	end)

	hooksecurefunc(AchievementFrame.searchResults.scrollFrame, 'update', function(self)
		for i = 1, #self.buttons do
			local result = self.buttons[i]

			if result.icon:GetTexCoord() == 0 then
				result.icon:SetTexCoord(unpack(E.TexCoords))
			end
		end
	end)

	S:HandleCloseButton(AchievementFrame.searchResults.closeButton)
	S:HandleScrollBar(_G.AchievementFrameScrollFrameScrollBar)

	--Tabs
	for i = 1, 3 do
		S:HandleTab(_G['AchievementFrameTab'..i])
		_G['AchievementFrameTab'..i]:SetFrameLevel(_G['AchievementFrameTab'..i]:GetFrameLevel() + 2)
	end

	SkinStatusBar(_G.AchievementFrameSummaryCategoriesStatusBar)
	SkinStatusBar(_G.AchievementFrameComparisonSummaryPlayerStatusBar)
	SkinStatusBar(_G.AchievementFrameComparisonSummaryFriendStatusBar)
	_G.AchievementFrameComparisonSummaryFriendStatusBar.text:ClearAllPoints()
	_G.AchievementFrameComparisonSummaryFriendStatusBar.text:Point('CENTER')
	_G.AchievementFrameComparisonHeader:Point('BOTTOMRIGHT', _G.AchievementFrameComparison, 'TOPRIGHT', 45, -20)

	for i=1, 12 do
		local frame = _G['AchievementFrameSummaryCategoriesCategory'..i]
		local button = _G['AchievementFrameSummaryCategoriesCategory'..i..'Button']
		local highlight = _G['AchievementFrameSummaryCategoriesCategory'..i..'ButtonHighlight']
		SkinStatusBar(frame)
		button:StripTextures()
		highlight:StripTextures()

		_G[highlight:GetName()..'Middle']:SetColorTexture(1, 1, 1, 0.3)
		_G[highlight:GetName()..'Middle']:SetAllPoints(frame)
	end

	hooksecurefunc('AchievementButton_DisplayAchievement', setAchievementColor)

	hooksecurefunc('AchievementFrameSummary_UpdateAchievements', function()
		for i=1, _G.ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do
			local frame = _G['AchievementFrameSummaryAchievement'..i]
			if not frame.isSkinned then
				skinAch(frame)
				frame.isSkinned = true
			end

			--The backdrop borders tend to overlap so add a little more space between summary achievements
			local prevFrame = _G['AchievementFrameSummaryAchievement'..i-1]
			if i ~= 1 then
				frame:ClearAllPoints()
				frame:Point('TOPLEFT', prevFrame, 'BOTTOMLEFT', 0, 1)
				frame:Point('TOPRIGHT', prevFrame, 'BOTTOMRIGHT', 0, 1)
			end

			setAchievementColor(frame)
		end
	end)

	for i=1, 20 do
		local frame = _G['AchievementFrameStatsContainerButton'..i]
		frame:StyleButton()

		_G['AchievementFrameStatsContainerButton'..i..'BG']:SetColorTexture(1, 1, 1, 0.2)
		_G['AchievementFrameStatsContainerButton'..i..'HeaderLeft']:Kill()
		_G['AchievementFrameStatsContainerButton'..i..'HeaderRight']:Kill()
		_G['AchievementFrameStatsContainerButton'..i..'HeaderMiddle']:Kill()

		frame = 'AchievementFrameComparisonStatsContainerButton'..i
		_G[frame]:StripTextures()
		_G[frame]:StyleButton()

		_G[frame..'BG']:SetColorTexture(1, 1, 1, 0.2)
		_G[frame..'HeaderLeft']:Kill()
		_G[frame..'HeaderRight']:Kill()
		_G[frame..'HeaderMiddle']:Kill()
	end

	hooksecurefunc('AchievementButton_GetProgressBar', function(index)
		local frame = _G['AchievementFrameProgressBar'..index]
		if frame then
			if not frame.skinned then
				frame:StripTextures()
				frame:SetStatusBarTexture(E.media.normTex)
				E:RegisterStatusBar(frame)
				frame:SetStatusBarColor(4/255, 179/255, 30/255)
				frame:CreateBackdrop('Transparent')
				frame:SetFrameLevel(frame:GetFrameLevel() + 3)
				frame:Height(frame:GetHeight() - 2)

				frame.text:ClearAllPoints()
				frame.text:Point('CENTER', frame, 'CENTER', 0, -1)
				frame.text:SetJustifyH('CENTER')

				if index > 1 then
					frame:ClearAllPoints()
					frame:Point('TOP', _G['AchievementFrameProgressBar'..index-1], 'BOTTOM', 0, -5)
					frame.SetPoint = E.noop
					frame.ClearAllPoints = E.noop
				end

				frame.skinned = true
			end

		end
	end)

	hooksecurefunc('AchievementObjectives_DisplayCriteria', function(objectivesFrame, id)
		local numCriteria = GetAchievementNumCriteria(id)
		local textStrings, metas = 0, 0
		for i = 1, numCriteria do
			local _, criteriaType, completed, _, _, _, _, assetID = GetAchievementCriteriaInfo(id, i)

			if criteriaType == _G.CRITERIA_TYPE_ACHIEVEMENT and assetID then
				metas = metas + 1;
				local metaCriteria = _G.AchievementButton_GetMeta(metas);
				if objectivesFrame.completed and completed then
					metaCriteria.label:SetShadowOffset(0, 0)
					metaCriteria.label:SetTextColor(1, 1, 1, 1);
				elseif completed then
					metaCriteria.label:SetShadowOffset(1, -1)
					metaCriteria.label:SetTextColor(0, 1, 0, 1);
				else
					metaCriteria.label:SetShadowOffset(1, -1)
					metaCriteria.label:SetTextColor(.6, .6, .6, 1);
				end
			elseif criteriaType ~= 1 then
				textStrings = textStrings + 1;
				local criteria = _G.AchievementButton_GetCriteria(textStrings);
				if objectivesFrame.completed and completed then
					criteria.name:SetTextColor(1, 1, 1, 1);
					criteria.name:SetShadowOffset(0, 0);
				elseif completed then
					criteria.name:SetTextColor(0, 1, 0, 1);
					criteria.name:SetShadowOffset(1, -1);
				else
					criteria.name:SetTextColor(.6, .6, .6, 1);
					criteria.name:SetShadowOffset(1, -1);
				end
			end
		end
	end)

	--The section below is usually handled in our hook, but another addon may have loaded the AchievementUI before we were ready
	--Categories
	for i = 1, 20 do
		local button = _G['AchievementFrameCategoriesContainerButton'..i]
		if not button or (button and button.isSkinned) then return end
		button:StripTextures(true)
		button:StyleButton()
		button.isSkinned = true
	end

	--Comparison
	for i = 1, 10 do
		local Achievement = _G['AchievementFrameComparisonContainerButton'..i]
		if not Achievement or (Achievement and Achievement.isSkinned) then return end

		skinAch(Achievement.player)
		skinAch(Achievement.friend)

		hooksecurefunc(Achievement.player, 'Saturate', playerSaturate)

		Achievement.isSkinned = true
	end
end

local f = CreateFrame('Frame')
f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:SetScript('OnEvent', function(self, event)
	self:UnregisterEvent(event)
	S:Blizzard_AchievementUI(event)
end)

S:AddCallbackForAddon('Blizzard_AchievementUI')
