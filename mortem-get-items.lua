local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer
local Backpack = Player:FindFirstChild("Backpack")
local remoteEvent = ReplicatedStorage:FindFirstChild("Item")

if not remoteEvent or not Backpack then
    warn("Missing remote event or Backpack!")
    return
end

local start = 1
local done = 50
local itemTable = {}
for i = start, done do
    -- Fire the server to select the item
    local args = {
        [1] = i, -- Item index being sent
        [2] = "0:0:0:0" -- Equipment slot
    }
    remoteEvent:FireServer(unpack(args))

    -- Wait for selection to process
    task.wait(1)

    for i, v in pairs(Player.Backpack:GetChildren()) do
        if v.Name == 'C4' or v.Name == 'Fire bomb' or v.Name == 'Grenade' or v.Name == 'Bear trap' then
            v:Destroy()
        end
    end

    -- Get the first tool in the backpack (currently selected tool)
    local tool = Player.Backpack:FindFirstChildOfClass("Tool")

    -- Print the item index and tool name
    if tool then
        itemTable[tool.Name] = i
        print("Selected Item Index:", i, "Item Name:", tool.Name)
    else
        print("Selected Item Index:", i, "No tool found")
    end

    Player.Character:FindFirstChild("Humanoid").Health = 0
    task.wait(7)
end

print("\n=== Final Item Table ===")
for name, index in pairs(itemTable) do
    print(name .. " = " .. index)
end
