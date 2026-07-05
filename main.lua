-- Tải thư viện giao diện Orion (Bản sửa lỗi hiển thị)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- SỬA LỖI: Tắt SaveConfig và ConfigFolder để tránh bị kẹt do trùng tên Repository
local Window = OrionLib:MakeWindow({
    Name = "Banana Mini 🍌", 
    HidePremium = true, 
    SaveConfig = false, -- Đổi thành false
    IntroText = "Loading Mini AW2..."
})

-- Biến quản lý trạng thái
_G.AutoEgg = false
_G.SelectedEgg = "Nemak"

-- Tạo Tab Mở Trứng
local EggTab = Window:MakeTab({
    Name = "Mở Trứng",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Chức năng chọn loại trứng
EggTab:AddDropdown({
    Name = "Chọn Thế Giới/Trứng",
    Default = "Nemak",
    Options = {"Nemak", "Earth", "Saiyan", "Namek", "Frieza"},
    Callback = function(Value)
        _G.SelectedEgg = Value
    end    
})

-- Nút Bật/Tắt Auto Mở Trứng
EggTab:AddToggle({
    Name = "Tự Động Mở Trứng",
    Default = false,
    Callback = function(Value)
        _G.AutoEgg = Value
        
        if Value then
            task.spawn(function()
                while _G.AutoEgg do
                    local args = {
                        [1] = _G.SelectedEgg
                    }

                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("remo"):WaitForChild("src"):WaitForChild("container"):WaitForChild("eggs.open"):InvokeServer(unpack(args))
                    end)

                    task.wait(0.5)
                end
            end)
        end
    end    
})

-- Tab Tiện ích nhân vật
local MiscTab = Window:MakeTab({
    Name = "Nhân Vật",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MiscTab:AddSlider({
    Name = "Tốc độ chạy",
    Min = 16,
    Max = 300,
    Default = 16,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end    
})

-- Khởi tạo Menu
OrionLib:Init()
