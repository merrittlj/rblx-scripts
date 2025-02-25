--[[
This dupe is based off of preventing events from reaching the server, then sending all at once
The 'Item' RemoteEvent takes in the weapon ID and the equipment slots
]]
local plr = game.Players.LocalPlayer
local network = settings().Network
local dupe = {}

local items = {
    ['Mace'] = 1,
    ['Katana'] = 2,
    ['Spear'] = 3,
    ['Axe'] = 4,
    ['Maul'] = 5,
    ['Great sword'] = 6,
    -- Index 7 was 'No tool found'
    ['Brute mace'] = 8,
    ['Rapier'] = 9,
    ['Cutlass'] = 10,
    ['Great axe'] = 11,
    ['Crossbow'] = 12,
    ['Scissor'] = 13,
    ['Flail'] = 14,
    ['Halberd'] = 15,
    ['Kanabo'] = 16,
    ['Scythe'] = 17,
    ['Trident'] = 18,
    ['Dagger'] = 19,
    ['Torch'] = 20,
    ['Gladius'] = 21,
    ['War hammer'] = 22,
    ['Pickaxe'] = 23,
    ['Spiked club'] = 24,
    ['Tekko kagi'] = 25,
    ['Naginata'] = 26,
    ['Long bow'] = 27,
    ['Macuahuitl'] = 28,
    ['Zweihänder'] = 29,
    ['Khopesh'] = 30,
    ['Hatchets'] = 31,
    ['Flamberge'] = 32,
    ['Shovel'] = 33,
    ['Bardiche'] = 34,
    ['Bo staff'] = 35,
    ['Caestus'] = 36,
    ['Dual hammers'] = 37,
    ['Hook swords'] = 38,
    ['Sabre'] = 39,
    ['Tonfas'] = 40,
    ['Lucerne'] = 41,
    ['Guan dao'] = 42,
    ['Makhaira'] = 43,
    ['Warpick'] = 44,
    ['Kamas'] = 45,
    ['Nunchaku'] = 46,
    ['Sai'] = 47
}
local itemID = items['Crossbow']
local amtItem = 10

for i = 1, amtItem do
    table.insert(dupe, tonumber(itemID))
end

network.IncomingReplicationLag = math.huge
wait()

for i, v in pairs(dupe) do
    local args = {
        [1] = v, -- Main weapon item ID
        [2] = '0:0:0:0' -- Equipment(C4, Fire bomb, etc.) slots
    }
    game:GetService('ReplicatedStorage').Item:FireServer(unpack(args))
end

wait(0.5)
network.IncomingReplicationLag = 0

wait(#dupe / 19)
for i, v in pairs(plr.Backpack:GetChildren()) do
    if v.Name == 'C4' or v.Name == 'Fire bomb' or v.Name == 'Grenade' or v.Name == 'Bear trap' then
        v:Destroy()
    end
end

local folder = workspace:FindFirstChild('StoredWeapons');
if not folder then 
   folder = Instance.new('Folder', workspace)
   folder.Name = 'StoredWeapons'
end

for _, tool in pairs(plr.Backpack:GetChildren()) do
    if tool:IsA('Tool') then
        tool.Parent = folder
    end
end

local sel = Instance.new('Tool')
sel.Name = 'Selector'
sel.Parent = plr.Backpack
sel.RequiresHandle = false
sel.Equipped:Connect(
    function()
        for _, tool in ipairs(plr.Backpack:GetChildren()) do
            if tool:IsA('Tool') then
                tool.Parent = plr.Character
            end
        end
    end
)

for _, tool in pairs(folder:GetChildren()) do
    if tool:IsA('Tool') then
        tool.Parent = plr.Backpack
    end
end