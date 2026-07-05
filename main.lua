-- Tải thư viện Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Tạo Cửa sổ chính
local Window = Rayfield:CreateWindow({
   Name = "Banana Mini v3 🍌",
   LoadingTitle = "Đang khởi tạo Menu...",
   LoadingSubtitle = "by Leminluan",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Biến quản lý trạng thái
_G.AutoFarm = false
_G.AutoEgg = false
_G.SelectedEgg = "Nemak"

-- Hàm tìm con quái gần nhân vật nhất trong Workspace
local function getClosestMonster()
    local maxDistance = math.huge
    local targetMonster = nil
    local player = game.Players.LocalPlayer
    
    -- Kiểm tra nếu nhân vật tồn tại
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local myPos = player.Character.HumanoidRootPart.Position
        
        -- Duyệt qua thư mục chứa quái (Thường là workspace.Monsters hoặc workspace.Enemies hoặc trực tiếp trong workspace)
        -- Ở đây quét trong một số folder phổ biến của game Simulator
        local foldersToScan = {workspace, workspace:FindFirstChild("Monsters"), workspace:FindFirstChild("Enemies"), workspace:FindFirstChild("Mobs")}
        
        for _, folder in pairs(foldersToScan) do
            if folder then
                for _, monster in pairs(folder:GetChildren()) do
                    -- Kiểm tra xem có phải là Quái vật hợp lệ không (có máu và có vị trí)
                    if monster:IsA("Model") and monster:FindFirstChild("HumanoidRootPart") and monster ~= player.Character then
                        -- Tránh quét nhầm vào Pet hoặc người chơi khác nếu game để chung trong workspace
                        if not game.Players:GetPlayerFromCharacter(monster) and not monster:FindFirstChild("PetInGame") then 
                            local distance = (monster.HumanoidRootPart.Position - myPos).magnitude
                            if distance < maxDistance then
                                maxDistance = distance
                                targetMonster = monster
                            end
                        end
                    end
                end
            end
        end
    end
    return targetMonster
end

---------------------------------------------------------
-- TAB 1: AUTO FARM (CẬP NHẬT TỰ TÌM QUÁI)
---------------------------------------------------------
local FarmTab = Window:CreateTab("Auto Farm ⚔️", 4483345998)

FarmTab:CreateSection("Cày Cấp Đội Hình")

FarmTab:CreateToggle({
   Name = "Auto Tìm & Cho Đội Hình Đánh Quái",
   CurrentValue = false,
   Flag = "ToggleAutoFarm",
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then
         task.spawn(function()
            while _G.AutoFarm do
               local monster = getClosestMonster()
               if monster then
                  -- Di chuyển nhân vật đến gần quái (nếu cần thiết để pet/đội hình tương tác)
                  -- game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = monster.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)

                  pcall(function()
                     local remoContainer = game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("remo"):WaitForChild("src"):WaitForChild("container")
                     
                     -- CÁC HƯỚNG CẤU HÌNH REMOTE CHUYỂN TARGET CHO ĐỘI HÌNH:
                     if remoContainer:FindFirstChild("click") then
                        -- Gửi mục tiêu là con quái vừa tìm được để toàn đội lao vào
                        remoContainer:FindFirstChild("click"):InvokeServer(monster)
                     elseif remoContainer:FindFirstChild("monster.attack") then
                        remoContainer:FindFirstChild("monster.attack"):InvokeServer(monster)
                     elseif remoContainer:FindFirstChild("combat.target") then
                        remoContainer:FindFirstChild("combat.target"):InvokeServer({["monster"] = monster})
                     end
                  end)
               end
               task.wait(0.2) -- Giãn cách thời gian ra lệnh để toàn đội kịp đánh một lượt và tránh lag
            end
         end)
      end
   end,
})

---------------------------------------------------------
-- TAB 2: MỞ TRỨNG
---------------------------------------------------------
local EggTab = Window:CreateTab("Mở Trứng 🥚", 4483345998)

EggTab:CreateDropdown({
   Name = "Chọn Thế Giới/Trứng",
   Options = {"Nemak", "Earth", "Saiyan", "Namek", "Frieza"},
   CurrentOption = {"Nemak"},
   MultipleOptions = false,
   Flag = "DropdownEgg",
   Callback = function(Option)
      _G.SelectedEgg = Option[1]
   end,
})

EggTab:CreateToggle({
   Name = "Tự Động Mở Trứng",
   CurrentValue = false,
   Flag = "ToggleAutoEgg",
   Callback = function(Value)
      _G.AutoEgg = Value
      if Value then
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
   end,
})

---------------------------------------------------------
-- TAB 3: NHÂN VẬT (MISC)
---------------------------------------------------------
local MiscTab = Window:CreateTab("Nhân Vật ⚡", 4483345998)

MiscTab:CreateSlider({
   Name = "Tốc Độ Chạy (WalkSpeed)",
   Range = {16, 300},
   Increment = 1,
   Suffix = " Speed",
   CurrentValue = 16,
   Flag = "SliderSpeed",
   Callback = function(Value)
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

Rayfield:Notify({
   Title = "Banana Mini Hoàn Tất!",
   Content = "Đã cập nhật hệ thống tự tìm quái thông minh.",
   Duration = 5,
   Image = 4483345998,
})
