local AS = unpack(AddOnSkins)

if not AS:CheckAddOn('Immersion') then return end

function AS:Immersion(event, addon)
	AS:SkinBackdropFrame(ImmersionFrame.TalkBox.BackgroundFrame)
	AS:CreateShadow(ImmersionFrame.TalkBox.BackgroundFrame.Backdrop)

	ImmersionFrame.TalkBox.BackgroundFrame.Backdrop:SetPoint('TOPLEFT', ImmersionFrame.TalkBox.BackgroundFrame, 'TOPLEFT', 8, -8)
	ImmersionFrame.TalkBox.BackgroundFrame.Backdrop:SetPoint('BOTTOMRIGHT', ImmersionFrame.TalkBox.BackgroundFrame, 'BOTTOMRIGHT', -8, 8)

	AS:StripTextures(ImmersionFrame.TalkBox.PortraitFrame)
	AS:SkinCloseButton(ImmersionFrame.TalkBox.MainFrame.CloseButton)

	AS:SetTemplate(ImmersionFrame.TalkBox.Hilite)
	ImmersionFrame.TalkBox.Hilite:SetBackdropBorderColor(0, 0.44, .87, 1)
	ImmersionFrame.TalkBox.Hilite:SetBackdropColor(0, 0, 0, 0)

	ImmersionFrame.TalkBox.MainFrame.Model.ModelShadow:SetDrawLayer("OVERLAY", 7)
	ImmersionFrame.TalkBox.MainFrame.Model.ModelShadow:SetPoint("BOTTOMRIGHT", 2, -2)
	ImmersionFrame.TalkBox.MainFrame.Model.PortraitBG:Hide()

	AS:SkinBackdropFrame(ImmersionFrame.TalkBox.Elements)
	ImmersionFrame.TalkBox.Elements.Backdrop:SetPoint('TOPLEFT', ImmersionFrame.TalkBox.Elements, 'TOPLEFT', 16, -16)
	ImmersionFrame.TalkBox.Elements.Backdrop:SetPoint('BOTTOMRIGHT', ImmersionFrame.TalkBox.Elements, 'BOTTOMRIGHT', -16, 16)
	AS:CreateShadow(ImmersionFrame.TalkBox.Elements.Backdrop)

	AS:Kill(ImmersionFrame.TalkBox.MainFrame.Overlay)

	AS:SkinStatusBar(ImmersionFrame.TalkBox.ReputationBar)
	ImmersionFrame.TalkBox.ReputationBar:ClearAllPoints()
	ImmersionFrame.TalkBox.ReputationBar:SetPoint('TOPLEFT', ImmersionFrame.TalkBox, 'BOTTOMLEFT', -20, 10)
	ImmersionFrame.TalkBox.ReputationBar.icon:SetAlpha(0)
	ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.ItemHighlight.Icon:Hide();
	ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.ItemHighlight.Icon.Show = function() end;

	ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.ItemHighlight.NameTag:Hide();
	ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.ItemHighlight.NameTag.Show = function() end;

	ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.ItemHighlight.TextSheen:Hide();
	ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.ItemHighlight.TextSheen.Show = function() end;

	local function SkinReward(Button)
		if Button.Icon then
			AS:CreateBackdrop(Button)

			if Button.NameFrame then
				Button.NameFrame:Hide()
			end

			if Button.Border then
				Button.Border:Hide()
			end

			if Button.Mask then
				Button.Mask:Hide()
			end

			Button.Backdrop:SetPoint('TOPLEFT', Button.Icon, 'TOPRIGHT', 0, 0)
			Button.Backdrop:SetPoint('BOTTOMLEFT', Button.Icon, 'BOTTOMRIGHT', 0, 0)
			Button.Backdrop:SetPoint('RIGHT', Button, 'RIGHT', -5, 0)

			AS:SkinTexture(Button.Icon)
			Button.Icon.Backdrop = CreateFrame('Frame', nil, Button)
			AS:SetTemplate(Button.Icon.Backdrop)
			Button.Icon.Backdrop:SetBackdropColor(0, 0, 0, 0)
			AS:SetOutside(Button.Icon.Backdrop, Button.Icon)

			Button.AutoCastShine = CreateFrame('Frame', '$parentShine', Button, 'AutoCastShineTemplate')
			Button.AutoCastShine:SetParent(Button.Icon.Backdrop)
			Button.AutoCastShine:SetAllPoints()

			for _, sparks in pairs(Button.AutoCastShine.sparkles) do
				sparks:SetSize(sparks:GetWidth() * 2, sparks:GetHeight() * 2)
			end

			Button:SetScript("OnUpdate", function(self)
				if ImmersionFrame.TalkBox.Elements.chooseItems and ImmersionFrame.TalkBox.Elements.itemChoice == self:GetID() then
					AutoCastShine_AutoCastStart(self.AutoCastShine, 0, .44, .87 )
					self.Backdrop:SetBackdropBorderColor(0, 0.44, .87, 1)
				else
					self.Backdrop:SetBackdropBorderColor(unpack(AS.BorderColor))
					AutoCastShine_AutoCastStop(self.AutoCastShine)
				end
			end)
		end

		if Button.CircleBackground then
			Button.CircleBackground:SetTexture()
			Button.CircleBackgroundGlow:SetTexture()
			hooksecurefunc(Button.ValueText, "SetText", function(self, text) Button.Count:SetText('+'..text) self:Hide() end)
		end
	end

	SkinReward(ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.ArtifactXPFrame)
	SkinReward(ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.HonorFrame)
	SkinReward(ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.MoneyFrame)
	SkinReward(ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.TitleFrame)
	SkinReward(ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.SkillPointFrame)

	ImmersionFrame:HookScript('OnUpdate', function(self)
		for _, Button in ipairs(self.TitleButtons.Buttons) do
			if Button and not Button.Backdrop then
				AS:CreateBackdrop(Button)
				Button:SetBackdrop(nil)
				Button.Overlay:Hide()
				AS:CreateShadow(Button.Backdrop)
				AS:SetInside(Button.Backdrop, Button, 4, 4)
				AS:SetTemplate(Button.Hilite)
				Button.Hilite:SetBackdropBorderColor(0, 0.44, .87, 1)
				Button.Hilite:SetBackdropColor(0, 0, 0, 0)
				Button.Hilite:SetAllPoints(Button.Backdrop)
				Button:SetHighlightTexture('')
			end
		end
		for _, Button in ipairs(self.TalkBox.Elements.Content.RewardsFrame.Buttons) do
			if Button and not Button.Backdrop then
				SkinReward(Button)
			end
		end
		for _, Button in ipairs(self.TalkBox.Elements.Progress.Buttons) do
			if Button and not Button.Backdrop then
				AS:CreateBackdrop(Button)
				AS:SkinTexture(Button.Icon, true)
				Button.NameFrame:Hide()
				Button.Border:Hide()
				Button.Mask:Hide()

				Button.Backdrop:SetPoint('TOPLEFT', Button.Icon, 'TOPRIGHT', 0, 0)
				Button.Backdrop:SetPoint('BOTTOMLEFT', Button.Icon, 'BOTTOMRIGHT', 0, 0)
				Button.Backdrop:SetPoint('RIGHT', Button, 'RIGHT', -5, 0)
			end
		end
	end)
end

AS:RegisterSkin('Immersion', AS.Immersion)
