-- Tải thư viện giao diện Orion (Bản Mini gọn nhẹ)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Tạo cửa sổ Menu Mini
local Window = OrionLib:MakeWindow({
    Name = "Banana Mini 🍌", 
    HidePremium = true, 
    SaveConfig = false, 
    IntroText = "Loading Mini AW2..."
})

-- Biến quản lý trạng thái
_G.AutoEgg = false
_G.SelectedEgg = "Nemak" -- Giá trị mặc định bạn cung cấp

-- Tạo Tab Mở Trứng
local EggTab = Window:MakeTab({
    Name = "Mở Trứng",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- 1. Chức năng chọn loại trứng (Dropdown)
EggTab:AddDropdown({
    Name = "Chọn Thế Giới/Trứng",
    Default = "Nemak",
    Options = {"Nemak", "Earth", "Saiyan", "Namek", "Frieza"}, -- Bạn có thể thêm tên các thế giới khác vào đây
    Callback = function(Value)
        _G.SelectedEgg = Value
        print("Đã chọn trứng: " .. Value)
    end    
})

-- 2. Nút Bật/Tắt Auto Mở Trứng (Toggle)
EggTab:AddToggle({
    Name = "Tự Động Mở Trứng",
    Default = false,
    Callback = function(Value)
        _G.AutoEgg = Value
        
        if Value then
            -- Chạy vòng lặp mở trứng trong một luồng riêng (thread)
            task.spawn(function()
                while _G.AutoEgg do
                    -- Sử dụng chính đoạn code Remote bạn tìm được
                    local args = {
                        [1] = _G.SelectedEgg
                    }

                    -- Thực thi lệnh mở trứng
                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("remo"):WaitForChild("src"):WaitForChild("container"):WaitForChild("eggs.open"):InvokeServer(unpack(args))
                    end)

                    task.wait(0.5) -- Thời gian chờ giữa mỗi lần mở (0.5 giây)
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
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end    
})

-- Khởi tạo Menu
OrionLib:Init()
