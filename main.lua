-- Tải thư viện Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Tạo Cửa sổ chính
local Window = Rayfield:CreateWindow({
   Name = "Banana Mini v3 🍌",
   LoadingTitle = "Đang kết nối dữ liệu...",
   LoadingSubtitle = "by Leminluan",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

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
-- TAB 1: AUTO FARM + TELEPORT (ĐÃ SỬA ĐƯỜNG DẪN)
---------------------------------------------------------
local FarmTab = Window:CreateTab("Auto Farm ⚔️", 4483345998)

FarmTab:CreateSection("Cày Cấp & Teleport")

FarmTab:CreateToggle({
   Name = "Auto Teleport + Đội Hình Diệt Quái",
   CurrentValue = false,
   Flag = "ToggleAutoFarm",
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then
         task.spawn(function()
            while _G.AutoFarm do
               local monster = getClosestMonsterObject()
               
               if monster and monster:FindFirstChild("HumanoidRootPart") then
                  local playerTransform = game.Players.LocalPlayer.Character
                  
                  if playerTransform and playerTransform:FindFirstChild("HumanoidRootPart") then
                     -- Teleport áp sát quái
                     playerTransform.HumanoidRootPart.CFrame = monster.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                     
                     -- Lấy ID ẩn của quái
                     local monsterId = monster:GetAttribute("Id") or monster.Name
                     local petId = getPetId()
                     
                     pcall(function()
                        local args = {
                            [1] = monsterId,
                            [2] = {
                                [1] = petId
                            }
                        }
                        
                        -- ĐÃ SỬA: Đường dẫn chuẩn xác theo SimpleSpy của bạn
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
