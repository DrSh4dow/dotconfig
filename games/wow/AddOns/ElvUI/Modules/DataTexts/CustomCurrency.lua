local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local DT = E:GetModule('DataTexts')

local _G = _G
local ipairs, pairs, format = ipairs, pairs, format
local tinsert, tremove, next = tinsert, tremove, next
local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local C_CurrencyInfo_GetCurrencyListInfo = C_CurrencyInfo.GetCurrencyListInfo
local C_CurrencyInfo_GetCurrencyListSize = C_CurrencyInfo.GetCurrencyListSize

local CustomCurrencies = {}
local CurrencyListNameToIndex = {}

local function OnEvent(self)
	local currency = CustomCurrencies[self.name]
	if currency then
		local info = C_CurrencyInfo_GetCurrencyInfo(currency.ID)
		if not info then return end

		if currency.DISPLAY_STYLE == 'ICON' then
			if currency.SHOW_MAX then
				self.text:SetFormattedText('%s %d / %d', currency.ICON, info.quantity, info.maxQuantity)
			else
				self.text:SetFormattedText('%s %d', currency.ICON, info.quantity)
			end
		elseif currency.DISPLAY_STYLE == 'ICON_TEXT' then
			if currency.SHOW_MAX then
				self.text:SetFormattedText('%s %s %d / %d', currency.ICON, currency.NAME, info.quantity, info.maxQuantity)
			else
				self.text:SetFormattedText('%s %s %d', currency.ICON, currency.NAME, info.quantity)
			end
		else --ICON_TEXT_ABBR
			if currency.SHOW_MAX then
				self.text:SetFormattedText('%s %s %d / %d', currency.ICON, E:AbbreviateString(currency.NAME), info.quantity, info.maxQuantity)
			else
				self.text:SetFormattedText('%s %s %d', currency.ICON, E:AbbreviateString(currency.NAME), info.quantity)
			end
		end
	end
end

local function OnEnter(self)
	DT.tooltip:ClearLines()

	local currency = CustomCurrencies[self.name]
	if not currency or not currency.USE_TOOLTIP then return end

	local index = CurrencyListNameToIndex[self.name]
	if not index then return end
	DT.tooltip:SetCurrencyToken(index)
	DT.tooltip:Show()
end

local function AddCurrencyNameToIndex(name)
	for index = 1, C_CurrencyInfo_GetCurrencyListSize() do
		local info = C_CurrencyInfo_GetCurrencyListInfo(index)
		if info.name == name then
			CurrencyListNameToIndex[name] = index
			break
		end
	end
end

local function RegisterNewDT(currencyID)
	local info = C_CurrencyInfo_GetCurrencyInfo(currencyID)
	if info.discovered then
		local name = info.name

		--Add to internal storage, stored with name as key
		CustomCurrencies[name] = {NAME = name, ID = currencyID, ICON = format('|T%s:16:16:0:0:64:64:4:60:4:60|t', info.iconFileID), DISPLAY_STYLE = 'ICON', USE_TOOLTIP = true, SHOW_MAX = false, DISPLAY_IN_MAIN_TOOLTIP = true}
		--Register datatext
		DT:RegisterDatatext(name, _G.CURRENCY, {'CHAT_MSG_CURRENCY', 'CURRENCY_DISPLAY_UPDATE'}, OnEvent, nil, nil, OnEnter, nil, name)
		--Save info to persistent storage, stored with ID as key
		E.global.datatexts.customCurrencies[currencyID] = CustomCurrencies[name]
		--Get the currency index for this currency, so we can use it for a tooltip
		AddCurrencyNameToIndex(name)

		--Set the HyperDT
		local menuIndex = DT:GetMenuListCategory(_G.CURRENCY)
		local hyperList = DT.HyperList[menuIndex]
		if hyperList then
			local menuList = hyperList.menuList

			tinsert(menuList, {
				text = name,
				checked = function() return DT.EasyMenu.MenuGetItem(DT.SelectedDatatext, name) end,
				func = function() DT.EasyMenu.MenuSetItem(DT.SelectedDatatext, name) end
			})

			DT:SortMenuList(menuList)
		end
	end
end

function DT:UpdateCustomCurrencySettings(currencyName, option, value)
	if not currencyName or not option then return end

	if option == 'DISPLAY_STYLE' then
		CustomCurrencies[currencyName].DISPLAY_STYLE = value
	elseif option == 'USE_TOOLTIP' then
		CustomCurrencies[currencyName].USE_TOOLTIP = value
	elseif option == 'SHOW_MAX' then
		CustomCurrencies[currencyName].SHOW_MAX = value
	elseif option == 'DISPLAY_IN_MAIN_TOOLTIP' then
		CustomCurrencies[currencyName].DISPLAY_IN_MAIN_TOOLTIP = value
	end
end

function DT:RegisterCustomCurrencyDT(currencyID)
	if currencyID then
		--We added a new datatext through the config
		if not next(CustomCurrencies) then -- add Currency category if one didn't already exist
			tinsert(DT.HyperList, { text = _G.CURRENCY, notCheckable = true, hasArrow = true, menuList = {} } )
			DT:SortMenuList(DT.HyperList)
		end

		RegisterNewDT(currencyID)
	else
		--We called this in DT:Initialize, so load all the stored currency datatexts
		for _, info in pairs(E.global.datatexts.customCurrencies) do
			CustomCurrencies[info.NAME] = {NAME = info.NAME, ID = info.ID, ICON = info.ICON, DISPLAY_STYLE = info.DISPLAY_STYLE, USE_TOOLTIP = info.USE_TOOLTIP, SHOW_MAX = info.SHOW_MAX}
			DT:RegisterDatatext(info.NAME, _G.CURRENCY, {'CHAT_MSG_CURRENCY', 'CURRENCY_DISPLAY_UPDATE'}, OnEvent, nil, nil, OnEnter, nil, info.NAME)
			--Get the currency index for this currency, so we can use it for a tooltip
			AddCurrencyNameToIndex(info.NAME)
		end
	end
end

function DT:RemoveCustomCurrency(currencyName)
	--Remove from internal storage
	CustomCurrencies[currencyName] = nil

	if not next(CustomCurrencies) then
		for i, menu in ipairs(DT.HyperList) do
			if menu.text ==  _G.CURRENCY then
				tremove(DT.HyperList, i)
				break
			end
		end
	else
		local menuIndex = DT:GetMenuListCategory(_G.CURRENCY)
		local hyperList = DT.HyperList[menuIndex]
		if hyperList then
			local menuList = hyperList.menuList

			for i, info in ipairs(menuList) do
				if info.text == currencyName then
					tremove(menuList, i)
				end
			end
		end
	end

	DT:SortMenuList(DT.HyperList)
end
