local MenuName = 'RBLXHAX'
local Modules = {
    ['UtilAimbotEnable'] = false,
    ['UtilFlingEnable'] = false,
    ['GamesMMCooldown'] = false,
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


local UtilFlingGroupBox = Tabs.Util:AddLeftGroupbox('Invisible Fling')

UtilFlingGroupBox:AddToggle('UtilFlingEnable', {
    Text = 'Enable module',
    Default = false,
    Tooltip = 'Enable module',
    Callback = function(v) Modules["UtilFlingEnable"] = v end
})

UtilFlingGroupBox:AddLabel('Start/Stop bind'):AddKeyPicker('UtilFlingSS', {
    Default = 'F',
    SyncToggleState = false,

    Mode = 'Toggle',

    Text = 'Start/Stop Fling',
    NoUI = false,
})

UtilFlingGroupBox:AddLabel('Move forward'):AddKeyPicker('UtilFlingF', {
    Default = 'W',
    SyncToggleState = false,

    Mode = 'Hold',

    Text = 'Move forward bind, DO NOT CHANGE',
    NoUI = true,
})

UtilFlingGroupBox:AddLabel('Move backward'):AddKeyPicker('UtilFlingB', {
    Default = 'S',
    SyncToggleState = false,

    Mode = 'Hold',

    Text = 'Move backward bind, DO NOT CHANGE',
    NoUI = true,
})

UtilFlingGroupBox:AddLabel('Move left'):AddKeyPicker('UtilFlingL', {
    Default = 'A',
    SyncToggleState = false,

    Mode = 'Hold',

    Text = 'Move left bind, DO NOT CHANGE',
    NoUI = true,
})

UtilFlingGroupBox:AddLabel('Move right'):AddKeyPicker('UtilFlingR', {
    Default = 'D',
    SyncToggleState = false,

    Mode = 'Hold',

    Text = 'Move right bind, DO NOT CHANGE',
    NoUI = true,
})



local GamesMMGroupbox = Tabs.Games:AddLeftGroupbox('Mortem Metallum')

GamesMMGroupbox:AddToggle('GamesMMCooldown', {
    Text = 'Enable no cooldown',
    Default = false,
    Tooltip = 'No cooldown on crossbow shooting',
    Callback = function(v) Modules["GamesMMCooldown"] = v end
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
local root = char:FindFirstChild("HumanoidRootPart")
local hum = char:FindFirstChild("Humanoid")
local mouse = plr:GetMouse()
local camera = workspace.CurrentCamera

function getMouseTarget(valf)
        local ray = camera:ScreenPointToRay(mouse.X, mouse.Y)
        local raycastResult = game.Workspace:Raycast(ray.Origin, ray.Direction * 50000)
        local mousePos = raycastResult and raycastResult.Position or ray.Origin
        local closestTarget = nil
        local closestDistance = math.huge

        for _, character in pairs(aimbotCharFolder:GetChildren()) do
            if character:IsA("Model") and character ~= plr.Character then
                if not valf(character) then continue end
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

-- Aimbot
task.spawn(function()
    local aimbotCharFolder = game:GetService("Workspace")

    local function valid(who)
        local human = who:FindFirstChild("Humanoid")
        print("checking: " .. who.Name)
        if human then
            print(human.Health)
        end
        print(aimbotCharFolder:FindFirstChild(who.Name))
        return who and human and human.Health > 0 and aimbotCharFolder:FindFirstChild(who.Name)
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
            local target = getMouseTarget(valid)
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


-- Invisible Fling
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastctrl = {f = 0, b = 0, l = 0, r = 0}
Options.UtilFlingSS:OnClick(function()
    local state = Options.UtilFlingSS:GetState()
    if not Modules["UtilFlingEnable"] or not state then return end

    spawn(
        function()
            local message = Instance.new("Message", workspace)
            message.Text = "Invisible Fling by irobloxianlover (wait 11 seconds to load)"
            wait(11)
            message:Destroy()
        end
    )

    local prevFrame = root.CFrame

    local prt = Instance.new("Model", workspace)

    local ch = char
    local z1 = Instance.new("Part", prt)
    z1.Name = "Torso"
    z1.CanCollide = false
    z1.Anchored = true

    local z2 = Instance.new("Part", prt)
    z2.Name = "Head"
    z2.Anchored = true
    z2.CanCollide = false

    local z3 = Instance.new("Humanoid", prt)
    z3.Name = "Humanoid"
    z1.Position = Vector3.new(0, 9999, 0)
    z2.Position = Vector3.new(0, 9991, 0)
    char = prt
    wait(5)
    char = ch
    wait(6)

    local sel = Instance.new("SelectionBox", root)
    sel.Adornee = root
    sel.Color3 = Color3.fromRGB(255,0,0)

    char:FindFirstChild("Humanoid").RequiresNeck = false;
    local humanoid = Instance.new("Humanoid", plr)
    humanoid.RequiresNeck = false;

    for _, v in pairs(char:GetChildren()) do
        if v ~= root and v.Name ~= "Humanoid" then
            v:Destroy()
        end
    end

    camera.CameraSubject = root

    game:GetService("RunService").Stepped:connect(
        function()
            root.CanCollide = false
        end
    )
    game:GetService("RunService").RenderStepped:connect(
        function()
            root.CanCollide = false
        end
    )
    
    power = 999999 * 10 -- change this to make it more or less powerful

    ---
    wait(.1)
    local bambam = Instance.new("BodyThrust", root)
    bambam.Force = Vector3.new(power, 0, power)
    bambam.Location = root.Position

    local flying = true
    local deb = true
    local maxspeed = 120
    local speed = 15

    local bg = Instance.new("BodyGyro", root)
    bg.P = 9e4
    bg.maxTorque = Vector3.new(0, 0, 0)
    bg.cframe = root.CFrame
    local bv = Instance.new("BodyVelocity", root)
    bv.velocity = Vector3.new(0, 0, 0)
    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
    repeat
        task.wait()

        if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
            speed = speed + .2
            if speed > maxspeed then
                speed = maxspeed
            end
        elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
            speed = speed - 1
            if speed < 0 then
                speed = 0
            end
        end
        if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
            bv.velocity =
                ((camera.CoordinateFrame.lookVector * (ctrl.f + ctrl.b)) +
                ((camera.CoordinateFrame *
                    CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * .2, 0).p) -
                    camera.CoordinateFrame.p)) *
                speed
            lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
        elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
            bv.velocity =
                ((camera.CoordinateFrame.lookVector * (lastctrl.f + lastctrl.b)) +
                ((camera.CoordinateFrame *
                    CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * .2, 0).p) -
                    camera.CoordinateFrame.p)) *
                speed
        else
            bv.velocity = Vector3.new(0, 0.1, 0)
        end
    until not flying
    ctrl = {f = 0, b = 0, l = 0, r = 0}
    lastctrl = {f = 0, b = 0, l = 0, r = 0}
    speed = 0
    bg:Destroy()
    bv:Destroy()

    repeat task.wait() until not Options.UtilFlingSS:GetState()

    -- respawn
    root.CFrame = prevFrame
    sel:Destroy()
end)

task.spawn(function()
    while true do
        task.wait()
        if Library.Unloaded then break end
        if not Modules["UtilFlingEnable"] then continue end

        ctrl = {f=0,b=0,l=0,r=0}
        if Options.UtilFlingF:GetState() then ctrl.f = 1 end
        if Options.UtilFlingB:GetState() then ctrl.b = -1 end
        if Options.UtilFlingL:GetState() then ctrl.l = -1 end
        if Options.UtilFlingR:GetState() then ctrl.r = 1 end
    end
end)

-- Mortom Metallum No Cooldown
task.spawn(function()
    while true do
        task.wait()
        
        if Modules["GamesMMCooldown"] then
            local plrchar = workspace["PlayersCharacters"]:FindFirstChild(plr.Name)
            local tool = nil
            if plrchar then tool = plrchar:FindFirstChildOfClass("Tool") end
            if tool then 
                --tool.Cooldowntime.Value = 0
                tool:WaitForChild("Reloaded").Value = true
                local m = tool:WaitForChild("mouse")
                local dir = Vector3.new(0,0,0)
                local target = workspace["PlayersCharacters"]:FindFirstChild("iamsocoolunlikeuhaha")
                local pos = target.HumanoidRootPart.CFrame
                m:FireServer(dir, pos, 'S')
            end
                --m:FireServer(nil, nil, 'R')
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