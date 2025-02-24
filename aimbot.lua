-- Custom aimbot by irobloxianlover
game.StarterGui:SetCore("SendNotification", {
    Title = "Loading aimbot",
    Text = "by irobloxianlover"
})

local plr = game:GetService("Players").LocalPlayer
local mouse = plr:GetMouse()
local camera = workspace.CurrentCamera

local keyCode = Enum.KeyCode.LeftShift
local charFolder = game:GetService("Workspace")

function getMouseTarget(valf)
    local ray = camera:ScreenPointToRay(mouse.X, mouse.Y)
    local raycastResult = game.Workspace:Raycast(ray.Origin, ray.Direction * 50000)
    local mousePos = raycastResult and raycastResult.Position or ray.Origin
    local closestTarget = nil
    local closestDistance = math.huge

    for _, character in pairs(charFolder:GetChildren()) do
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

local function valid(who)
    local human = who:FindFirstChild("Humanoid")
    print("checking: " .. who.Name)
    if human then
        print(human.Health)
    end
    print(charFolder:FindFirstChild(who.Name))
    return who and human and human.Health > 0 and charFolder:FindFirstChild(who.Name)
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

local inputService = game:GetService("UserInputService")
inputService.InputBegan:Connect(function(inputObject, gameProcessed)
    if gameProcessed then return end
    if inputObject.KeyCode == keyCode then
        print("aimbot active")
        local target = getMouseTarget(valid)
        if not target then return end
        print("found target " .. target.Name)
        repeat
            look(target)
            task.wait(1 / 1000)
        until not inputService:IsKeyDown(keyCode) or not valid(target)
    end
end)