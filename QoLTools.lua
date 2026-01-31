-- QoLTools: Open Wowhead item pages from in-game
-- Usage: /qolt [item link] or Alt-Click any item/achievement/quest

local addonName = "QoLTools"
local debugMode = false -- Toggle for debug messages
local lastTriggerTime = 0
local debounceDelay = 0.2

-- Popup frame
local copyFrame = CreateFrame("Frame", "QoLToolsCopyFrame", UIParent, "PortraitFrameTemplate")
copyFrame:SetSize(500, 200)
copyFrame:SetPoint("CENTER")
copyFrame:Hide()
copyFrame:SetMovable(true)
copyFrame:EnableMouse(true)
copyFrame:RegisterForDrag("LeftButton")
copyFrame:SetScript("OnDragStart", copyFrame.StartMoving)
copyFrame:SetScript("OnDragStop", copyFrame.StopMovingOrSizing)
tinsert(UISpecialFrames, "QoLToolsCopyFrame")

if copyFrame.TitleText then
    copyFrame.TitleText:SetText("QoL Tools - Wowhead Lookup")
elseif copyFrame.TitleContainer and copyFrame.TitleContainer.TitleText then
    copyFrame.TitleContainer.TitleText:SetText("QoL Tools - Wowhead Lookup")
else
    local title = copyFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOP", 0, -5)
    title:SetText("QoL Tools - Wowhead Lookup")
end

function copyFrame:SetPortraitIcon(iconPath)
    if self.portrait then self.portrait:SetTexture(iconPath)
    elseif self.Portrait then self.Portrait:SetTexture(iconPath)
    elseif self.PortraitContainer and self.PortraitContainer.portrait then
        self.PortraitContainer.portrait:SetTexture(iconPath)
    end
end
copyFrame:SetPortraitIcon("Interface\\Icons\\INV_Misc_Book_09")

local instructions = copyFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
instructions:SetPoint("TOP", 0, -35)
instructions:SetText("Press |cFFFFD700Ctrl+C|r to copy the URL below:")

local urlBox = CreateFrame("EditBox", nil, copyFrame, "InputBoxTemplate")
urlBox:SetSize(450, 30)
urlBox:SetPoint("TOP", instructions, "BOTTOM", 0, -10)
urlBox:SetAutoFocus(true)
urlBox:SetScript("OnEscapePressed", function() copyFrame:Hide() end)
urlBox:SetScript("OnEnterPressed", function(self) copyFrame:Hide() end)
urlBox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
urlBox:SetScript("OnMouseDown", function(self) self:HighlightText() end)
urlBox:SetScript("OnTextChanged", function(self) self:HighlightText() end)

urlBox:SetScript("OnKeyDown", function(self, key)
    if key == "C" and IsControlKeyDown() then
        C_Timer.After(0.1, function() copyFrame:Hide() end)
    end
end)

local helpText = copyFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
helpText:SetPoint("TOP", urlBox, "BOTTOM", 0, -10)
helpText:SetTextColor(0.7, 0.7, 0.7)
helpText:SetText("After copying, your browser will open automatically.\nPaste the URL (Ctrl+V) to view on Wowhead.")

local commentsButton = CreateFrame("Button", nil, copyFrame, "UIPanelButtonTemplate")
commentsButton:SetSize(100, 25)
commentsButton:SetPoint("BOTTOM", 0, 20)
commentsButton:SetText("Comments")
local baseUrl = ""
commentsButton:SetScript("OnClick", function()
    local currentUrl = urlBox:GetText()
    if currentUrl:find("#comments$") then
        urlBox:SetText(baseUrl)
    else
        baseUrl = currentUrl
        urlBox:SetText(currentUrl .. "#comments")
    end
    urlBox:HighlightText()
end)

if copyFrame.CloseButton then
    copyFrame.CloseButton:SetScript("OnClick", function() copyFrame:Hide() end)
end

-- URL from link
local function CreateWowheadURLFromLink(link)
    if not link then return nil end
    if link:match("|Hitem:") then
        local id = link:match("item:(%d+)")
        if id then return "https://www.wowhead.com/item=" .. id end
    end
    if link:match("|Hachievement:") then
        local id = link:match("achievement:(%d+)")
        if id then return "https://www.wowhead.com/achievement=" .. id end
    end
    if link:match("|Hquest:") then
        local id = link:match("quest:(%d+)")
        if id then return "https://www.wowhead.com/quest=" .. id end
    end
    return nil
end

-- Show popup with debounce
local function ShowPopupWithDebounce(url, name, icon, debugMsg)
    local currentTime = GetTime()
    if currentTime - lastTriggerTime < debounceDelay then return end
    lastTriggerTime = currentTime
    baseUrl = url
    copyFrame:SetPortraitIcon(icon)
    urlBox:SetText(url)
    urlBox:SetFocus()
    urlBox:HighlightText()
    copyFrame:Show()
    if debugMode and debugMsg then
        print("|cff00ff00" .. addonName .. ":|r " .. debugMsg)
    end
end

-- Slash command
local function SlashCommandHandler(msg)
    msg = strtrim(msg or "")
    if msg == "debug" then
        debugMode = not debugMode
        print("|cff00ff00" .. addonName .. ":|r Debug mode " .. (debugMode and "enabled" or "disabled"))
        return
    end
    if msg == "" or msg == "help" then
        print("|cff00ff00" .. addonName .. ":|r Usage: /qolt [item link]")
        print("Alt-Click items, quests, achievements in UI/tracker/chat")
        print("/qolt debug to toggle prints")
        return
    end
    local url = CreateWowheadURLFromLink(msg)
    if url then
        local name = msg:match("|h%[(.-)%]|h") or "item"
        local icon = "Interface\\Icons\\INV_Misc_Book_09"
        local itemID = msg:match("item:(%d+)")
        if itemID then icon = C_Item.GetItemIconByID(itemID) or icon end
        ShowPopupWithDebounce(url, name, icon, "Wowhead URL ready for: " .. name)
    else
        print("|cffff0000" .. addonName .. ":|r Please provide a valid link")
    end
end

SLASH_QOLTOOLS1 = "/qolt"
SLASH_QOLTOOLS2 = "/wh"
SLASH_QOLTOOLS3 = "/wowhead"
SlashCmdList["QOLTOOLS"] = SlashCommandHandler

-- Chat / tooltip links
hooksecurefunc("HandleModifiedItemClick", function(link)
    if not IsAltKeyDown() or IsShiftKeyDown() or IsControlKeyDown() then return end
    local url = CreateWowheadURLFromLink(link)
    if url then
        local name = link:match("|h%[(.-)%]|h") or "link"
        local icon = "Interface\\Icons\\INV_Misc_Book_09"
        if link:match("|Hitem:") then
            local id = link:match("item:(%d+)")
            if id then icon = C_Item.GetItemIconByID(id) or icon end
        elseif link:match("|Hachievement:") then
            local id = link:match("achievement:(%d+)")
            if id then
                local _,_,_,_,_,_,_,_,_,tex = GetAchievementInfo(id)
                icon = tex or icon
            end
        elseif link:match("|Hquest:") then
            icon = "Interface\\QuestFrame\\UI-QuestLog-BookIcon"
        end
        ShowPopupWithDebounce(url, name, icon, "Wowhead URL for: " .. name)
    end
end)

-- Quest log
local function HookQuestLog()
    hooksecurefunc("QuestMapLogTitleButton_OnClick", function(self)
        if not IsAltKeyDown() or IsShiftKeyDown() or IsControlKeyDown() then return end
        local questID = self.questID
        if questID then
            local url = "https://www.wowhead.com/quest=" .. questID
            local title = C_QuestLog.GetTitleForQuestID(questID) or "Quest"
            ShowPopupWithDebounce(url, title, "Interface\\QuestFrame\\UI-QuestLog-BookIcon", "Wowhead URL for: " .. title)
        end
    end)
end

-- Achievement frame
local function HookAchievements()
    if not AchievementTemplateMixin then return end
    hooksecurefunc(AchievementTemplateMixin, "OnClick", function(self)
        if not IsAltKeyDown() or IsShiftKeyDown() or IsControlKeyDown() then return end
        local achievementID = self.id or self:GetID()
        if achievementID and achievementID > 0 then
            local _, name, _, _, _, _, _, _, _, icon = GetAchievementInfo(achievementID)
            local url = "https://www.wowhead.com/achievement=" .. achievementID
            ShowPopupWithDebounce(url, name or "Achievement", icon or "Interface\\Icons\\Achievement_General", "Wowhead URL for: " .. (name or "Achievement"))
        end
    end)
end

-- Objective tracker quests (regular + many world quests)
local function HookObjectiveTrackerQuests()
    if C_QuestLog and C_QuestLog.SetSelectedQuest then
        hooksecurefunc(C_QuestLog, "SetSelectedQuest", function(questID)
            if not IsAltKeyDown() or IsShiftKeyDown() or IsControlKeyDown() then return end
            if questID then
                local url = "https://www.wowhead.com/quest=" .. questID
                local title = C_QuestLog.GetTitleForQuestID(questID) or "Quest"
                ShowPopupWithDebounce(url, title, "Interface\\QuestFrame\\UI-QuestLog-BookIcon", "Wowhead URL for: " .. title)
            end
        end)
    end
    if QuestMapFrame_OpenToQuestDetails then
        hooksecurefunc("QuestMapFrame_OpenToQuestDetails", function(questID)
            if not IsAltKeyDown() or IsShiftKeyDown() or IsControlKeyDown() then return end
            if questID then
                local url = "https://www.wowhead.com/quest=" .. questID
                local title = C_QuestLog.GetTitleForQuestID(questID) or "Quest"
                ShowPopupWithDebounce(url, title, "Interface\\QuestFrame\\UI-QuestLog-BookIcon", "Wowhead URL for: " .. title)
            end
        end)
    end
end

-- Tracked achievements in objective tracker
local function HookObjectiveTrackerAchievements()
    pcall(function()
        hooksecurefunc("AchievementFrame_SelectAchievement", function(achievementID)
            if not IsAltKeyDown() or IsShiftKeyDown() or IsControlKeyDown() then return end
            if achievementID then
                local _, name, _, _, _, _, _, _, _, icon = GetAchievementInfo(achievementID)
                local url = "https://www.wowhead.com/achievement=" .. achievementID
                ShowPopupWithDebounce(url, name or "Achievement", icon or "Interface\\Icons\\Achievement_General", "Wowhead URL for: " .. (name or "Achievement"))
            end
        end)
    end)
end

-- Load handler
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, loadedAddon)
    if loadedAddon == addonName then
        print("|cff00ff00" .. addonName .. " loaded!|r Type /qolt help")
        HookQuestLog()
        HookAchievements()
        HookObjectiveTrackerQuests()
        HookObjectiveTrackerAchievements()
    end
    if loadedAddon == "Blizzard_AchievementUI" then
        HookAchievements()
        HookObjectiveTrackerAchievements()
    end
    if loadedAddon == "Blizzard_ObjectiveTracker" then
        HookObjectiveTrackerQuests()
    end
end)