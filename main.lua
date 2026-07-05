-- Tải thư viện Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Tạo Cửa sổ chính
local Window = Rayfield:CreateWindow({
   Name = "Banana Mini v3 🍌",
   LoadingTitle = "Đang khởi tạo Menu...",
   LoadingSubtitle = "by Leminluan",
   ConfigurationSaving = {
      Enabled = false
   },
   KeySystem = false
})

-- Biến quản lý trạng thái
_G.AutoFarm = false
_G.AutoEgg = false
_G.SelectedEgg = "Nemak"

---------------------------------------------------------
-- TAB 1: AUTO FARM (MỚI)
---------------------------------------------------------
local FarmTab = Window:CreateTab("Auto Farm ⚔️", 4483345998)

FarmTab:CreateSection("Cày Cấp Tự Động")

FarmTab:CreateToggle({
   Name = "Tự Động Đánh Quái (Auto Click)",
   CurrentValue = false,
   Flag = "ToggleAutoFarm",
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then
         task.spawn(function()
            while _G.AutoFarm do
               -- Thực thi lệnh đánh quái dựa trên framework TS của game
               pcall(function()
                  -- Hướng đi 1: Gọi remote click/tấn công chung của container
                  local remoContainer = game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("remo"):WaitForChild("src"):WaitForChild("container")
                  
                  if remoContainer:FindFirstChild("click") then
                     remoContainer:FindFirstChild("click"):InvokeServer()
                  elseif remoContainer:FindFirstChild("combat.click") then
                     remoContainer:FindFirstChild("combat.click"):InvokeServer()
                  elseif remoContainer:FindFirstChild("attack") then
                     remoContainer:FindFirstChild("attack"):FireServer()
                  end
               end)

               task.wait(0.1) -- Tốc độ click đấm (0.1 giây một lần để đánh cực nhanh)
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

-- Thông báo sẵn sàng
Rayfield:Notify({
   Title = "Banana Mini Hoàn Tất!",
   Content = "Đã thêm tab Auto Farm. Bấm X để ẩn menu thành nút bay nhé.",
   Duration = 5,
   Image = 4483345998,
})
