local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "remo HUB",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest"
})

local HentaiTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998"  -- Replace with a suitable icon if desired
})

local PetSimSection = HentaiTab:AddSection({
    Name = "Pet Simulator 99"
})

local AutoFarmToggle = PetSimSection:AddToggle({
    Name = "Auto Farm Coins",
    Default = false,
    Callback = function(Value)
        getgenv().AutoFarmCoins = Value
        while getgenv().AutoFarmCoins do
            task.wait()
            local Coin = GetCoins()[math.random(1, #GetCoins())]
            if Coin then
                Network.Breakables_PlayerDealDamage:FireServer(Coin.Name)
            end
        end
    end
})

-- ... other code ...

local SelectedMapName = ""  -- Store selected map name

local TeleportToggle = PetSimSection:AddToggle({
    Name = "Teleport to Selected Map",
    Default = false,
    Callback = function(Value)
        if Value and SelectedMapName ~= "" then
            local ZoneFolder = game:GetService("ReplicatedStorage").__DIRECTORY.Zones["Early Game"]
            local SelectedMap = ZoneFolder[SelectedMapName]  -- Use the correct path here
            if SelectedMap then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedMap.CFrame
            else
                warn("Selected map not found:", SelectedMapName)
            end
        end
    end
})

local FishToggle = PetSimSection:AddToggle({
        Name = "Auto Fish",
        Default = false,
        Callback = function(value)

local Chimpanzees = game:GetService("Players")
local Jungle = game:GetService("Workspace")
local TreeClimbingService = game:GetService("RunService")
local BananaStorage = game:GetService("ReplicatedStorage")

-- monkey type shit

local InGame = false
local Monkey = Chimpanzees.LocalPlayer
local MonkeyHabitat = Jungle:WaitForChild("__THINGS")
local ActiveMonkeys = MonkeyHabitat:WaitForChild("__INSTANCE_CONTAINER"):WaitForChild("Active")
local MonkeyDebris = Jungle:WaitForChild("__DEBRIS")
local MonkeyNetwork = BananaStorage:WaitForChild("Network")
local OldMonkeyHooks = {}
local MonkeyFishingGame = Monkey:WaitForChild("PlayerGui"):WaitForChild("_INSTANCES").FishingGame.GameBar
local CurrentMonkeyFishingModule = require(MonkeyHabitat.__INSTANCE_CONTAINER.Active:WaitForChild("Fishing").ClientModule.FishingGame)

--  functions

for i, v in pairs(CurrentMonkeyFishingModule) do
    OldMonkeyHooks[i] = v
end

CurrentMonkeyFishingModule.IsFishInBar = function()
    return math.random(1, 6) ~= 1
end

CurrentMonkeyFishingModule.StartGame = function(...)
    InGame = true
    return OldMonkeyHooks.StartGame(...)
end

CurrentMonkeyFishingModule.StopGame = function(...)
    InGame = false
    return OldMonkeyHooks.StopGame(...)
end

local function waitForMonkeyGameState(state)
    repeat
        TreeClimbingService.RenderStepped:Wait()
    until InGame == state
end

local function getMonkeyRod()
    return Monkey.Character and Monkey.Character:FindFirstChild("Rod", true)
end

local function getMonkeyBubbles(anchor)
    local myBobber = nil
    local myBubbles = false
    local closestBobber = math.huge

    for _, v in pairs(ActiveMonkeys.Fishing.Bobbers:GetChildren()) do
        local distance = (v.Bobber.CFrame.Position - anchor.CFrame.Position).Magnitude

        if distance <= closestBobber then
            myBobber = v.Bobber
            closestBobber = distance
        end
    end

    if myBobber then
        for _, v in pairs(MonkeyDebris:GetChildren()) do
            if v.Name == "host" and v:FindFirstChild("Attachment") and (v.Attachment:FindFirstChild("Bubbles") or v.Attachment:FindFirstChild("Rare Bubbles")) and (v.CFrame.Position - myBobber.CFrame.Position).Magnitude <= 1 then
                myBubbles = true
                break
            end
        end
    end

    return myBubbles
end

while task.wait(1) do
    pcall(function()
        local fishingInstance = MonkeyHabitat.__INSTANCE_CONTAINER.Active:FindFirstChild("Fishing")
        if fishingInstance and not InGame then
            MonkeyNetwork.Instancing_FireCustomFromClient:FireServer("Fishing", "RequestCast", Vector3.new(1158 + math.random(-10, 10), 75, -3454 + math.random(-10, 10)))

            local myAnchor = getMonkeyRod():WaitForChild("FishingLine").Attachment0
            repeat
                TreeClimbingService.RenderStepped:Wait()
            until not ActiveMonkeys:FindFirstChild("Fishing") or (myAnchor and getMonkeyBubbles(myAnchor)) or InGame

            if ActiveMonkeys:FindFirstChild("Fishing") then
                MonkeyNetwork.Instancing_FireCustomFromClient:FireServer("Fishing", "RequestReel")
                waitForMonkeyGameState(true)
                waitForMonkeyGameState(false)
            end

            repeat
                TreeClimbingService.RenderStepped:Wait()
            until not ActiveMonkeys:FindFirstChild("Fishing") or (getMonkeyRod() and getMonkeyRod().Parent.Bobber.Transparency <= 0)
        end
    end)
end
