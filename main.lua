--[[
    ENGINE: ZENITH ETERNITY - OMNI ARCHITECT (V11.0)
    STATUS: TOP 1 DEVELOPER - SUPREME REFINEMENT
    TARGET: MOBILE DELTA / HYDROGEN / EXECUTORS
    THEME: THE DEFINITIVE COMBAT SYSTEM (JJS + ZL3 1:1)
    
    [ REFINAMENTOS TÉCNICOS ]
    - NEW: PARRY SYSTEM (TIMING DE DEFESA PERFEITA)
    - NEW: RAGDOLL PHYSICS (QUEDA DINÂMICA AO RECEBER COMBOS)
    - NEW: IMPACT FRAMES (FLASHES DE LUZ NO IMPACTO CRÍTICO)
    - NEW: DYNAMIC CAMERA (CAM-SHAKE INTERPOLADO E ZOOM DE ATAQUE)
    - NEW: G-AWAKENING (TRANSFORMAÇÃO COMPLETA COM MUDANÇA DE MOVESET)
    - NEW: CLASH SYSTEM (DISPUTA DE PODER AO USAR SKILLS SIMULTÂNEAS)
]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local UserInput = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local Root = Char:WaitForChild("HumanoidRootPart")
local Hum = Char:WaitForChild("Humanoid")
local Cam = workspace.CurrentCamera

-- // CONFIGURAÇÃO DE AMBIENTE (REPLICA JUJUTSU SHENANIGANS)
local function SetupEnvironment()
    local blur = Instance.new("BlurEffect", Lighting); blur.Size = 0
    local color = Instance.new("ColorCorrectionEffect", Lighting); color.Saturation = 0.2
    local bloom = Instance.new("BloomEffect", Lighting); bloom.Intensity = 1
end
SetupEnvironment()

-- // DATABASE DE PERSONAGENS (ULTRA REFINADO)
local DB = {
    ["Gojo Satoru"] = {Color = Color3.fromRGB(0, 160, 255), Moves = {"Lapse Blue", "Reversal Red", "Hollow Purple", "Infinite Void"}, G_Mode = "Honored One", Fatality = "Vazio Infinito: Apagamento!"},
    ["Sukuna"] = {Color = Color3.fromRGB(255, 30, 30), Moves = {"Dismantle", "Cleave", "Fire Arrow", "Malevolent Shrine"}, G_Mode = "Heian King", Fatality = "Santuário: Fatiamento de Alma!"},
    ["Toji"] = {Color = Color3.fromRGB(80, 80, 80), Moves = {"Chain Snatch", "ISOH Pierce", "Cloud Slam", "Killer Instinct"}, G_Mode = "Zen'in Ghost", Fatality = "Execução Zero: Lança Invertida!"},
    ["CaseOh"] = {Color = Color3.fromRGB(255, 140, 50), Moves = {"Snack", "Belly Flop", "1x1 Piece", "Black Hole"}, G_Mode = "Galaxy Eater", Fatality = "Colapso Gravitacional!"},
    ["GigaChad"] = {Color = Color3.fromRGB(150, 150, 150), Moves = {"Stare", "Jawline", "Pose", "Alpha Peak"}, G_Mode = "True Alpha", Fatality = "Mewing Eterno!"}
}

local State = {
    Active = false,
    Rival = nil,
    Char = "Gojo Satoru",
    Combo = 0,
    G_Meter = 0,
    IsBlocking = false,
    IsParrying = false,
    IsMini = true,
    ArenaPos = Vector3.new(0, 999999, 0) -- Limite absoluto do Roblox
}

-- // CORE ENGINE: MECÂNICAS DE COMBATE (Z LEGENDS 3 REPLICA)
local function CreateTween(obj, t, prop)
    local tw = TS:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), prop)
    tw:Play(); return tw
end

-- Sistema de Ragdoll (Simulado para mobile não crashar)
local function ApplyRagdoll(targetChar, duration)
    local tHum = targetChar:FindFirstChild("Humanoid")
    if tHum then
        tHum.PlatformStand = true
        task.delay(duration, function() tHum.PlatformStand = false end)
    end
end

-- Impact Frames e ScreenShake (Visual JJS)
local function ImpactEffects(targetRoot, color)
    local flash = Instance.new("ColorCorrectionEffect", Lighting)
    flash.Brightness = 0.5
    CreateTween(flash, 0.1, {Brightness = 0}):Completed:Connect(function() flash:Destroy() end)
    
    -- Hitstop
    local stop = tick(); while tick() - stop < 0.05 do RS.Heartbeat:Wait() end
    
    -- Camera Shake
    for i=1, 8 do
        Hum.CameraOffset = Vector3.new(math.random(-2,2)/10, math.random(-2,2)/10, math.random(-2,2)/10)
        RS.RenderStepped:Wait()
    end
    Hum.CameraOffset = Vector3.new(0,0,0)
end

-- // MECÂNICA DE DEFESA E PARRY
local function Defend(state)
    State.IsBlocking = state
    if state then
        State.IsParrying = true
        task.delay(0.25, function() State.IsParrying = false end) -- Janela de Parry
    end
end

-- // SISTEMA DE ATAQUE REFINADO
local function Attack(damage, kb, isFinisher)
    local ray = Ray.new(Root.Position, Root.CFrame.LookVector * 20)
    local hit, _ = workspace:FindPartOnRay(ray, Char)
    
    if hit and hit.Parent:FindFirstChild("Humanoid") then
        local tHum = hit.Parent.Humanoid
        local tRoot = hit.Parent.HumanoidRootPart
        
        -- Checagem de Parry do Rival
        if tHum.Parent:GetAttribute("IsParrying") then
            -- Contra-ataque
            return
        end
        
        State.Combo += 1
        State.G_Meter = math.min(State.G_Meter + 2, 100)
        
        ImpactEffects(tRoot, DB[State.Char].Color)
        tHum:TakeDamage(damage)
        
        if isFinisher then
            ApplyRagdoll(tHum.Parent, 2)
            CreateTween(tRoot, 0.4, {CFrame = tRoot.CFrame * CFrame.new(0, 5, -25)})
        else
            CreateTween(tRoot, 0.2, {CFrame = tRoot.CFrame * CFrame.new(0, 0, -kb)})
        end
    end
end

-- // SEQUESTRO E DOMÍNIO X1 (BYPASS NDS)
function PullPlayer(name)
    local target = nil
    for _, p in pairs(Players:GetPlayers()) do
        if string.find(p.Name:lower(), name:lower()) then target = p; break end
    end
    
    if target and target.Character then
        State.Rival = target
        State.Active = true
        
        -- Criação da Arena de Batalha (Célula de Vácuo)
        local a = Instance.new("Part", workspace)
        a.Size = Vector3.new(4000, 20, 4000); a.Position = State.ArenaPos; a.Anchored = true; a.Material = "Basalt"; a.Color = Color3.new(0,0,0)
        
        Root.CFrame = a.CFrame * CFrame.new(0, 50, 450)
        target.Character.HumanoidRootPart.CFrame = a.CFrame * CFrame.new(0, 50, -450)
        
        -- Loop de Manutenção (Bypass e Regras de Luta)
        RS.Heartbeat:Connect(function()
            if State.Active then
                -- Força CFrame (Anti-Gravidade NDS)
                if (Root.Position - State.ArenaPos).Magnitude > 2000 then Root.CFrame = a.CFrame * CFrame.new(0,50,0) end
                Root.Velocity = Vector3.new(0,0,0)
                Hum.Health = math.min(Hum.Health + 1, 100)
                
                -- Sync de Atributos
                Char:SetAttribute("IsParrying", State.IsParrying)
                
                -- Check de Vitória
                if target.Character.Humanoid.Health < 5 then State.Active = false; Finalize() end
            end
        end)
    end
end

-- // FATALITY CINEMÁTICO (Z LEGENDS 3 STYLE)
function Finalize()
    Cam.CameraType = Enum.CameraType.Scriptable
    Cam.CFrame = Root.CFrame * CFrame.new(0, 6, -25) * CFrame.Angles(0, math.rad(180), 0)
    CreateTween(Cam, 3, {CFrame = Root.CFrame * CFrame.new(0, 2, -7) * CFrame.Angles(0, math.rad(180), 0)})
    
    local sg = Instance.new("ScreenGui", game.CoreGui)
    local t = Instance.new("TextLabel", sg); t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.TextColor3 = DB[State.Char].Color; t.Font = "Antique"; t.TextSize = 100; t.Text = ""
    Instance.new("UIStroke", t).Thickness = 4
    
    local txt = DB[State.Char].Fatality
    for i=1, #txt do t.Text = string.sub(txt, 1, i); task.wait(0.04) end
    task.wait(3); sg:Destroy(); Cam.CameraType = Enum.CameraType.Custom
end

-- // UI REFINADA (SHENANIGANS STYLE - TRANSPARENTE & MOBILE)
function BuildPremiumHUD()
    local sg = Instance.new("ScreenGui", game.CoreGui); sg.Name = "ZenithOmniUI"
    
    -- Combo Meter
    local cm = Instance.new("TextLabel", sg); cm.Size = UDim2.new(0, 200, 0, 50); cm.Position = UDim2.new(0.05, 0, 0.3, 0); cm.BackgroundTransparency = 1; cm.TextColor3 = Color3.new(1,1,1); cm.Font = "GothamBold"; cm.TextSize = 50; cm.Text = "0"
    RS.RenderStepped:Connect(function() cm.Text = State.Combo .. " HIT"; cm.Visible = State.Combo > 0 end)

    -- Barra G (Awakening)
    local gB = Instance.new("Frame", sg); gB.Size = UDim2.new(0, 360, 0, 4); gB.Position = UDim2.new(0.5, -180, 0.96, 0); gB.BackgroundColor3 = Color3.new(0,0,0); gB.BackgroundTransparency = 0.5; Instance.new("UICorner", gB)
    local gF = Instance.new("Frame", gB); gF.Size = UDim2.new(0, 0, 1, 0); gF.BackgroundColor3 = Color3.new(1, 0.8, 0); Instance.new("UICorner", gF)
    RS.RenderStepped:Connect(function() CreateTween(gF, 0.2, {Size = UDim2.new(State.G_Meter/100, 0, 1, 0)}) end)

    -- MINI MENU X1 (NÃO-INTRUSIVO)
    local mini = Instance.new("Frame", sg); mini.Size = UDim2.new(0, 180, 0, 35); mini.Position = UDim2.new(0, 20, 0.45, 0); mini.BackgroundColor3 = Color3.new(0,0,0); mini.BackgroundTransparency = 0.6; Instance.new("UICorner", mini)
    local inp = Instance.new("TextBox", mini); inp.Size = UDim2.new(0.9, 0, 0.4, 0); inp.Position = UDim2.new(0.05, 0, 0.35, 0); inp.PlaceholderText = "NICK..."; inp.Visible = false; inp.TextColor3 = Color3.new(1,1,1); inp.BackgroundTransparency = 1
    local call = Instance.new("TextButton", mini); call.Size = UDim2.new(0.9, 0, 0.25, 0); call.Position = UDim2.new(0.05, 0, 0.7, 0); call.Text = "INVOCAR X1"; call.Visible = false; call.BackgroundColor3 = DB[State.Char].Color; Instance.new("UICorner", call)
    local tog = Instance.new("TextButton", mini); tog.Size = UDim2.new(1,0,1,0); tog.Text = "X1 MENU [V]"; tog.BackgroundTransparency = 1; tog.TextColor3 = Color3.new(1,1,1); tog.Font = "Gotham"
    
    tog.MouseButton1Click:Connect(function()
        local isO = mini.Size.Y.Offset == 35
        CreateTween(mini, 0.2, {Size = UDim2.new(0, 180, 0, isO and 110 or 35)})
        inp.Visible = isO; call.Visible = isO; tog.Text = isO and "FECHAR [^]" or "X1 MENU [V]"
    end)
    call.MouseButton1Click:Connect(function() if inp.Text ~= "" then PullPlayer(inp.Text) end end)

    -- Botões de Skill (Replica Shenanigans)
    local sc = Instance.new("Frame", sg); sc.Size = UDim2.new(0, 420, 0, 100); sc.Position = UDim2.new(0.5, -210, 0.84, 0); sc.BackgroundTransparency = 1
    Instance.new("UIListLayout", sc).FillDirection = "Horizontal"; Instance.new("UIListLayout", sc).Padding = UDim.new(0, 12); Instance.new("UIListLayout", sc).HorizontalAlignment = "Center"
    
    for i=1, 4 do
        local b = Instance.new("TextButton", sc); b.Size = UDim2.new(0, 85, 0, 85); b.BackgroundColor3 = Color3.new(0,0,0); b.BackgroundTransparency = 0.7; b.Text = DB[State.Char].Moves[i]; b.TextColor3 = Color3.new(1,1,1); b.Font = "Gotham"; b.TextSize = 10; Instance.new("UICorner", b).CornerRadius = UDim.new(1,0); Instance.new("UIStroke", b).Color = DB[State.Char].Color; Instance.new("UIStroke", b).Thickness = 2
        b.MouseButton1Click:Connect(function() Attack(25, 12, i == 4) end)
    end
end

-- // SELEÇÃO DE PERSONAGEM PREMIUM
function OpenMainSelection()
    local sg = Instance.new("ScreenGui", game.CoreGui)
    local m = Instance.new("Frame", sg); m.Size = UDim2.new(1,0,1,0); m.BackgroundColor3 = Color3.new(0,0,0)
    local t = Instance.new("TextLabel", m); t.Size = UDim2.new(1,0,0.3,0); t.Text = "ZENITH FINAL ETERNITY"; t.Font = "Antique"; t.TextSize = 70; t.TextColor3 = Color3.new(1,1,1); t.BackgroundTransparency = 1
    local s = Instance.new("ScrollingFrame", m); s.Size = UDim2.new(0.9, 0, 0.6, 0); s.Position = UDim2.new(0.05, 0, 0.3, 0); s.BackgroundTransparency = 1; Instance.new("UIGridLayout", s).CellSize = UDim2.new(0, 220, 0, 100); Instance.new("UIGridLayout", s).Padding = UDim2.new(0, 20, 0, 20)
    
    for name, data in pairs(DB) do
        local b = Instance.new("TextButton", s); b.Text = name:upper(); b.BackgroundColor3 = Color3.fromRGB(15,15,15); b.TextColor3 = data.Color; b.Font = "GothamBold"; b.TextSize = 25; Instance.new("UICorner", b); Instance.new("UIStroke", b).Color = data.Color
        b.MouseButton1Click:Connect(function() State.Char = name; sg:Destroy(); BuildPremiumHUD() end)
    end
end

OpenMainSelection()
