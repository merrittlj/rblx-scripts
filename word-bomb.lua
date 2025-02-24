-- Word Bomb script by irobloxianlover
-- credit for unpatchabomb's word list
game.StarterGui:SetCore("SendNotification", {
    Title = "Loading Word Bomb",
    Text = "by irobloxianlover"
})

local plr = game:GetService("Players").LocalPlayer
local alreadyUsed = {}
loadstring(game:HttpGet("https://raw.githubusercontent.com/MarsQQ/Unpatchabomb/master/unpatchabomb_english_words", true))()

function tableItemExists(array, val)
    for i,v in pairs (array) do 
        if v == val then 
            return true
        end
    end
    return false
end

function findWord (str, where)
    local found = nil
    for i,v in pairs (where) do
        if string.find(v, string.lower(str)) and not tableItemExists(alreadyUsed, v) then 
            if found == nil or string.len(v) > string.len(found) then
                found = v
            end
        end
    end
    return found
end


game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightAlt then
        print("clearing")
        alreadyUsed = {};
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftControl then
        print("typing")
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
        local foundWord = findWord(Letters, ENGLISH_WORDS)
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
end)
