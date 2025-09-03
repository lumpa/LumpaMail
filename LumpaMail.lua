-- =========================
-- Config: Target characters
-- =========================
local Targets = {
    Bank = "Lbank",
    Leather = "Lskin",
    Mining  = "Lmine",
    Herbs   = "Lherb",
    Enchanting = "Lench",
    Cooking = "Lcook",
    Tailoring = "Lcloth",
}

-- =========================
-- Item IDs per category
-- =========================
local ItemLists = {
    Bank = {
        [7070]=true,[4481]=true,[4479]=true,[4480]=true,[7069]=true,[2738]=true,[2725]=true,[2748]=true,[2744]=true,[2740]=true,[2742]=true,[2751]=true,[2732]=true,[2734]=true,[2728]=true,[2735]=true,
    },
    Leather = {
        [2318]=true,[2319]=true,[4234]=true,[4304]=true,[8170]=true,[2934]=true,[4232]=true,[4235]=true,[8169]=true,[8171]=true,[4461]=true,[8150]=true,[8152]=true,[5637]=true,
    },
    Mining = {
        [2770]=true,[2771]=true,[2772]=true,[2775]=true,[2776]=true,[3858]=true,[10620]=true,[11370]=true,[2835]=true,[2836]=true,[7912]=true,[12365]=true,[2838]=true,[2840]=true,[2841]=true,[2842]=true,[2843]=true,[3575]=true,[3860]=true,[12359]=true,[11371]=true,[774]=true,[818]=true,[1210]=true,[1705]=true,[7909]=true,[12361]=true,[12364]=true,[3857]=true,[3577]=true,
    },
    Herbs = {
        [785]=true,[2447]=true,[2449]=true,[2450]=true,[2452]=true,[2453]=true,[3355]=true,[3356]=true,[3818]=true,[3819]=true,[3820]=true,[4625]=true,[8831]=true,[8836]=true,[13464]=true,[13465]=true,[13463]=true,[3357]=true,[3821]=true,[3358]=true,[3369]=true,[8838]=true,[8153]=true,
    },
    Enchanting = {
        [16202]=true,[16204]=true,[16207]=true,[11137]=true,[11135]=true,[11139]=true,[11138]=true,[14343]=true,[16203]=true,[16208]=true,
    },
    Cooking = {
        [2677]=true,[4604]=true,[5470]=true,[5465]=true,[2765]=true,[3173]=true,[3712]=true,[2678]=true,[3685]=true,[12184]=true,[7974]=true,
    },
    Tailoring = {
        [4306]=true,[4338]=true,[14048]=true,[2997]=true,[2592]=true,[4340]=true,[4339]=true,[14047]=true,[5500]=true,[13926]=true,[4305]=true
    },
}

-- =========================
-- Internal state
-- =========================
local queue = {}
local sending = false
local delay = 0.5
local lastTime = 0
local waitingForAttach = false
local currentItem = nil
local currentTarget = nil
local currentCategory = nil
local sendAllQueue = {}
local bounceQueue = {}
local bouncing = false
local lastBounceTime = 0

-- =========================
-- Frame & messaging
-- =========================
local f = CreateFrame("Frame")
f:RegisterEvent("MAIL_SHOW")
f:RegisterEvent("MAIL_SEND_SUCCESS")

local function msg(text)
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99SendItems:|r "..text)
end

-- =========================
-- Scan a category for items
-- =========================
local function ScanCategory(category)
    if not category then
        msg("Error: No category provided to scan!")
        return false
    end

    local list = ItemLists[category]
    if not list then
        msg("Error: Item list for category "..tostring(category).." not found!")
        return false
    end

    queue = {}
    currentCategory = category
    currentTarget = Targets[category]

    for b=0,4 do
        for s=1,GetContainerNumSlots(b) do
            local link = GetContainerItemLink(b,s)
            if link then
                local itemID = tonumber(string.match(link,"item:(%d+)"))
                if itemID and list[itemID] then
                    table.insert(queue,{bag=b,slot=s,link=link})
                    msg("Queued "..category..": "..link.." (ID="..itemID..")")
                end
            end
        end
    end

    msg("Total "..category.." items queued: "..table.getn(queue))
    return table.getn(queue) > 0
end

-- =========================
-- Send next item in queue
-- =========================
local function SendNext()
    if table.getn(queue) == 0 then
        msg("Done sending "..(currentCategory or "items")..".")
        sending = false

        -- Process next category if sending all
        if table.getn(sendAllQueue) > 0 then
            local nextCat = table.remove(sendAllQueue,1)
            if nextCat then
                local hasItems = ScanCategory(nextCat)
                if hasItems then
                    sending = true
                    SendNext()
                else
                    SendNext() -- skip empty category
                end
            end
        end
        return
    end

    currentItem = table.remove(queue,1)
    if not currentItem then return end
    ClearCursor()
    PickupContainerItem(currentItem.bag,currentItem.slot)
    ClickSendMailItemButton()
    waitingForAttach = true
end

-- =========================
-- OnUpdate for safe mailing & bouncing
-- =========================
f:SetScript("OnUpdate", function()
    local now = GetTime()

    -- Sending items
    if sending and waitingForAttach and currentItem then
        local attachLink = GetSendMailItem(1)
        if attachLink then
            SendMail(currentTarget or "", currentCategory or "", "")
            msg("Sent "..(currentItem.link or "item").." to "..(currentTarget or "Unknown").." ("..(currentCategory or "Unknown")..")")
            waitingForAttach = false
            currentItem = nil
            lastTime = now
        end
    elseif sending and not waitingForAttach then
        if now - lastTime >= delay then
            lastTime = now
            SendNext()
        end
    end

    -- Bouncing mails
    if bouncing and table.getn(bounceQueue) > 0 then
        if now - lastBounceTime >= delay then
            local mailIndex = table.remove(bounceQueue,1)
            ReturnInboxItem(mailIndex)
            msg("Bounced mail #" .. mailIndex)
            lastBounceTime = now
        end
    elseif bouncing and table.getn(bounceQueue) == 0 then
        msg("Finished bouncing mails.")
        bouncing = false
    end
end)

-- =========================
-- Helper to start sending a category
-- =========================
local function StartCategory(category)
    if not MailFrame:IsShown() then
        msg("You must be at a mailbox.")
        return
    end
    local hasItems = ScanCategory(category)
    if hasItems then
        sending = true
        SendNext()
    else
        msg("No "..(category or "items").." found.")
    end
end

-- =========================
-- Slash commands per category
-- =========================
local categories = {"Bank","Leather","Mining","Herbs","Enchanting","Cooking","Tailoring"}

for _,cat in ipairs(categories) do
    local cmdName = "SEND"..cat
    local slashName = "/send"..string.lower(cat)
    local thisCat = cat
    setglobal("SLASH_"..cmdName.."1", slashName)
    SlashCmdList[cmdName] = function()
        StartCategory(thisCat)
    end
end

-- =========================
-- /sendall command
-- =========================
SLASH_SENDALL1 = "/sendall"
SlashCmdList["SENDALL"] = function()
    if not MailFrame:IsShown() then
        msg("You must be at a mailbox.")
        return
    end
    sendAllQueue = {unpack(categories)}
    msg("Sending all categories...")

    local firstCat = table.remove(sendAllQueue,1)
    if firstCat then
        local hasItems = ScanCategory(firstCat)
        if hasItems then
            sending = true
            SendNext()
        else
            sending = true
        end
    end
end

-- =========================
-- /listbags debug command
-- =========================
SLASH_LISTBAGS1 = "/listbags"
SlashCmdList["LISTBAGS"] = function()
    for b=0,4 do
        local numSlots = GetContainerNumSlots(b)
        for s=1,numSlots do
            local link = GetContainerItemLink(b,s)
            if link then
                local itemID = tonumber(string.match(link,"item:(%d+)"))
                local texture, count = GetContainerItemInfo(b,s)
                count = count or 1
                DEFAULT_CHAT_FRAME:AddMessage(
                    "|cff33ff99Bag "..b.." Slot "..s.."|r: "..link.." (ID="..(itemID or "nil")..") x"..count
                )
            end
        end
    end
end



-- Bounce All button
local bounceButton = CreateFrame("Button", "LumpaBounceButton", InboxFrame, "UIPanelButtonTemplate")
bounceButton:SetWidth(80)
bounceButton:SetHeight(22)
bounceButton:SetText("Bounce All")
bounceButton:SetPoint("TOPLEFT", InboxFrame, "TOPLEFT", 60, -40)
bounceButton:SetScript("OnClick", function()
    local numMails = GetInboxNumItems()
    if not numMails or numMails == 0 then return end
    bounceQueue = {}
    for i = numMails, 1, -1 do
        local _, _, _, _, _, _, _, hasItem = GetInboxHeaderInfo(i)
        if hasItem then
            table.insert(bounceQueue, i)
        end
    end
    if table.getn(bounceQueue) == 0 then
        msg("No mails with attachments to bounce.")
        return
    end
    msg("Bouncing "..table.getn(bounceQueue).." mails...")
    bouncing = true
end)

-- Send All button
local sendAllButton = CreateFrame("Button", "LumpaSendAllButton", InboxFrame, "UIPanelButtonTemplate")
sendAllButton:SetWidth(80)
sendAllButton:SetHeight(22)
sendAllButton:SetText("Send All")
sendAllButton:SetPoint("TOPLEFT", bounceButton, "TOPRIGHT", 4, 0)
sendAllButton:SetScript("OnClick", function()
    if not MailFrame:IsShown() then return end
    sendAllQueue = {unpack(categories)}
    local firstCat = table.remove(sendAllQueue, 1)
    if firstCat then
        local hasItems = ScanCategory(firstCat)
        if hasItems then
            sending = true
            SendNext()
        else
            sending = true
        end
    end
end)

-- Open All button
local openAllButton = CreateFrame("Button", "LumpaOpenAllButton", InboxFrame, "UIPanelButtonTemplate")
openAllButton:SetWidth(80)
openAllButton:SetHeight(22)
openAllButton:SetText("Open All")
openAllButton:SetPoint("TOPLEFT", sendAllButton, "TOPRIGHT", 4, 0)
openAllButton:SetScript("OnClick", function()
    local numMails = GetInboxNumItems()
    if not numMails or numMails == 0 then return end
    for i = 1, numMails do
        local _, _, _, _, _, money, COD, hasItem = GetInboxHeaderInfo(i)
        if hasItem or money > 0 then
            TakeInboxItem(i)
            msg("Opened mail #" .. i)
        end
    end
end)

-- Show/hide buttons based on tab
local function UpdateButtons()
    if MailFrameTab1:IsSelected() then -- Inbox tab
        bounceButton:Show()
        sendAllButton:Show()
        openAllButton:Show()
    else
        bounceButton:Hide()
        sendAllButton:Hide()
        openAllButton:Hide()
    end
end



local function HookInboxButtons()
    for i = 1, 50 do
        local buttonName = "MailItem"..i.."Button"
        local button = getglobal(buttonName)  -- Classic-compatible
        if button and not button.lumped then
            local oldClick = button:GetScript("OnClick")
            button:SetScript("OnClick", function(self, buttonClicked)
                if oldClick then oldClick(self, buttonClicked) end

                if buttonClicked == "LeftButton" and IsShiftKeyDown() then
                    local index = self:GetID()
                    local _, _, _, _, _, money, COD, hasItem = GetInboxHeaderInfo(index)
                    if hasItem or (money and money > 0) then
                        TakeInboxItem(index)
                        DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99Shift loot:|r Mail #" .. index)
                    end
                end
            end)
            button.lumped = true
        end
    end
end

-- Call whenever inbox updates
local f = CreateFrame("Frame")
f:SetScript("OnUpdate", function()
    if InboxFrame:IsVisible() then
        HookInboxButtons()
    end
end)
