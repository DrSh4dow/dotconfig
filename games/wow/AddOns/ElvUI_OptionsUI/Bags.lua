local E, _, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local C, L = unpack(select(2, ...))
local B = E:GetModule('Bags')
local ACH = E.Libs.ACH

local _G = _G
local gsub = gsub
local strmatch = strmatch
local SetCVar = SetCVar
local GetCVarBool = GetCVarBool
local SetInsertItemsLeftToRight = SetInsertItemsLeftToRight
local GameTooltip = _G.GameTooltip

E.Options.args.bags = {
	type = 'group',
	name = L["BAGSLOT"],
	childGroups = 'tab',
	order = 2,
	get = function(info) return E.db.bags[info[#info]] end,
	set = function(info, value) E.db.bags[info[#info]] = value end,
	args = {
		intro = ACH:Description(L["BAGS_DESC"], 1),
		enable = {
			order = 2,
			type = 'toggle',
			name = L["Enable"],
			desc = L["Enable/Disable the all-in-one bag."],
			get = function() return E.private.bags.enable end,
			set = function(_, value) E.private.bags.enable = value; E:StaticPopup_Show('PRIVATE_RL') end
		},
		general = {
			order = 3,
			type = 'group',
			name = L["General"],
			disabled = function() return not E.Bags.Initialized end,
			args = {
				currencyFormat = {
					order = 1,
					type = 'select',
					name = L["Currency Format"],
					desc = L["The display format of the currency icons that get displayed below the main bag. (You have to be watching a currency for this to display)"],
					values = {
						ICON = L["Icons Only"],
						ICON_TEXT = L["Icons and Text"],
						ICON_TEXT_ABBR = L["Icons and Text (Short)"],
					},
					set = function(info, value) E.db.bags[info[#info]] = value; B:UpdateTokens(); end,
				},
				moneyFormat = {
					order = 2,
					type = 'select',
					name = L["Money Format"],
					desc = L["The display format of the money text that is shown at the top of the main bag."],
					values = {
						SMART = L["Smart"],
						FULL = L["Full"],
						SHORT = L["SHORT"],
						SHORTINT = L["Short (Whole Numbers)"],
						CONDENSED = L["Condensed"],
						BLIZZARD = L["Blizzard Style"],
						BLIZZARD2 = L["Blizzard Style"]..' 2',
					},
					set = function(info, value) E.db.bags[info[#info]] = value; B:UpdateGoldText(); end,
				},
				strata = {
					order = 3,
					type = 'select',
					name = L["Frame Strata"],
					set = function(info, value) E.db.bags[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL') end,
					values = {
						BACKGROUND = 'BACKGROUND',
						LOW = 'LOW',
						MEDIUM = 'MEDIUM',
						HIGH = 'HIGH',
					},
				},
				spacer = ACH:Spacer(4, 'full'),
				moneyCoins = {
					order = 10,
					type = 'toggle',
					name = L["Show Coins"],
					desc = L["Use coin icons instead of colored text."],
					set = function(info, value) E.db.bags[info[#info]] = value; B:UpdateGoldText(); end,
				},
				transparent = {
					order = 11,
					type = 'toggle',
					name = L["Transparent Buttons"],
					set = function(info, value) E.db.bags[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
				},
				junkIcon = {
					order = 12,
					type = 'toggle',
					name = L["Show Junk Icon"],
					desc = L["Display the junk icon on all grey items that can be vendored."],
					set = function(info, value) E.db.bags[info[#info]] = value; B:UpdateAllBagSlots(); end,
				},
				junkDesaturate = {
					order = 13,
					type = 'toggle',
					name = L["Desaturate Junk Items"],
					set = function(info, value) E.db.bags[info[#info]] = value; B:UpdateAllBagSlots(); end,
				},
				upgradeIcon = {
					order = 14,
					type = 'toggle',
					name = L["Show Upgrade Icon"],
					desc = L["Display the upgrade icon on items that WoW considers an upgrade for your character."],
					set = function(info, value) E.db.bags[info[#info]] = value; B:UpdateAllBagSlots(); end,
				},
				scrapIcon = {
					order = 15,
					type = 'toggle',
					name = L["Show Scrap Icon"],
					desc = L["Display the scrap icon on items that can be scrapped."],
					set = function(info, value) E.db.bags[info[#info]] = value; B:UpdateAllBagSlots(); end,
				},
				newItemGlow = {
					order = 16,
					type = 'toggle',
					name = L["Show New Item Glow"],
					desc = L["Display the New Item Glow"],
					set = function(info, value) E.db.bags[info[#info]] = value; B:UpdateAllBagSlots(); end,
				},
				showAssignedColor = {
					order = 17,
					type = 'toggle',
					name = L["Show Assigned Color"],
					desc = L["Colors the border according to the type of items assigned to the bag."],
					set = function(info, value) E.db.bags[info[#info]] = value; B:UpdateAllBagSlots(); end,
				},
				showAssignedIcon = {
					order = 18,
					type = 'toggle',
					name = L["Show Assigned Icon"],
					set = function(info, value) E.db.bags[info[#info]] = value; B:Layout(); B:SizeAndPositionBagBar() end,
				},
				qualityColors = {
					order = 19,
					type = 'toggle',
					name = L["Show Quality Color"],
					desc = L["Colors the border according to the Quality of the Item."],
					set = function(info, value) E.db.bags[info[#info]] = value; B:UpdateAllBagSlots(); end,
				},
				specialtyColors = {
					order = 20,
					type = 'toggle',
					name = L["Show Special Bags Color"],
					set = function(info, value) E.db.bags[info[#info]] = value; B:UpdateAllBagSlots(); end,
				},
				showBindType = {
					order = 21,
					type = 'toggle',
					name = L["Show Bind on Equip/Use Text"],
					set = function(info, value) E.db.bags[info[#info]] = value; B:UpdateAllBagSlots(); end,
				},
				clearSearchOnClose = {
					order = 22,
					type = 'toggle',
					name = L["Clear Search On Close"],
					set = function(info, value) E.db.bags[info[#info]] = value; end
				},
				reverseLoot = {
					order = 23,
					type = 'toggle',
					name = L["REVERSE_NEW_LOOT_TEXT"],
					set = function(info, value)
						E.db.bags.reverseLoot = value;
						SetInsertItemsLeftToRight(value)
					end,
				},
				reverseSlots = {
					order = 24,
					type = 'toggle',
					name = L["Reverse Bag Slots"],
					set = function(info, value) E.db.bags[info[#info]] = value B:UpdateAll() end,
				},
				disableBagSort = {
					order = 25,
					type = 'toggle',
					name = L["Disable Bag Sort"],
					set = function(info, value) E.db.bags[info[#info]] = value; B:ToggleSortButtonState(false); end
				},
				disableBankSort = {
					order = 26,
					type = 'toggle',
					name = L["Disable Bank Sort"],
					set = function(info, value) E.db.bags[info[#info]] = value; B:ToggleSortButtonState(true); end
				},
				useBlizzardCleanup = {
					order = 27,
					type = 'toggle',
					name = L["Use Blizzard Cleanup"],
					desc = L["Use Blizzards method of cleaning up bags instead of the ElvUI sorting."],
					set = function(info, value) E.db.bags[info[#info]] = value; end
				},
				auctionToggle = {
					order = 28,
					type = 'toggle',
					name = L["Auction Toggle"],
					desc = L["This will toggle your bags while visiting the Auction House."],
					set = function(info, value) E.db.bags[info[#info]] = value; end
				},
				countGroup = {
					order = 50,
					type = 'group',
					name = L["Item Count Font"],
					inline = true,
					args = {
						countFont = {
							order = 1,
							type = 'select',
							dialogControl = 'LSM30_Font',
							name = L["Font"],
							values = AceGUIWidgetLSMlists.font,
							set = function(info, value) E.db.bags.countFont = value; B:UpdateCountDisplay() end,
						},
						countFontColor = {
							order = 2,
							type = 'color',
							name = L["COLOR"],
							get = function(info)
								local t = E.db.bags[info[#info]]
								local d = P.bags[info[#info]]
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b
							end,
							set = function(info, r, g, b)
								local t = E.db.bags[info[#info]]
								t.r, t.g, t.b = r, g, b
								B:UpdateCountDisplay()
							end,
						},
						countFontSize = {
							order = 3,
							type = 'range',
							name = L["FONT_SIZE"],
							min = 6, max = 64, step = 1,
							set = function(info, value) E.db.bags.countFontSize = value; B:UpdateCountDisplay() end,
						},
						countFontOutline = {
							order = 4,
							type = 'select',
							name = L["Font Outline"],
							set = function(info, value) E.db.bags.countFontOutline = value; B:UpdateCountDisplay() end,
							values = C.Values.FontFlags,
						},
					},
				},
				itemLevelGroup = {
					order = 55,
					type = 'group',
					name = L["Item Level"],
					inline = true,
					args = {
						itemLevel = {
							order = 1,
							type = 'toggle',
							name = L["Display Item Level"],
							desc = L["Displays item level on equippable items."],
							set = function(info, value) E.db.bags.itemLevel = value; B:UpdateItemLevelDisplay() end,
						},
						itemLevelCustomColorEnable = {
							order = 2,
							type = 'toggle',
							name = L["Enable Custom Color"],
							set = function(info, value) E.db.bags.itemLevelCustomColorEnable = value; B:UpdateItemLevelDisplay() end,
						},
						itemLevelCustomColor = {
							order = 3,
							type = 'color',
							name = L["Custom Color"],
							disabled = function() return not E.db.bags.itemLevelCustomColorEnable end,
							get = function(info)
								local t = E.db.bags.itemLevelCustomColor
								local d = P.bags.itemLevelCustomColor
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b
							end,
							set = function(info, r, g, b)
								local t = E.db.bags.itemLevelCustomColor
								t.r, t.g, t.b = r, g, b
								B:UpdateItemLevelDisplay()
							end,
						},
						itemLevelThreshold = {
							order = 4,
							name = L["Item Level Threshold"],
							desc = L["The minimum item level required for it to be shown."],
							type = 'range',
							min = 1, max = 1000, step = 1,
							disabled = function() return not E.db.bags.itemLevel end,
							set = function(info, value) E.db.bags.itemLevelThreshold = value; B:UpdateItemLevelDisplay() end,
						},
						itemLevelFont = {
							order = 5,
							type = 'select',
							dialogControl = 'LSM30_Font',
							name = L["Font"],
							values = AceGUIWidgetLSMlists.font,
							disabled = function() return not E.db.bags.itemLevel end,
							set = function(info, value) E.db.bags.itemLevelFont = value; B:UpdateItemLevelDisplay() end,
						},
						itemLevelFontSize = {
							order = 6,
							type = 'range',
							name = L["FONT_SIZE"],
							min = 6, max = 64, step = 1,
							disabled = function() return not E.db.bags.itemLevel end,
							set = function(info, value) E.db.bags.itemLevelFontSize = value; B:UpdateItemLevelDisplay() end,
						},
						itemLevelFontOutline = {
							order = 7,
							type = 'select',
							name = L["Font Outline"],
							disabled = function() return not E.db.bags.itemLevel end,
							set = function(info, value) E.db.bags.itemLevelFontOutline = value; B:UpdateItemLevelDisplay() end,
							values = C.Values.FontFlags,
						},
					},
				},
			},
		},
		sizeGroup = {
			order = 4,
			type = 'group',
			name = L["Size"],
			disabled = function() return not E.Bags.Initialized end,
			args = {
				bagSize = {
					order = 2,
					type = 'range',
					name = L["Button Size (Bag)"],
					desc = L["The size of the individual buttons on the bag frame."],
					min = 15, max = 45, step = 1,
					set = function(info, value) E.db.bags[info[#info]] = value; B:Layout(); end,
				},
				bankSize = {
					order = 3,
					type = 'range',
					name = L["Button Size (Bank)"],
					desc = L["The size of the individual buttons on the bank frame."],
					min = 15, max = 45, step = 1,
					set = function(info, value) E.db.bags[info[#info]] = value; B:Layout(true) end,
				},
				bagWidth = {
					order = 4,
					type = 'range',
					name = L["Panel Width (Bags)"],
					desc = L["Adjust the width of the bag frame."],
					min = 150, max = 1400, step = 1,
					set = function(info, value) E.db.bags[info[#info]] = value; B:Layout();end,
				},
				bankWidth = {
					order = 5,
					type = 'range',
					name = L["Panel Width (Bank)"],
					desc = L["Adjust the width of the bank frame."],
					min = 150, max = 1400, step = 1,
					set = function(info, value) E.db.bags[info[#info]] = value; B:Layout(true) end,
				},
			},
		},
		colorGroup = {
			order = 5,
			type = 'group',
			name = L["COLORS"],
			disabled = function() return not E.Bags.Initialized end,
			args = {
				bags = {
					order = 2,
					type = 'group',
					name = L["Bags"],
					inline = true,
					args = {
						profession = {
							order = 1,
							type = 'group',
							name = L["Profession Bags"],
							inline = true,
							get = function(info)
								local t = E.db.bags.colors.profession[info[#info]]
								local d = P.bags.colors.profession[info[#info]]
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b
							end,
							set = function(info, r, g, b)
								local t = E.db.bags.colors.profession[info[#info]]
								t.r, t.g, t.b = r, g, b
								B:UpdateBagColors('ProfessionColors', info[#info], r, g, b)
								B:UpdateAllBagSlots()
							end,
							args = {
								leatherworking = {
									order = 1,
									type = 'color',
									name = L["Leatherworking"],
								},
								inscription = {
									order = 2,
									type = 'color',
									name = L["INSCRIPTION"],
								},
								herbs = {
									order = 3,
									type = 'color',
									name = L["Herbalism"],
								},
								enchanting = {
									order = 4,
									type = 'color',
									name = L["Enchanting"],
								},
								engineering = {
									order = 5,
									type = 'color',
									name = L["Engineering"],
								},
								gems = {
									order = 6,
									type = 'color',
									name = L["Gems"],
								},
								mining = {
									order = 7,
									type = 'color',
									name = L["Mining"],
								},
								fishing = {
									order = 8,
									type = 'color',
									name = L["PROFESSIONS_FISHING"],
								},
								cooking = {
									order = 9,
									type = 'color',
									name = L["PROFESSIONS_COOKING"],
								},
							},
						},
						assignment = {
							order = 2,
							type = 'group',
							name = L["Bag Assignment"],
							inline = true,
							get = function(info)
								local t = E.db.bags.colors.assignment[info[#info]]
								local d = P.bags.colors.assignment[info[#info]]
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b
							end,
							set = function(info, r, g, b)
								local t = E.db.bags.colors.assignment[info[#info]]
								t.r, t.g, t.b = r, g, b
								B:UpdateBagColors('AssignmentColors', info[#info], r, g, b)
								B:UpdateAllBagSlots()
							end,
							args = {
								equipment = {
									order = 1,
									type = 'color',
									name = L["BAG_FILTER_EQUIPMENT"],
								},
								consumables = {
									order = 2,
									type = 'color',
									name = L["BAG_FILTER_CONSUMABLES"],
								},
								tradegoods = {
									order = 3,
									type = 'color',
									name = L["BAG_FILTER_TRADE_GOODS"],
								},
							},
						},
					},
				},
				items = {
					order = 3,
					type = 'group',
					name = L["ITEMS"],
					inline = true,
					get = function(info)
						local t = E.db.bags.colors.items[info[#info]]
						local d = P.bags.colors.items[info[#info]]
						return t.r, t.g, t.b, t.a, d.r, d.g, d.b
					end,
					set = function(info, r, g, b)
						local t = E.db.bags.colors.items[info[#info]]
						t.r, t.g, t.b = r, g, b
						B:UpdateQuestColors('QuestColors', info[#info], r, g, b)
						B:UpdateAllBagSlots()
					end,
					args = {
						questStarter = {
							order = 1,
							type = 'color',
							name = L["Quest Starter"]
						},
						questItem = {
							order = 2,
							type = 'color',
							name = L["ITEM_BIND_QUEST"],
						}
					}
				}
			}
		},
		bagBar = {
			order = 6,
			type = 'group',
			name = L["Bag-Bar"],
			get = function(info) return E.db.bags.bagBar[info[#info]] end,
			set = function(info, value) E.db.bags.bagBar[info[#info]] = value; B:SizeAndPositionBagBar() end,
			args = {
				enable = {
					order = 1,
					type = 'toggle',
					name = L["Enable"],
					desc = L["Enable/Disable the Bag-Bar."],
					get = function() return E.private.bags.bagBar end,
					set = function(_, value) E.private.bags.bagBar = value; E:StaticPopup_Show('PRIVATE_RL') end
				},
				showBackdrop = {
					order = 2,
					type = 'toggle',
					name = L["Backdrop"],
				},
				mouseover = {
					order = 3,
					name = L["Mouse Over"],
					desc = L["The frame is not shown unless you mouse over the frame."],
					type = 'toggle',
				},
				showCount = {
					order = 4,
					name = L["Show Count"],
					type = 'toggle',
					set = function(_, value)
						SetCVar('displayFreeBagSlots', value and 1 or 0)
						B:SizeAndPositionBagBar()
					end,
					get = function()
						return GetCVarBool('displayFreeBagSlots')
					end
				},
				size = {
					order = 5,
					type = 'range',
					name = L["Button Size"],
					desc = L["Set the size of your bag buttons."],
					min = 12, max = 128, step = 1,
				},
				spacing = {
					order = 6,
					type = 'range',
					name = L["Button Spacing"],
					desc = L["The spacing between buttons."],
					min = -3, max = 20, step = 1,
				},
				backdropSpacing = {
					order = 7,
					type = 'range',
					name = L["Backdrop Spacing"],
					desc = L["The spacing between the backdrop and the buttons."],
					min = 0, max = 10, step = 1,
					disabled = function() return not E.private.actionbar.enable end,
				},
				spacer = ACH:Spacer(8, 'full'),
				sortDirection = {
					order = 9,
					type = 'select',
					name = L["Sort Direction"],
					desc = L["The direction that the bag frames will grow from the anchor."],
					values = {
						ASCENDING = L["Ascending"],
						DESCENDING = L["Descending"],
					},
				},
				growthDirection = {
					order = 10,
					type = 'select',
					name = L["Bar Direction"],
					desc = L["The direction that the bag frames be (Horizontal or Vertical)."],
					values = {
						VERTICAL = L["Vertical"],
						HORIZONTAL = L["Horizontal"],
					},
				},
				visibility = {
					type = 'input',
					order = 11,
					name = L["Visibility State"],
					desc = L["This works like a macro, you can run different situations to get the actionbar to show/hide differently.\n Example: '[combat] show;hide'"],
					width = 'full',
					multiline = true,
					set = function(_, value)
						if value and value:match('[\n\r]') then
							value = value:gsub('[\n\r]','')
						end
						E.db.bags.bagBar.visibility = value;
						B:SizeAndPositionBagBar()
					end,
				},
			},
		},
		split = {
			order = 7,
			type = 'group',
			name = L["Split"],
			get = function(info) return E.db.bags.split[info[#info]] end,
			set = function(info, value) E.db.bags.split[info[#info]] = value B:UpdateAll() end,
			disabled = function() return not E.Bags.Initialized end,
			args = {
				bagSpacing = {
					order = 1,
					type = 'range',
					name = L["Bag Spacing"],
					min = -3, max = 20, step = 1,
				},
				player = {
					order = 2,
					type = 'toggle',
					set = function(info, value) E.db.bags.split[info[#info]] = value B:Layout() end,
					name = L["Bag"],
				},
				bank = {
					order = 3,
					type = 'toggle',
					set = function(info, value) E.db.bags.split[info[#info]] = value B:Layout(true) end,
					name = L["Bank"],
				},
				splitbags = {
					order = 4,
					type = 'multiselect',
					name = L["Player"],
					get = function(_, key) return E.db.bags.split[key] end,
					set = function(_, key, value) E.db.bags.split[key] = value B:Layout() end,
					values = {
						bag1 = L["Bag 1"],
						bag2 = L["Bag 2"],
						bag3 = L["Bag 3"],
						bag4 = L["Bag 4"],
					},
					disabled = function() return not E.db.bags.split.player end,
				},
				splitbank = {
					order = 5,
					type = 'multiselect',
					name = L["Bank"],
					get = function(_, key) return E.db.bags.split[key] end,
					set = function(_, key, value) E.db.bags.split[key] = value B:Layout(true) end,
					sortByValue = true,
					values = {
						bag5 = L["Bank 1"],
						bag6 = L["Bank 2"],
						bag7 = L["Bank 3"],
						bag8 = L["Bank 4"],
						bag9 = L["Bank 5"],
						bag10 = L["Bank 6"],
						bag11 = L["Bank 7"],
					},
					disabled = function() return not E.db.bags.split.bank end,
				},
			},
		},
		vendorGrays = {
			order = 8,
			type = 'group',
			name = L["Vendor Grays"],
			get = function(info) return E.db.bags.vendorGrays[info[#info]] end,
			set = function(info, value) E.db.bags.vendorGrays[info[#info]] = value; B:UpdateSellFrameSettings() end,
			args = {
				enable = {
					order = 1,
					type = 'toggle',
					name = L["Enable"],
					desc = L["Automatically vendor gray items when visiting a vendor."],
				},
				interval = {
					order = 2,
					type = 'range',
					name = L["Sell Interval"],
					desc = L["Will attempt to sell another item in set interval after previous one was sold."],
					min = 0.1, max = 1, step = 0.1,
				},
				details = {
					order = 3,
					name = L["Vendor Gray Detailed Report"],
					desc = L["Displays a detailed report of every item sold when enabled."],
					type = 'toggle',
				},
				progressBar = {
					order = 4,
					name = L["Progress Bar"],
					type = 'toggle',
				},
			},
		},
		bagSortingGroup = {
			order = 9,
			type = 'group',
			name = L["Bag Sorting"],
			disabled = function() return (not E.Bags.Initialized) or E.db.bags.useBlizzardCleanup end,
			args = {
				sortInverted = {
					order = 1,
					type = 'toggle',
					name = L["Sort Inverted"],
					desc = L["Direction the bag sorting will use to allocate the items."],
				},
				description = ACH:Description(L["Here you can add items or search terms that you want to be excluded from sorting. To remove an item just click on its name in the list."], 3),
				addEntryGroup = {
					order = 4,
					type = 'group',
					name = L["Add Item or Search Syntax"],
					inline = true,
					args = {
						addEntryProfile = {
							order = 1,
							name = L["Profile"],
							desc = L["Add an item or search syntax to the ignored list. Items matching the search syntax will be ignored."],
							type = 'input',
							get = function() return '' end,
							set = function(_, value)
								if value == '' or gsub(value, '%s+', '') == '' then return; end --Don't allow empty entries

								--Store by itemID if possible
								local itemID = strmatch(value, 'item:(%d+)')
								E.db.bags.ignoredItems[(itemID or value)] = value
							end,
						},
						addEntryGlobal = {
							order = 3,
							name = L["Global"],
							desc = L["Add an item or search syntax to the ignored list. Items matching the search syntax will be ignored."],
							type = 'input',
							get = function() return '' end,
							set = function(_, value)
								if value == '' or gsub(value, '%s+', '') == '' then return; end --Don't allow empty entries

								--Store by itemID if possible
								local itemID = strmatch(value, 'item:(%d+)')
								E.global.bags.ignoredItems[(itemID or value)] = value

								--Remove from profile list if we just added the same item to global list
								if E.db.bags.ignoredItems[(itemID or value)] then
									E.db.bags.ignoredItems[(itemID or value)] = nil
								end
							end,
						},
					},
				},
				ignoredEntriesProfile = {
					order = 5,
					type = 'multiselect',
					name = L["Ignored Items and Search Syntax (Profile)"],
					values = function() return E.db.bags.ignoredItems end,
					get = function(_, value)	return E.db.bags.ignoredItems[value] end,
					set = function(_, value)
						E.db.bags.ignoredItems[value] = nil
						GameTooltip:Hide()--Make sure tooltip is properly hidden
					end,
				},
				ignoredEntriesGlobal = {
					order = 6,
					type = 'multiselect',
					name = L["Ignored Items and Search Syntax (Global)"],
					values = function() return E.global.bags.ignoredItems end,
					get = function(_, value)	return E.global.bags.ignoredItems[value] end,
					set = function(_, value)
						E.global.bags.ignoredItems[value] = nil
						GameTooltip:Hide()--Make sure tooltip is properly hidden
					end,
				},
			},
		},
		search_syntax = {
			order = 10,
			type = 'group',
			name = L["Search Syntax"],
			disabled = function() return not E.Bags.Initialized end,
			args = {
				text = {
					order = 1,
					type = 'input',
					multiline = 26,
					width = 'full',
					name = '',
					get = function() return L["SEARCH_SYNTAX_DESC"]; end,
					set = E.noop,
				},
			},
		},
	},
}
