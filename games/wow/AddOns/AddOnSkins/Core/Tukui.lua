local AS, ASL = unpack(AddOnSkins)
if not AS:CheckAddOn('Tukui') then return end
local T, C

function AS:UpdateMedia()
	if not Tukui then return end
	if not T then
		T, C = Tukui:unpack()
	end

	AS.HideShadows = C.General.HideShadows

	AS.DataTextFontSize = 12
	AS.DataTexts = T.DataTexts
	AS.InfoLeft = T.DataTexts.Panels.Left
	AS.InfoRight = T.DataTexts.Panels.Right
	AS.ChatBackgroundRight = T.Chat.Panels and T.Chat.Panels.RightChat
	AS.ChatBackgroundLeft = T.Chat.Panels and T.Chat.Panels.LeftChat
	AS.TabsRightBackground = T.Chat.Panels and T.Chat.Panels.RightChatTabs
	AS.TabsLeftBackground = T.Chat.Panels and T.Chat.Panels.LeftChatTabs
	AS.Minimap = T.Maps.Minimap
	AS.ActionBar1 = T.ActionBars.Bars and T.ActionBars.Bars.Bar1
	AS.ActionBar2 = T.ActionBars.Bars and T.ActionBars.Bars.Bar2
	AS.ActionBar3 = T.ActionBars.Bars and T.ActionBars.Bars.Bar3
	AS.ActionBar4 = T.ActionBars.Bars and T.ActionBars.Bars.Bar4

	AS.Blank = C.Medias.Blank
	AS.NormTex = C.Medias.Normal
	AS.Font = C.Medias.Font
	AS.BackdropColor = C.General.BackdropColor
	AS.BorderColor = C.General.BorderColor
end
