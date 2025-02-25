--[[
This dupe is based off of preventing events from reaching the server, then sending all at once
The "Item" RemoteEvent takes in the weapon ID and the equipment slots
]]
local plr = game.Players.LocalPlayer
local network = settings().Network
local dupe = {}
local itemID = 12
local amtItem = 5

for i = 1, amtItem do
    table.insert(dupe, tonumber(itemID))
end

network.IncomingReplicationLag = math.huge
wait()

for i, v in pairs(dupe) do
    local args = {
        [1] = v, -- Main weapon item ID
        [2] = "0:0:0:0" -- Equipment(C4, Fire bomb, etc.) slots
    }
    game:GetService("ReplicatedStorage").Item:FireServer(unpack(args))
end

wait(0.5)
network.IncomingReplicationLag = 0

wait(#dupe / 19)
for i, v in pairs(plr.Backpack:GetChildren()) do
    if v.Name == "C4" or v.Name == "Fire bomb" or v.Name == "Grenade" or v.Name == "Bear trap" then
        v:Destroy()
    end
end

for _, tool in pairs(plr.Backpack:GetChildren()) do
   if tool:IsA("Tool") then
      tool.Parent = workspace
      tool.Parent = plr.Backpack
   end
end