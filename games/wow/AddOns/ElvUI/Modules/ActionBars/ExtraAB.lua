local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local AB = E:GetModule('ActionBars')

local _G = _G
local pairs = pairs
local unpack = unpack
local tinsert = tinsert
local CreateFrame = CreateFrame
local GetBindingKey = GetBindingKey
local hooksecurefunc = hooksecurefunc

local ExtraActionBarHolder, ZoneAbilityHolder
local ExtraButtons = {}

function AB:ExtraButtons_BossStyle(button)
	if not button.style then return end
	button.style:SetAlpha(not E.db.actionbar.extraActionButton.clean and E.db.actionbar.extraActionButton.alpha or 0)
end

function AB:ExtraButtons_ZoneStyle()
	local zoneAlpha = E.db.actionbar.zoneActionButton.alpha
	_G.ZoneAbilityFrame.Style:SetAlpha(not E.db.actionbar.zoneActionButton.clean and zoneAlpha or 0)

	for button in _G.ZoneAbilityFrame.SpellButtonContainer:EnumerateActive() do
		button:SetAlpha(zoneAlpha)
	end
end

function AB:ExtraButtons_OnEnter()
	if self.holder and self.holder:GetParent() == AB.fadeParent and not AB.fadeParent.mouseLock then
		E:UIFrameFadeIn(AB.fadeParent, 0.2, AB.fadeParent:GetAlpha(), 1)
	end
end

function AB:ExtraButtons_OnLeave()
	if self.holder and self.holder:GetParent() == AB.fadeParent and not AB.fadeParent.mouseLock then
		E:UIFrameFadeOut(AB.fadeParent, 0.2, AB.fadeParent:GetAlpha(), 1 - AB.db.globalFadeAlpha)
	end
end

function AB:ExtraButtons_GlobalFade()
	ExtraActionBarHolder:SetParent(E.db.actionbar.extraActionButton.inheritGlobalFade and AB.fadeParent or E.UIParent)
	ZoneAbilityHolder:SetParent(E.db.actionbar.zoneActionButton.inheritGlobalFade and AB.fadeParent or E.UIParent)
end

function AB:ExtraButtons_UpdateAlpha()
	if not E.private.actionbar.enable then return end
	local bossAlpha = E.db.actionbar.extraActionButton.alpha

	for i = 1, _G.ExtraActionBarFrame:GetNumChildren() do
		local button = _G['ExtraActionButton'..i]
		if button then
			button:SetAlpha(bossAlpha)
			AB:ExtraButtons_BossStyle(button)
		end
	end

	AB:ExtraButtons_ZoneStyle()
end

function AB:ExtraButtons_UpdateScale()
	if not E.private.actionbar.enable then return end

	AB:ExtraButtons_ZoneScale()

	local scale = E.db.actionbar.extraActionButton.scale
	_G.ExtraActionBarFrame:SetScale(scale)

	local width, height = _G.ExtraActionBarFrame.button:GetSize()
	ExtraActionBarHolder:SetSize(width * scale, height * scale)
end

function AB:ExtraButtons_ZoneScale()
	if not E.private.actionbar.enable then return end

	local scale = E.db.actionbar.zoneActionButton.scale
	_G.ZoneAbilityFrame.Style:SetScale(scale)
	_G.ZoneAbilityFrame.SpellButtonContainer:SetScale(scale)

	local width, height = _G.ZoneAbilityFrame.SpellButtonContainer:GetSize()
	ZoneAbilityHolder:SetSize(width * scale, height * scale)
end

function AB:SetupExtraButton()
	local ExtraActionBarFrame = _G.ExtraActionBarFrame
	local ZoneAbilityFrame = _G.ZoneAbilityFrame

	ExtraActionBarHolder = CreateFrame('Frame', nil, E.UIParent)
	ExtraActionBarHolder:Point('BOTTOM', E.UIParent, 'BOTTOM', -150, 300)

	ZoneAbilityHolder = CreateFrame('Frame', nil, E.UIParent)
	ZoneAbilityHolder:Point('BOTTOM', E.UIParent, 'BOTTOM', 150, 300)

	ZoneAbilityFrame.SpellButtonContainer.holder = ZoneAbilityHolder
	ZoneAbilityFrame.SpellButtonContainer:HookScript('OnEnter', AB.ExtraButtons_OnEnter)
	ZoneAbilityFrame.SpellButtonContainer:HookScript('OnLeave', AB.ExtraButtons_OnLeave)

	-- try to shutdown the container movement and taints
	_G.UIPARENT_MANAGED_FRAME_POSITIONS.ExtraAbilityContainer = nil
	_G.ExtraAbilityContainer.SetSize = E.noop

	ZoneAbilityFrame:SetParent(ZoneAbilityHolder)
	ZoneAbilityFrame:ClearAllPoints()
	ZoneAbilityFrame:SetAllPoints()
	ZoneAbilityFrame.ignoreInLayout = true

	ExtraActionBarFrame:SetParent(ExtraActionBarHolder)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:SetAllPoints()
	ExtraActionBarFrame.ignoreInLayout = true

	hooksecurefunc(ZoneAbilityFrame.SpellButtonContainer, 'SetSize', AB.ExtraButtons_ZoneScale)
	hooksecurefunc(ZoneAbilityFrame, 'UpdateDisplayedZoneAbilities', function(frame)
		AB:ExtraButtons_ZoneStyle()

		for spellButton in frame.SpellButtonContainer:EnumerateActive() do
			if spellButton and not spellButton.IsSkinned then
				spellButton.NormalTexture:SetAlpha(0)
				spellButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
				spellButton:StyleButton(nil, true)
				spellButton:CreateBackdrop(nil, nil, nil, nil, nil, nil, true)
				spellButton.Icon:SetDrawLayer('ARTWORK')
				spellButton.Icon:SetTexCoord(unpack(E.TexCoords))
				spellButton.Icon:SetInside()

				--check these
				--spellButton.HotKey:SetText(GetBindingKey(spellButton:GetName()))
				--tinsert(ExtraButtons, spellButton)

				spellButton.holder = ZoneAbilityHolder
				spellButton:HookScript('OnEnter', AB.ExtraButtons_OnEnter)
				spellButton:HookScript('OnLeave', AB.ExtraButtons_OnLeave)

				if spellButton.Cooldown then
					spellButton.Cooldown.CooldownOverride = 'actionbar'
					E:RegisterCooldown(spellButton.Cooldown)
					spellButton.Cooldown:SetInside(spellButton)
				end

				spellButton.IsSkinned = true
			end
		end
	end)

	for i = 1, ExtraActionBarFrame:GetNumChildren() do
		local button = _G['ExtraActionButton'..i]
		if button then
			button.pushed = true
			button.checked = true

			self:StyleButton(button, true) -- registers cooldown too
			button.icon:SetDrawLayer('ARTWORK')
			button:CreateBackdrop(nil, nil, nil, nil, nil, nil, true, true)

			AB:ExtraButtons_BossStyle(button)

			button.holder = ExtraActionBarHolder
			button:HookScript('OnEnter', AB.ExtraButtons_OnEnter)
			button:HookScript('OnLeave', AB.ExtraButtons_OnLeave)

			local tex = button:CreateTexture(nil, 'OVERLAY')
			tex:SetColorTexture(0.9, 0.8, 0.1, 0.3)
			tex:SetInside()
			button:SetCheckedTexture(tex)

			button.HotKey:SetText(GetBindingKey('ExtraActionButton'..i))
			tinsert(ExtraButtons, button)
		end
	end

	AB:ExtraButtons_UpdateAlpha()
	AB:ExtraButtons_UpdateScale()
	AB:ExtraButtons_GlobalFade()

	E:CreateMover(ExtraActionBarHolder, 'BossButton', L["Boss Button"], nil, nil, nil, 'ALL,ACTIONBARS', nil, 'actionbar,extraActionButton')
	E:CreateMover(ZoneAbilityHolder, 'ZoneAbility', L["Zone Ability"], nil, nil, nil, 'ALL,ACTIONBARS')

	-- Spawn the mover before its available.
	ZoneAbilityHolder:Size(52 * E.db.actionbar.zoneActionButton.scale)
end

function AB:UpdateExtraBindings()
	for _, button in pairs(ExtraButtons) do
		button.HotKey:SetText(_G.GetBindingKey(button:GetName()))
		AB:FixKeybindText(button)
	end
end
