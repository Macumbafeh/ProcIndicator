-- ProcIndicator (TBC)

for i=1,5 do
	local frame = CreateFrame("Frame", "ProcIndicatorFrame"..i, UIParent)
	frame:SetPoint("CENTER")
	frame:SetWidth(36)
	frame:SetHeight(36)
	if i > 1 then
		frame:SetPoint("TOPLEFT", ProcIndicatorFrame1, (i-1)*46, 0)
	end
	frame:SetClampedToScreen(true)
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function() ProcIndicatorFrame1:StartMoving() end)
	frame:SetScript("OnDragStop", function() ProcIndicatorFrame1:StopMovingOrSizing() end)
	
	local background = frame:CreateTexture("ProcIndicatorBackground"..i, "BACKGROUND")
	background:SetAllPoints()
	background:SetTexture(0, 0, 0, 0.3)
	background:SetWidth(36)
	background:SetHeight(36)
	
	local texture = frame:CreateTexture("ProcIndicatorTexture"..i)
	texture:SetAllPoints()
	texture:SetWidth(36)
	texture:SetHeight(36)
	texture:SetTexCoord(0.06, 0.94, 0.06, 0.94)
	
	local font = frame:CreateFontString("ProcIndicatorFont"..i, "ARTWORK", "GameFontNormal")
	font:SetPoint("TOPRIGHT", 4, -38)
	font:SetPoint("BOTTOMLEFT", -5, -18)
	font:SetJustifyH("CENTER")
	font:SetFont("Fonts\\FRIZQT__.TTF", 16)
	font:SetTextColor(1, 0, 0)
end

SLASH_PROCINDICATOR1 = "/proc"
SlashCmdList["PROCINDICATOR"] = function(msg)
	if tonumber(msg) ~= nil and tonumber(msg) <= 5 then
		local procNumber = tonumber(msg)
		savedProcIndicatorSettings[1] = procNumber -- number of buffs displayed
		for i=1,5 do
			if i > procNumber then
				_G["ProcIndicatorFrame"..i]:Hide()
			else
				_G["ProcIndicatorFrame"..i]:Show()
			end
		end
	elseif msg == "add" then
		local procToModify = ""
		local savedProc = savedProcIndicatorSettings
		StaticPopupDialogs["PROCINDICATOR_NAME"] = {
			text = "",
			button1 = "Accept",
			button3 = "Remove",
			button2 = "Cancel",
			OnShow = function()
				StaticPopup1Text:SetText("Proc "..procToModify.." ("..(savedProc[10+procToModify] or "None").."): Enter the new proc name")
				StaticPopup1EditBox:SetText("")
			end,
			OnAccept = function()
				if StaticPopup1EditBox:GetText() ~= "" then
					savedProc[10+procToModify] = StaticPopup1EditBox:GetText()
					DEFAULT_CHAT_FRAME:AddMessage("|cfff0e68c[ProcIndicator]: "..savedProc[10+procToModify].." added as proc number "..procToModify..".")
				end
			end,
			OnAlt = function()
				savedProc[10+procToModify] = nil
				DEFAULT_CHAT_FRAME:AddMessage("|cfff0e68c[ProcIndicator]: Proc number "..procToModify.." removed.")
			end,
			EditBoxOnEnterPressed = function()
				if StaticPopup1EditBox:GetText() ~= "" then
					savedProc[10+procToModify] = StaticPopup1EditBox:GetText()
					DEFAULT_CHAT_FRAME:AddMessage("|cfff0e68c[ProcIndicator]: "..savedProc[10+procToModify].." added as proc number "..procToModify..".")
					StaticPopup_Hide("PROCINDICATOR_NAME")
				end
			end,
			EditBoxOnEscapePressed = function()
				StaticPopup_Hide("PROCINDICATOR_NAME")
			end,
			cancels = "PROCINDICATOR_NUMBER",
			exclusive = 1,
			hasEditBox = 1,
			maxLetters = 0,
			timeout = 0,
			whileDead = 1,
		}
		StaticPopupDialogs["PROCINDICATOR_NUMBER"] = {
			text = "",
			button1 = "Next",
			button2 = "Cancel",
			OnShow = function()
				StaticPopup1Text:SetText("Which proc do you want to modify?\n Proc 1: "..(savedProc[11] or "(None)").."\n Proc 2: "..(savedProc[12] or "(None)").."\n Proc 3: "..(savedProc[13] or "(None)").."\n Proc 4: "..(savedProc[14] or "(None)").."\n Proc 5: "..(savedProc[15] or "(None)"))
				StaticPopup1EditBox:SetText("")
			end,
			OnAccept = function()
				if tonumber(StaticPopup1EditBox:GetText()) ~= nil and tonumber(StaticPopup1EditBox:GetText()) > 0 and tonumber(StaticPopup1EditBox:GetText()) < 6 then
					procToModify = StaticPopup1EditBox:GetText()
					StaticPopup_Show("PROCINDICATOR_NAME")
				end
			end,
			EditBoxOnEnterPressed = function()
				if tonumber(StaticPopup1EditBox:GetText()) ~= nil and tonumber(StaticPopup1EditBox:GetText()) > 0 and tonumber(StaticPopup1EditBox:GetText()) < 6 then
					procToModify = StaticPopup1EditBox:GetText()
					StaticPopup_Show("PROCINDICATOR_NAME")
				end
			end,
			EditBoxOnEscapePressed = function()
				StaticPopup_Hide("PROCINDICATOR_NUMBER")
			end,
			exclusive = 1,
			hasEditBox = 1,
			maxLetters = 1,
			timeout = 0,
			whileDead = 1,
		}
		StaticPopup_Show ("PROCINDICATOR_NUMBER")
	elseif strfind(msg, "scale %d") then
		local _, _, procScale = strfind(msg, "scale (.+)")
		savedProcIndicatorSettings[2] = procScale -- addon's scale
		for i=1,5 do
			_G["ProcIndicatorFrame"..i]:SetScale(tonumber(procScale))
		end	
	elseif msg == "lock" then
		savedProcIndicatorSettings[3] = 1 -- locked
		for i=1,5 do
			_G["ProcIndicatorBackground"..i]:Hide()
			_G["ProcIndicatorFrame"..i]:EnableMouse(false)
		end
	elseif msg == "unlock" then
		savedProcIndicatorSettings[3] = 0 -- unlocked
		for i=1,5 do
			_G["ProcIndicatorBackground"..i]:Show()
			_G["ProcIndicatorFrame"..i]:EnableMouse(true)
		end
	elseif msg == "reset" then
		savedProcIndicatorSettings[1] = 5 -- 5 buffs displayed
		savedProcIndicatorSettings[2] = 1 -- scale x1
		savedProcIndicatorSettings[3] = 0 -- unlocked
		for i=1,5 do
			_G["ProcIndicatorFrame"..i]:Show()
			_G["ProcIndicatorFrame"..i]:SetScale(1)
			_G["ProcIndicatorBackground"..i]:Show()
			_G["ProcIndicatorFrame"..i]:EnableMouse(true)
			if i == 5 then
				ProcIndicatorFrame1:SetPoint("CENTER")
			end
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage("|cfff0e68c[ProcIndicator]: Available commands\n |cfff0e68c/proc 0-5|r - modifies the number of buffs to display (up to 5)\n |cfff0e68c/proc add|r - prompts a menu to add/remove procs\n |cfff0e68c/proc scale x|r - adapts addon's scale to x (0.8 - 1.2 recommended)\n |cfff0e68c/proc lock|r - locks frame position and hides background\n |cfff0e68c/proc unlock|r - unlocks frame position and shows background\n |cfff0e68c/proc reset|r - resets frame position and scale")
	end
end

local ProcIndicatorEventFrame = CreateFrame("Frame")
ProcIndicatorEventFrame:RegisterEvent("ADDON_LOADED")
ProcIndicatorEventFrame:RegisterEvent("PLAYER_LOGIN")
ProcIndicatorEventFrame:SetScript("OnEvent", function(self, event, arg1, ...)
	if (event == "ADDON_LOADED" and arg1 == "ProcIndicator") or event == "PLAYER_LOGIN" then
		ProcIndicatorEventFrame:UnregisterEvent("ADDON_LOADED")
		ProcIndicatorEventFrame:UnregisterEvent("PLAYER_LOGIN")
		if not savedProcIndicatorSettings then
			savedProcIndicatorSettings = {}
			savedProcIndicatorSettings[1] = 5 -- 5 buffs displayed
			savedProcIndicatorSettings[2] = 1 -- scale x1
			savedProcIndicatorSettings[3] = 0 -- unlocked
		else
			local procNumber = savedProcIndicatorSettings[1]
			for i=1,5 do
				if i > procNumber then
					_G["ProcIndicatorFrame"..i]:Hide()
				else
					_G["ProcIndicatorFrame"..i]:Show()
				end
				_G["ProcIndicatorFrame"..i]:SetScale(tonumber(savedProcIndicatorSettings[2]))
				if savedProcIndicatorSettings[3] == 1 then
					_G["ProcIndicatorBackground"..i]:Hide()
					_G["ProcIndicatorFrame"..i]:EnableMouse(false)
				end
			end
		end
	end
end)

local procCheck = {}
local ProcIndicatorUpdateFrame = CreateFrame("Frame")
ProcIndicatorUpdateFrame:SetScript("OnUpdate", function(self, elapsed)
	for k=1,5 do -- loop to reset the check value
		procCheck[k] = 0
	end
	for i=1,40 do -- loop to go through your buffs
		if select(1, UnitBuff("player", i)) ~= nil then
			local spellName, _, spellIcon, _, _, spellDur = UnitBuff("player", i)
			for k=1,5 do
				if spellName == savedProcIndicatorSettings[10+k] and _G["ProcIndicatorFrame"..k]:IsShown() and spellDur ~= nil then
					_G["ProcIndicatorTexture"..k]:SetTexture(spellIcon)
					_G["ProcIndicatorTexture"..k]:Show()
					if spellDur < 60 then
						_G["ProcIndicatorFont"..k]:SetText(spellDur - spellDur % 0.1)
					end
					procCheck[k] = 1
				end
			end
		else -- once all the buffs are checked, verifies if some buffs are still displayed but not found
			for k=1,5 do
				if procCheck[k] == 0 and _G["ProcIndicatorTexture"..k]:IsShown() then
					_G["ProcIndicatorTexture"..k]:Hide()
					_G["ProcIndicatorFont"..k]:SetText("")
				end
			end
			break
		end
	end
end)