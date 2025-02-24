local player = game.Players.LocalPlayer
local backpack = player:WaitForChild('Backpack')
local character = player.Character or player.CharacterAdded:Wait()
local args = {
    [1] = 0,
    [2] = '11:11:11:11'
}
local replicatedStorage = game:GetService('ReplicatedStorage')
local itemRemote = replicatedStorage:WaitForChild('Item')
for _ = 1, 15 do
    itemRemote:FireServer(unpack(args))
end
local tool = Instance.new('Tool')
tool.Name = '1 Punch'
tool.Parent = backpack
tool.RequiresHandle = false
local function activateFists()
    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA('Tool') and item.Name == 'Fists' then
            item.Parent = character
            item:Activate()
        end
    end
    for _, item in ipairs(character:GetChildren()) do
        if item:IsA('Tool') and item.Name == 'Fists' then
            item:Activate()
        end
    end
end
local function onActivated()
    activateFists()
end
tool.Activated:Connect(onActivated)
tool.RequiresHandle = false
