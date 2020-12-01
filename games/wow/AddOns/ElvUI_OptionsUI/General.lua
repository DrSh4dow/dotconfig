local E, _, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local C, L = unpack(select(2, ...))
local Misc = E:GetModule('Misc')
local Layout = E:GetModule('Layout')
local Totems = E:GetModule('Totems')
local Blizzard = E:GetModule('Blizzard')
local NP = E:GetModule('NamePlates')
local UF = E:GetModule('UnitFrames')
local AFK = E:GetModule('AFK')
local ACH = E.Libs.ACH

local _G = _G
local IsAddOnLoaded = IsAddOnLoaded
local IsMouseButtonDown = IsMouseButtonDown
local FCF_GetNumActiveChatFrames = FCF_GetNumActiveChatFrames

local function GetChatWindowInfo()
	local ChatTabInfo = {}
	for i = 1, FCF_GetNumActiveChatFrames() do
		ChatTabInfo['ChatFrame'..i] = _G['ChatFrame'..i..'Tab']:GetText()
	end
	return ChatTabInfo
end

E.Options.args.general = {
	type = 'group',
	name = L["General"],
	order = 1,
	childGroups = 'tab',
	get = function(info) return E.db.general[info[#info]] end,
	set = function(info, value) E.db.general[info[#info]] = value end,
	args = {
		general = {
			order = 5,
			type = 'group',
			name = L["General"],
			args = {
				loginmessage = {
					order = 4,
					type = 'toggle',
					name = L["Login Message"],
				},
				taintLog = {
					order = 5,
					type = 'toggle',
					name = L["Log Taints"],
					desc = L["Send ADDON_ACTION_BLOCKED errors to the Lua Error frame. These errors are less important in most cases and will not effect your game performance. Also a lot of these errors cannot be fixed. Please only report these errors if you notice a Defect in gameplay."],
				},
				bottomPanel = {
					order = 6,
					type = 'toggle',
					name = L["Bottom Panel"],
					desc = L["Display a panel across the bottom of the screen. This is for cosmetic only."],
					set = function(info, value) E.db.general.bottomPanel = value; Layout:BottomPanelVisibility() end
				},
				topPanel = {
					order = 7,
					type = 'toggle',
					name = L["Top Panel"],
					desc = L["Display a panel across the top of the screen. This is for cosmetic only."],
					set = function(info, value) E.db.general.topPanel = value; Layout:TopPanelVisibility() end
				},
				afk = {
					order = 8,
					type = 'toggle',
					name = L["AFK Mode"],
					desc = L["When you go AFK display the AFK screen."],
					set = function(info, value) E.db.general.afk = value; AFK:Toggle() end
				},
				eyefinity = {
					order = 9,
					name = L["Multi-Monitor Support"],
					desc = L["Attempt to support eyefinity/nvidia surround."],
					type = 'toggle',
					get = function(info) return E.global.general.eyefinity end,
					set = function(info, value) E.global.general.eyefinity = value; E:StaticPopup_Show('GLOBAL_RL') end,
				},
				ultrawide = {
					order = 10,
					name = L["Ultrawide Support"],
					desc = L["Attempts to center UI elements in a 16:9 format for ultrawide monitors"],
					type = 'toggle',
					get = function(info) return E.global.general.ultrawide end,
					set = function(info, value) E.global.general.ultrawide = value; E:StaticPopup_Show('GLOBAL_RL') end,
				},
				autoAcceptInvite = {
					order = 11,
					name = L["Accept Invites"],
					desc = L["Automatically accept invites from guild/friends."],
					type = 'toggle',
				},
				autoRoll = {
					order = 12,
					name = L["Auto Greed/DE"],
					desc = L["Automatically select greed or disenchant (when available) on green quality items. This will only work if you are the max level."],
					type = 'toggle',
					disabled = function() return not E.private.general.lootRoll end
				},
				autoTrackReputation = {
					order = 13,
					name = L["Auto Track Reputation"],
					type = 'toggle',
				},
				spacer1 = ACH:Spacer(15, 'full'),
				locale = {
					order = 16,
					type = 'select',
					name = L["LANGUAGE"],
					get = function(info) return E.global.general.locale end,
					set = function(info, value)
						E.global.general.locale = value
						E:StaticPopup_Show('CONFIG_RL')
					end,
					values = {
						deDE = 'Deutsch',
						enUS = 'English',
						esMX = 'Español',
						frFR = 'Français',
						ptBR = 'Português',
						ruRU = 'Русский',
						zhCN = '简体中文',
						zhTW = '正體中文',
						koKR = '한국어',
						itIT = 'Italiano',
					},
				},
				messageRedirect = {
					order = 17,
					name = L["Chat Output"],
					desc = L["This selects the Chat Frame to use as the output of ElvUI messages."],
					type = 'select',
					values = GetChatWindowInfo()
				},
				numberPrefixStyle = {
					order = 18,
					type = 'select',
					name = L["Unit Prefix Style"],
					desc = L["The unit prefixes you want to use when values are shortened in ElvUI. This is mostly used on UnitFrames."],
					set = function(info, value)
						E.db.general.numberPrefixStyle = value
						E:BuildPrefixValues()
						E:StaticPopup_Show('CONFIG_RL')
					end,
					values = {
						TCHINESE = '萬, 億',
						CHINESE = '万, 亿',
						ENGLISH = 'K, M, B',
						GERMAN = 'Tsd, Mio, Mrd',
						KOREAN = '천, 만, 억',
						METRIC = 'k, M, G'
					},
				},
				interruptAnnounce = {
					order = 19,
					name = L["Announce Interrupts"],
					desc = L["Announce when you interrupt a spell to the specified chat channel."],
					type = 'select',
					values = {
						NONE = L["NONE"],
						SAY = L["SAY"],
						YELL = L["YELL"],
						PARTY = L["Party Only"],
						RAID = L["Party / Raid"],
						RAID_ONLY = L["Raid Only"],
						EMOTE = L["CHAT_MSG_EMOTE"],
					},
					set = function(info, value)
						E.db.general[info[#info]] = value
						if value == 'NONE' then
							Misc:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
						else
							Misc:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
						end
					end,
				},
				autoRepair = {
					order = 20,
					name = L["Auto Repair"],
					desc = L["Automatically repair using the following method when visiting a merchant."],
					type = 'select',
					values = {
						NONE = L["NONE"],
						GUILD = L["GUILD"],
						PLAYER = L["PLAYER"],
					},
				},
				spacer2 = ACH:Spacer(25, 'full'),
				decimalLength = {
					order = 26,
					type = 'range',
					name = L["Decimal Length"],
					desc = L["Controls the amount of decimals used in values displayed on elements like NamePlates and UnitFrames."],
					min = 0, max = 4, step = 1,
					set = function(info, value)
						E.db.general.decimalLength = value
						E:BuildPrefixValues()
						E:StaticPopup_Show('CONFIG_RL')
					end,
				},
				smoothingAmount = {
					order = 27,
					type = 'range',
					isPercent = true,
					name = L["Smoothing Amount"],
					desc = L["Controls the speed at which smoothed bars will be updated."],
					min = 0.2, max = 0.8, softMax = 0.75, softMin = 0.25, step = 0.01,
					set = function(info, value)
						E.db.general.smoothingAmount = value
						E:SetSmoothingAmount(value)
					end,
				},
				scaling = {
					order = 50,
					type = 'group',
					inline = true,
					name = L["UI Scale"],
					get = function(info) end,
					set = function(info, value) end,
					args = {
						UIScale = {
							order = 1,
							type = 'range',
							name = L["UI_SCALE"],
							min = 0.1, max = 1.25, step = 0.000000000000001,
							softMin = 0.40, softMax = 1.15, bigStep = 0.01,
							get = function(info) return E.global.general.UIScale end,
							set = function(info, value)
								E.global.general.UIScale = value

								if not IsMouseButtonDown() then
									E:PixelScaleChanged()
									E:StaticPopup_Show('PRIVATE_RL')
								end
							end
						},
						ScaleSmall = {
							order = 2,
							type = 'execute',
							name = _G.SMALL,
							customWidth = 100,
							func = function()
								E.global.general.UIScale = .6
								E:PixelScaleChanged()
								E:StaticPopup_Show('PRIVATE_RL')
							end,
						},
						ScaleMedium = {
							order = 3,
							type = 'execute',
							name = _G.TIME_LEFT_MEDIUM,
							customWidth = 100,
							func = function()
								E.global.general.UIScale = .7
								E:PixelScaleChanged()
								E:StaticPopup_Show('PRIVATE_RL')
							end,
						},
						ScaleLarge = {
							order = 4,
							type = 'execute',
							name = _G.LARGE,
							customWidth = 100,
							func = function()
								E.global.general.UIScale = .8
								E:PixelScaleChanged()
								E:StaticPopup_Show('PRIVATE_RL')
							end,
						},
						ScaleAuto = {
							order = 5,
							type = 'execute',
							name = L["Auto Scale"],
							customWidth = 100,
							func = function()
								E.global.general.UIScale = E:PixelBestSize()
								E:PixelScaleChanged()
								E:StaticPopup_Show('PRIVATE_RL')
							end,
						},
					},
				},
				totems = {
					order = 55,
					type = 'group',
					inline = true,
					name = L["Class Totems"],
					get = function(info) return E.db.general.totems[info[#info]] end,
					set = function(info, value) E.db.general.totems[info[#info]] = value; Totems:PositionAndSize() end,
					args = {
						enable = {
							order = 2,
							type = 'toggle',
							name = L["Enable"],
							get = function() return E.private.general.totemBar end,
							set = function(_, value) E.private.general.totemBar = value; E:StaticPopup_Show('PRIVATE_RL') end,
						},
						size = {
							order = 3,
							type = 'range',
							name = L["Button Size"],
							min = 24, max = 60, step = 1,
							disabled = function() return not E.private.general.totemBar end,
						},
						spacing = {
							order = 4,
							type = 'range',
							name = L["Button Spacing"],
							min = 1, max = 10, step = 1,
							disabled = function() return not E.private.general.totemBar end,
						},
						sortDirection = {
							order = 5,
							type = 'select',
							name = L["Sort Direction"],
							disabled = function() return not E.private.general.totemBar end,
							values = {
								ASCENDING = L["Ascending"],
								DESCENDING = L["Descending"],
							},
						},
						growthDirection = {
							order = 6,
							type = 'select',
							name = L["Bar Direction"],
							disabled = function() return not E.private.general.totemBar end,
							values = {
								VERTICAL = L["Vertical"],
								HORIZONTAL = L["Horizontal"],
							},
						},
					},
				},
			},
		},
		media = {
			order = 10,
			type = 'group',
			name = L["Media"],
			get = function(info) return E.db.general[info[#info]] end,
			set = function(info, value) E.db.general[info[#info]] = value end,
			args = {
				fontGroup = {
					order = 50,
					name = L["Font"],
					type = 'group',
					inline = true,
					args = {
						main = {
							order = 1,
							type = 'group',
							name = ' ',
							args = {
								font = {
									type = 'select', dialogControl = 'LSM30_Font',
									order = 1,
									name = L["Default Font"],
									desc = L["The font that the core of the UI will use."],
									values = AceGUIWidgetLSMlists.font,
									set = function(info, value) E.db.general[info[#info]] = value; E:UpdateMedia(); E:UpdateFontTemplates(); end,
								},
								fontSize = {
									order = 2,
									name = L["FONT_SIZE"],
									desc = L["Set the font size for everything in UI. Note: This doesn't effect somethings that have their own seperate options (UnitFrame Font, Datatext Font, ect..)"],
									type = 'range',
									min = 6, max = 64, step = 1,
									softMin = 8, softMax = 32,
									set = function(info, value) E.db.general[info[#info]] = value; E:UpdateMedia(); E:UpdateFontTemplates(); end,
								},
								fontStyle = {
									type = 'select',
									order = 3,
									name = L["Font Outline"],
									values = C.Values.FontFlags,
									set = function(info, value) E.db.general[info[#info]] = value; E:UpdateMedia(); E:UpdateFontTemplates(); end,
								},
								applyFontToAll = {
									order = 4,
									type = 'execute',
									name = L["Apply Font To All"],
									desc = L["Applies the font and font size settings throughout the entire user interface. Note: Some font size settings will be skipped due to them having a smaller font size by default."],
									func = function() E:StaticPopup_Show('APPLY_FONT_WARNING'); end,
								},
								replaceBlizzFonts = {
									order = 5,
									type = 'toggle',
									name = L["Replace Blizzard Fonts"],
									desc = L["Replaces the default Blizzard fonts on various panels and frames with the fonts chosen in the Media section of the ElvUI Options. NOTE: Any font that inherits from the fonts ElvUI usually replaces will be affected as well if you disable this. Enabled by default."],
									get = function(info) return E.private.general[info[#info]] end,
									set = function(info, value) E.private.general[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
								},
								unifiedBlizzFonts = {
									order = 6,
									type = 'toggle',
									name = L["Unified Font Sizes"],
									desc = L["This setting mimics the older style of Replace Blizzard Fonts, with a more static unified font sizing."],
									get = function(info) return E.private.general[info[#info]] end,
									set = function(info, value) E.private.general[info[#info]] = value; E:UpdateBlizzardFonts() end,
								},
							},
						},
						replaceCombatFont = {
							order = 6,
							type = 'toggle',
							name = L["Replace Combat Font"],
							get = function(info) return E.private.general[info[#info]] end,
							set = function(info, value) E.private.general[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
						},
						dmgfont = {
							type = 'select', dialogControl = 'LSM30_Font',
							order = 7,
							name = L["CombatText Font"],
							desc = L["The font that combat text will use. |cffFF0000WARNING: This requires a game restart or re-log for this change to take effect.|r"],
							disabled = function() return not E.private.general.replaceCombatFont end,
							values = AceGUIWidgetLSMlists.font,
							get = function(info) return E.private.general[info[#info]] end,
							set = function(info, value) E.private.general[info[#info]] = value; E:UpdateMedia(); E:UpdateFontTemplates(); E:StaticPopup_Show('PRIVATE_RL'); end,
						},
						replaceNameFont = {
							order = 8,
							type = 'toggle',
							name = L["Replace Name Font"],
							get = function(info) return E.private.general[info[#info]] end,
							set = function(info, value) E.private.general[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
						},
						namefont = {
							type = 'select', dialogControl = 'LSM30_Font',
							order = 9,
							name = L["Name Font"],
							desc = L["The font that appears on the text above players heads. |cffFF0000WARNING: This requires a game restart or re-log for this change to take effect.|r"],
							disabled = function() return not E.private.general.replaceNameFont end,
							values = AceGUIWidgetLSMlists.font,
							get = function(info) return E.private.general[info[#info]] end,
							set = function(info, value) E.private.general[info[#info]] = value; E:UpdateMedia(); E:UpdateFontTemplates(); E:StaticPopup_Show('PRIVATE_RL'); end,
						},
					},
				},
				textureGroup = {
					order = 51,
					name = L["Textures"],
					type = 'group',
					inline = true,
					get = function(info) return E.private.general[info[#info]] end,
					args = {
						normTex = {
							type = 'select', dialogControl = 'LSM30_Statusbar',
							order = 1,
							name = L["Primary Texture"],
							desc = L["The texture that will be used mainly for statusbars."],
							values = AceGUIWidgetLSMlists.statusbar,
							set = function(info, value)
								E.private.general[info[#info]] = value;
								E:UpdateMedia()
								E:UpdateStatusBars()
							end
						},
						glossTex = {
							type = 'select', dialogControl = 'LSM30_Statusbar',
							order = 2,
							name = L["Secondary Texture"],
							desc = L["This texture will get used on objects like chat windows and dropdown menus."],
							values = AceGUIWidgetLSMlists.statusbar,
							set = function(info, value)
								E.private.general[info[#info]] = value;
								E:UpdateMedia()
								E:UpdateFrameTemplates()
							end
						},
						applyTextureToAll = {
							order = 3,
							type = 'execute',
							name = L["Copy Primary Texture"],
							desc = L["Replaces the StatusBar texture setting on Unitframes and Nameplates with the primary texture."],
							func = function()
								E.db.unitframe.statusbar = E.private.general.normTex
								UF:Update_StatusBars()

								E.db.nameplates.statusbar = E.private.general.normTex
								NP:ConfigureAll()
							end,
						},
					},
				},
				bordersGroup = {
					order = 52,
					name = L["Borders"],
					type = 'group',
					inline = true,
					args = {
						uiThinBorders = {
							order = 1,
							name = L["Thin Borders"],
							desc = L["The Thin Border Theme option will change the overall apperance of your UI. Using Thin Border Theme is a slight performance increase over the traditional layout."],
							type = 'toggle',
							get = function(info) return E.private.general.pixelPerfect end,
							set = function(info, value)
								E.private.general.pixelPerfect = value
								E:StaticPopup_Show('PRIVATE_RL')
							end
						},
						ufThinBorders = {
							order = 2,
							name = L["Unitframe Thin Borders"],
							desc = L["Use thin borders on certain unitframe elements."],
							type = 'toggle',
							get = function(info) return E.db.unitframe.thinBorders end,
							set = function(info, value)
								E.db.unitframe.thinBorders = value
								E:StaticPopup_Show('CONFIG_RL')
							end,
						},
						npThinBorders = {
							order = 2,
							name = L["Nameplate Thin Borders"],
							desc = L["Use thin borders on certain nameplate elements."],
							type = 'toggle',
							get = function(info) return E.db.nameplates.thinBorders end,
							set = function(info, value)
								E.db.nameplates.thinBorders = value
								E:StaticPopup_Show('CONFIG_RL')
							end,
						},
						cropIcon = {
							order = 3,
							type = 'toggle',
							tristate = true,
							name = L["Crop Icons"],
							desc = L["This is for Customized Icons in your Interface/Icons folder."],
							get = function(info)
								local value = E.db.general[info[#info]]
								if value == 2 then return true
								elseif value == 1 then return nil
								else return false end
							end,
							set = function(info, value)
								E.db.general[info[#info]] = (value and 2) or (value == nil and 1) or 0
								E:StaticPopup_Show('PRIVATE_RL')
							end,
						},
					}
				},
				colorsGroup = {
					order = 52,
					name = L["Colors"],
					type = 'group',
					inline = true,
					get = function(info)
						local t = E.db.general[info[#info]]
						local d = P.general[info[#info]]
						return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
					end,
					set = function(info, r, g, b, a)
						local setting = info[#info]
						local t = E.db.general[setting]
						t.r, t.g, t.b, t.a = r, g, b, a
						E:UpdateMedia()
						if setting == 'bordercolor' then
							E:UpdateBorderColors()
						elseif setting == 'backdropcolor' or setting == 'backdropfadecolor' then
							E:UpdateBackdropColors()
						end
					end,
					args = {
						backdropcolor = {
							type = 'color',
							order = 1,
							name = L["Backdrop Color"],
							desc = L["Main backdrop color of the UI."],
							hasAlpha = false,
						},
						backdropfadecolor = {
							type = 'color',
							order = 2,
							name = L["Backdrop Faded Color"],
							desc = L["Backdrop color of transparent frames"],
							hasAlpha = true,
						},
						valuecolor = {
							type = 'color',
							order = 3,
							name = L["Value Color"],
							desc = L["Color some texts use."],
							hasAlpha = false,
						},
						spacer1 = ACH:Spacer(9, 'full'),
						uiBorderColors = {
							type = 'color',
							order = 10,
							name = L["Border Color"],
							desc = L["Main border color of the UI."],
							get = function(info)
								local t = E.db.general.bordercolor
								local d = P.general.bordercolor
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.general.bordercolor
								t.r, t.g, t.b, t.a = r, g, b, a
								E:UpdateMedia()
								E:UpdateBorderColors()
							end,
						},
						ufBorderColors = {
							order = 11,
							type = 'color',
							name = L["Unitframes Border Color"],
							get = function(info)
								local t = E.db.unitframe.colors.borderColor
								local d = P.unitframe.colors.borderColor
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
							end,
							set = function(info, r, g, b, a)
								local t = E.db.unitframe.colors.borderColor
								t.r, t.g, t.b, t.a = r, g, b, a
								E:UpdateMedia()
								E:UpdateBorderColors()
							end,
						},
					},
				},
			}
		},
		alternativePowerGroup = {
			order = 15,
			type = 'group',
			name = L["Alternative Power"],
			get = function(info) return E.db.general.altPowerBar[info[#info]] end,
			set = function(info, value)
				E.db.general.altPowerBar[info[#info]] = value;
				Blizzard:UpdateAltPowerBarSettings();
			end,
			args = {
				enable = {
					order = 2,
					type = 'toggle',
					name = L["Enable"],
					desc = L["Replace Blizzard's Alternative Power Bar"],
					width = 'full',
					set = function(info, value)
						E.db.general.altPowerBar[info[#info]] = value;
						E:StaticPopup_Show('PRIVATE_RL');
					end,
				},
				width = {
					order = 3,
					type = 'range',
					name = L["Width"],
					min = 50, max = 1000, step = 1,
				},
				height = {
					order = 4,
					type = 'range',
					name = L["Height"],
					min = 5, max = 100, step = 1,
				},
				statusBarGroup = {
					order = 5,
					name = L["Status Bar"],
					type = 'group',
					inline = true,
					set = function(info, value)
						E.db.general.altPowerBar[info[#info]] = value;
						Blizzard:UpdateAltPowerBarColors();
					end,
					get = function(info)
						return E.db.general.altPowerBar[info[#info]]
					end,
					args = {
						smoothbars = {
							type = 'toggle',
							order = 1,
							name = L["Smooth Bars"],
							desc = L["Bars will transition smoothly."],
						},
						statusBar = {
							order = 2,
							type = 'select', dialogControl = 'LSM30_Statusbar',
							name = L["StatusBar Texture"],
							values = AceGUIWidgetLSMlists.statusbar,
						},
						statusBarColorGradient = {
							order = 3,
							name = L["Color Gradient"],
							type = 'toggle',
						},
						statusBarColor = {
							type = 'color',
							order = 4,
							name = L["COLOR"],
							disabled = function()
								return E.db.general.altPowerBar.statusBarColorGradient
							end,
							get = function(info)
								local t = E.db.general.altPowerBar[info[#info]]
								local d = P.general.altPowerBar[info[#info]]
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b
							end,
							set = function(info, r, g, b)
								local t = E.db.general.altPowerBar[info[#info]]
								t.r, t.g, t.b = r, g, b
								Blizzard:UpdateAltPowerBarColors()
							end,
						},
					},
				},
				textGroup = {
					order = 6,
					name = L["Text"],
					type = 'group',
					inline = true,
					set = function(info, value)
						E.db.general.altPowerBar[info[#info]] = value;
						Blizzard:UpdateAltPowerBarSettings()
					end,
					get = function(info)
						return E.db.general.altPowerBar[info[#info]]
					end,
					args = {
						font = {
							type = 'select', dialogControl = 'LSM30_Font',
							order = 1,
							name = L["Font"],
							values = AceGUIWidgetLSMlists.font,
						},
						fontSize = {
							order = 2,
							name = L["FONT_SIZE"],
							type = 'range',
							min = 6, max = 24, step = 1,
						},
						fontOutline = {
							order = 3,
							type = 'select',
							name = L["Font Outline"],
							values = C.Values.FontFlags,
						},
						textFormat = {
							order = 4,
							type = 'select',
							name = L["Text Format"],
							sortByValue = true,
							values = {
								NONE = L["NONE"],
								NAME = L["NAME"],
								NAMEPERC = L["Name: Percent"],
								NAMECURMAX = L["Name: Current / Max"],
								NAMECURMAXPERC = L["Name: Current / Max - Percent"],
								PERCENT = L["Percent"],
								CURMAX = L["Current / Max"],
								CURMAXPERC = L["Current / Max - Percent"],
							},
						},
					},
				},
			},
		},
		blizzUIImprovements = {
			order = 20,
			type = 'group',
			name = L["BlizzUI Improvements"],
			args = {
				loot = {
					order = 1,
					type = 'toggle',
					name = L["Loot"],
					desc = L["Enable/Disable the loot frame."],
					get = function(info) return E.private.general.loot end,
					set = function(info, value) E.private.general.loot = value; E:StaticPopup_Show('PRIVATE_RL') end
				},
				lootRoll = {
					order = 2,
					type = 'toggle',
					name = L["Loot Roll"],
					desc = L["Enable/Disable the loot roll frame."],
					get = function(info) return E.private.general.lootRoll end,
					set = function(info, value) E.private.general.lootRoll = value; E:StaticPopup_Show('PRIVATE_RL') end
				},
				hideErrorFrame = {
					order = 3,
					name = L["Hide Error Text"],
					desc = L["Hides the red error text at the top of the screen while in combat."],
					type = 'toggle'
				},
				enhancedPvpMessages = {
					order = 4,
					type = 'toggle',
					name = L["Enhanced PVP Messages"],
					desc = L["Display battleground messages in the middle of the screen."],
				},
				showMissingTalentAlert = {
					order = 5,
					type = 'toggle',
					name = L["Missing Talent Alert"],
					desc = L["Show an alert frame if you have unspend talent points."],
					get = function(info) return E.global.general.showMissingTalentAlert end,
					set = function(info, value) E.global.general.showMissingTalentAlert = value; E:StaticPopup_Show('GLOBAL_RL') end,
				},
				raidUtility = {
					order = 6,
					type = 'toggle',
					name = L["RAID_CONTROL"],
					desc = L["Enables the ElvUI Raid Control panel."],
					get = function(info) return E.private.general.raidUtility end,
					set = function(info, value) E.private.general.raidUtility = value; E:StaticPopup_Show('PRIVATE_RL') end
				},
				voiceOverlay = {
					order = 7,
					type = 'toggle',
					name = L["Voice Overlay"],
					desc = L["Replace Blizzard's Voice Overlay."],
					get = function(info) return E.private.general.voiceOverlay end,
					set = function(info, value) E.private.general.voiceOverlay = value; E:StaticPopup_Show('PRIVATE_RL') end
				},
				disableTutorialButtons = {
					order = 8,
					type = 'toggle',
					name = L["Disable Tutorial Buttons"],
					desc = L["Disables the tutorial button found on some frames."],
					get = function(info) return E.global.general.disableTutorialButtons end,
					set = function(info, value) E.global.general.disableTutorialButtons = value; E:StaticPopup_Show('GLOBAL_RL') end,
				},
				resurrectSound = {
					order = 9,
					type = 'toggle',
					name = L["Resurrect Sound"],
					desc = L["Enable to hear sound if you receive a resurrect."],
				},
				vehicleSeatIndicatorSize = {
					order = 10,
					type = 'range',
					name = L["Vehicle Seat Indicator Size"],
					min = 64, max = 128, step = 4,
					get = function(info) return E.db.general.vehicleSeatIndicatorSize end,
					set = function(info, value) E.db.general.vehicleSeatIndicatorSize = value; Blizzard:UpdateVehicleFrame() end,
				},
				durabilityScale = {
					order = 11,
					type = 'range',
					name = L["Durability Scale"],
					min = 0.5, max = 8, step = 0.5,
					get = function(info) return E.db.general.durabilityScale end,
					set = function(info, value) E.db.general.durabilityScale = value; Blizzard:UpdateDurabilityScale() end,
				},
				commandBarSetting = {
					order = 12,
					type = 'select',
					name = L["Order Hall Command Bar"],
					get = function(info) return E.global.general.commandBarSetting end,
					set = function(info, value) E.global.general.commandBarSetting = value; E:StaticPopup_Show('GLOBAL_RL') end,
					width = 'normal',
					values = {
						DISABLED = L["Disable"],
						ENABLED = L["Enable"],
						ENABLED_RESIZEPARENT = L["Enable + Adjust Movers"],
					},
				},
				questRewardMostValueIcon = {
					order = 13,
					type = 'toggle',
					name = L["Mark Quest Reward"],
					desc = L["Marks the most valuable quest reward with a gold coin."],
				},
				questXPPercent = {
					order = 13,
					type = 'toggle',
					name = L["XP Quest Percent"],
				},
				itemLevelInfo = {
					order = 14,
					name = L["Item Level"],
					type = 'group',
					inline = true,
					get = function(info) return E.db.general.itemLevel[info[#info]] end,
					args = {
						displayCharacterInfo = {
							order = 1,
							type = 'toggle',
							name = L["Display Character Info"],
							desc = L["Shows item level of each item, enchants, and gems on the character page."],
							set = function(info, value)
								E.db.general.itemLevel.displayCharacterInfo = value;
								Misc:ToggleItemLevelInfo()
							end
						},
						displayInspectInfo = {
							order = 2,
							type = 'toggle',
							name = L["Display Inspect Info"],
							desc = L["Shows item level of each item, enchants, and gems when inspecting another player."],
							set = function(info, value)
								E.db.general.itemLevel.displayInspectInfo = value;
								Misc:ToggleItemLevelInfo()
							end
						},
						fontGroup = {
							order = 3,
							type = 'group',
							name = L["Fonts"],
							disabled = function() return not E.db.general.itemLevel.displayCharacterInfo and not E.db.general.itemLevel.displayInspectInfo end,
							get = function(info) return E.db.general.itemLevel[info[#info]] end,
							set = function(info, value)
								E.db.general.itemLevel[info[#info]] = value
								Misc:UpdateInspectPageFonts('Character')
								Misc:UpdateInspectPageFonts('Inspect')
							end,
							args = {
								itemLevelFont = {
									order = 1,
									type = 'select',
									name = L["Font"],
									dialogControl = 'LSM30_Font',
									values = AceGUIWidgetLSMlists.font,
								},
								itemLevelFontSize = {
									order = 2,
									type = 'range',
									name = L["FONT_SIZE"],
									min = 4, max = 42, step = 1,
								},
								itemLevelFontOutline = {
									order = 3,
									type = 'select',
									name = L["Font Outline"],
									values = C.Values.FontFlags,
								},
							},
						},
					},
				},
				objectiveFrameGroup = {
					order = 15,
					type = 'group',
					inline = true,
					name = L["Objective Frame"],
					get = function(info) return E.db.general[info[#info]] end,
					args = {
						objectiveFrameAutoHide = {
							order = 31,
							type = 'toggle',
							name = L["Auto Hide"],
							desc = L["Automatically hide the objective frame during boss or arena fights."],
							disabled = function() return IsAddOnLoaded('!KalielsTracker') end,
							set = function(info, value) E.db.general.objectiveFrameAutoHide = value; Blizzard:SetObjectiveFrameAutoHide(); end,
						},
						objectiveFrameAutoHideInKeystone = {
							order = 32,
							type = 'toggle',
							name = L["Hide In Keystone"],
							hidden = function() return not E.db.general.objectiveFrameAutoHide end,
							set = function(info, value) E.db.general.objectiveFrameAutoHideInKeystone = value end,
						},
						objectiveFrameHeight = {
							order = 33,
							type = 'range',
							name = L["Objective Frame Height"],
							desc = L["Height of the objective tracker. Increase size to be able to see more objectives."],
							min = 400, max = E.screenheight, step = 1,
							set = function(info, value) E.db.general.objectiveFrameHeight = value; Blizzard:SetObjectiveFrameHeight(); end,
						},
						bonusObjectivePosition = {
							order = 34,
							type = 'select',
							name = L["Bonus Reward Position"],
							desc = L["Position of bonus quest reward frame relative to the objective tracker."],
							values = {
								RIGHT = L["Right"],
								LEFT = L["Left"],
								AUTO = L["Automatic"],
							},
						},
					},
				},
				chatBubblesGroup = {
					order = 16,
					type = 'group',
					inline = true,
					name = L["Chat Bubbles"],
					get = function(info) return E.private.general[info[#info]] end,
					set = function(info, value) E.private.general[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL') end,
					args = {
						chatBubbles = {
							order = 2,
							type = 'select',
							name = L["Chat Bubbles Style"],
							desc = L["Skin the blizzard chat bubbles."],
							values = {
								backdrop = L["Skin Backdrop"],
								nobackdrop = L["Remove Backdrop"],
								backdrop_noborder = L["Skin Backdrop (No Borders)"],
								disabled = L["DISABLE"],
							}
						},
						chatBubbleFont = {
							order = 3,
							type = 'select',
							name = L["Font"],
							dialogControl = 'LSM30_Font',
							values = AceGUIWidgetLSMlists.font,
						},
						chatBubbleFontSize = {
							order = 4,
							type = 'range',
							name = L["FONT_SIZE"],
							min = 6, max = 64, step = 1,
						},
						chatBubbleFontOutline = {
							order = 5,
							type = 'select',
							name = L["Font Outline"],
							values = C.Values.FontFlags,
						},
						chatBubbleName = {
							order = 6,
							type = 'toggle',
							name = L["Chat Bubble Names"],
							desc = L["Display the name of the unit on the chat bubble. This will not work if backdrop is disabled or when you are in an instance."],
						},
					},
				},
			},
		},
	},
}
