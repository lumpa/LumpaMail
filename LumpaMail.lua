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
    Engineering = "Lengi",
    Greens = "Lbank",
    Maxprof = "Dairycow",
}

-- =========================
-- Item IDs per category
-- =========================
local ItemLists = {
    Bank = {
        [7070]=true,[4481]=true,[4479]=true,[4480]=true,[7069]=true,[2738]=true,[2725]=true,[2748]=true,[2744]=true,[2740]=true,[2742]=true,[2751]=true,[2732]=true,[2734]=true,[2728]=true,[2735]=true,[2750]=true,[2749]=true,[2730]=true,[8483]=true,[22528]=true,[18944]=true,[7068]=true,[18945]=true,[7078]=true,[22527]=true,[13446]=true,[19262]=true,[22529]=true,[11018]=true,[7077]=true,[7972]=true,[22526]=true,[3928]=true,[11404]=true,[6310]=true,[3404]=true,[5117]=true,[7080]=true,[7079]=true,[19441]=true,[22525]=true,[12808]=true,[12811]=true,[18335]=true,[26039]=true,[8545]=true,[14529]=true,[8544]=true,[14530]=true,[20520]=true,[10513]=true,[10562]=true,[19933]=true,[7082]=true,[7081]=true,[7067]=true,[20404]=true,[7075]=true,[11185]=true,[11186]=true,[11184]=true,[15997]=true,[8151]=true,[20408]=true,[20406]=true,[20407]=true,[12360]=true,[17413]=true,[13489]=true,[12704]=true,[12697]=true,[11737]=true,[6149]=true,[15743]=true,[12683]=true,[18600]=true,[15775]=true,[14466]=true,[12804]=true,[19264]=true,[8390]=true,[13490]=true,[15749]=true,[14498]=true,[12695]=true,[19233]=true,[19234]=true,[17683]=true,[12691]=true,[12838]=true,[12713]=true,[15757]=true,[8146]=true,[12803]=true,[17414]=true,[19265]=true,[14478]=true,[3827]=true,[16051]=true,[16247]=true,[2745]=true,[7072]=true,[4096]=true,[12202]=true,[4611]=true,[5785]=true,[1710]=true,[9719]=true,[7191]=true,[9260]=true,[4589]=true,[9259]=true,
    },
    Leather = {
        [2318]=true,[2319]=true,[4234]=true,[4304]=true,[8170]=true,[2934]=true,[4232]=true,[4235]=true,[8169]=true,[8171]=true,[4461]=true,[8150]=true,[8152]=true,[5637]=true,[4304]=true,[8154]=true,[8172]=true,[4236]=true,[15408]=true,[8368]=true,[15417]=true,[15419]=true,[15416]=true,[8165]=true,[15422]=true,[15415]=true,[15423]=true,[20501]=true,[20500]=true,[20498]=true,[15409]=true,[12810]=true,[783]=true,[15412]=true,[12607]=true,[4231]=true,[7428]=true,[8167]=true,
    },
    Mining = {
        [2770]=true,[2771]=true,[2772]=true,[2775]=true,[2776]=true,[3858]=true,[10620]=true,[11370]=true,[2835]=true,[2836]=true,[7912]=true,[12365]=true,[2838]=true,[2840]=true,[2841]=true,[2842]=true,[2843]=true,[3575]=true,[3860]=true,[12359]=true,[11371]=true,[774]=true,[818]=true,[1210]=true,[1705]=true,[7909]=true,[12361]=true,[12364]=true,[3857]=true,[3577]=true,[3864]=true,[7911]=true,[7910]=true,[12799]=true,[3859]=true,[7966]=true,[3486]=true,[6037]=true,[1529]=true,[1206]=true,[11370]=true,[9262]=true,[11754]=true,[12800]=true,[12363]=true,[3478]=true,[3470]=true,[3576]=true,
    },
    Herbs = {
        [785]=true,[2447]=true,[2449]=true,[2450]=true,[2452]=true,[2453]=true,[3355]=true,[3356]=true,[3818]=true,[3819]=true,[3820]=true,[4625]=true,[8831]=true,[8836]=true,[13464]=true,[13465]=true,[13463]=true,[3357]=true,[3821]=true,[3358]=true,[3369]=true,[8838]=true,[8153]=true,[8846]=true,[765]=true,[8839]=true,[10286]=true,[13466]=true,[13467]=true,[13468]=true,[8845]=true,
    },
    Enchanting = {
        [16202]=true,[16204]=true,[16207]=true,[11137]=true,[11135]=true,[11139]=true,[11138]=true,[14343]=true,[16203]=true,[14344]=true,[11176]=true,[15994]=true,[10998]=true,[11082]=true,[10940]=true,[10978]=true,[10939]=true,[10938]=true,[11134]=true,[11174]=true,[11177]=true,[11083]=true,[11175]=true,[11178]=true,[20725]=true,[11084]=true,
    },
    Cooking = {
        [2677]=true,[4604]=true,[5470]=true,[5465]=true,[2765]=true,[3173]=true,[3712]=true,[2678]=true,[3685]=true,[12184]=true,[7974]=true,[12206]=true,[12037]=true,[12208]=true,[12203]=true,[12205]=true,[12037]=true,[4603]=true,[6361]=true,[4594]=true,[8364]=true,[6308]=true,[8365]=true,[21071]=true,[6289]=true,[13759]=true,[13760]=true,[13757]=true,[6359]=true,[12037]=true,[12205]=true,[20424]=true,[5469]=true,[6370]=true,[6358]=true,[6291]=true,[12207]=true,
    },
    Tailoring = {
        [4306]=true,[4338]=true,[14048]=true,[2997]=true,[2592]=true,[4340]=true,[4339]=true,[14047]=true,[5500]=true,[13926]=true,[4305]=true,[5498]=true,[2589]=true,[4337]=true,[14227]=true,[10285]=true,[14227]=true,[4337]=true,[10285]=true,[2996]=true,[7971]=true,[3182]=true,
    },
    Engineering = {
        [4371]=true,[4361]=true,[4359]=true,[4375]=true,[4382]=true,[4357]=true,[10558]=true,[4363]=true,[4364]=true,[4387]=true,[4389]=true,[10559]=true,[10505]=true,[4404]=true,[4377]=true,[10561]=true,[10560]=true,[15994]=true,[15992]=true,
    },
    Greens = {},
    Maxprof = {},
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
-- list of professions to scan for in tooltips
-- =========================
local ProfessionKeywords = {
    "blacksmithing",
    "tailoring",
    "alchemy",
    "herbalism",
    "mining",
    "skinning",
    "leatherworking",
    "engineering",
    "enchanting",
    "cooking",
    "first aid",
    "fishing",
}

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

    queue = {}
    currentCategory = category
    currentTarget = Targets[category]

    for b = 0, 4 do
        for s = 1, GetContainerNumSlots(b) do
            local link = GetContainerItemLink(b, s)
            if link then
                local itemID = tonumber(string.match(link, "item:(%d+)"))

                -- Special handling for Greens category
                if category == "Greens" then
                    GameTooltip:SetOwner(UIParent, "ANCHOR_NONE")
                    GameTooltip:SetBagItem(b, s)

                    local isBoE, isGreen, isKnown = false, false, false
                    for i = 1, GameTooltip:NumLines() do
                        local left = getglobal("GameTooltipTextLeft"..i)
                        if left then
                            local text = left:GetText()
                            if text then
                                if string.find(text, "Binds when equipped") then
                                    isBoE = true
                                end
                                if string.find(text, "|cff1eff00") then -- green rarity
                                    isGreen = true
                                end
                                if string.find(string.lower(text), "already known") then
                                    isKnown = true
                                end
                            end
                        end
                    end
                    GameTooltip:Hide()

                    if (isBoE and isGreen) or isKnown then
                        table.insert(queue, {bag=b, slot=s, link=link})
                        msg("Queued Greens: "..link.." (ID="..(itemID or "nil")..")")
                    end

                elseif category == "Maxprof" then
                    GameTooltip:SetOwner(UIParent, "ANCHOR_NONE")
                    GameTooltip:SetBagItem(b, s)

                    local teachesYou, requiresProfession = false, false

                    for i = 1, GameTooltip:NumLines() do
                        local left = getglobal("GameTooltipTextLeft"..i)
                        if left then
                            local text = left:GetText()
                            if text then
                                local lower = string.lower(text)

                                -- check if it's a recipe/pattern
                                if string.find(lower, "teaches you") then
                                    teachesYou = true
                                end

                                -- check for profession requirement
                                if string.find(lower, "requires") then
                                    for _, prof in ipairs(ProfessionKeywords) do
                                        if string.find(lower, prof) then
                                            requiresProfession = true
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                    GameTooltip:Hide()

                    -- must match BOTH
                    if teachesYou and requiresProfession then
                        table.insert(queue, {bag=b, slot=s, link=link})
                        msg("Queued MaxProf recipe: "..link.." (ID="..(itemID or "nil")..")")
                    end


                else
                    -- Normal category lookup
                    local list = ItemLists[category]
                    if list and itemID and list[itemID] then
                        table.insert(queue, {bag=b, slot=s, link=link})
                        msg("Queued "..category..": "..link.." (ID="..itemID..")")
                    end
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
local categories = {"Bank","Leather","Mining","Herbs","Enchanting","Cooking","Tailoring","Engineering","Greens","Maxprof"}

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
            --msg("Opened mail #" .. i)
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



-- =========================
-- /clearqueue command
-- =========================
SLASH_CLEARQUEUE1 = "/clearqueue"
SlashCmdList["CLEARQUEUE"] = function()
    queue = {}
    sending = false
    waitingForAttach = false
    currentItem = nil
    currentCategory = nil
    currentTarget = nil
    sendAllQueue = {}
    msg("Queue cleared. All pending sends canceled.")
end