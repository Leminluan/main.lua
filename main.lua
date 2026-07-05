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

-- Hàm tìm ID của con quái gần nhất
local function getClosestMonsterData()
    local maxDistance = math.huge
    local targetMonsterId = nil
    local player = game.Players.LocalPlayer
    
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local myPos = player.Character.HumanoidRootPart.Position
        
        -- Quét tất cả các folder quái có thể có trong game
        for _, v in pairs(workspace:GetDescendants()) do
            -- Tìm các Model có máu và không phải người chơi/pet
            if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v ~= player.Character then
                if not game.Players:GetPlayerFromCharacter(v) and not v:FindFirstChild("Pet") then
                    
                    local distance = (v.HumanoidRootPart.Position - myPos).magnitude
                    if distance < maxDistance then
                        -- Kiểm tra xem ID nằm ở tên Model hay Attribute
                        local monsterId = v:GetAttribute("Id") or v:GetAttribute("ID") or v.Name
                        
                        -- Chỉ lấy nếu chuỗi có định dạng ID dài (chứa dấu gạch ngang giống mã của bạn)
                        if monsterId and string.find(monsterId, "-") then
                            maxDistance = distance
                            targetMonsterId = monsterId
                        elseif v.Name and string.find(v.Name, "-") then
                            maxDistance = distance
                            targetMonsterId = v.Name
                        end
                    end
                end
            end
        end
    end
    return targetMonsterId
end

-- Hàm tự động lấy ID tất cả Pet/Đội hình đang trang bị của bạn
local function getMySquadIds()
    local squad = {}
    pcall(function()
        -- Quét trong thư mục lưu trữ Pet của người chơi (Thường nằm ở LocalPlayer)
        -- Hoặc quét các Model pet đang đi theo nhân vật trong Workspace
        local myName = game.Players.LocalPlayer.Name
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v:GetAttribute("Owner") == myName or v.Name == myName .."'s Pet" then
                local petId = v:GetAttribute("Id") or v.Name
                if petId and string.find(petId, "-") then
                    table.insert(squad, petId)
                end
            end
        end
        
        -- Nếu không quét được ngoài workspace, dự phòng điền mã test của bạn để không bị lỗi trống bảng
        if #squad == 0 then
            table.insert(squad, "b93c8bcc-e41e-4399-ba53-3b3844fe1e41") 
        end
    end)
    return squad
end

---------------------------------------------------------
-- TAB 1: AUTO FARM (ĐÃ SỬA THEO REMOTE CHUẨN)
---------------------------------------------------------
local FarmTab = Window:CreateTab("Auto Farm ⚔️", 4483345998)

FarmTab:CreateSection("Cày Cấp Đội Hình")

FarmTab:CreateToggle({
   Name = "Auto Cho Toàn Đội Đánh Quái Gần Nhất",
   CurrentValue = false,
   Flag = "ToggleAutoFarm",
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then
         task.spawn(function()
            while _G.AutoFarm do
               local monsterId = getClosestMonsterData()
               local mySquad = getMySquadIds()
               
               if monsterId and #mySquad > 0 then
                  pcall(function()
                     -- Sử dụng chính xác đường dẫn Remote bạn gửi
                     local args = {
                         [1] = monsterId, -- ID quái quét được
                         [2] = mySquad    -- Danh sách ID đội hình của bạn
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
               task.wait(0.3) -- Giãn cách 0.3 giây mỗi lượt ra lệnh để mượt mà
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
