--Neuron, a World of Warcraft® user interface addon.

local DB

local L = LibStub("AceLocale-3.0"):GetLocale("Neuron")




function Neuron:Startup()

	DB = Neuron.db.profile

	Neuron:RegisterBars()

	Neuron:RegisterGUI()

	Neuron:CreateBarsAndButtons()

	--Neuron:Overrides()


	for _,bar in pairs(Neuron.BARIndex) do
		bar:Load()
	end

end



function Neuron:RegisterBars()

	--Neuron Action Bar
	Neuron:RegisterBarClass("ActionBar", "ActionBar", L["Action Bar"], "Action Button", DB.ActionBar, Neuron.ACTIONBUTTON, 250)

	--Neuron Zone Ability Bar
	Neuron:RegisterBarClass("ZoneAbilityBar", "ZoneAbilityBar", L["Zone Action Bar"], "Zone Action Button", DB.ZoneAbilityBar, Neuron.ZONEABILITYBTN, 1)

	--Neuron Extra Bar
	Neuron:RegisterBarClass("ExtraBar", "ExtraBar", L["Extra Action Bar"], "Extra Action Button", DB.ExtraBar, Neuron.EXTRABTN,1)

	--Neuron Bag Bar
	Neuron:RegisterBarClass("BagBar", "BagBar", L["Bag Bar"], "Bag Button", DB.BagBar, Neuron.BAGBTN,5)

	--Neuron Status Bar
	Neuron:RegisterBarClass("StatusBar", "StatusBar", L["Status Bar"], "Status Bar", DB.StatusBar, Neuron.STATUSBTN, 20)

	--Neuron Exit Bar
	Neuron:RegisterBarClass("ExitBar", "ExitBar", L["Vehicle Exit Bar"], "Vehicle Exit Button", DB.ExitBar, Neuron.EXITBTN,1)

	--Neuron Menu Bar
	Neuron:RegisterBarClass("MenuBar", "MenuBar", L["Menu Bar"], "Menu Button", DB.MenuBar, Neuron.MENUBTN, 11)

	--Neuron Pet Bar
	Neuron:RegisterBarClass("PetBar", "PetBar", L["Pet Bar"], "Pet Button", DB.PetBar, Neuron.PETBTN, 10)

end

function Neuron:RegisterGUI()

	--Neuron Action Bar
	Neuron:RegisterGUIOptions("ActionBar", {
		AUTOHIDE = true,
		SHOWGRID = true,
		SPELLGLOW = true,
		SNAPTO = true,
		UPCLICKS = true,
		DOWNCLICKS = true,
		MULTISPEC = true,
		HIDDEN = true,
		LOCKBAR = true,
		TOOLTIPS = true,
		BINDTEXT = true,
		MACROTEXT = true,
		COUNTTEXT = true,
		RANGEIND = true,
		CDTEXT = true,
		CDALPHA = true,
		AURATEXT = true,
		AURAIND = true },
			true, 115)

	--Neuron Zone Ability Bar
	Neuron:RegisterGUIOptions("ZoneAbilityBar", {
		AUTOHIDE = true,
		SHOWGRID = false,
		SNAPTO = true,
		UPCLICKS = true,
		DOWNCLICKS = true,
		HIDDEN = true,
		LOCKBAR = false,
		TOOLTIPS = true,
		BINDTEXT = true,
		RANGEIND = true,
		CDTEXT = true,
		CDALPHA = true,
		ZONEABILITY = true},
			false, 65)


	--Neuron Extra Bar
	Neuron:RegisterGUIOptions("ExtraBar", {
		AUTOHIDE = true,
		SHOWGRID = false,
		SNAPTO = true,
		UPCLICKS = true,
		DOWNCLICKS = true,
		HIDDEN = true,
		LOCKBAR = true,
		BINDTEXT = true,
		RANGEIND = true,
		CDTEXT = true,
		CDALPHA = true },
			false, 65)


	--Neuron Bag Bar
	Neuron:RegisterGUIOptions("BagBar", {
		AUTOHIDE = true,
		SHOWGRID = false,
		SPELLGLOW = false,
		SNAPTO = true,
		MULTISPEC = false,
		HIDDEN = true,
		LOCKBAR = false,
		TOOLTIPS = true, },
			false, false)

	--Neuron Status Bar
	Neuron:RegisterGUIOptions("StatusBar", {
		AUTOHIDE = true,
		SNAPTO = true,
		HIDDEN = true,
		TOOLTIPS = true },
			false, false)

	--Neuron Exit Bar
	Neuron:RegisterGUIOptions("ExitBar", {
		AUTOHIDE = true,
		SHOWGRID = false,
		SNAPTO = true,
		UPCLICKS = true,
		DOWNCLICKS = true,
		HIDDEN = true,
		LOCKBAR = true,
		TOOLTIPS = true,
		BINDTEXT = true,
		RANGEIND = true,
		CDTEXT = true,
		CDALPHA = true },
			false, 65)

	--Neuron Menu Bar
	Neuron:RegisterGUIOptions("MenuBar", {
		AUTOHIDE = true,
		SHOWGRID = false,
		SPELLGLOW = false,
		SNAPTO = true,
		MULTISPEC = false,
		HIDDEN = true,
		LOCKBAR = false,
		TOOLTIPS = true },
			false, false)

	--Neuron Pet Bar
	Neuron:RegisterGUIOptions("PetBar", {
		AUTOHIDE = true,
		SHOWGRID = false,
		SNAPTO = true,
		UPCLICKS = true,
		DOWNCLICKS = true,
		HIDDEN = true,
		LOCKBAR = true,
		TOOLTIPS = true,
		BINDTEXT = true,
		RANGEIND = true,
		CDTEXT = true,
		CDALPHA = true },
			false, 65)

end

function Neuron:CreateBarsAndButtons()

	if (DB.firstRun) then

		for barClass, barDefaults in pairs(NeuronDefaultBarOptions) do

			for i, defaults in ipairs(barDefaults) do

				local bar = Neuron:CreateNewBar(barClass, i, defaults) --this calls the bar constructor

			end

		end

		DB.firstRun = false

	else

		for barClass, barClassData in pairs (Neuron.RegisteredBarData) do

			for id,data in pairs(barClassData.barDB) do
				if (data ~= nil) then
					Neuron:CreateNewBar(barClass, id)
				end
			end
		end
	end

end


function Neuron:Overrides()

	--bag bar overrides
	if DB.blizzbar == false then
		---hide the weird color border around bag bars
		CharacterBag0Slot.IconBorder:Hide()
		CharacterBag1Slot.IconBorder:Hide()
		CharacterBag2Slot.IconBorder:Hide()
		CharacterBag3Slot.IconBorder:Hide()

		---overwrite the Show function with a null function because it keeps coming back and won't stay hidden
		Neuron:RawHook(CharacterBag0Slot.IconBorder, "Show", function() end, true)
		Neuron:RawHook(CharacterBag1Slot.IconBorder, "Show", function() end, true)
		Neuron:RawHook(CharacterBag2Slot.IconBorder, "Show", function() end, true)
		Neuron:RawHook(CharacterBag3Slot.IconBorder, "Show", function() end, true)
	end



	--status bar overrides
	local disableDefaultCast = false
	local disableDefaultMirror = false

	for i,v in ipairs(Neuron.Buttons.Status) do

		if (v["bar"]) then --only disable if a specific button has an associated bar
			if v.config.sbType == "cast" then
				disableDefaultCast = true
			elseif v.config.sbType == "mirror" then
				disableDefaultMirror = true
			end
		end
	end


	if disableDefaultCast then
		CastingBarFrame:UnregisterAllEvents()
		CastingBarFrame:SetParent(Neuron.hiddenFrame)
	end

	if disableDefaultMirror then
		UIParent:UnregisterEvent("MIRROR_TIMER_START")
		MirrorTimer1:UnregisterAllEvents()
		MirrorTimer1:SetParent(Neuron.hiddenFrame)
		MirrorTimer2:UnregisterAllEvents()
		MirrorTimer2:SetParent(Neuron.hiddenFrame)
		MirrorTimer3:UnregisterAllEvents()
		MirrorTimer3:SetParent(Neuron.hiddenFrame)
	end

end