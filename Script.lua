-- ==========================================================
-- ⚡ darkZx199 HUB v10.0 (RAYFIELD ULTRA EXPANDED & POWERED)
-- 👑 Created by: andrea_susamongus29
-- ==========================================================

-- Attesa caricamento sicuro del gioco
if not game:IsLoaded() then game.Loaded:Wait() end

-- Caricamento protetto di Rayfield Library
local Rayfield = nil
local success, err = pcall(function()
	Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
	Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Mouse = LocalPlayer:GetMouse()

-- --- STATI E VARIABILI ---
local states = {
	Fly = false,
	Noclip = false,
	InfJump = false,
	SpinBot = false,
	KillAura = false,
	AutoClicker = false,
	ClickTP = false,
	ESP = false,
	Tracers = false,
	Fullbright = false,
	XRay = false,
	Hitbox = false,
	AntiAFK = true,
	AutoEquip = false,
	AntiFallDamage = false,
	InfiniteSit = false,
	GodMode = false,
	SpeedBypass = false
}

local flySpeed = 50
local walkSpeedVal = 16
local jumpPowerVal = 50
local auraRange = 15
local clickerDelay = 0.05
local hitboxSize = 10
local bodyVel, bodyGyro
local espHighlights = {}
local tracersList = {}
local xrayParts = {}

local originalAmbient = Lighting.Ambient
local originalBrightness = Lighting.Brightness

-- --- CREAZIONE FINESTRA PRINCIPALE ---
local Window = Rayfield:CreateWindow({
	Name = "⚡ darkZx199 HUB v10.0 | By: andrea_susamongus29",
	Icon = 0,
	LoadingTitle = "⚡ Loading darkZx199 HUB...",
	LoadingSubtitle = "Created by andrea_susamongus29",
	ConfigurationSaving = { Enabled = false },
	Discord = { Enabled = false },
	KeySystem = false
})

-- ==========================================================
-- 🚀 TAB 1: MOVIMENTO & POTENZIAMENTI
-- ==========================================================
local TabMov = Window:CreateTab("🚀 Movimento", 4483362458)

TabMov:CreateToggle({
	Name = "Fly CFrame (Volo)",
	CurrentValue = false,
	Flag = "FlyToggle",
	Callback = function(Value)
		states.Fly = Value
		local char = LocalPlayer.Character
		if not char or not char:FindFirstChild("HumanoidRootPart") then return end
		local hrp = char.HumanoidRootPart

		if Value then
			bodyVel = Instance.new("BodyVelocity")
			bodyVel.MaxForce = Vector3.new(1e6, 1e6, 1e6)
			bodyVel.Velocity = Vector3.zero
			bodyVel.Parent = hrp

			bodyGyro = Instance.new("BodyGyro")
			bodyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
			bodyGyro.CFrame = hrp.CFrame
			bodyGyro.Parent = hrp
		else
			if bodyVel then bodyVel:Destroy() end
			if bodyGyro then bodyGyro:Destroy() end
		end
	end,
})

TabMov:CreateSlider({
	Name = "Velocità Volo",
	Range = {10, 250},
	Increment = 5,
	Suffix = "Studs",
	CurrentValue = 50,
	Flag = "FlySpeedSlider",
	Callback = function(Value) flySpeed = Value end,
})

TabMov:CreateToggle({
	Name = "Noclip (Attraversa Pareti)",
	CurrentValue = false,
	Flag = "NoclipToggle",
	Callback = function(Value) states.Noclip = Value end,
})

TabMov:CreateToggle({
	Name = "Salto Infinito (InfJump)",
	CurrentValue = false,
	Flag = "InfJumpToggle",
	Callback = function(Value) states.InfJump = Value end,
})

TabMov:CreateToggle({
	Name = "Speed Bypass Loop (Forza Camminata)",
	CurrentValue = false,
	Flag = "SpeedBypassToggle",
	Callback = function(Value) states.SpeedBypass = Value end,
})

TabMov:CreateSlider({
	Name = "WalkSpeed (Velocità)",
	Range = {16, 300},
	Increment = 2,
	Suffix = "Speed",
	CurrentValue = 16,
	Flag = "SpeedSlider",
	Callback = function(Value)
		walkSpeedVal = Value
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
		end
	end,
})

TabMov:CreateSlider({
	Name = "JumpPower (Forza Salto)",
	Range = {50, 400},
	Increment = 5,
	Suffix = "Power",
	CurrentValue = 50,
	Flag = "JumpSlider",
	Callback = function(Value)
		jumpPowerVal = Value
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = Value
		end
	end,
})

TabMov:CreateToggle({
	Name = "SpinBot (Rotazione 360°)",
	CurrentValue = false,
	Flag = "SpinBotToggle",
	Callback = function(Value) states.SpinBot = Value end,
})

TabMov:CreateButton({
	Name = "Teletrasporto Avanti (+15 Studs)",
	Callback = function()
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = LocalPlayer.Character.HumanoidRootPart
			hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 15)
		end
	end,
})

TabMov:CreateButton({
	Name = "Teletrasporto In Alto (+25 Studs)",
	Callback = function()
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = LocalPlayer.Character.HumanoidRootPart
			hrp.CFrame = hrp.CFrame + Vector3.new(0, 25, 0)
		end
	end,
})

-- ==========================================================
-- ⚔️ TAB 2: COMBATTIMENTO & POTENZA
-- ==========================================================
local TabCombat = Window:CreateTab("⚔️ Combattimento", 4483362458)

TabCombat:CreateToggle({
	Name = "Kill Aura Auto-Tool",
	CurrentValue = false,
	Flag = "KillAuraToggle",
	Callback = function(Value) states.KillAura = Value end,
})

TabCombat:CreateSlider({
	Name = "Raggio Kill Aura",
	Range = {5, 60},
	Increment = 1,
	Suffix = "Studs",
	CurrentValue = 15,
	Flag = "AuraRangeSlider",
	Callback = function(Value) auraRange = Value end,
})

TabCombat:CreateToggle({
	Name = "Hitbox Extender (Teste Giganti)",
	CurrentValue = false,
	Flag = "HitboxToggle",
	Callback = function(Value)
		states.Hitbox = Value
		if not Value then
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
					p.Character.HumanoidRootPart.Transparency = 1
				end
			end
		end
	end,
})

TabCombat:CreateSlider({
	Name = "Dimensione Hitbox",
	Range = {2, 40},
	Increment = 1,
	Suffix = "Size",
	CurrentValue = 10,
	Flag = "HitboxSizeSlider",
	Callback = function(Value) hitboxSize = Value end,
})

TabCombat:CreateToggle({
	Name = "Auto-Clicker Ultra Veloce",
	CurrentValue = false,
	Flag = "AutoClickerToggle",
	Callback = function(Value) states.AutoClicker = Value end,
})

TabCombat:CreateToggle({
	Name = "Auto Equipaggia Tool",
	CurrentValue = false,
	Flag = "AutoEquipToggle",
	Callback = function(Value) states.AutoEquip = Value end,
})

TabCombat:CreateToggle({
	Name = "God Mode (Max Vita Client)",
	CurrentValue = false,
	Flag = "GodModeToggle",
	Callback = function(Value)
		states.GodMode = Value
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			LocalPlayer.Character:FindFirstChildOfClass("Humanoid").MaxHealth = Value and 999999 or 100
			LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = Value and 999999 or 100
		end
	end,
})

TabCombat:CreateToggle({
	Name = "Click TP (CTRL + Click)",
	CurrentValue = false,
	Flag = "ClickTPToggle",
	Callback = function(Value) states.ClickTP = Value end,
})

TabCombat:CreateButton({
	Name = "BRING ALL PLAYERS (Porta Tutti a Te)",
	Callback = function()
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local myPos = LocalPlayer.Character.HumanoidRootPart.CFrame
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					p.Character.HumanoidRootPart.CFrame = myPos * CFrame.new(0, 0, -3)
				end
			end
		end
	end,
})

-- ==========================================================
-- 👁️ TAB 3: VISUALS & ESP
-- ==========================================================
local TabVisuals = Window:CreateTab("👁️ Visuals", 4483362458)

TabVisuals:CreateToggle({
	Name = "Player ESP Highlight",
	CurrentValue = false,
	Flag = "ESPToggle",
	Callback = function(Value)
		states.ESP = Value
		if not Value then
			for _, hl in pairs(espHighlights) do hl:Destroy() end
			espHighlights = {}
		end
	end,
})

TabVisuals:CreateToggle({
	Name = "Tracers (Linee sui Giocatori)",
	CurrentValue = false,
	Flag = "TracersToggle",
	Callback = function(Value)
		states.Tracers = Value
		if not Value then
			for _, line in pairs(tracersList) do line:Remove() end
			tracersList = {}
		end
	end,
})

TabVisuals:CreateToggle({
	Name = "Fullbright (No Oscurità)",
	CurrentValue = false,
	Flag = "FullbrightToggle",
	Callback = function(Value)
		states.Fullbright = Value
		Lighting.Ambient = Value and Color3.fromRGB(255, 255, 255) or originalAmbient
		Lighting.Brightness = Value and 2 or originalBrightness
	end,
})

TabVisuals:CreateToggle({
	Name = "X-Ray (Pareti Trasparenti)",
	CurrentValue = false,
	Flag = "XRayToggle",
	Callback = function(Value)
		states.XRay = Value
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") and not obj:IsDescendantOf(LocalPlayer.Character) then
				if Value then
					if obj.Transparency == 0 then
						xrayParts[obj] = true
						obj.Transparency = 0.6
					end
				else
					if xrayParts[obj] then
						obj.Transparency = 0
					end
				end
			end
		end
		if not Value then xrayParts = {} end
	end,
})

TabVisuals:CreateSlider({
	Name = "Field of View (FOV Camera)",
	Range = {70, 130},
	Increment = 1,
	Suffix = "Deg",
	CurrentValue = 70,
	Flag = "FOVSlider",
	Callback = function(Value)
		workspace.CurrentCamera.FieldOfView = Value
	end,
})

-- ==========================================================
-- 🌐 TAB 4: MONDO & AMBIENTE
-- ==========================================================
local TabWorld = Window:CreateTab("🌐 Mondo", 4483362458)

TabWorld:CreateButton({
	Name = "FPS Booster / Anti-Lag",
	Callback = function()
		for _, v in ipairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Material = Enum.Material.SmoothPlastic
			elseif v:IsA("Decal") or v:IsA("Texture") then
				v:Destroy()
			end
		end
	end,
})

TabWorld:CreateSlider({
	Name = "Gravità del Mondo",
	Range = {0, 300},
	Increment = 5,
	Suffix = "Grav",
	CurrentValue = 196,
	Flag = "GravitySlider",
	Callback = function(Value)
		workspace.Gravity = Value
	end,
})

TabWorld:CreateButton({
	Name = "Ora del Giorno: GIORNO",
	Callback = function() Lighting.ClockTime = 12 end,
})

TabWorld:CreateButton({
	Name = "Ora del Giorno: NOTTE",
	Callback = function() Lighting.ClockTime = 0 end,
})

TabWorld:CreateButton({
	Name = "Rimuovi Nebbia (No Fog)",
	Callback = function() Lighting.FogEnd = 999999 end,
})

TabWorld:CreateButton({
	Name = "Elimina Oggetto Cliccato (Delete Tool)",
	Callback = function()
		local tool = Instance.new("Tool")
		tool.Name = "Click Delete"
		tool.RequiresHandle = false
		tool.Activated:Connect(function()
			if Mouse.Target then
				Mouse.Target:Destroy()
			end
		end)
		tool.Parent = LocalPlayer.Backpack
	end,
})

-- ==========================================================
-- ⚙️ TAB 5: UTILITÀ & SERVER
-- ==========================================================
local TabUtil = Window:CreateTab("⚙️ Utilità", 4483362458)

TabUtil:CreateToggle({
	Name = "Anti-AFK (Previene Kick 20min)",
	CurrentValue = true,
	Flag = "AntiAFKToggle",
	Callback = function(Value) states.AntiAFK = Value end,
})

TabUtil:CreateButton({
	Name = "TP a Giocatore Casuale",
	Callback = function()
		local targets = {}
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				table.insert(targets, p)
			end
		end
		if #targets > 0 then
			local randomP = targets[math.random(1, #targets)]
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				LocalPlayer.Character.HumanoidRootPart.CFrame = randomP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
			end
		end
	end,
})

TabUtil:CreateButton({
	Name = "Rejoin Server (Rientra)",
	Callback = function()
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
	end,
})

TabUtil:CreateButton({
	Name = "Server Hop (Cambia Server)",
	Callback = function()
		game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
	end,
})

TabUtil:CreateButton({
	Name = "Copia Coordinate CFrame",
	Callback = function()
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			setclipboard(tostring(LocalPlayer.Character.HumanoidRootPart.CFrame))
			Rayfield:Notify({
				Title = "CFrame Copiato!",
				Content = "Posizione salvata negli appunti.",
				Duration = 3,
				Image = 4483362458,
			})
		end
	end,
})

TabUtil:CreateButton({
	Name = "Reset Personaggio",
	Callback = function()
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
		end
	end,
})

-- ==========================================================
-- 🔄 BACKGROUND LOOPS
-- ==========================================================

-- FLY
RunService.RenderStepped:Connect(function()
	if states.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local cam = workspace.CurrentCamera
		local move = Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0, 1, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0, 1, 0) end

		if bodyVel and bodyGyro then
			bodyVel.Velocity = move * flySpeed
			bodyGyro.CFrame = cam.CFrame
		end
	end
end)

-- NOCLIP
RunService.Stepped:Connect(function()
	if states.Noclip and LocalPlayer.Character then
		for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end
	end
end)

-- INFINITE JUMP
UserInputService.JumpRequest:Connect(function()
	if states.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
		LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- SPEED BYPASS
RunService.RenderStepped:Connect(function()
	if states.SpeedBypass and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
		LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = walkSpeedVal
	end
end)

-- SPINBOT
RunService.RenderStepped:Connect(function()
	if states.SpinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(40), 0)
	end
end)

-- HITBOX & KILL AURA & AUTO CLICKER & AUTO EQUIP
task.spawn(function()
	while true do
		task.wait(clickerDelay)
		
		if states.AutoEquip then
			for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
				if tool:IsA("Tool") and LocalPlayer.Character then
					tool.Parent = LocalPlayer.Character
				end
			end
		end

		if states.Hitbox then
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					p.Character.HumanoidRootPart.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
					p.Character.HumanoidRootPart.Transparency = 0.7
					p.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really red")
					p.Character.HumanoidRootPart.Material = Enum.Material.Neon
					p.Character.HumanoidRootPart.CanCollide = false
				end
			end
		end

		if states.KillAura and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local myHrp = LocalPlayer.Character.HumanoidRootPart
			local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
			for _, other in ipairs(Players:GetPlayers()) do
				if other ~= LocalPlayer and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
					if (myHrp.Position - other.Character.HumanoidRootPart.Position).Magnitude <= auraRange then
						if tool then tool:Activate() end
					end
				end
			end
		end

		if states.AutoClicker then
			local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
			if tool then tool:Activate() end
		end
	end
end)

-- ESP HIGHLIGHT
RunService.Heartbeat:Connect(function()
	if states.ESP then
		for _, other in ipairs(Players:GetPlayers()) do
			if other ~= LocalPlayer and other.Character then
				if not espHighlights[other] or not espHighlights[other].Parent then
					local hl = Instance.new("Highlight")
					hl.FillColor = Color3.fromRGB(138, 43, 226)
					hl.OutlineColor = Color3.fromRGB(0, 229, 255)
					hl.FillTransparency = 0.4
					hl.Parent = other.Character
					espHighlights[other] = hl
				end
			end
		end
	end
end)

-- TRACERS
RunService.RenderStepped:Connect(function()
	if states.Tracers then
		local cam = workspace.CurrentCamera
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local hrp = p.Character.HumanoidRootPart
				local pos, visible = cam:WorldToViewportPoint(hrp.Position)

				if visible then
					local line = tracersList[p] or Drawing.new("Line")
					line.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
					line.To = Vector2.new(pos.X, pos.Y)
					line.Color = Color3.fromRGB(138, 43, 226)
					line.Thickness = 1.5
					line.Transparency = 1
					line.Visible = true
					tracersList[p] = line
				elseif tracersList[p] then
					tracersList[p].Visible = false
				end
			elseif tracersList[p] then
				tracersList[p].Visible = false
			end
		end
	end
end)

-- CLICK TELEPORT
Mouse.Button1Down:Connect(function()
	if states.ClickTP and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
		end
	end
end)

-- ANTI AFK PREVENTION
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
	if states.AntiAFK then
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end
end)

Rayfield:Notify({
	Title = "darkZx199 HUB v10.0 PRONTO!",
	Content = "Tutti i potenziamenti abilitati per andrea_susamongus29!",
	Duration = 5,
	Image = 4483362458,
})
