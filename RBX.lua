-- Rebirth-Champions-X

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/XLinestX/ShinyTool-Beta/main/Venyx"))()
local ShinyTool = library.new("ShinyTool | Version: 2.0.0", 8540346411)

-- themes
local themes = {
Background = Color3.fromRGB(24, 24, 24),
Glow = Color3.fromRGB(0, 204, 0),
Accent = Color3.fromRGB(10, 10, 10),
LightContrast = Color3.fromRGB(20, 20, 20),
DarkContrast = Color3.fromRGB(14, 14, 14),  
TextColor = Color3.fromRGB(255, 255, 255)
}

-- AutoClick
local AutoFarm = ShinyTool:addPage("AutoFarm", 8540346411)
local AutoClick = AutoFarm:addSection("AutoClick")
local Multiplayer = AutoFarm:addSection("Multiplayer")

-- Settings
local Settings = ShinyTool:addPage("Settings", 8540346411)
local Settings = Settings:addSection("Settings")

AutoClick:addToggle("AutoClick", nil, function(click)
    getgenv().loop = click
    while getgenv().loop do
        wait(0.00001)
        local Target = game:GetService("ReplicatedStorage").Events.Click3;
        Target:FireServer();
    end
end)
AutoClick:addToggle("Auto Click | Undetectable |",nil,  function(click1)
    getgenv().loop = click1
    while getgenv().loop do
        wait(0.025)
        local Target = game:GetService("ReplicatedStorage").Events.Click3;
        Target:FireServer();
    end
end)







Multiplayer:addDropdown("Dropdown", {"Hello", "World", "Hello World", "Word", 1, 2, 3})

Multiplayer:addButton("Button")

-- Settings
Settings:addKeybind("Keybind | Hide UI |", Enum.KeyCode.One, function()
    ShinyTool:toggle()
    end, function()
    end)



-- load
ShinyTool:SelectPage(ShinyTool.pages[1], true)
