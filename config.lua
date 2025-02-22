local MenuName = 'RBLXHAX'
local Modules = {
	['UtilAimbotEnable'] = false,
	['GamesBPBulletTP'] = false,
	['GamesWBType'] = false,
}

-- Linoria Lib
local repo = 'https://raw.githubusercontent.com/merrittlj/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()

local Window = Library:CreateWindow({
    Title = MenuName .. ' by irobloxianlover',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0
})

-- CALLBACK NOTE:
-- Passing in callback functions via the initial element parameters (i.e. Callback = function(Value)...) works
-- HOWEVER, using Toggles/Options.INDEX:OnChanged(function(Value) ... ) is the RECOMMENDED way to do this.
-- I strongly recommend decoupling UI code from logic code. i.e. Create your UI elements FIRST, and THEN setup :OnChanged functions later.

local Tabs = {
    -- Creates a new tab titled Main
    Main = Window:AddTab('Main'),
    Util = Window:AddTab('Util'),
    Games = Window:AddTab('Games')
}

local MainMenuGroupBox = Tabs.Main:AddLeftGroupbox('Menu')

MainMenuGroupBox:AddButton('Unload', function() Library:Unload() end)
MainMenuGroupBox:AddLabel('Unload bind'):AddKeyPicker('MainUnload', {
    Default = 'F3',

    Text = 'Unload the menu',
    NoUI = true,
    Callback = function() Library:Unload() end
})

MainMenuGroupBox:AddLabel('Menu bind'):AddKeyPicker('MainMenu', { Default = 'F1', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MainMenu -- Allows you to have a custom keybind for the menu


local MainScriptsGroupBox = Tabs.Main:AddLeftGroupbox('Scripts')
MainScriptsGroupBox:AddButton('Dex Explorer', function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end)


local UtilAimbotGroupBox = Tabs.Util:AddLeftGroupbox('Aimbot')

UtilAimbotGroupBox:AddToggle('UtilAimbotEnable', {
    Text = 'Enable module',
    Default = false,
    Tooltip = 'Enable module',
    Callback = function(v) Modules["UtilAimbotEnable"] = v end
})

UtilAimbotGroupBox:AddLabel('Lock on bind'):AddKeyPicker('UtilAimbotLock', {
    Default = 'LeftShift',
    SyncToggleState = false,

    Mode = 'Hold',

    Text = 'Lock onto player',
    NoUI = false,
})

UtilAimbotGroupBox:AddInput('UtilAimbotWait', {
    Default = '1',
    Numeric = true, -- true / false, only allows numbers
    Finished = false, -- true / false, only calls callback when you press enter

    Text = 'Lock wait',
    Tooltip = 'Time (ms) between locking', 
    Placeholder = '1',
    -- MaxLength is also an option which is the max length of the text
})



local GamesBPGroupbox = Tabs.Games:AddLeftGroupbox('Big Paintball')

GamesBPGroupbox:AddToggle('GamesBPBulletTP', {
    Text = 'Enable bullet TP',
    Default = false,
    Tooltip = 'Teleports bullets inside of enemies, good kill all',
    Callback = function(v) Modules["GamesBPBulletTP"] = v end
})

GamesBPGroupbox:AddLabel('Bullet TP bind'):AddKeyPicker('GamesBPBulletActivate', {
    Default = 'LeftShift',
    SyncToggleState = false,

    Mode = 'Hold',

    Text = 'Activate bullet TP',
    NoUI = false,
})

GamesBPGroupbox:AddLabel('Shooting bind'):AddKeyPicker('GamesBPShooting', {
    Default = 'MB1',
    SyncToggleState = false,

    Mode = 'Hold',

    Text = 'If shooting, DO NOT CHANGE',
    NoUI = true,
})


local GamesWBGroupbox = Tabs.Games:AddLeftGroupbox('Word Bomb')

GamesWBGroupbox:AddToggle('GamesWBType', {
    Text = 'Enable typing',
    Default = false,
    Tooltip = 'Searches for best word and types automatically',
    Callback = function(v) Modules["GamesWBType"] = v end
})

GamesWBGroupbox:AddLabel('Type word bind'):AddKeyPicker('GamesWBActivate', {
    Default = 'LeftControl',
    SyncToggleState = false,

    Mode = 'Press',

    Text = 'Search and type the best word',
    NoUI = false,

    Callback = function(v) WordBombActivate() end
})

GamesWBGroupbox:AddLabel('Clear used bind'):AddKeyPicker('GamesWBClear', {
    Default = 'RightAlt',
    SyncToggleState = false,

    Mode = 'Press',

    Text = 'Clears the already used list of words',
    NoUI = false,

    Callback = function(v) WordBombClear() end
})

GamesWBGroupbox:AddDropdown('GamesWBMethod', {
    Values = { 'Longest', 'Shortest', 'First' },
    Default = 1,
    Multi = false,

    Text = 'Method',
    Tooltip = 'How to sort and choose the best word for typing',
})


-- Library functions
-- Sets the watermark visibility
Library:SetWatermarkVisibility(true)

-- Example of dynamically-updating watermark with common traits (fps and ping)
local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1;

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter;
        FrameTimer = tick();
        FrameCounter = 0;
    end;

    Library:SetWatermark(("[" .. MenuName .. "] " .. ' %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

Library.KeybindFrame.Visible = true;

Library:OnUnload(function()
    WatermarkConnection:Disconnect()

    print('Unloaded!')
    Library.Unloaded = true
end)



function ApplyTheme()
	local data = '{"FontColor":"ffffff","MainColor":"0a0a0a","AccentColor":"ee0000","BackgroundColor":"000000","OutlineColor":"323232"}'
	local scheme = game:GetService('HttpService'):JSONDecode(data)
	for idx, col in next, scheme do
		Library[idx] = Color3.fromHex(col)
		
		if Options[idx] then
			Options[idx]:SetValueRGB(Color3.fromHex(col))
		end
	end

	ThemeUpdate()
end

function ThemeUpdate()
	-- This allows us to force apply themes without loading the themes tab :)
	local options = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }
	for i, field in next, options do
		if Options and Options[field] then
			Library[field] = Options[field].Value
		end
	end

	Library.AccentColorDark = Library:GetDarkerColor(Library.AccentColor);
	Library:UpdateColorsUsingRegistry()
end

ApplyTheme()




-- ___________________________________________________________________

local plr = game:GetService("Players").LocalPlayer
local char = plr.Character
local mouse = plr:GetMouse()
local camera = game.Workspace.CurrentCamera

-- Aimbot
task.spawn(function()
	local aimbotCharFolder = game:GetService("Workspace")

	local function getTarget()
	    local ray = camera:ScreenPointToRay(mouse.X, mouse.Y)
	    local raycastResult = game.Workspace:Raycast(ray.Origin, ray.Direction * 50000)
	    local mousePos = raycastResult and raycastResult.Position or ray.Origin
	    local closestTarget = nil
	    local closestDistance = math.huge

	    for _, character in pairs(aimbotCharFolder:GetChildren()) do
	        if character:IsA("Model") and character ~= plr.Character then
	            if not valid(character) then continue end
	            -- THIS MUST BE HRP
	            local primaryPart = character.PrimaryPart or character:FindFirstChild("HumanoidRootPart")
	            if primaryPart then
	                local distance = (primaryPart.Position - mousePos).Magnitude
	                if distance < closestDistance then
	                    closestDistance = distance
	                    closestTarget = character
	                end
	            end
	        end
	    end

	    return closestTarget
	end

	local function valid(who)
	    local hum = who:FindFirstChild("Humanoid")
	    print("checking: " .. who.Name)
	    if hum then
	        print(hum.Health)
	    end
	    print(aimbotCharFolder:FindFirstChild(who.Name))
	    return who and hum and hum.Health > 0 and aimbotCharFolder:FindFirstChild(who.Name)
	end

	local function look(who)
	    print("looking at " .. who.Name)

	    local them = who:FindFirstChild("Head")
	    if not them then
	        print("failed head check")
	        return 
	    end

	    camera.CFrame = CFrame.lookAt(camera.CFrame.Position, them.Position)
	end
    while true do
    	task.wait()
        if Options.UtilAimbotLock:GetState() and Modules["UtilAimbotEnable"] then
        	print("aimbot active")
            local target = getTarget()
	        if not target then return end
	        print("found target " .. target.Name)
	        while Options.UtilAimbotLock:GetState() and valid(target) and not Library.Unloaded do
	            look(target)
	            task.wait(tonumber(Options.UtilAimbotWait.Value) / 1000.0)
	        end
	        repeat task.wait() until not Options.UtilAimbotLock:GetState()
        end

        if Library.Unloaded then break end
    end
end)

-- Big Paintball Bullet TP
task.spawn(function()
	local bulletsFolder = game:GetService("Workspace")["__DEBRIS"].Projectiles
	local gunsFolder = game:GetService("Workspace")["__DEBRIS"].Guns
	local roundType = game:GetService("Workspace")["__VARIABLES"].RoundType.Value:lower()

	local function getFirstTarget()
		plrs = game:GetService("Players")
		for _, gun in pairs(gunsFolder:GetChildren()) do
			local target = plrs:FindFirstChild(gun.Name)
			if roundType:match("ffa") and target.UserId ~= plr.UserId then return target end
			if roundType:match("tdm") and target.Team ~= plr.Team then return target end
		end
	end
	local function getClosestPart(table)
	    local root = char:FindFirstChild("HumanoidRootPart")

	    if not root then
	        warn("No HumanoidRootPart found!")
	        return nil
	    end

	    local closestPart = nil
	    local shortestDistance = math.huge

	    for _, part in ipairs(table) do
	        if part:IsA("BasePart") then
	            local distance = (part.Position - root.Position).Magnitude
	            if distance < shortestDistance then
	                shortestDistance = distance
	                closestPart = part
	            end
	        end
    	end

    	return closestPart
	end

    while true do
        task.wait()
        
        if Options.GamesBPBulletActivate:GetState() and Options.GamesBPShooting:GetState() and Modules["GamesBPBulletTP"] then
            print('check and tp bullets')
            local target = getFirstTarget()
            print(target.Name)
            repeat 
            	local validBullets = {}
            	for _, part in pairs(bulletsFolder:GetChildren()) do
	             	if part.Material ~= Enum.Material.ForceField then continue end
	             	if roundType:match("tdm") then
	             		if plr.Team == "Blue" and part.Color == Color3.fromRGB(255, 0, 0) then continue end
	             		if plr.Team == "Red" and part.Color == Color3.fromRGB(0, 0, 255) then continue end
	             	end

	             	part.Anchored = false
	             	part.CFrame = CFrame.new(Vector3.new(0,0,0))
	             	table.insert(validBullets, part)
            	end

            	local closestBullet = getClosestPart(validBullets)
            	print("bullet pos: " .. tostring(closestBullet.Position))
            	print("player pos: " .. tostring(char:FindFirstChild("HumanoidRootPart").Position))

            	-- TP Bullet
            	--closestBullet.Position = target.Character:FindFirstChild("HumanoidRootPart").Position
            	closestBullet.Position = Vector3.new(0,0,0)

            	break
            until not gunsFolder:FindFirstChild(target.Name)
        end

        if Library.Unloaded then break end
    end
end)

alreadyUsed = {}
loadstring(game:HttpGet("https://raw.githubusercontent.com/MarsQQ/Unpatchabomb/master/unpatchabomb_english_words", true))()
-- Word Bomb
function WordBombActivate()
	if not Modules["GamesWBType"] then return end
	local function tableItemExists(array, val)
        for i,v in pairs (array) do 
            if v == val then 
                return true
            end
        end
        return false
    end
    local function findWord (str)
        local found = nil
        for i,v in pairs (ENGLISH_WORDS) do
            if string.find(v, string.lower(str)) and not tableItemExists(alreadyUsed, v) then 
                if found == nil or string.len(v) > string.len(found) then
                    found = v
                end
            end
        end
        return found
    end
    local textbox = plr.PlayerGui.GameUI.Container.GameSpace.DefaultUI
	                            .GameContainer.DesktopContainer.Typebar.Typebox.Text;
    local Letters = "";
    print('---------')
    for i, v in pairs(plr.PlayerGui.GameUI.Container.GameSpace.DefaultUI
                          .GameContainer.DesktopContainer.InfoFrameContainer.InfoFrame.TextFrame:GetChildren()) do
        if (v:IsA('Frame') and v.Visible) then
            Letters = Letters .. v.Letter.TextLabel.Text
        end
    end

    print(Letters)
    local foundWord = findWord(Letters)
    if foundWord == nil then
        foundWord = Letters
    end
    print(foundWord)

    if plr.PlayerGui.GameUI.Container.GameSpace.DefaultUI.GameContainer
        .DesktopContainer.Typebar.Typebox.Text == textbox then
        local t = plr.PlayerGui.GameUI.Container.GameSpace.DefaultUI.GameContainer
        .DesktopContainer.Typebar.Typebox
        for x = 1, #foundWord, 2 do
            t.Text = t.Text .. foundWord:sub(x,x+1)
        end
        wait(0.1)
    else
        for i, v in pairs(plr.PlayerGui.GameUI.Container.GameSpace.DefaultUI
                              .GameContainer.DesktopContainer.InfoFrameContainer.InfoFrame.TextFrame:GetChildren()) do
            if (v:IsA('Frame') and v.Visible) then
                Letters = Letters .. v.Letter.TextLabel.Text
            end
        end
    end
    table.insert(alreadyUsed, foundWord)
    print(alreadyUsed)
end

function WordBombClear()
	if not Modules["GamesWBType"] then return end
	alreadyUsed = {}
end