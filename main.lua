-- Tải thư viện Kavo UI (Ổn định 100%, không bị lỗi nil value)
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Banana Mini v3 🍌", "DarkTheme")

-- Biến quản lý trạng thái
_G.AutoFarm = false
_G.AutoEgg = false
_G.SelectedEgg = "Nemak"

-- Hàm quét và lấy đối tượng con quái gần nhất
local function getClosestMonsterObject()
    local maxDistance = math.huge
    local targetMonster = nil
    local player = game.Players.LocalPlayer
    
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local myPos = player.Character.HumanoidRootPart.Position
        
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v ~= player.Character then
                if not game.Players:GetPlayerFromCharacter(v) and not v:FindFirstChild("Pet") and not v.Name:find(player.Name) then
                    if v:FindFirstChild("Humanoid") or v:FindFirstChild("Configuration") or v:GetAttribute("Id") then
                        local distance = (v.HumanoidRootPart.Position - myPos).magnitude
                        if distance < maxDistance then
                            maxDistance = distance
                            targetMonster = v
                        end
                    end
                end
            end
        end
    end
    return targetMonster
end

-- Hàm lấy ID Pet mặc định bạn cung cấp
local function getPetId()
    return "b93c8bcc-e41e-4399-ba53-3b3844fe1e41"
end

---------------------------------------------------------
-- TAB 1: AUTO FARM
---------------------------------------------------------
local FarmTab = Window:NewTab("Auto Farm ⚔️")
local FarmSection = FarmTab:NewSection("Cày Cấp Đội Hình")

FarmSection:NewToggle("Auto Teleport + Đội Hình Diệt Quái", "Tự động bay đến quái và ra lệnh đánh", function(state)
    _G.AutoFarm = state
    if state then
        task.spawn(function()
            while _G.AutoFarm do
                local monster = getClosestMonsterObject()
                
                if monster and monster:FindFirstChild("HumanoidRootPart") then
                    local playerTransform = game.Players.LocalPlayer.Character
                    
                    if playerTransform and playerTransform:FindFirstChild("HumanoidRootPart") then
                        -- Dịch chuyển áp sát quái
                        playerTransform.HumanoidRootPart.CFrame = monster.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                        
                        local monsterId = monster:GetAttribute("Id") or monster.Name
                        local petId = getPetId()
                        
                        pcall(function()
                            local args = {
                                [1] = monsterId,
                                [2] = {
                                    [1] = petId
                                }
                            }
                            
                            game:GetService("ReplicatedStorage")
                               :WaitForChild("rbxts_include")
                               :WaitForChild("node_modules")
                               :WaitForChild("@rbxts")
                               :WaitForChild("remo")
                               :WaitForChild("src")
                               :WaitForChild("container")
                               :WaitForChild("enemies.sendAndRetreat")
                               :FireServer(unpack(args))
                        end)
                    end
                end
                task.wait(0.3)
            end
        end)
    end
end)

---------------------------------------------------------
-- TAB 2: MỞ TRỨNG
---------------------------------------------------------
local EggTab = Window:NewTab("Mở Trứng 🥚")
local EggSection = EggTab:NewSection("Cấu Hình Auto Egg")

EggSection:NewDropdown("Chọn Thế Giới/Trứng", "Chọn trứng để mở", {"Nemak", "Earth", "Saiyan", "Namek", "Frieza"}, function(currentOption)
    _G.SelectedEgg = currentOption
end)

EggSection:NewToggle("Tự Động Mở Trứng", "Bật để tự động mở liên tục", function(state)
    _G.AutoEgg = state
    if state then
        task.spawn(function()
            while _G.AutoEgg do
                local args = { [1] = _G.SelectedEgg }
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("remo"):WaitForChild("src"):WaitForChild("container"):WaitForChild("eggs.open"):InvokeServer(unpack(args))
                end)
                task.wait(0.5)
            end
        end)
    end
end)

---------------------------------------------------------
-- TAB 3: NHÂN VẬT & CÀI ĐẶT
---------------------------------------------------------
local MiscTab = Window:NewTab("Hệ Thống ⚡")
local MiscSection = MiscTab:NewSection("Tính Năng Ẩn / Hiện")

-- Hướng dẫn phím tắt
MiscSection:NewLabel("Mẹo: Bấm nút 'Right Control' để Ẩn/Hiện Menu")

MiscSection:NewSlider("Tốc Độ Chạy (WalkSpeed)", "Kéo để thay đổi tốc độ", 300, 16, function(s)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
    end
end)

-- Cấu hình phím bật/tắt (Mặc định là phím Right Control ở góc phải bàn phím)
KavoLib:ToggleUi()
