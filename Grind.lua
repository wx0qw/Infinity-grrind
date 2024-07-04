local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Robojini/Tuturial_UI_Library/main/UI_Template_1"))()

local colors = {
    SchemeColor = Color3.fromRGB(150, 72, 148),
    Background = Color3.fromRGB(15, 15, 15),
    Header = Color3.fromRGB(15, 15, 15),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(20, 20, 20)
}

local Window = Library.CreateLib("SPTS", "RJTheme3")
local Tab = Window:NewTab("MAIN")
local Section = Tab:NewSection("All")

Section:NewButton("Выдать гейм пассы", "Выдать гп лол", function()
    local player = game.Players.LocalPlayer
    local gamepasses = player:WaitForChild("Gamepassess")

    local gamepassIds = {
        "835591939",
        "835780200",
        "835915062",
        "835652925",
        "835844090"
    }

    for _, id in ipairs(gamepassIds) do
        local gamepass = Instance.new("NumberValue")
        gamepass.Name = id
        gamepass.Value = tonumber(id)
        gamepass.Parent = gamepasses
    end
end)

local function collectNpcParts(islands)
    local npcParts = {}
    for _, islandName in ipairs(islands) do
        local success, npcZone = pcall(function()
            return game.Workspace.Maps.Islands[islandName].Npcs:GetDescendants()
        end)
        if success then
            for _, descendant in ipairs(npcZone) do
                if descendant:IsA("Model") and descendant:FindFirstChild("HumanoidRootPart") then
                    table.insert(npcParts, descendant.HumanoidRootPart)
                end
            end
        end
    end
    return npcParts
end

local function teleportToNextNPC(npcParts, currentIndex)
    local player = game.Players.LocalPlayer

    if #npcParts > 0 then
        local targetPart = npcParts[currentIndex]
        if targetPart and targetPart.Parent and targetPart.Parent:IsA("Model") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPart.Position)

            local args = {
                [1] = {
                    [1] = "Fireball",
                    [2] = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -10)
                }
            }

            game.ReplicatedStorage.SkillsRemotes.UseSkill:InvokeServer(unpack(args))
        end
        currentIndex = (currentIndex % #npcParts) + 1
    end
    return currentIndex
end

local function farmNpcs(islandNames)
    local currentIndex = 1
    while autoFarmNpcsEnabled do
        local npcParts = collectNpcParts(islandNames)
        if #npcParts == 0 then
            wait(5)  -- Wait for NPCs to respawn
        else
            for _ = 1, #npcParts do
                if not autoFarmNpcsEnabled then
                    break
                end
                currentIndex = teleportToNextNPC(npcParts, currentIndex)
                wait(1)
            end
        end
    end
end

Section:NewToggleФарм нпс 1"Farming Npcs", function(state)
    autoFarmNpcsEnabled = state
    if state then
        spawn(function()
            farmNpcs({"Island1"})
        end)
    end
end)

Section:NewToggle("Фарм нпс 2", "Farming Npcs", function(state)
    autoFarmNpcsEnabled = state
    if state then
        spawn(function()
            farmNpcs({"Island2"})
        end)
    end
end)

Section:NewToggle("Фарм нпс 3", "Farming Npcs", function(state)
    autoFarmNpcsEnabled = state
    if state then
        spawn(function()
            farmNpcs({"Island3"})
        end)
    end
end)

while wait(0.1) do
    if game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Health <= 0 then
    game.ReplicatedStorage.CharacterRemotes.LoadCharacter:InvokeServer()
    end
end

local autoSpeedJumpFarmEnabled = false
local autoFistFarmEnabled = false

Section:NewToggle("Спид/джамп авто фарм", "Auto Farm Speed and Jump!", function(state)
    autoSpeedJumpFarmEnabled = state
    if state then
        spawn(function()
            while autoSpeedJumpFarmEnabled do
                local speedArgs = {
                    [1] = "SpeedFarm"
                }
                local jumpArgs = {
                    [1] = "JumpFarm"
                }

                game:GetService("ReplicatedStorage").StatsFarmRemotes.StatFarm:FireServer(unpack(speedArgs))
                game:GetService("ReplicatedStorage").StatsFarmRemotes.StatFarm:FireServer(unpack(jumpArgs))

                wait(0.1)
            end
        end)
    end
end)

Section:NewToggle("Авто фист", "Auto Farm Fist!", function(state)
    autoFistFarmEnabled = state
    if state then
        spawn(function()
            while autoFistFarmEnabled do
                local args = {
                    [1] = "FistFarm"
                }
                game:GetService("ReplicatedStorage").StatsFarmRemotes.StatFarm:FireServer(unpack(args))
                wait(0.1)
            end
        end)
    end
end)

Section:NewSlider("WalkSpeed", "Player WalkSpeed", 500, 0, function(speed)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
end)

Section:NewTextBox("Выдать токены", "Give Amount Of Tokens", function(txt)
    local player = game.Players.LocalPlayer
    local tokens = Instance.new("IntValue")
    tokens.Name = "Tokens"
    tokens.Value = tonumber(txt)
    tokens.Parent = player
end)

Section:NewButton("Анти афк", "Player doesn't get kicked!", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/evxncodes/mainroblox/main/anti-afk", true))()
end)

Section:NewButton("Инфинити елд", "Open InfinityYield!", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

Section:NewButton("Декс", "Open Dex/Explorer!", function()
    loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Dex%20Explorer.txt"))()
end)
