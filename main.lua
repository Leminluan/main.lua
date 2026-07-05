-- Tải thư viện Kavo UI (Thay thế cho Orion bị lỗi 404)
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
-- Tạo cửa sổ chính với giao diện Dark Theme cực chất
local Window = KavoLib.CreateLib("Banana Mini 🍌", "DarkTheme")

-- Biến quản lý trạng thái
_G.AutoEgg = false
_G.SelectedEgg = "Nemak"

-- TAB 1: MỞ TRỨNG
local EggTab = Window:NewTab("Mở Trứng")
local EggSection = EggTab:NewSection("Cấu Hình Auto Egg")

-- Chức năng chọn loại trứng (Dropdown)
EggSection:NewDropdown("Chọn Thế Giới/Trứng", "Chọn map bạn muốn mở trứng", {"Nemak", "Earth", "Saiyan", "Namek", "Frieza"}, function(currentOption)
    _G.SelectedEgg = currentOption
    print("Đã chọn trứng: " .. currentOption)
end)

-- Chức năng Bật/Tắt Auto mở (Toggle)
EggSection:NewToggle("Tự Động Mở Trứng", "Bật để tự động spam mở trứng", function(state)
    _G.AutoEgg = state
    
    if state then
        task.spawn(function()
            while _G.AutoEgg do
                local args = {
                    [1] = _G.SelectedEgg
                }

                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("remo"):WaitForChild("src"):WaitForChild("container"):WaitForChild("eggs.open"):InvokeServer(unpack(args))
                end)

                task.wait(0.5) -- Thời gian chờ (0.5 giây)
            end
        end)
    end
end)

-- TAB 2: NHÂN VẬT (MISC)
local MiscTab = Window:NewTab("Nhân Vật")
local MiscSection = MiscTab:NewSection("Thông Số")

-- Thanh trượt tăng tốc độ chạy (Slider)
MiscSection:NewSlider("Tốc Độ Chạy", "Kéo để thay đổi WalkSpeed", 300, 16, function(s) -- Max là 300, Min là 16
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
    end
end)
